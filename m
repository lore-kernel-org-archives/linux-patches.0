Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7585221FD6;
	Mon,  2 Jun 2025 14:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873098; cv=none; b=pLyVtOcttwlGAEPoWeAua7nctOJGhJxs0dBLYiIz9s8OAdPDOgIOL86y6cjW2S3KDPDVIynwpjkAfKBPc+MkBfNmrkVWC4sliMyGrBjPpJ0B6S44hsLlx5sdPtVn4HXqMKSxrAUBU5e9ZUu5P+AyDjR15243EJ2qPt1Qk3jPyHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873098; c=relaxed/simple;
	bh=qFlH5/IwGtecYd5/VnnKdbFP5lVfeVuycGfIOMEvj7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aEFEfK6M7Qfk0VhPBmRe+3wZ13Clf9Lrf0GGSuWNiRhWzAIkTqbu+D0PHALjM7e0unUrnXKDbD7B3zI7nL9UneYJerFoeK9IQ5lCTuH89voxPZQ7B9sXD/Dz2jUEgESY0gOWL+XZu6cV/CwitNLU8Akfd4NcLmeMmaGecP9Oot0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kTOqtMKv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kTOqtMKv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E6CC4CEEB;
	Mon,  2 Jun 2025 14:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873098;
	bh=qFlH5/IwGtecYd5/VnnKdbFP5lVfeVuycGfIOMEvj7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kTOqtMKv2RvlhHzPcGhKakVKdoN7HGy2+WSeKnECHO7zbqE05gQC95VY89KjATfB+
	 6pydYVBO0oWYv639WCdOPkAyEySA9zRB7kl8FXidoP9uXmqE1xaY1AXLX6CYcL0Ylt
	 H7go1VmS0k/XS4qCnlcIVKJnJESn7FUo1Diz7JNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 037/444] cifs: Fix negotiate retry functionality
Date: Mon,  2 Jun 2025 15:41:41 +0200
Message-ID: <20250602134342.434069890@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

[ Upstream commit e94e882a6d69525c07589222cf3a6ff57ad12b5b ]

SMB negotiate retry functionality in cifs_negotiate() is currently broken
and does not work when doing socket reconnect. Caller of this function,
which is cifs_negotiate_protocol() requires that tcpStatus after successful
execution of negotiate callback stay in CifsInNegotiate. But if the
CIFSSMBNegotiate() called from cifs_negotiate() fails due to connection
issues then tcpStatus is changed as so repeated CIFSSMBNegotiate() call
does not help.

Fix this problem by moving retrying code from negotiate callback (which is
either cifs_negotiate() or smb2_negotiate()) to cifs_negotiate_protocol()
which is caller of those callbacks. This allows to properly handle and
implement correct transistions between tcpStatus states as function
cifs_negotiate_protocol() already handles it.

With this change, cifs_negotiate_protocol() now handles also -EAGAIN error
set by the RFC1002_NEGATIVE_SESSION_RESPONSE processing after reconnecting
with NetBIOS session.

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/connect.c | 10 ++++++++++
 fs/smb/client/smb1ops.c |  7 -------
 fs/smb/client/smb2ops.c |  3 ---
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 54aba8d642ee7..267fba234c12d 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3946,11 +3946,13 @@ int
 cifs_negotiate_protocol(const unsigned int xid, struct cifs_ses *ses,
 			struct TCP_Server_Info *server)
 {
+	bool in_retry = false;
 	int rc = 0;
 
 	if (!server->ops->need_neg || !server->ops->negotiate)
 		return -ENOSYS;
 
+retry:
 	/* only send once per connect */
 	spin_lock(&server->srv_lock);
 	if (server->tcpStatus != CifsGood &&
@@ -3970,6 +3972,14 @@ cifs_negotiate_protocol(const unsigned int xid, struct cifs_ses *ses,
 	spin_unlock(&server->srv_lock);
 
 	rc = server->ops->negotiate(xid, ses, server);
+	if (rc == -EAGAIN) {
+		/* Allow one retry attempt */
+		if (!in_retry) {
+			in_retry = true;
+			goto retry;
+		}
+		rc = -EHOSTDOWN;
+	}
 	if (rc == 0) {
 		spin_lock(&server->srv_lock);
 		if (server->tcpStatus == CifsInNegotiate)
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index caa1d852ece49..280885dd6bf08 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -426,13 +426,6 @@ cifs_negotiate(const unsigned int xid,
 {
 	int rc;
 	rc = CIFSSMBNegotiate(xid, ses, server);
-	if (rc == -EAGAIN) {
-		/* retry only once on 1st time connection */
-		set_credits(server, 1);
-		rc = CIFSSMBNegotiate(xid, ses, server);
-		if (rc == -EAGAIN)
-			rc = -EHOSTDOWN;
-	}
 	return rc;
 }
 
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index b809a616728f2..cead96454bb3d 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -428,9 +428,6 @@ smb2_negotiate(const unsigned int xid,
 	server->CurrentMid = 0;
 	spin_unlock(&server->mid_lock);
 	rc = SMB2_negotiate(xid, ses, server);
-	/* BB we probably don't need to retry with modern servers */
-	if (rc == -EAGAIN)
-		rc = -EHOSTDOWN;
 	return rc;
 }
 
-- 
2.39.5



