Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B87822258C;
	Mon, 23 Jun 2025 21:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715128; cv=none; b=n5L6/vmQpJTbo6XYxQsK5TV+NgRp1uzRrdcCmPYy1BU8JPFcg8NRt+oOpofhTE80uLifNzo8CRXXZqPGaI7PWjm0MHuk8+2Odtoq01nLdpUYPF086MNz1qzlDB6Z9SLUfwe3XnWDvK1+obtXNgNX4U20kEVl06Q2iheNRbQcg68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715128; c=relaxed/simple;
	bh=mcQV4cV2FRTGqCi74/NETMg1LAuef2iLe4I5DTHoj40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ao5cb14aQkdQLIY/vBOd1Vr/KGnKCb1N6WeoW+3H8iiJGA3d0BYxIcLvOjqTfPr5ObF1iwNDzGiqNgsTiXpgdZ8W1ymbNZKfsQHIsLCdjE+mwEqgtv90ssycnAWT9Vf69soF717nrNnsoc1je7A0OIEOpWa/gV9vSiB00S8xRlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JuELbz4/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JuELbz4/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F968C4CEEA;
	Mon, 23 Jun 2025 21:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715127;
	bh=mcQV4cV2FRTGqCi74/NETMg1LAuef2iLe4I5DTHoj40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JuELbz4/9Mi0/fU3iyvMYkHvPUSufuzOQZUaXucrNoxYBb/gUbU70Qb+WfzG6IOn/
	 kuHGuRq31GfPTozHMCpIBDOtJ8aV5vBz9fI3Li43StAUAsvq5F0/bnWQQjciMeT6+x
	 EueB6+LDd25C18ctJqttNmcMnGFc4XNoSSKMxrAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.15 460/592] cifs: do not disable interface polling on failure
Date: Mon, 23 Jun 2025 15:06:58 +0200
Message-ID: <20250623130711.369242685@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

From: Shyam Prasad N <sprasad@microsoft.com>

commit 42ca547b13a20e7cbb04fbdf8d5f089ac4bb35b7 upstream.

When a server has multichannel enabled, we keep polling the server
for interfaces periodically. However, when this query fails, we
disable the polling. This can be problematic as it takes away the
chance for the server to start advertizing again.

This change reschedules the delayed work, even if the current call
failed. That way, multichannel sessions can recover.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |    6 +-----
 fs/smb/client/smb2pdu.c |    9 +++++----
 2 files changed, 6 insertions(+), 9 deletions(-)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -116,13 +116,9 @@ static void smb2_query_server_interfaces
 	rc = server->ops->query_server_interfaces(xid, tcon, false);
 	free_xid(xid);
 
-	if (rc) {
-		if (rc == -EOPNOTSUPP)
-			return;
-
+	if (rc)
 		cifs_dbg(FYI, "%s: failed to query server interfaces: %d\n",
 				__func__, rc);
-	}
 
 	queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
 			   (SMB_INTERFACE_POLL_INTERVAL * HZ));
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -423,6 +423,10 @@ skip_sess_setup:
 		free_xid(xid);
 		ses->flags &= ~CIFS_SES_FLAGS_PENDING_QUERY_INTERFACES;
 
+		/* regardless of rc value, setup polling */
+		queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
+				   (SMB_INTERFACE_POLL_INTERVAL * HZ));
+
 		mutex_unlock(&ses->session_mutex);
 
 		if (rc == -EOPNOTSUPP && ses->chan_count > 1) {
@@ -443,11 +447,8 @@ skip_sess_setup:
 		if (ses->chan_max > ses->chan_count &&
 		    ses->iface_count &&
 		    !SERVER_IS_CHAN(server)) {
-			if (ses->chan_count == 1) {
+			if (ses->chan_count == 1)
 				cifs_server_dbg(VFS, "supports multichannel now\n");
-				queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
-						 (SMB_INTERFACE_POLL_INTERVAL * HZ));
-			}
 
 			cifs_try_adding_channels(ses);
 		}


