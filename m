Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D017282F1F;
	Sat, 12 Sep 2026 15:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227499; cv=none; b=A73RRsqgZRNVXNQZvC+jo/0EtIoSJt/w8D1sFb5VLVGqEMgbHqRLCR1KOGcH3SNslX1noJ55gqjzUynVBZ1uuLcSQA5QfZqjDUFL3EjaVeiX62MQ1MZ0Zb8ifbz1YrImZDr7ngsdAmdV2Kr2LXI1gu++E/I7I4OtxEynluw7hcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227499; c=relaxed/simple;
	bh=UUZGjIH+6IoyCYYcsr5dUT1DQxpdYTe27N18fBNdzqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IZqcsAUrfDHJze8Ol5lJbXnvLkjeEircSVvAWoQK9MvhvvJkrxBH46kFMuPhnQ3qzg/qaEm+XQ0/JE1rPGXXk3xA4uEUlvGeLwdiYXrbxMelaNmPB5DuHmxcbMdFrLtTnDISkicgt4MrJRRwlWnoztRu+3asxLPEIAI15lrB8XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XqU4c0VI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XqU4c0VI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18BAA1F000FF;
	Sat, 12 Sep 2026 15:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227498;
	bh=dbUe9O6c+XnKQ5SstjXRdm8zbVBQrbCwsr8D4xYYfkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XqU4c0VI9T1nh3/nnUawjAj+7tK7kpH5CzeplcNxvDdmZ+q7wFoeq1d0eeMF67Tps
	 DE5iGXRM3va/Mj1gTw+W2jC6+Dsw8Y1GQJ2UY9uWvIEbIo6GnrwG+sEC6ZmShsIRKg
	 gYrKGVAdgAQPcU/UequugzCd2LT3SONrZMOJmGMs=
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
Subject: [PATCH 6.1 0151/1191] ocfs2: validate lengths in dlm_mig_lockres_handler
Date: Sat, 12 Sep 2026 08:47:59 +0200
Message-ID: <20260912065551.596225196@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


