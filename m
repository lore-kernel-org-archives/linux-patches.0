Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AEA6225414;
	Tue,  8 Jul 2025 16:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993561; cv=none; b=fkXnfjm+R/KTEHQryiOQEbIsKwtr9rB/RYBGSq/iL+/PoaHek/x+jn2/vTNbB5MRzU+QG7hklhzrXM6iDtcAwJbJGz368l5euHYUH1RGA5XP2Vl0HSkeHmkThggJyZmBWitwbeBNmnflhBMFyG4R2v+GSJ7Erj87OF22eLZG6mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993561; c=relaxed/simple;
	bh=4zDJ56QBfvX8Hna1sSFPHrRL/oqc9LPrAGYcd8RzKAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aKlGawPfVN9QFUB5J1j3aFozplWCfGOScfLr1adYKRPfmUvpwmb2Mgt2KB7G3oWRriOWGus8lg03pKaxPp2cST52Z893cJo0uMfl0tVKXA19gxhIWozDqiJGgXrSK2P1X4ft8nYxwqj+RKnqV2/xQCnYOMPS1f5QQIRsVuJNCKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KOkKtyv8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KOkKtyv8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C39C4CEED;
	Tue,  8 Jul 2025 16:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993561;
	bh=4zDJ56QBfvX8Hna1sSFPHrRL/oqc9LPrAGYcd8RzKAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KOkKtyv8dofpx0ZAYm3yBBvbRH+D1r9yoK+gV/1w5zyR03rCFUPt79W1HapS1CGne
	 2TV+WjaMXPwmJelXVGOECVT+jsihJlnGlanFiGKIKiZwrzL2ZWg4Wm2AIgweAPZylk
	 NKFcFB660aIcU3qydSnchR1gW1U5MRmX7d4bhR+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Zhaolong <wangzhaolong@huaweicloud.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 117/178] smb: client: fix race condition in negotiate timeout by using more precise timing
Date: Tue,  8 Jul 2025 18:22:34 +0200
Message-ID: <20250708162239.668683271@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Zhaolong <wangzhaolong@huaweicloud.com>

[ Upstream commit 266b5d02e14f3a0e07414e11f239397de0577a1d ]

When the SMB server reboots and the client immediately accesses the mount
point, a race condition can occur that causes operations to fail with
"Host is down" error.

Reproduction steps:
  # Mount SMB share
  mount -t cifs //192.168.245.109/TEST /mnt/ -o xxxx
  ls /mnt

  # Reboot server
  ssh root@192.168.245.109 reboot
  ssh root@192.168.245.109 /path/to/cifs_server_setup.sh
  ssh root@192.168.245.109 systemctl stop firewalld

  # Immediate access fails
  ls /mnt
  ls: cannot access '/mnt': Host is down

  # But works if there is a delay

The issue is caused by a race condition between negotiate and reconnect.
The 20-second negotiate timeout mechanism can interfere with the normal
recovery process when both are triggered simultaneously.

  ls                              cifsd
---------------------------------------------------
 cifs_getattr
 cifs_revalidate_dentry
 cifs_get_inode_info
 cifs_get_fattr
 smb2_query_path_info
 smb2_compound_op
 SMB2_open_init
 smb2_reconnect
 cifs_negotiate_protocol
  smb2_negotiate
   cifs_send_recv
    smb_send_rqst
    wait_for_response
                            cifs_demultiplex_thread
                              cifs_read_from_socket
                              cifs_readv_from_socket
                                server_unresponsive
                                cifs_reconnect
                                  __cifs_reconnect
                                  cifs_abort_connection
                                    mid->mid_state = MID_RETRY_NEEDED
                                    cifs_wake_up_task
    cifs_sync_mid_result
     // case MID_RETRY_NEEDED
     rc = -EAGAIN;
   // In smb2_negotiate()
   rc = -EHOSTDOWN;

The server_unresponsive() timeout triggers cifs_reconnect(), which aborts
ongoing mid requests and causes the ls command to receive -EAGAIN, leading
to -EHOSTDOWN.

Fix this by introducing a dedicated `neg_start` field to
precisely tracks when the negotiate process begins. The timeout check
now uses this accurate timestamp instead of `lstrp`, ensuring that:

1. Timeout is only triggered after negotiate has actually run for 20s
2. The mechanism doesn't interfere with concurrent recovery processes
3. Uninitialized timestamps (value 0) don't trigger false timeouts

Fixes: 7ccc1465465d ("smb: client: fix hang in wait_for_response() for negproto")
Signed-off-by: Wang Zhaolong <wangzhaolong@huaweicloud.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsglob.h | 1 +
 fs/smb/client/connect.c  | 7 ++++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index b89db44e0a8e3..eed29f043114a 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -777,6 +777,7 @@ struct TCP_Server_Info {
 	__le32 session_key_id; /* retrieved from negotiate response and send in session setup request */
 	struct session_key session_key;
 	unsigned long lstrp; /* when we got last response from this server */
+	unsigned long neg_start; /* when negotiate started (jiffies) */
 	struct cifs_secmech secmech; /* crypto sec mech functs, descriptors */
 #define	CIFS_NEGFLAVOR_UNENCAP	1	/* wct == 17, but no ext_sec */
 #define	CIFS_NEGFLAVOR_EXTENDED	2	/* wct == 17, ext_sec bit set */
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index e92c7b71626fd..b4b162c93106b 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -679,12 +679,12 @@ server_unresponsive(struct TCP_Server_Info *server)
 	/*
 	 * If we're in the process of mounting a share or reconnecting a session
 	 * and the server abruptly shut down (e.g. socket wasn't closed, packet
-	 * had been ACK'ed but no SMB response), don't wait longer than 20s to
-	 * negotiate protocol.
+	 * had been ACK'ed but no SMB response), don't wait longer than 20s from
+	 * when negotiate actually started.
 	 */
 	spin_lock(&server->srv_lock);
 	if (server->tcpStatus == CifsInNegotiate &&
-	    time_after(jiffies, server->lstrp + 20 * HZ)) {
+	    time_after(jiffies, server->neg_start + 20 * HZ)) {
 		spin_unlock(&server->srv_lock);
 		cifs_reconnect(server, false);
 		return true;
@@ -4209,6 +4209,7 @@ cifs_negotiate_protocol(const unsigned int xid, struct cifs_ses *ses,
 
 	server->lstrp = jiffies;
 	server->tcpStatus = CifsInNegotiate;
+	server->neg_start = jiffies;
 	spin_unlock(&server->srv_lock);
 
 	rc = server->ops->negotiate(xid, ses, server);
-- 
2.39.5



