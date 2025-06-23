Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88FB222576;
	Mon, 23 Jun 2025 22:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717018; cv=none; b=j+qx5o8nHZTwa4v3sr6SFKtpq2y/ghwr1advpU+RHnQVkNOD1/erXGnAkVe/dHHIy0KrPfsPizYrbmvsn6oX2XivhlgOLTSZo/d+rMozpQDR/hwulqFJvWq9ZiT1YG3zuj7aNKLu5CehP66SXWXzZTFLV3jlPVVs/TXqxQr0s5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717018; c=relaxed/simple;
	bh=MTVPJT0+VJqmWmMP+/GtIc7KrM530QkAj9K9QZ3G4ZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lS85rB1ilv92DMhDXtcCG/XWdUsS5vYa4Fe3nuRMVukyu6Qoqnvm6IY6u3ViT8c1G6lLIkXimGQ/YD9mwGeW5l+DT+3318Ko5JgGTWQavsEntlS9AikPbBks5MGEmxLxFMVdnijED9YnmQ4NbeH2tbKf+618ryFVLH51fr8EafA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mk+VZAIP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mk+VZAIP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 516F1C4CEEA;
	Mon, 23 Jun 2025 22:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717018;
	bh=MTVPJT0+VJqmWmMP+/GtIc7KrM530QkAj9K9QZ3G4ZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mk+VZAIPiEc/0wdsjuAdkcaMVII8oE602WUjWJ8Q++wiWtXGhYY0r0Aa5sEOgF1Ku
	 7WW70MS8gsbJi4oLJM3Rg6SK+9PrPVuMXInZM7UbhGDY2FO882UdDOqNqcNo+/hm0z
	 MYQ8vHvnVIAYhwu3gpSOfFeD38eEPAcHkJSKEztk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 307/414] cifs: serialize other channels when query server interfaces is pending
Date: Mon, 23 Jun 2025 15:07:24 +0200
Message-ID: <20250623130649.677746967@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Prasad N <sprasad@microsoft.com>

commit b5e3e6e28cf3853566ba5d816f79aba5be579158 upstream.

Today, during smb2_reconnect, session_mutex is released as soon as
the tcon is reconnected and is in a good state. However, in case
multichannel is enabled, there is also a query of server interfaces that
follows. We've seen that this query can race with reconnects of other
channels, causing them to step on each other with reconnects.

This change extends the hold of session_mutex till after the query of
server interfaces is complete. In order to avoid recursive smb2_reconnect
checks during query ioctl, this change also introduces a session flag
for sessions where such a query is in progress.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsglob.h |    1 +
 fs/smb/client/smb2pdu.c  |   24 ++++++++++++++++++------
 2 files changed, 19 insertions(+), 6 deletions(-)

--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1058,6 +1058,7 @@ struct cifs_chan {
 };
 
 #define CIFS_SES_FLAG_SCALE_CHANNELS (0x1)
+#define CIFS_SES_FLAGS_PENDING_QUERY_INTERFACES (0x2)
 
 /*
  * Session structure.  One of these for each uid session with a particular host
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -428,14 +428,19 @@ skip_sess_setup:
 	if (!rc &&
 	    (server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL) &&
 	    server->ops->query_server_interfaces) {
-		mutex_unlock(&ses->session_mutex);
-
 		/*
-		 * query server network interfaces, in case they change
+		 * query server network interfaces, in case they change.
+		 * Also mark the session as pending this update while the query
+		 * is in progress. This will be used to avoid calling
+		 * smb2_reconnect recursively.
 		 */
+		ses->flags |= CIFS_SES_FLAGS_PENDING_QUERY_INTERFACES;
 		xid = get_xid();
 		rc = server->ops->query_server_interfaces(xid, tcon, false);
 		free_xid(xid);
+		ses->flags &= ~CIFS_SES_FLAGS_PENDING_QUERY_INTERFACES;
+
+		mutex_unlock(&ses->session_mutex);
 
 		if (rc == -EOPNOTSUPP && ses->chan_count > 1) {
 			/*
@@ -577,11 +582,18 @@ static int smb2_ioctl_req_init(u32 opcod
 			       struct TCP_Server_Info *server,
 			       void **request_buf, unsigned int *total_len)
 {
-	/* Skip reconnect only for FSCTL_VALIDATE_NEGOTIATE_INFO IOCTLs */
-	if (opcode == FSCTL_VALIDATE_NEGOTIATE_INFO) {
+	/*
+	 * Skip reconnect in one of the following cases:
+	 * 1. For FSCTL_VALIDATE_NEGOTIATE_INFO IOCTLs
+	 * 2. For FSCTL_QUERY_NETWORK_INTERFACE_INFO IOCTL when called from
+	 * smb2_reconnect (indicated by CIFS_SES_FLAG_SCALE_CHANNELS ses flag)
+	 */
+	if (opcode == FSCTL_VALIDATE_NEGOTIATE_INFO ||
+	    (opcode == FSCTL_QUERY_NETWORK_INTERFACE_INFO &&
+	     (tcon->ses->flags & CIFS_SES_FLAGS_PENDING_QUERY_INTERFACES)))
 		return __smb2_plain_req_init(SMB2_IOCTL, tcon, server,
 					     request_buf, total_len);
-	}
+
 	return smb2_plain_req_init(SMB2_IOCTL, tcon, server,
 				   request_buf, total_len);
 }


