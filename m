Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A0B15AAD5;
	Mon, 29 Jan 2024 17:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548078; cv=none; b=iyJYUbnxAj2daIrEhZx6Uqh1h5wNpxdBy2jeD0DQ0gsQ5mAUeziDo7aWSp7qhDEThgCwS33rPTlXvjOmVRMg/m0Pl/Q4qiWsQXWh4u5lPPqpwR680SObkj28QHaM7cj/mMmzR2VaExQ2x1Zebu84CKbjXdNG0Bp1234nTrBhd4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548078; c=relaxed/simple;
	bh=LurOXTWau/BiGVRnGeLKXbbaQDM4n8f+O1pXIZeyDAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EyvVNpD3VLNCi1r5okVjg8oa/vVyO7Z//jND2esGOhnkQkZ3GGMcxxuarkzSJuUD/bctiRktRi6R2D2yICGZl/zd9dDqG6/sH3AkPt9MlWbOyuCRwDtgCfOjwstmiKd/46U4BKtKvuUQaDTG/E+UoR/LxswlJpc8u5weJrJbcIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hoI3Qk7D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hoI3Qk7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67612C433F1;
	Mon, 29 Jan 2024 17:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548078;
	bh=LurOXTWau/BiGVRnGeLKXbbaQDM4n8f+O1pXIZeyDAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hoI3Qk7DW3KUkTNMtkuYXO0LLLFOb8bF9o8z5TmWrmbOGB83yDkaBrKOZIAyopOV4
	 fh2sRhljs6hipuQ8y/4Ntzte2j9cJOWRB0Sn9OQ+jjX+dNQWdiIgt6z3cWy7bR1aNV
	 Ej8Fu0vIzsbq/Wypty/QdnRPHIpFrKIygb7nZN84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 063/346] cifs: handle servers that still advertise multichannel after disabling
Date: Mon, 29 Jan 2024 09:01:34 -0800
Message-ID: <20240129170018.248730700@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit f591062bdbf4742b7f1622173017f19e927057b0 ]

Some servers like Azure SMB servers always advertise multichannel
capability in server capabilities list. Such servers return error
STATUS_NOT_IMPLEMENTED for ioctl calls to query server interfaces,
and expect clients to consider that as a sign that they do not support
multichannel.

We already handled this at mount time. Soon after the tree connect,
we query server interfaces. And when server returned STATUS_NOT_IMPLEMENTED,
we kept interface list as empty. When cifs_try_adding_channels gets
called, it would not find any interfaces, so will not add channels.

For the case where an active multichannel mount exists, and multichannel
is disabled by such a server, this change will now allow the client
to disable secondary channels on the mount. It will check the return
status of query server interfaces call soon after a tree reconnect.
If the return status is EOPNOTSUPP, then instead of the check to add
more channels, we'll disable the secondary channels instead.

For better code reuse, this change also moves the common code for
disabling multichannel to a helper function.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 78e727e58e54 ("cifs: update iface_last_update on each query-and-update")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c |   8 +--
 fs/smb/client/smb2pdu.c | 107 +++++++++++++++++++++++++---------------
 2 files changed, 69 insertions(+), 46 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 14bc745de199..17310f3a9d89 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -614,7 +614,7 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 				 "multichannel not available\n"
 				 "Empty network interface list returned by server %s\n",
 				 ses->server->hostname);
-		rc = -EINVAL;
+		rc = -EOPNOTSUPP;
 		goto out;
 	}
 
@@ -734,12 +734,6 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 	if ((bytes_left > 8) || p->Next)
 		cifs_dbg(VFS, "%s: incomplete interface info\n", __func__);
 
