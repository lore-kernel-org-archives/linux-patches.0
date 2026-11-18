Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051952;
	b=2N6pFwH6GeOVTLbtJ42S7HgfmHUcjmNvR/pKNuyoJEDeUxFCjRoFzoCaWaInwINWMEe+
	 8TnrbnKgkvVnhE6oxXlkZrHludUUEVYIGa2QPAg3y77ATpPNG5GNfpyJOpt8oTnuiQckV
	 Zro1j+ncZKx6SG7fyCXf1jlFzfT73GAsooS5CEfzARTQoSySpRhPdLaNPVRVztgkav7c1
	 yYaWiU2V8CU7VC5NCPHltcOYJ5vnlkRMbYcQCpsT/M+B19hHNb98MM1eQkWdEoZ4anbkM
	 mthE3JTcJlSy+Ap0W6ok318lZrhptcNM74ViVIxVVmbLS3rZkjCTyUvjcivn7SRtH8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051952;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fsZI2zn9g85tzWXN1GRWYmaHoKrJE4dwDk+GE20FY2M=;
	b=MkRYZiEYn8NIBmpGyb2P10NQCdE4vWHVCSg6luhwZEHiYt/Rs4j0wfBoNTGFX+2akXls
	 hYK2J+mtOTITsOcMmSueS42tgWxpmf/AuHLIOikJkP7P5w1tAqeYs+nbnxnDPL/xdMvxD
	 JGP9fbho4IDjFUZdv7p6yzC2dFKfNgK+hnApkFCB27LHUiggiYOtFQnio4YMEUkph7WKz
	 VT2yqor34ye1ff3TXAQ4+xuERnQbAdJcHZSKHItTtrs5AjFKa2X9NiIwPK6Uu1A2eJFOo
	 FUzGBqlE3s4S2NuSkFMD6YGt07rf1lsYhwDNDMYSnbLG5w7a9xbuEGvXsqgma6/ulpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mUaRn0RW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51CA6606A332;
	Thu, 19 Nov 2026 01:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mUaRn0RW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670741F000C4;
	Thu, 19 Nov 2026 01:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051951;
	bh=fsZI2zn9g85tzWXN1GRWYmaHoKrJE4dwDk+GE20FY2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mUaRn0RWy3oA7M8r9GbTSvuu9c+MvI3Pv3hpis3zdNs9Aqmw1BqTsjNM2HvvctAtS
	 VZYs3FLadcBZG6c6A/zRRGwyteyctXZv2JX2ivr2THc8U1glGoxM80XQZnF6XM6sLD
	 m2OSwnwSnuxZH6/XiMgmEcEw4XXiDTnSXiLuUHwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fredric Cover <fredric.cover.lkernel@gmail.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0391/2214] smb: client: fix early procfs exposure race
Date: Wed, 18 Nov 2026 15:34:27 +0100
Message-ID: <20261118150026.307153435@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fredric Cover <fredric.cover.lkernel@gmail.com>

[ Upstream commit 7b1afb631395c958993cda4631002258ef4151ea ]

Currently, init_cifs() calls cifs_proc_init() near the beginning of
the function, before INIT_LIST_HEAD, leading to a momentarily
uninitialized, but exposed, procfs. If a userspace process reads this
empty procfs, iterating over a zeroed list_head leads to a NULL
pointer dereference and a kernel oops/panic.

For example, if a delay is added between cifs_proc_init() and
INIT_LIST_HEAD, and a userspace process is polling
/proc/fs/cifs/DebugData, the following oops occurs:

BUG: kernel NULL pointer dereference, address: 0000000000000608
Oops: Oops: 0000 [#1] SMP PTI
CPU: 0 UID: 0 PID: 3477 Comm: cat Not tainted
7.3.0-02212-g4df4d2a577db-dirty #6 PREEMPT(lazy)
RIP: 0010:cifs_debug_data_proc_show+0x103/0xd80 [cifs]
Call Trace:
<TASK>
 ? seq_read_iter+0x86/0x400
 ? seq_read_iter+0x86/0x400
 seq_read_iter+0x183/0x400
 proc_reg_read_iter+0x62/0x90
 copy_splice_read+0x215/0x310
 splice_file_to_pipe+0xec/0x1c0
 do_splice+0x4b8/0x780
 __se_sys_splice+0x18f/0x250
 do_syscall_64+0x109/0x330
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
</TASK>

Fix this by moving cifs_proc_init() down in init_cifs(), ensuring it runs
only after all internal lists, locks, counters, and workqueues are fully
ready, but before registering the filesystem. Update the error cleanup
ladder and exit_cifs() to maintain proper LIFO order.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
[ sashal: adjusted context to match existing CIFS initialization and teardown code ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsfs.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index e3572c30be4f9..7b0255c600c3a 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1590,7 +1590,6 @@ static int __init
 init_cifs(void)
 {
 	int rc = 0;
-	cifs_proc_init();
 	INIT_LIST_HEAD(&cifs_tcp_ses_list);
 /*
  *  Initialize Global counters
@@ -1633,10 +1632,8 @@ init_cifs(void)
 	}
 
 	cifsiod_wq = alloc_workqueue("cifsiod", WQ_FREEZABLE|WQ_MEM_RECLAIM, 0);
-	if (!cifsiod_wq) {
-		rc = -ENOMEM;
-		goto out_clean_proc;
-	}
+	if (!cifsiod_wq)
+		return -ENOMEM;
 
 	/*
 	 * Consider in future setting limit!=0 maybe to min(num_of_cores - 1, 3)
@@ -1709,19 +1706,22 @@ init_cifs(void)
 	if (rc)
 		goto out_cifs_swn_init;
 
+	cifs_proc_init();
+
 	rc = register_filesystem(&cifs_fs_type);
 	if (rc)
-		goto out_init_cifs_idmap;
+		goto out_clean_proc;
 
 	rc = register_filesystem(&smb3_fs_type);
 	if (rc) {
 		unregister_filesystem(&cifs_fs_type);
-		goto out_init_cifs_idmap;
+		goto out_clean_proc;
 	}
 
 	return 0;
 
-out_init_cifs_idmap:
+out_clean_proc:
+	cifs_proc_clean();
 	exit_cifs_idmap();
 out_cifs_swn_init:
 #ifdef CONFIG_CIFS_SWN_UPCALL
@@ -1753,8 +1753,6 @@ init_cifs(void)
 	destroy_workqueue(decrypt_wq);
 out_destroy_cifsiod_wq:
 	destroy_workqueue(cifsiod_wq);
-out_clean_proc:
-	cifs_proc_clean();
 	return rc;
 }
 
@@ -1764,6 +1762,7 @@ exit_cifs(void)
 	cifs_dbg(NOISY, "exit_smb3\n");
 	unregister_filesystem(&cifs_fs_type);
 	unregister_filesystem(&smb3_fs_type);
+	cifs_proc_clean();
 	cifs_dfs_release_automount_timer();
 	exit_cifs_idmap();
 #ifdef CONFIG_CIFS_SWN_UPCALL
@@ -1784,7 +1783,6 @@ exit_cifs(void)
 	destroy_workqueue(decrypt_wq);
 	destroy_workqueue(fileinfo_put_wq);
 	destroy_workqueue(cifsiod_wq);
-	cifs_proc_clean();
 }
 
 MODULE_AUTHOR("Steve French");
-- 
2.53.0



