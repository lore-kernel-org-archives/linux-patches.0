Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DDB27C092;
	Mon,  8 Apr 2024 13:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583990; cv=none; b=cYMDKdD08CXVSmsjvlx0q6IngbP7OQNPZyM5VJ6uc7pUFjpTvw2ER+jr8VHLh1LAYCJd/gE33u4WYAAUqumQbzGoPpgYHqesWv+aTlUCPwEHvaZfMspeBuKgLnzE606pM+lnJTRxjrofq/YFRzrGJDIf/uD1SYVr7hXForYnsB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583990; c=relaxed/simple;
	bh=llOwdpzJ73ih2KgS907mPwcGFiA0EaYp32r9JJZX0UU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cGX8DEAFj3No/yZRpVKAL8Pb5+ZdQn1H1CTQ0MJotwVTsnLNI4EW/lQYECsSWMOXIuXvJMo/xhHOrdt3Inmhhn9QrJtRv9TLM+XKqePRdeFZeH8k4bPIs29rsw3So/IMTS33Vf4aSDSOsO1DyTPV/S2n6gXTkWVV0Qhydl6uB1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t2JnU431; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t2JnU431"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88DD0C433F1;
	Mon,  8 Apr 2024 13:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583989;
	bh=llOwdpzJ73ih2KgS907mPwcGFiA0EaYp32r9JJZX0UU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t2JnU431Lh4iq7UARzvFcLeJp3Xm7VUMNmmdwyDA+SWmHfHFQj8k1NLojMeGW3Su5
	 Sow6Yw67OfggOarbCE6uPTe3++yvgI6Y8zr1IoW3FC1ptKoa2U9WzNYSHnZWAF9Sqs
	 YPD6qv+h9X+z61L6Sj/jPLeidJtejY89VWOY8LTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.8 243/273] smb: client: fix UAF in smb2_reconnect_server()
Date: Mon,  8 Apr 2024 14:58:38 +0200
Message-ID: <20240408125316.985633002@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

commit 24a9799aa8efecd0eb55a75e35f9d8e6400063aa upstream.

The UAF bug is due to smb2_reconnect_server() accessing a session that
is already being teared down by another thread that is executing
__cifs_put_smb_ses().  This can happen when (a) the client has
connection to the server but no session or (b) another thread ends up
setting @ses->ses_status again to something different than
SES_EXITING.

To fix this, we need to make sure to unconditionally set
@ses->ses_status to SES_EXITING and prevent any other threads from
setting a new status while we're still tearing it down.

The following can be reproduced by adding some delay to right after
the ipc is freed in __cifs_put_smb_ses() - which will give
smb2_reconnect_server() worker a chance to run and then accessing
@ses->ipc:

