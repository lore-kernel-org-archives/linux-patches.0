Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF343389472;
	Sat, 12 Sep 2026 18:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237015; cv=none; b=RTCQ6RSelnsrQgLyPiUV9Jk8kwz+IQngihfpdOtaxTG1ejo7T89lrpnBNaJjW9XEXY1hzjlsrojzo8lNi8veNqR7ASZRxJ6HzWLTQeB0shhnrmSLELRyS1EEDMZlsPnLJ/CMT5DBy0zxbk7Wg3SoqAfao3kHLKHILD1+cgId1AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237015; c=relaxed/simple;
	bh=4U1+X2lWNDIl8NtrHYukWcmzuL+7u0IEEO+rKxRfHME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FE9e2Y6mBGnT+m6uC0Hr9+y2uBR/3HfE0Bv+4G8ESoQtHRs2AHYduEAGrI+zZbPNQ8GDDfazs0CkTe6vLkoIrN/XW7BLhKpHAFFMQT4w902FoiAssdfDKjBzTl+hr5yQ5I09LzDIWTqgg9LwMKT3Dj7WYt7slmdmn7QiY3kym7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xMT2nB18; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xMT2nB18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0C01F000FF;
	Sat, 12 Sep 2026 18:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237014;
	bh=cIn4o7rFxYT91brHoVl5ewIIUHNZ7nvJioKJ02FrHYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xMT2nB18Fw3kpIBRUi/PP4M2b37+a/YE7n/csRsRLEdJrUmJBa4f0vsoeWsg/6SkY
	 j9S/95ebw4Ed8+iuQRlQZ1V557EGK25J9KCchKUmeyiuG0+zm/F2DHxgJnYz2D2Z9d
	 WirjfTjFlye+kYSKF7QO72GRaADCC3vdgFAanTjU=
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
Subject: [PATCH 5.15 130/935] ocfs2: validate lengths in dlm_mig_lockres_handler
Date: Sat, 12 Sep 2026 08:52:40 +0200
Message-ID: <20260912065529.804562676@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


