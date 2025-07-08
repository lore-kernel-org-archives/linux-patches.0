Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D88B1548C;
	Tue,  8 Jul 2025 16:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992353; cv=none; b=Og02NnlDV4h8idoMBwFtL7ZhtzKAb+yr4k//oKASNWhKhYPw9dN44BRw+WEY9nkT4W36Gxakybg95GPjUjcTSrrKWNuwDKVeaWT/+Rom7e4F+doyPoMfVNJ+kQO8VrGyn/sRRkGvwjETh6+Q5WHM/oWe4gJ2J9LPzsKlzkL3Kj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992353; c=relaxed/simple;
	bh=u/yv1fiHOHgIDZlk7ipp3IAIg+WrhTtTNqhzqstoJPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLhoPSKhW+W0G00vR7JPlSPvBn69s6ZEE7fmxOs1eBpLJqqxw7qTa20cwmfgQt3nCQbGH2pQ5pHgDor2i1bDdLPLDSaNvwJBLlSNtyCwrb8CB7jTw3VUnbnvJxCTtcuM1JGddvr9PcRZNKVggOPYqtPGP9C+Iyc59htfMhNTIc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LTkB5xhm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LTkB5xhm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F98C4CEED;
	Tue,  8 Jul 2025 16:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992353;
	bh=u/yv1fiHOHgIDZlk7ipp3IAIg+WrhTtTNqhzqstoJPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LTkB5xhmOsuiFjCMzolN0W+V1IB36Yat3CF1y8o7LOau57bZCxImdXu4xG6U8UC+w
	 7WGI5FWGY47QLcBsJXkBrQpbIgP2ziRbycAeh8APk0mIGMpu2+/205g7QwQsOVaTjL
	 HL0LsJpj4TwPR3mRqf39NplKc2vVZwmoexmGFung=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Zhaolong <wangzhaolong@huaweicloud.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 063/132] smb: client: fix race condition in negotiate timeout by using more precise timing
Date: Tue,  8 Jul 2025 18:22:54 +0200
Message-ID: <20250708162232.499336773@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a6020f7408fe5..5c856adf7be9e 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -743,6 +743,7 @@ struct TCP_Server_Info {
 	__le32 session_key_id; /* retrieved from negotiate response and send in session setup request */
 	struct session_key session_key;
 	unsigned long lstrp; /* when we got last response from this server */
+	unsigned long neg_start; /* when negotiate started (jiffies) */
 	struct cifs_secmech secmech; /* crypto sec mech functs, descriptors */
 #define	CIFS_NEGFLAVOR_UNENCAP	1	/* wct == 17, but no ext_sec */
 #define	CIFS_NEGFLAVOR_EXTENDED	2	/* wct == 17, ext_sec bit set */
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 454420aa02220..8298d1745f9b9 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -677,12 +677,12 @@ server_unresponsive(struct TCP_Server_Info *server)
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
@@ -3998,6 +3998,7 @@ cifs_negotiate_protocol(const unsigned int xid, struct cifs_ses *ses,
 
 	server->lstrp = jiffies;
 	server->tcpStatus = CifsInNegotiate;
+	server->neg_start = jiffies;
 	spin_unlock(&server->srv_lock);
 
 	rc = server->ops->negotiate(xid, ses, server);
-- 
2.39.5



