Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3AC15B0E2;
	Mon, 29 Jan 2024 17:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548423; cv=none; b=I+Tfk777rV9LOLA/cZ1oLby6FBGt7U0bOXm2PE0PVRHxXq5aYD0okbTnDV+YGq559xNvhgNVza4Q8VelaHFpblE/d0i1L2pg3rPmPGNHq5eBwI3mGJI3otrFb3GLMLjHcKvZ+cS3SZBcEkoHUSDuSzmcwSTcsl6ZEdPL9fTQSXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548423; c=relaxed/simple;
	bh=rvuqNt+MugQYTKnWyR2Uv/ZxzKMJo9jy4efE0BmDDpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ch1ty6AOxLBqSGSr0rqlxxNYFYuzYdHo9s4CUhzAiCFf5qdWHz2nZ79UmN6lCtnSXyxFt/6Qfj/fSVwqd0EK/6nUCCBpXjEi7Niegl53O0trA8bgdcDKR0kmJBNxNJLcAoYhelFHtJ1/mbTzJ37txfkKvzQT1H37jvI+CyF9YxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bPMO3jEK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bPMO3jEK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F84EC43390;
	Mon, 29 Jan 2024 17:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548423;
	bh=rvuqNt+MugQYTKnWyR2Uv/ZxzKMJo9jy4efE0BmDDpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bPMO3jEK95vIYuT3sq82dE1A+vF+BkK5BplyY5yhFB1Tlq8qXIWjAvq4MMpME+cSe
	 MgpzHMUgiqyWTLiImJKEeWX70sxfkqOqzXaEfbdFOecBkdXtXhfI8UVyEbV3f6wVxP
	 bVVc1fITBWRBQwTGEJSOlvV5v8JnSjhIgpeIlIqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/331] cifs: reconnect work should have reference on server struct
Date: Mon, 29 Jan 2024 09:01:26 -0800
Message-ID: <20240129170015.606409392@linuxfoundation.org>
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

[ Upstream commit 19a4b9d6c372cab6a3b2c9a061a236136fe95274 ]

The delayed work for reconnect takes server struct
as a parameter. But it does so without holding a ref
to it. Normally, this may not show a problem as
the reconnect work is only cancelled on umount.

However, since we now plan to support scaling down of
channels, and the scale down can happen from reconnect
work itself, we need to fix it.

This change takes a reference on the server struct
before it is passed to the delayed work. And drops
the reference in the delayed work itself. Or if
the delayed work is successfully cancelled, by the
process that cancels it.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 78e727e58e54 ("cifs: update iface_last_update on each query-and-update")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/connect.c | 27 +++++++++++++++++++++------
 fs/smb/client/smb2pdu.c | 23 +++++++++++++----------
 2 files changed, 34 insertions(+), 16 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index a482afa3fa42..2f5be7dcd1f9 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -388,7 +388,13 @@ static int __cifs_reconnect(struct TCP_Server_Info *server,
 			spin_unlock(&server->srv_lock);
 			cifs_swn_reset_server_dstaddr(server);
 			cifs_server_unlock(server);
-			mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
+
+			/* increase ref count which reconnect work will drop */
+			spin_lock(&cifs_tcp_ses_lock);
+			server->srv_count++;
+			spin_unlock(&cifs_tcp_ses_lock);
+			if (mod_delayed_work(cifsiod_wq, &server->reconnect, 0))
+				cifs_put_tcp_session(server, false);
 		}
 	} while (server->tcpStatus == CifsNeedReconnect);
 
@@ -518,7 +524,13 @@ static int reconnect_dfs_server(struct TCP_Server_Info *server)
 		spin_unlock(&server->srv_lock);
 		cifs_swn_reset_server_dstaddr(server);
 		cifs_server_unlock(server);
-		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
+
+		/* increase ref count which reconnect work will drop */
+		spin_lock(&cifs_tcp_ses_lock);
+		server->srv_count++;
+		spin_unlock(&cifs_tcp_ses_lock);
+		if (mod_delayed_work(cifsiod_wq, &server->reconnect, 0))
+			cifs_put_tcp_session(server, false);
 	} while (server->tcpStatus == CifsNeedReconnect);
 
 	mutex_lock(&server->refpath_lock);
@@ -1605,16 +1617,19 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
 
 	cancel_delayed_work_sync(&server->echo);
 
-	if (from_reconnect)
+	if (from_reconnect) {
 		/*
 		 * Avoid deadlock here: reconnect work calls
 		 * cifs_put_tcp_session() at its end. Need to be sure
 		 * that reconnect work does nothing with server pointer after
 		 * that step.
 		 */
-		cancel_delayed_work(&server->reconnect);
-	else
-		cancel_delayed_work_sync(&server->reconnect);
+		if (cancel_delayed_work(&server->reconnect))
+			cifs_put_tcp_session(server, from_reconnect);
+	} else {
+		if (cancel_delayed_work_sync(&server->reconnect))
+			cifs_put_tcp_session(server, from_reconnect);
+	}
 
 	spin_lock(&server->srv_lock);
 	server->tcpStatus = CifsExiting;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 888eb59ad86f..0274ef67457b 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3879,12 +3879,6 @@ void smb2_reconnect_server(struct work_struct *work)
 		}
 		spin_unlock(&ses->chan_lock);
 	}
-	/*
-	 * Get the reference to server struct to be sure that the last call of
-	 * cifs_put_tcon() in the loop below won't release the server pointer.
-	 */
-	if (tcon_exist || ses_exist)
-		server->srv_count++;
 
 	spin_unlock(&cifs_tcp_ses_lock);
 
@@ -3932,13 +3926,17 @@ void smb2_reconnect_server(struct work_struct *work)
 
 done:
 	cifs_dbg(FYI, "Reconnecting tcons and channels finished\n");
-	if (resched)
+	if (resched) {
 		queue_delayed_work(cifsiod_wq, &server->reconnect, 2 * HZ);
+		mutex_unlock(&pserver->reconnect_mutex);
+
+		/* no need to put tcp session as we're retrying */
+		return;
+	}
 	mutex_unlock(&pserver->reconnect_mutex);
 
 	/* now we can safely release srv struct */
-	if (tcon_exist || ses_exist)
-		cifs_put_tcp_session(server, 1);
+	cifs_put_tcp_session(server, true);
 }
 
 int
@@ -3958,7 +3956,12 @@ SMB2_echo(struct TCP_Server_Info *server)
 	    server->ops->need_neg(server)) {
 		spin_unlock(&server->srv_lock);
 		/* No need to send echo on newly established connections */
-		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
+		spin_lock(&cifs_tcp_ses_lock);
+		server->srv_count++;
+		spin_unlock(&cifs_tcp_ses_lock);
+		if (mod_delayed_work(cifsiod_wq, &server->reconnect, 0))
+			cifs_put_tcp_session(server, false);
+
 		return rc;
 	}
 	spin_unlock(&server->srv_lock);
-- 
2.43.0



