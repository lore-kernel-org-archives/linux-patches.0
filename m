Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C481F7580;
	Mon, 23 Jun 2025 22:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717030; cv=none; b=CJYEI/rwj3UckjiYRwwn9JEGZv0+TXzF/cNaSD6zzaDdQ1LcLd0RGACdX8kIXBtW0FOKKHazYfV4btWNH2+GJGBKiEvQDbefrB9y/IYw8Zb1P7YjqWJjG5NVr+Pch+/3VB3eentxEpj28nXhKJOgJMh0fcN1sAqSOdwSS0fNLbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717030; c=relaxed/simple;
	bh=j9fSHw8MJhC3PHK6sjrfKrie1kyFmEn5zQurGVWHEDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jC9ZxSALdDc1DRuSluhr3K8YveIZa6x3S4oVr0cVQ/lru6+PwV4sDSD09OHrV5hc7KDd9WOB4dLkH3W2mPGFXixLGh8LxZdB0uDl+Hid2ArCPEVQ3ktsPFwF/9uiZbV6g9rUYay9o3Dp403QFyVgei5PGkaTlpbYdvc7hYKM58Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eCedoDrZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eCedoDrZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 711DCC4CEEA;
	Mon, 23 Jun 2025 22:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717030;
	bh=j9fSHw8MJhC3PHK6sjrfKrie1kyFmEn5zQurGVWHEDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eCedoDrZ0MIjL8mg/Xph4peHex1Rh+D2v7TNGkg8UY4sN1eAmireVfhH+0gQTJFUf
	 V4NS4z6mZS35c8fcJxHvsdUp5NGd1j61K+ecZoJUMnVp+ErV60mTKu0Ixyd69zn5ce
	 KhJBTvHfNptj54lE07tZK8llFkanJCqCm19ilZ9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 308/414] cifs: do not disable interface polling on failure
Date: Mon, 23 Jun 2025 15:07:25 +0200
Message-ID: <20250623130649.702139795@linuxfoundation.org>
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
@@ -132,13 +132,9 @@ static void smb2_query_server_interfaces
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
@@ -440,6 +440,10 @@ skip_sess_setup:
 		free_xid(xid);
 		ses->flags &= ~CIFS_SES_FLAGS_PENDING_QUERY_INTERFACES;
 
+		/* regardless of rc value, setup polling */
+		queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
+				   (SMB_INTERFACE_POLL_INTERVAL * HZ));
+
 		mutex_unlock(&ses->session_mutex);
 
 		if (rc == -EOPNOTSUPP && ses->chan_count > 1) {
@@ -460,11 +464,8 @@ skip_sess_setup:
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


