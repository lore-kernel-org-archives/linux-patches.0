Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893BA41BA60;
	Fri,  4 Sep 2026 06:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502543; cv=none; b=BQyXIT05Oc+GHNLyyvEIhhglu6YkrChoCSibTLXZChaqv4cBoBpQipcd/JhxryouldDpaz/oRP9TfKppl86cwMtHphi6GTDJppohriOSYwZ4C+Oz/hdjak7rB2qmLMpitfU/4XAxDXODAV53md2OU0gPOPc+KiGFPvSLoIz+GxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502543; c=relaxed/simple;
	bh=rxottXjKfA+tRJi6K3MOQ/ksZLwpTui+8oA1J2T8eoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=anW4g3KCEehBVshM6+R0DH9RKu5Ia+7mmI4AiI1SHlo/XstFWXRQqaKHLAwUnFU32I0lsqkeqhk8/sjS5DLIvRemhE6HGGG1D8ASWw4lzZgpcx5MRmT8JycsmZjPKIu7gDFSxpSZlw3Je9zRnT4BEcE3hsmyHgVH4PWHjc+FyIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F6vpZu0l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F6vpZu0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA6CA1F00A3D;
	Fri,  4 Sep 2026 06:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502542;
	bh=NSxKNSHbzaVxPa5PtMu6hiFVZLEgPijb/NQ4ecJxHjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F6vpZu0lAsFxQaWghRUFqxnYnrqXF/d0uoDJPk/ClA6VtwjPLUcljgbhhTRvjG/ba
	 piF0Us6/gjNyaG3dogdSrMRU4g/NpWRuGQQ/RElXmHgIxyS9wXaZHPPknRZzYfUzxm
	 +y6JAoD8GPUirnGd7uP+xJ/hWbqjlHtaIIzOmZVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 244/403] ocfs2: validate lengths in dlm_mig_lockres_handler
Date: Fri,  4 Sep 2026 07:00:47 +0200
Message-ID: <20260904045740.421525220@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

commit b54e03d9b3697d25f4a0063cf717d459c5e3ad94 upstream.

A node receiving a DLM_MIG_LOCKRES message trusts several fields of the
peer-supplied dlm_migratable_lockres without validation.  num_locks and
lockname_len are bounded only on the sending side, and the message is
never checked to actually carry num_locks migratable_lock entries.  As a
result dlm_process_recovery_data() walks mres->ml[0..num_locks) past the
kmalloc(data_len) copy of the message (an out-of-bounds read that ends in
a BUG_ON panic), and dlm_init_lockres() copies lockname_len bytes into the
fixed 32-byte o2dlm_lockname slab object (a heap out-of-bounds write).
Both are reachable by any node in the domain.

Validate these fields right after dlm_grab(), before anything uses them --
including the not-joined error path, which already prints mres->lockname
with the unbounded lockname_len as a %.*s precision.  Reject the message
unless lockname_len <= DLM_LOCKID_NAME_MAX, num_locks <=
DLM_MAX_MIGRATABLE_LOCKS (the bound the sender already asserts), and the
payload is large enough to hold the claimed locks.  Conforming recovery
and migration messages are unaffected.

Link: https://lore.kernel.org/20260629-b4-disp-94fb6521-v1-2-6953bcc0421f@proton.me
Fixes: 6714d8e86bf4 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/dlm/dlmrecovery.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1359,6 +1359,15 @@ int dlm_mig_lockres_handler(struct o2net
 	if (!dlm_grab(dlm))
 		return -EINVAL;
 
+	if (mres->lockname_len > DLM_LOCKID_NAME_MAX ||
+	    mres->num_locks > DLM_MAX_MIGRATABLE_LOCKS ||
+	    be16_to_cpu(msg->data_len) < struct_size(mres, ml, mres->num_locks)) {
+		mlog(ML_ERROR, "%s: invalid lockres migration message from %u\n",
+		     dlm->name, mres->master);
+		dlm_put(dlm);
+		return -EINVAL;
+	}
+
 	if (!dlm_joined(dlm)) {
 		mlog(ML_ERROR, "Domain %s not joined! "
 			  "lockres %.*s, master %u\n",


