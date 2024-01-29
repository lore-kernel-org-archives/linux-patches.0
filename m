Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8766515957C;
	Mon, 29 Jan 2024 17:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548451; cv=none; b=VExPLpb1Yt53UPQSuNH/Vs8k6GtSD2CWIOpDRNHUKD7fOmdNAao7lBpl5o21BK3RxsOyoMz1w5bEE3EZ2sScjzR6WZKrhBTNfrfwpPrkzI2mj8fohfVl42N0XXLodxGQlIHQyUsysQTAkKQOngj5DBhq6gTz1gmkrKtrOUdfK7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548451; c=relaxed/simple;
	bh=4Zkj9JRb5ad7xi2oYr6t6fiIaBoGorERQAwSa1xVQNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oGujPXu96VVYVQT4YxiVdDrHgFaJ0MbpqxfQe9f29y2Lah6pb29cqKkopjPX2ro17A5/jcWwWwQY7WoBiJbhpImzJpXxjDodh5zWogeezT0bScevWbSSYYBg/CbPS/3gp7biFNEzZICq+kjwec84OJmWY+ipWXq/GQ2dZTPCDUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CcqXNG8P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CcqXNG8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA9EC433F1;
	Mon, 29 Jan 2024 17:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548451;
	bh=4Zkj9JRb5ad7xi2oYr6t6fiIaBoGorERQAwSa1xVQNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CcqXNG8PEFj0dW97h9c+m2rPWe3XOgAmZqbvtug7BhnKGWP7MEkN00IGfPmKF7ZcU
	 QCHPNuYhAmnNxwOSe1F+48kls3cVzd5KJ1fBrMde7RHm8TEVSFVN7ZQmARxvmjxWd/
	 aIVropQrEwWiMTV07Eoo6zUY26cXnlkLqE8q3WLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 026/331] cifs: reconnect worker should take reference on server struct unconditionally
Date: Mon, 29 Jan 2024 09:01:30 -0800
Message-ID: <20240129170015.722522570@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit 04909192ada3285070f8ced0af7f07735478b364 ]

Reconnect worker currently assumes that the server struct
is alive and only takes reference on the server if it needs
to call smb2_reconnect.

With the new ability to disable channels based on whether the
server has multichannel disabled, this becomes a problem when
we need to disable established channels. While disabling the
channels and deallocating the server, there could be reconnect
work that could not be cancelled (because it started).

This change forces the reconnect worker to unconditionally
take a reference on the server when it runs.

Also, this change now allows smb2_reconnect to know if it was
called by the reconnect worker. Based on this, the cifs_put_tcp_session
can decide whether it can cancel the reconnect work synchronously or not.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 78e727e58e54 ("cifs: update iface_last_update on each query-and-update")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/connect.c |  8 ++++----
 fs/smb/client/smb2pdu.c | 29 +++++++++++++++--------------
 2 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 2a30245287d5..432248e955ed 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1612,10 +1612,6 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
 	list_del_init(&server->tcp_ses_list);
 	spin_unlock(&cifs_tcp_ses_lock);
 
-	/* For secondary channels, we pick up ref-count on the primary server */
-	if (SERVER_IS_CHAN(server))
-		cifs_put_tcp_session(server->primary_server, from_reconnect);
-
 	cancel_delayed_work_sync(&server->echo);
 
 	if (from_reconnect)
@@ -1629,6 +1625,10 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
 	else
 		cancel_delayed_work_sync(&server->reconnect);
 
+	/* For secondary channels, we pick up ref-count on the primary server */
+	if (SERVER_IS_CHAN(server))
+		cifs_put_tcp_session(server->primary_server, from_reconnect);
+
 	spin_lock(&server->srv_lock);
 	server->tcpStatus = CifsExiting;
 	spin_unlock(&server->srv_lock);
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index da752f41a4e6..a3995c6dc1ad 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -158,7 +158,7 @@ smb2_hdr_assemble(struct smb2_hdr *shdr, __le16 smb2_cmd,
 
 static int
 smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
-	       struct TCP_Server_Info *server)
+	       struct TCP_Server_Info *server, bool from_reconnect)
 {
 	int rc = 0;
 	struct nls_table *nls_codepage = NULL;
@@ -331,7 +331,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 				 * as cifs_put_tcp_session takes a higher lock
 				 * i.e. cifs_tcp_ses_lock
 				 */
-				cifs_put_tcp_session(server, 1);
+				cifs_put_tcp_session(server, from_reconnect);
 
 				server->terminate = true;
 				cifs_signal_cifsd_for_reconnect(server, false);
@@ -504,7 +504,7 @@ static int smb2_plain_req_init(__le16 smb2_command, struct cifs_tcon *tcon,
 {
 	int rc;
 
-	rc = smb2_reconnect(smb2_command, tcon, server);
+	rc = smb2_reconnect(smb2_command, tcon, server, false);
 	if (rc)
 		return rc;
 
@@ -3924,6 +3924,15 @@ void smb2_reconnect_server(struct work_struct *work)
 	int rc;
 	bool resched = false;
 
+	/* first check if ref count has reached 0, if not inc ref count */
+	spin_lock(&cifs_tcp_ses_lock);
+	if (!server->srv_count) {
+		spin_unlock(&cifs_tcp_ses_lock);
+		return;
+	}
+	server->srv_count++;
+	spin_unlock(&cifs_tcp_ses_lock);
+
 	/* If server is a channel, select the primary channel */
 	pserver = SERVER_IS_CHAN(server) ? server->primary_server : server;
 
@@ -3981,17 +3990,10 @@ void smb2_reconnect_server(struct work_struct *work)
 		}
 		spin_unlock(&ses->chan_lock);
 	}
-	/*
-	 * Get the reference to server struct to be sure that the last call of
-	 * cifs_put_tcon() in the loop below won't release the server pointer.
-	 */
-	if (tcon_exist || ses_exist)
-		server->srv_count++;
-
 	spin_unlock(&cifs_tcp_ses_lock);
 
 	list_for_each_entry_safe(tcon, tcon2, &tmp_list, rlist) {
-		rc = smb2_reconnect(SMB2_INTERNAL_CMD, tcon, server);
+		rc = smb2_reconnect(SMB2_INTERNAL_CMD, tcon, server, true);
 		if (!rc)
 			cifs_reopen_persistent_handles(tcon);
 		else
@@ -4024,7 +4026,7 @@ void smb2_reconnect_server(struct work_struct *work)
 	/* now reconnect sessions for necessary channels */
 	list_for_each_entry_safe(ses, ses2, &tmp_ses_list, rlist) {
 		tcon->ses = ses;
-		rc = smb2_reconnect(SMB2_INTERNAL_CMD, tcon, server);
+		rc = smb2_reconnect(SMB2_INTERNAL_CMD, tcon, server, true);
 		if (rc)
 			resched = true;
 		list_del_init(&ses->rlist);
@@ -4039,8 +4041,7 @@ void smb2_reconnect_server(struct work_struct *work)
 	mutex_unlock(&pserver->reconnect_mutex);
 
 	/* now we can safely release srv struct */
-	if (tcon_exist || ses_exist)
-		cifs_put_tcp_session(server, 1);
+	cifs_put_tcp_session(server, true);
 }
 
 int
-- 
2.43.0



