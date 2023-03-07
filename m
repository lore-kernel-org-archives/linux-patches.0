Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63226BA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5FB1C433EF;
	Tue,  7 Mar 2023 17:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211057;
	bh=x8QQC8Sso74aHc/fshn/Nnjs36aQLerzYq2RGzsexfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wq9/nmCngFvuKRgIz2y2j/q5MaU9fCd25qe4UkZPDeO5XURcmYv5lmaHYmcny9PH+
	 9PwS2Y9rnYCh25FqWh0AgVdYYs08Ue3wzjp/Sne6VFPQBl4bcPuQtoSzEJBhEPW4A3
	 FVGyRquu8M/vCMNw4PvMJJzIu4cO79bZaTNJVAzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0740/1001] cifs: prevent data race in smb2_reconnect()
Date: Tue,  7 Mar 2023 17:58:32 +0100
Message-Id: <20230307170053.847257904@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paulo Alcantara <pc@cjr.nz>

[ Upstream commit 3c0070f54b3128de498c2dd9934a21f0dd867111 ]

Make sure to get an up-to-date TCP_Server_Info::nr_targets value prior
to waiting the server to be reconnected in smb2_reconnect().  It is
set in cifs_tcp_ses_needs_reconnect() and protected by
TCP_Server_Info::srv_lock.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2pdu.c | 119 +++++++++++++++++++++++++---------------------
 1 file changed, 64 insertions(+), 55 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 3b93680a319e4..5a063af8a094e 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -139,6 +139,66 @@ smb2_hdr_assemble(struct smb2_hdr *shdr, __le16 smb2_cmd,
 	return;
 }
 
+static int wait_for_server_reconnect(struct TCP_Server_Info *server,
+				     __le16 smb2_command, bool retry)
+{
+	int timeout = 10;
+	int rc;
+
+	spin_lock(&server->srv_lock);
+	if (server->tcpStatus != CifsNeedReconnect) {
+		spin_unlock(&server->srv_lock);
+		return 0;
+	}
+	timeout *= server->nr_targets;
+	spin_unlock(&server->srv_lock);
+
+	/*
+	 * Return to caller for TREE_DISCONNECT and LOGOFF and CLOSE
+	 * here since they are implicitly done when session drops.
+	 */
+	switch (smb2_command) {
+	/*
+	 * BB Should we keep oplock break and add flush to exceptions?
+	 */
+	case SMB2_TREE_DISCONNECT:
+	case SMB2_CANCEL:
+	case SMB2_CLOSE:
+	case SMB2_OPLOCK_BREAK:
+		return -EAGAIN;
+	}
+
+	/*
+	 * Give demultiplex thread up to 10 seconds to each target available for
+	 * reconnect -- should be greater than cifs socket timeout which is 7
+	 * seconds.
+	 *
+	 * On "soft" mounts we wait once. Hard mounts keep retrying until
+	 * process is killed or server comes back on-line.
+	 */
+	do {
+		rc = wait_event_interruptible_timeout(server->response_q,
+						      (server->tcpStatus != CifsNeedReconnect),
+						      timeout * HZ);
+		if (rc < 0) {
+			cifs_dbg(FYI, "%s: aborting reconnect due to received signal\n",
+				 __func__);
+			return -ERESTARTSYS;
+		}
+
+		/* are we still trying to reconnect? */
+		spin_lock(&server->srv_lock);
+		if (server->tcpStatus != CifsNeedReconnect) {
+			spin_unlock(&server->srv_lock);
+			return 0;
+		}
+		spin_unlock(&server->srv_lock);
+	} while (retry);
+
+	cifs_dbg(FYI, "%s: gave up waiting on reconnect\n", __func__);
+	return -EHOSTDOWN;
+}
+
 static int
 smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	       struct TCP_Server_Info *server)
@@ -146,7 +206,6 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	int rc = 0;
 	struct nls_table *nls_codepage;
 	struct cifs_ses *ses;
-	int retries;
 
 	/*
 	 * SMB2s NegProt, SessSetup, Logoff do not have tcon yet so
@@ -184,61 +243,11 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	    (!tcon->ses->server) || !server)
 		return -EIO;
 
-	ses = tcon->ses;
-	retries = server->nr_targets;
-
-	/*
-	 * Give demultiplex thread up to 10 seconds to each target available for
-	 * reconnect -- should be greater than cifs socket timeout which is 7
-	 * seconds.
-	 */
-	while (server->tcpStatus == CifsNeedReconnect) {
-		/*
-		 * Return to caller for TREE_DISCONNECT and LOGOFF and CLOSE
-		 * here since they are implicitly done when session drops.
-		 */
-		switch (smb2_command) {
-		/*
-		 * BB Should we keep oplock break and add flush to exceptions?
-		 */
-		case SMB2_TREE_DISCONNECT:
-		case SMB2_CANCEL:
-		case SMB2_CLOSE:
-		case SMB2_OPLOCK_BREAK:
-			return -EAGAIN;
-		}
-
-		rc = wait_event_interruptible_timeout(server->response_q,
-						      (server->tcpStatus != CifsNeedReconnect),
-						      10 * HZ);
-		if (rc < 0) {
-			cifs_dbg(FYI, "%s: aborting reconnect due to a received signal by the process\n",
-				 __func__);
-			return -ERESTARTSYS;
-		}
-
-		/* are we still trying to reconnect? */
-		spin_lock(&server->srv_lock);
-		if (server->tcpStatus != CifsNeedReconnect) {
-			spin_unlock(&server->srv_lock);
-			break;
-		}
-		spin_unlock(&server->srv_lock);
-
-		if (retries && --retries)
-			continue;
+	rc = wait_for_server_reconnect(server, smb2_command, tcon->retry);
+	if (rc)
+		return rc;
 
-		/*
-		 * on "soft" mounts we wait once. Hard mounts keep
-		 * retrying until process is killed or server comes
-		 * back on-line
-		 */
-		if (!tcon->retry) {
-			cifs_dbg(FYI, "gave up waiting on reconnect in smb_init\n");
-			return -EHOSTDOWN;
-		}
-		retries = server->nr_targets;
-	}
+	ses = tcon->ses;
 
 	spin_lock(&ses->chan_lock);
 	if (!cifs_chan_needs_reconnect(ses, server) && !tcon->need_reconnect) {
-- 
2.39.2



