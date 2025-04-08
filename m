Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2D9268C6B;
	Tue,  8 Apr 2025 12:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115100; cv=none; b=F5JsAIUqazWq9bb5083PYtaxo2JREJzFZAGUrVWpYWTwwv935lTgRQM11gZQ2Pc9PcgJW2UXuP+h4SP0rBTvyw527oSsczVqekSkx3HQWt43GfmjIC6Lyx74ItGroOcQuEH/fKxQ+/T8YYu7M+Labpg6oBWjIv90ibzzxZ+lPpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115100; c=relaxed/simple;
	bh=dmYhj/3oIgeotgbQyyFD8Q9Yeg5h7XEyIavb33Hk0ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pqPPUqrb62nVmhktN6znjJss+P2otFHrwRbBVLtUAiC4gVQIc3O6Ro3qtR9Q3+ezjPKR4onVvN53gblLVK71cSaV2u9IiVT1CgSc0WXA8PWJSsJMuC5tD2FobQ/yqumCQkEs+QBOKedzBXTz7QuGrRn7uju56lY4Dnnfy1jlFl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JGjK5UYy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JGjK5UYy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C19FC4CEE5;
	Tue,  8 Apr 2025 12:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115099;
	bh=dmYhj/3oIgeotgbQyyFD8Q9Yeg5h7XEyIavb33Hk0ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JGjK5UYyrC3RPG92+jG3KtxC8/nYySi1fc64L3QqzPdhPA10J3JmUjdxdjXHn6IuG
	 n2FfKgZuy9Qy8501WeaGyaN8dhFMIGXMH8cueHDeUpWQKXnjELYNoXzwsVN6UknHPo
	 9/LsL4BFD1zvpKOQgYdafmjFuT++ftQoFFY0UrpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Jay Shin <jaeshin@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 350/499] smb: client: dont retry IO on failed negprotos with soft mounts
Date: Tue,  8 Apr 2025 12:49:22 +0200
Message-ID: <20250408104859.954977522@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 7643dbd9db09fffebb4a62cd27599f17f4148b17 ]

If @server->tcpStatus is set to CifsNeedReconnect after acquiring
@ses->session_mutex in smb2_reconnect() or cifs_reconnect_tcon(), it
means that a concurrent thread failed to negotiate, in which case the
server is no longer responding to any SMB requests, so there is no
point making the caller retry the IO by returning -EAGAIN.

Fix this by returning -EHOSTDOWN to the callers on soft mounts.

Cc: David Howells <dhowells@redhat.com>
Reported-by: Jay Shin <jaeshin@redhat.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifssmb.c | 46 ++++++++++++--------
 fs/smb/client/smb2pdu.c | 96 ++++++++++++++++++-----------------------
 2 files changed, 69 insertions(+), 73 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index a993d4ac58411..dd5211d268f48 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -114,19 +114,23 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 
 	mutex_lock(&ses->session_mutex);
 	/*
-	 * Recheck after acquire mutex. If another thread is negotiating
-	 * and the server never sends an answer the socket will be closed
-	 * and tcpStatus set to reconnect.
+	 * Handle the case where a concurrent thread failed to negotiate or
+	 * killed a channel.
 	 */
 	spin_lock(&server->srv_lock);
