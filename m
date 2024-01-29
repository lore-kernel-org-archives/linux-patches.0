Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EBA15DBA8;
	Mon, 29 Jan 2024 17:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548425; cv=none; b=pVsB95Oj18uW68DsIG5h6AQYlczLBD8AGPFfTWxcN/qmKeiNEKowz8unPxPvPTtxDRaP5yiMg9gIKs8UATSrcnpoAPJLWeY4u0tQyawuR5isQCssABZ5ZYCSgUIp10oIGJ3L0qjtraC83oe9aaHc3YRgH0z9EWgAe6ddk+dCQJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548425; c=relaxed/simple;
	bh=Tf3yXotavoXlXGrfzrIdzqIY/vGL5Gy/z4kAkQJxivg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/EmxDZkY09ehMjtCQ0cuMmO1YcWrSJUgYjj0sN1cS1SQCs6qKB54kJsyM96po/FkOQ4qo0MFsE0lwFy9iM7I4lXJxHlQ2+hLw2gwEuscdpGETgg6pgAneTQx3QJ2e4atNfPARMFYgYruULfNpLIoB1tlbypO0okSbKYTL9r9GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P3f6NHz+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P3f6NHz+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D027C433F1;
	Mon, 29 Jan 2024 17:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548425;
	bh=Tf3yXotavoXlXGrfzrIdzqIY/vGL5Gy/z4kAkQJxivg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P3f6NHz+NoFWUyF3FTwwHrqI7ScdI4XNTTMKbMOOoyVop0nHL1YVRdaOu6N/V/lrx
	 ttXr23v32wpxPXZCPdvIFLHNvydK8I5xHdO8aNa/e7Sz8L4PGuaR2raCgVSCakD1hY
	 COpbdpfR2/O/jZHJiwr780KfQBCdOfbE+4qJ06kY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/331] Revert "cifs: reconnect work should have reference on server struct"
Date: Mon, 29 Jan 2024 09:01:29 -0800
Message-ID: <20240129170015.691470770@linuxfoundation.org>
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

[ Upstream commit 823342524868168bf681f135d01b4ae10f5863ec ]

This reverts commit 19a4b9d6c372cab6a3b2c9a061a236136fe95274.

This earlier commit was making an assumption that each mod_delayed_work
called for the reconnect work would result in smb2_reconnect_server
being called twice. This assumption turns out to be untrue. So reverting
this change for now.

I will submit a follow-up patch to fix the actual problem in a different
way.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 78e727e58e54 ("cifs: update iface_last_update on each query-and-update")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/connect.c | 27 ++++++---------------------
 fs/smb/client/smb2pdu.c | 23 ++++++++++-------------
 2 files changed, 16 insertions(+), 34 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index f43f51f2d1c1..2a30245287d5 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -401,13 +401,7 @@ static int __cifs_reconnect(struct TCP_Server_Info *server,
 			spin_unlock(&server->srv_lock);
 			cifs_swn_reset_server_dstaddr(server);
 			cifs_server_unlock(server);
-
-			/* increase ref count which reconnect work will drop */
-			spin_lock(&cifs_tcp_ses_lock);
-			server->srv_count++;
-			spin_unlock(&cifs_tcp_ses_lock);
-			if (mod_delayed_work(cifsiod_wq, &server->reconnect, 0))
-				cifs_put_tcp_session(server, false);
+			mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
 		}
 	} while (server->tcpStatus == CifsNeedReconnect);
 
@@ -537,13 +531,7 @@ static int reconnect_dfs_server(struct TCP_Server_Info *server)
 		spin_unlock(&server->srv_lock);
 		cifs_swn_reset_server_dstaddr(server);
 		cifs_server_unlock(server);
-
-		/* increase ref count which reconnect work will drop */
-		spin_lock(&cifs_tcp_ses_lock);
-		server->srv_count++;
-		spin_unlock(&cifs_tcp_ses_lock);
-		if (mod_delayed_work(cifsiod_wq, &server->reconnect, 0))
-			cifs_put_tcp_session(server, false);
+		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
 	} while (server->tcpStatus == CifsNeedReconnect);
 
 	mutex_lock(&server->refpath_lock);
@@ -1630,19 +1618,16 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
 
 	cancel_delayed_work_sync(&server->echo);
 
-	if (from_reconnect) {
+	if (from_reconnect)
 		/*
 		 * Avoid deadlock here: reconnect work calls
 		 * cifs_put_tcp_session() at its end. Need to be sure
 		 * that reconnect work does nothing with server pointer after
 		 * that step.
 		 */
-		if (cancel_delayed_work(&server->reconnect))
-			cifs_put_tcp_session(server, from_reconnect);
-	} else {
-		if (cancel_delayed_work_sync(&server->reconnect))
-			cifs_put_tcp_session(server, from_reconnect);
-	}
+		cancel_delayed_work(&server->reconnect);
+	else
+		cancel_delayed_work_sync(&server->reconnect);
 
 	spin_lock(&server->srv_lock);
 	server->tcpStatus = CifsExiting;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index f1977987ae74..da752f41a4e6 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3981,6 +3981,12 @@ void smb2_reconnect_server(struct work_struct *work)
 		}
 		spin_unlock(&ses->chan_lock);
 	}
+	/*
+	 * Get the reference to server struct to be sure that the last call of
+	 * cifs_put_tcon() in the loop below won't release the server pointer.
+	 */
+	if (tcon_exist || ses_exist)
+		server->srv_count++;
 
 	spin_unlock(&cifs_tcp_ses_lock);
 
@@ -4028,17 +4034,13 @@ void smb2_reconnect_server(struct work_struct *work)
 
 done:
 	cifs_dbg(FYI, "Reconnecting tcons and channels finished\n");
-	if (resched) {
+	if (resched)
 		queue_delayed_work(cifsiod_wq, &server->reconnect, 2 * HZ);
-		mutex_unlock(&pserver->reconnect_mutex);
-
-		/* no need to put tcp session as we're retrying */
-		return;
-	}
 	mutex_unlock(&pserver->reconnect_mutex);
 
 	/* now we can safely release srv struct */
-	cifs_put_tcp_session(server, true);
+	if (tcon_exist || ses_exist)
+		cifs_put_tcp_session(server, 1);
 }
 
 int
@@ -4058,12 +4060,7 @@ SMB2_echo(struct TCP_Server_Info *server)
 	    server->ops->need_neg(server)) {
 		spin_unlock(&server->srv_lock);
 		/* No need to send echo on newly established connections */
-		spin_lock(&cifs_tcp_ses_lock);
-		server->srv_count++;
-		spin_unlock(&cifs_tcp_ses_lock);
-		if (mod_delayed_work(cifsiod_wq, &server->reconnect, 0))
-			cifs_put_tcp_session(server, false);
-
+		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
 		return rc;
 	}
 	spin_unlock(&server->srv_lock);
-- 
2.43.0



