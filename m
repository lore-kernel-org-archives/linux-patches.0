Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037696;
	b=p8gBHd3dJ3Wx99/OOs1xrtRbawuaxws+hS38D2lcDcHtH9x1J77yocPAnkJ7igXdwDc1
	 0vZKU1XVg3L47b71x72Qt3bOslqrngZENG4cl83KTGkF/Sh5f+1HyMVpPFKRXa85/uf7X
	 TmfcjrpcvKS4YRYCX9TurFUIIwzyKeok93oIscpLufWIJosXpXfZqyliggJZCu25y5fhP
	 EWEBbQHc7TFlSWHauDmKfq4+66RRiNyJvAcXJD8VVJNv1HO4EruUSE+lVrDh6e097rEOM
	 Mf8qJARGhTwbpULNZHo+3+z8Yf+tRtIiBCrsuEosrxR2WSLuNneEzl2qMVU2mOQOPnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037696;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M7k/Ya37UkUr9XiDs83aZ8UYO4glaNV0DbUjuB05ZGE=;
	b=NAz8tJOSefXV3kvKoFJOI2KKgUF0DSL/9p/6KCS4ippJzmNHnAC8Lips6U/zleMba/u/
	 6tfJhucrRbkdVsBNyfiw2mXB/VOnO2dXK+bef92M/XVN0pcgPLS89gk19QMfsly6S/S1A
	 x17YpBA7thnHSOcj8m0j8bwajBBdMjtPX00+kt1MhTItNruO+OQYtm6tInIamrjt1Mujt
	 eUbopDbH9lwCe+wv03uw+nhlzdbG12Cw8K7V+JxRKZ+KUD1bRDrdXid/DRdHYasUTXw5r
	 ldsHILb7LjrMWAlK05012k3JdL3VUxGqfJt2csrEACVCEecrpsPKjhONKWSk/pqiYog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ok88KIFv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1456F606A31C;
	Wed, 18 Nov 2026 21:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ok88KIFv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC7C1F000C4;
	Wed, 18 Nov 2026 21:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037695;
	bh=M7k/Ya37UkUr9XiDs83aZ8UYO4glaNV0DbUjuB05ZGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ok88KIFvEeFBGjn3g8MiwSmjIXMTyn6MJlNmXkag/VSWQXjoUX2mwK8lgu02zGHLj
	 WJBGTE4hq7nY4qhxlKdYDKobzaojY+iqIYCucBRbcxzVca3DKjs1B4x4TV/TlCj8cC
	 SYY5VbmVNUUTp4FtVNm9JQRmVsxchB7Hl0EWkSZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Heming Zhao <heming.zhao@suse.com>,
	Jia-Ju Bai <baijiaju1990@gmail.com>,
	jjzuming@gmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1487/3318] ocfs2: keep locking_state within the cluster connection lifetime
Date: Wed, 18 Nov 2026 15:35:09 +0100
Message-ID: <20261118150405.512173152@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 5bdef466851e39ba752634cbea68e5ea24ccfb24 ]

The locking_state reader calls ocfs2_dlm_lvb() through the selected
cluster stack.  Its debug-object reference keeps the tracking list alive,
but does not keep that stack selected without a cluster connection.

DLM initialization publishes the file before establishing its connection,
and DLM shutdown drops the connection while the file still exists.  Both
the mount error unwind in ocfs2_mount_volume() and ocfs2_dismount_volume()
remove the debugfs subtree only after ocfs2_dlm_shutdown() has returned.
Whenever the disconnect releases the last stack reference, which is the
case for a failed mount and for any unmount without a pending hangup, a
concurrent reader dereferences a NULL active_stack:

  Mount error unwind                  Debugfs reader
  ------------------                  --------------
  ocfs2_mount_volume(): out_dlm
    ocfs2_dlm_shutdown()
      disconnect last cluster
        clear active_stack
                                      read locking_state
                                        ocfs2_dlm_seq_show()
                                          ocfs2_dlm_lvb()
                                            dereference active_stack
  fill_super(): out_debugfs
    remove debugfs subtree

Publish the debug files only after the connection and the mount lock
resources are initialized, so a failed DLM initialization has no debug
reference to drop.  Remove them again in the common DLM shutdown helper
before the connection is dropped: debugfs removal waits for readers that
are inside the file operations, and the parent directory is still present
at that point in every caller.  This covers the mount error unwind, the
ocfs2_fill_super() failures after a successful mount that dismount with
mnt_err set, and unmounts whose disconnect releases the stack directly.

Only the relevant frames of the report are kept:

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
RIP: 0010:ocfs2_dlm_lvb+0x38/0xf0
Call Trace:
 <TASK>
 ocfs2_dlm_seq_show+0x36a/0xb70
 seq_read_iter+0x480/0x1110
 seq_read+0x362/0x5a0
 full_proxy_read+0x11f/0x180
 vfs_read+0x1a0/0xc20
 ksys_read+0x111/0x200
 </TASK>

Link: https://lore.kernel.org/pm-ocfs2-objects-candidate-0011-v7-61e3ef8b1ad44ac2e817@gmail.com
Fixes: 286eaa95c5c5 ("ocfs2: Break out stackglue into modules.")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/dlmglue.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index cbeb4c4bd044c..6ff52ebe9fa3c 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3339,6 +3339,14 @@ static void ocfs2_dlm_shutdown_debug(struct ocfs2_super *osb)
 {
 	struct ocfs2_dlm_debug *dlm_debug = osb->osb_dlm_debug;
 
+	/*
+	 * Drain the readers before the cluster stack goes away: the
+	 * locking_state reader resolves ocfs2_dlm_lvb() through the
+	 * stack. Every caller removes the parent directory later.
+	 */
+	debugfs_lookup_and_remove("locking_state", osb->osb_debug_root);
+	debugfs_lookup_and_remove("locking_filter", osb->osb_debug_root);
+
 	if (dlm_debug)
 		ocfs2_put_dlm_debug(dlm_debug);
 }
@@ -3353,8 +3361,6 @@ int ocfs2_dlm_init(struct ocfs2_super *osb)
 		goto local;
 	}
 
-	ocfs2_dlm_init_debug(osb);
-
 	/* launch downconvert thread */
 	osb->dc_task = kthread_run(ocfs2_downconvert_thread, osb, "ocfs2dc-%s",
 			osb->uuid_str);
@@ -3394,9 +3400,10 @@ int ocfs2_dlm_init(struct ocfs2_super *osb)
 	ocfs2_orphan_scan_lock_res_init(&osb->osb_orphan_scan.os_lockres, osb);
 
 	osb->cconn = conn;
+	if (conn)
+		ocfs2_dlm_init_debug(osb);
 bail:
 	if (status < 0) {
-		ocfs2_dlm_shutdown_debug(osb);
 		if (osb->dc_task)
 			kthread_stop(osb->dc_task);
 	}
@@ -3426,10 +3433,11 @@ void ocfs2_dlm_shutdown(struct ocfs2_super *osb,
 	ocfs2_lock_res_free(&osb->osb_orphan_scan.os_lockres);
 
 	if (osb->cconn) {
+		/* The disconnect below may release the selected stack. */
+		ocfs2_dlm_shutdown_debug(osb);
+
 		ocfs2_cluster_disconnect(osb->cconn, hangup_pending);
 		osb->cconn = NULL;
-
-		ocfs2_dlm_shutdown_debug(osb);
 	}
 }
 
-- 
2.53.0