-
-	if (!ses->iface_count) {
-		rc = -EINVAL;
-		goto out;
-	}
-
 out:
 	/*
 	 * Go through the list again and put the inactive entries
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 12e41fcd0b46..bfec2ca0f4e6 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -156,6 +156,57 @@ smb2_hdr_assemble(struct smb2_hdr *shdr, __le16 smb2_cmd,
 	return;
 }
 
+/* helper function for code reuse */
+static int
+cifs_chan_skip_or_disable(struct cifs_ses *ses,
+			  struct TCP_Server_Info *server,
+			  bool from_reconnect)
+{
+	struct TCP_Server_Info *pserver;
+	unsigned int chan_index;
+
+	if (SERVER_IS_CHAN(server)) {
+		cifs_dbg(VFS,
+			"server %s does not support multichannel anymore. Skip secondary channel\n",
+			 ses->server->hostname);
+
+		spin_lock(&ses->chan_lock);
+		chan_index = cifs_ses_get_chan_index(ses, server);
+		if (chan_index == CIFS_INVAL_CHAN_INDEX) {
+			spin_unlock(&ses->chan_lock);
+			goto skip_terminate;
+		}
+
+		ses->chans[chan_index].server = NULL;
+		spin_unlock(&ses->chan_lock);
+
+		/*
+		 * the above reference of server by channel
+		 * needs to be dropped without holding chan_lock
+		 * as cifs_put_tcp_session takes a higher lock
+		 * i.e. cifs_tcp_ses_lock
+		 */
+		cifs_put_tcp_session(server, from_reconnect);
+
+		server->terminate = true;
+		cifs_signal_cifsd_for_reconnect(server, false);
+
+		/* mark primary server as needing reconnect */
+		pserver = server->primary_server;
+		cifs_signal_cifsd_for_reconnect(pserver, false);
+skip_terminate:
+		mutex_unlock(&ses->session_mutex);
+		return -EHOSTDOWN;
+	}
+
+	cifs_server_dbg(VFS,
+		"server does not support multichannel anymore. Disable all other channels\n");
+	cifs_disable_secondary_channels(ses);
+
+
+	return 0;
+}
+
 static int
 smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	       struct TCP_Server_Info *server, bool from_reconnect)
@@ -164,8 +215,6 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	struct nls_table *nls_codepage = NULL;
 	struct cifs_ses *ses;
 	int xid;
-	struct TCP_Server_Info *pserver;
-	unsigned int chan_index;
 
 	/*
 	 * SMB2s NegProt, SessSetup, Logoff do not have tcon yet so
@@ -310,44 +359,11 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 		 */
 		if (ses->chan_count > 1 &&
 		    !(server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
-			if (SERVER_IS_CHAN(server)) {
-				cifs_dbg(VFS, "server %s does not support " \
-					 "multichannel anymore. skipping secondary channel\n",
-					 ses->server->hostname);
-
-				spin_lock(&ses->chan_lock);
-				chan_index = cifs_ses_get_chan_index(ses, server);
-				if (chan_index == CIFS_INVAL_CHAN_INDEX) {
-					spin_unlock(&ses->chan_lock);
-					goto skip_terminate;
-				}
-
-				ses->chans[chan_index].server = NULL;
-				spin_unlock(&ses->chan_lock);
-
-				/*
-				 * the above reference of server by channel
-				 * needs to be dropped without holding chan_lock
-				 * as cifs_put_tcp_session takes a higher lock
-				 * i.e. cifs_tcp_ses_lock
-				 */
-				cifs_put_tcp_session(server, from_reconnect);
-
-				server->terminate = true;
-				cifs_signal_cifsd_for_reconnect(server, false);
-
-				/* mark primary server as needing reconnect */
-				pserver = server->primary_server;
-				cifs_signal_cifsd_for_reconnect(pserver, false);
-
-skip_terminate:
+			rc = cifs_chan_skip_or_disable(ses, server,
+						       from_reconnect);
+			if (rc) {
 				mutex_unlock(&ses->session_mutex);
-				rc = -EHOSTDOWN;
 				goto out;
-			} else {
-				cifs_server_dbg(VFS, "does not support " \
-					 "multichannel anymore. disabling all other channels\n");
-				cifs_disable_secondary_channels(ses);
 			}
 		}
 
@@ -395,11 +411,23 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 		rc = SMB3_request_interfaces(xid, tcon, false);
 		free_xid(xid);
 
-		if (rc)
+		if (rc == -EOPNOTSUPP) {
+			/*
+			 * some servers like Azure SMB server do not advertise
+			 * that multichannel has been disabled with server
+			 * capabilities, rather return STATUS_NOT_IMPLEMENTED.
+			 * treat this as server not supporting multichannel
+			 */
+
+			rc = cifs_chan_skip_or_disable(ses, server,
+						       from_reconnect);
+			goto skip_add_channels;
+		} else if (rc)
 			cifs_dbg(FYI, "%s: failed to query server interfaces: %d\n",
 				 __func__, rc);
 
 		if (ses->chan_max > ses->chan_count &&
+		    ses->iface_count &&
 		    !SERVER_IS_CHAN(server)) {
 			if (ses->chan_count == 1)
 				cifs_server_dbg(VFS, "supports multichannel now\n");
@@ -409,6 +437,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	} else {
 		mutex_unlock(&ses->session_mutex);
 	}
+skip_add_channels:
 
 	if (smb2_command != SMB2_INTERNAL_CMD)
 		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
-- 
2.43.0