kinit ...
mount.cifs //srv/share /mnt/1 -o sec=krb5,nohandlecache,echo_interval=10
[disconnect srv]
ls /mnt/1 &>/dev/null
sleep 30
kdestroy
[reconnect srv]
sleep 10
umount /mnt/1
...
CIFS: VFS: Verify user has a krb5 ticket and keyutils is installed
CIFS: VFS: \\srv Send error in SessSetup = -126
CIFS: VFS: Verify user has a krb5 ticket and keyutils is installed
CIFS: VFS: \\srv Send error in SessSetup = -126
general protection fault, probably for non-canonical address
0x6b6b6b6b6b6b6b6b: 0000 [#1] PREEMPT SMP NOPTI
CPU: 3 PID: 50 Comm: kworker/3:1 Not tainted 6.9.0-rc2 #1
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-1.fc39
04/01/2014
Workqueue: cifsiod smb2_reconnect_server [cifs]
RIP: 0010:__list_del_entry_valid_or_report+0x33/0xf0
Code: 4f 08 48 85 d2 74 42 48 85 c9 74 59 48 b8 00 01 00 00 00 00 ad
de 48 39 c2 74 61 48 b8 22 01 00 00 00 00 74 69 <48> 8b 01 48 39 f8 75
7b 48 8b 72 08 48 39 c6 0f 85 88 00 00 00 b8
RSP: 0018:ffffc900001bfd70 EFLAGS: 00010a83
RAX: dead000000000122 RBX: ffff88810da53838 RCX: 6b6b6b6b6b6b6b6b
RDX: 6b6b6b6b6b6b6b6b RSI: ffffffffc02f6878 RDI: ffff88810da53800
RBP: ffff88810da53800 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: ffff88810c064000
R13: 0000000000000001 R14: ffff88810c064000 R15: ffff8881039cc000
FS: 0000000000000000(0000) GS:ffff888157c00000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe3728b1000 CR3: 000000010caa4000 CR4: 0000000000750ef0
PKRU: 55555554
Call Trace:
 <TASK>
 ? die_addr+0x36/0x90
 ? exc_general_protection+0x1c1/0x3f0
 ? asm_exc_general_protection+0x26/0x30
 ? __list_del_entry_valid_or_report+0x33/0xf0
 __cifs_put_smb_ses+0x1ae/0x500 [cifs]
 smb2_reconnect_server+0x4ed/0x710 [cifs]
 process_one_work+0x205/0x6b0
 worker_thread+0x191/0x360
 ? __pfx_worker_thread+0x10/0x10
 kthread+0xe2/0x110
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x34/0x50
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1a/0x30
 </TASK>

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |   85 +++++++++++++++++++-----------------------------
 1 file changed, 35 insertions(+), 50 deletions(-)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -235,7 +235,13 @@ cifs_mark_tcp_ses_conns_for_reconnect(st
 
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry_safe(ses, nses, &pserver->smb_ses_list, smb_ses_list) {
-		/* check if iface is still active */
+		spin_lock(&ses->ses_lock);
+		if (ses->ses_status == SES_EXITING) {
+			spin_unlock(&ses->ses_lock);
+			continue;
+		}
+		spin_unlock(&ses->ses_lock);
+
 		spin_lock(&ses->chan_lock);
 		if (cifs_ses_get_chan_index(ses, server) ==
 		    CIFS_INVAL_CHAN_INDEX) {
@@ -1966,31 +1972,6 @@ out:
 	return rc;
 }
 
-/**
- * cifs_free_ipc - helper to release the session IPC tcon
- * @ses: smb session to unmount the IPC from
- *
- * Needs to be called everytime a session is destroyed.
- *
- * On session close, the IPC is closed and the server must release all tcons of the session.
- * No need to send a tree disconnect here.
- *
- * Besides, it will make the server to not close durable and resilient files on session close, as
- * specified in MS-SMB2 3.3.5.6 Receiving an SMB2 LOGOFF Request.
- */
-static int
-cifs_free_ipc(struct cifs_ses *ses)
-{
-	struct cifs_tcon *tcon = ses->tcon_ipc;
-
-	if (tcon == NULL)
-		return 0;
-
-	tconInfoFree(tcon);
-	ses->tcon_ipc = NULL;
-	return 0;
-}
-
 static struct cifs_ses *
 cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 {
@@ -2022,48 +2003,52 @@ cifs_find_smb_ses(struct TCP_Server_Info
 void __cifs_put_smb_ses(struct cifs_ses *ses)
 {
 	struct TCP_Server_Info *server = ses->server;
+	struct cifs_tcon *tcon;
 	unsigned int xid;
 	size_t i;
+	bool do_logoff;
 	int rc;
 
+	spin_lock(&cifs_tcp_ses_lock);
 	spin_lock(&ses->ses_lock);
-	if (ses->ses_status == SES_EXITING) {
+	cifs_dbg(FYI, "%s: id=0x%llx ses_count=%d ses_status=%u ipc=%s\n",
+		 __func__, ses->Suid, ses->ses_count, ses->ses_status,
+		 ses->tcon_ipc ? ses->tcon_ipc->tree_name : "none");
+	if (ses->ses_status == SES_EXITING || --ses->ses_count > 0) {
 		spin_unlock(&ses->ses_lock);
-		return;
-	}
-	spin_unlock(&ses->ses_lock);
-
-	cifs_dbg(FYI, "%s: ses_count=%d\n", __func__, ses->ses_count);
-	cifs_dbg(FYI,
-		 "%s: ses ipc: %s\n", __func__, ses->tcon_ipc ? ses->tcon_ipc->tree_name : "NONE");
-
-	spin_lock(&cifs_tcp_ses_lock);
-	if (--ses->ses_count > 0) {
 		spin_unlock(&cifs_tcp_ses_lock);
 		return;
 	}
-	spin_lock(&ses->ses_lock);
-	if (ses->ses_status == SES_GOOD)
-		ses->ses_status = SES_EXITING;
-	spin_unlock(&ses->ses_lock);
-	spin_unlock(&cifs_tcp_ses_lock);
-
 	/* ses_count can never go negative */
 	WARN_ON(ses->ses_count < 0);
 
-	spin_lock(&ses->ses_lock);
-	if (ses->ses_status == SES_EXITING && server->ops->logoff) {
-		spin_unlock(&ses->ses_lock);
-		cifs_free_ipc(ses);
+	spin_lock(&ses->chan_lock);
+	cifs_chan_clear_need_reconnect(ses, server);
+	spin_unlock(&ses->chan_lock);
+
+	do_logoff = ses->ses_status == SES_GOOD && server->ops->logoff;
+	ses->ses_status = SES_EXITING;
+	tcon = ses->tcon_ipc;
+	ses->tcon_ipc = NULL;
+	spin_unlock(&ses->ses_lock);
+	spin_unlock(&cifs_tcp_ses_lock);
+
+	/*
+	 * On session close, the IPC is closed and the server must release all
+	 * tcons of the session.  No need to send a tree disconnect here.
+	 *
+	 * Besides, it will make the server to not close durable and resilient
+	 * files on session close, as specified in MS-SMB2 3.3.5.6 Receiving an
+	 * SMB2 LOGOFF Request.
+	 */
+	tconInfoFree(tcon);
+	if (do_logoff) {
 		xid = get_xid();
 		rc = server->ops->logoff(xid, ses);
 		if (rc)
 			cifs_server_dbg(VFS, "%s: Session Logoff failure rc=%d\n",
 				__func__, rc);
 		_free_xid(xid);
-	} else {
-		spin_unlock(&ses->ses_lock);
-		cifs_free_ipc(ses);
 	}
 
 	spin_lock(&cifs_tcp_ses_lock);