-	if (server->tcpStatus == CifsNeedReconnect) {
+	switch (server->tcpStatus) {
+	case CifsExiting:
 		spin_unlock(&server->srv_lock);
 		mutex_unlock(&ses->session_mutex);
-
-		if (tcon->retry)
-			goto again;
-		rc = -EHOSTDOWN;
-		goto out;
+		return -EHOSTDOWN;
+	case CifsNeedReconnect:
+		spin_unlock(&server->srv_lock);
+		mutex_unlock(&ses->session_mutex);
+		if (!tcon->retry)
+			return -EHOSTDOWN;
+		goto again;
+	default:
+		break;
 	}
 	spin_unlock(&server->srv_lock);
 
@@ -152,16 +156,20 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	spin_unlock(&ses->ses_lock);
 
 	rc = cifs_negotiate_protocol(0, ses, server);
-	if (!rc) {
-		rc = cifs_setup_session(0, ses, server, ses->local_nls);
-		if ((rc == -EACCES) || (rc == -EHOSTDOWN) || (rc == -EKEYREVOKED)) {
-			/*
-			 * Try alternate password for next reconnect if an alternate
-			 * password is available.
-			 */
-			if (ses->password2)
-				swap(ses->password2, ses->password);
-		}
+	if (rc) {
+		mutex_unlock(&ses->session_mutex);
+		if (!tcon->retry)
+			return -EHOSTDOWN;
+		goto again;
+	}
+	rc = cifs_setup_session(0, ses, server, ses->local_nls);
+	if ((rc == -EACCES) || (rc == -EHOSTDOWN) || (rc == -EKEYREVOKED)) {
+		/*
+		 * Try alternate password for next reconnect if an alternate
+		 * password is available.
+		 */
+		if (ses->password2)
+			swap(ses->password2, ses->password);
 	}
 
 	/* do we need to reconnect tcon? */
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 7ece98c742bdb..23ae73c9c5e97 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -300,32 +300,23 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 
 	mutex_lock(&ses->session_mutex);
 	/*
-	 * if this is called by delayed work, and the channel has been disabled
-	 * in parallel, the delayed work can continue to execute in parallel
-	 * there's a chance that this channel may not exist anymore
+	 * Handle the case where a concurrent thread failed to negotiate or
+	 * killed a channel.
 	 */
 	spin_lock(&server->srv_lock);
-	if (server->tcpStatus == CifsExiting) {
+	switch (server->tcpStatus) {
+	case CifsExiting:
 		spin_unlock(&server->srv_lock);
 		mutex_unlock(&ses->session_mutex);
-		rc = -EHOSTDOWN;
-		goto out;
-	}
-
-	/*
-	 * Recheck after acquire mutex. If another thread is negotiating
-	 * and the server never sends an answer the socket will be closed
-	 * and tcpStatus set to reconnect.
-	 */
-	if (server->tcpStatus == CifsNeedReconnect) {
+		return -EHOSTDOWN;
+	case CifsNeedReconnect:
 		spin_unlock(&server->srv_lock);
 		mutex_unlock(&ses->session_mutex);
-
-		if (tcon->retry)
-			goto again;
-
-		rc = -EHOSTDOWN;
-		goto out;
+		if (!tcon->retry)
+			return -EHOSTDOWN;
+		goto again;
+	default:
+		break;
 	}
 	spin_unlock(&server->srv_lock);
 
@@ -350,43 +341,41 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	spin_unlock(&ses->ses_lock);
 
 	rc = cifs_negotiate_protocol(0, ses, server);
-	if (!rc) {
-		/*
-		 * if server stopped supporting multichannel
-		 * and the first channel reconnected, disable all the others.
-		 */
-		if (ses->chan_count > 1 &&
-		    !(server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
-			rc = cifs_chan_skip_or_disable(ses, server,
-						       from_reconnect);
-			if (rc) {
-				mutex_unlock(&ses->session_mutex);
-				goto out;
-			}
-		}
-
-		rc = cifs_setup_session(0, ses, server, ses->local_nls);
-		if ((rc == -EACCES) || (rc == -EKEYEXPIRED) || (rc == -EKEYREVOKED)) {
-			/*
-			 * Try alternate password for next reconnect (key rotation
-			 * could be enabled on the server e.g.) if an alternate
-			 * password is available and the current password is expired,
-			 * but do not swap on non pwd related errors like host down
-			 */
-			if (ses->password2)
-				swap(ses->password2, ses->password);
-		}
-
-		if ((rc == -EACCES) && !tcon->retry) {
-			mutex_unlock(&ses->session_mutex);
-			rc = -EHOSTDOWN;
-			goto failed;
-		} else if (rc) {
+	if (rc) {
+		mutex_unlock(&ses->session_mutex);
+		if (!tcon->retry)
+			return -EHOSTDOWN;
+		goto again;
+	}
+	/*
+	 * if server stopped supporting multichannel
+	 * and the first channel reconnected, disable all the others.
+	 */
+	if (ses->chan_count > 1 &&
+	    !(server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
+		rc = cifs_chan_skip_or_disable(ses, server,
+					       from_reconnect);
+		if (rc) {
 			mutex_unlock(&ses->session_mutex);
 			goto out;
 		}
-	} else {
+	}
+
+	rc = cifs_setup_session(0, ses, server, ses->local_nls);
+	if ((rc == -EACCES) || (rc == -EKEYEXPIRED) || (rc == -EKEYREVOKED)) {
+		/*
+		 * Try alternate password for next reconnect (key rotation
+		 * could be enabled on the server e.g.) if an alternate
+		 * password is available and the current password is expired,
+		 * but do not swap on non pwd related errors like host down
+		 */
+		if (ses->password2)
+			swap(ses->password2, ses->password);
+	}
+	if (rc) {
 		mutex_unlock(&ses->session_mutex);
+		if (rc == -EACCES && !tcon->retry)
+			return -EHOSTDOWN;
 		goto out;
 	}
 
@@ -490,7 +479,6 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	case SMB2_IOCTL:
 		rc = -EAGAIN;
 	}
-failed:
 	return rc;
 }
 
-- 
2.39.5



