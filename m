Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC2C15DBB0;
	Mon, 29 Jan 2024 17:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548432; cv=none; b=FG/JyXiZHY+hzRs9wwTiLbNr7ca9Fe0vXoraQtm7LYyH6u6Q9UdBUWxogj//ugLhltdvmWkyGVRNfU0po096JfuS/iSIyoXQc2fuXIp+WsxlhZvxWl+xBFNBMwiS7ys1Z5kf/GgqQVPIu4OZ73uvfOkqFfROaL4RRdW3hpWJ1/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548432; c=relaxed/simple;
	bh=NpA3x1lf3ir7T3W9gJm75dnGAqDooGZPqU8NVKivijQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPLJH7+C7s3J8C302HGC+HBI5lqyxDVa2mydQbZDgh+yb056JekUyJLP8tghkWCbpSll0IXO4QoKUG/9KVsfvu2TW49/p6IgpH0el3C8so0RzN4a8cJ4LX1Zgf7Kn1RIyixpJY/GxoM6/XAXt9cSX83870wYpJJvEzobU4PjoWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s0MfO0vV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s0MfO0vV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 618AAC433C7;
	Mon, 29 Jan 2024 17:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548432;
	bh=NpA3x1lf3ir7T3W9gJm75dnGAqDooGZPqU8NVKivijQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s0MfO0vVXw2hT3q+3IfM/HAiCkFNtkYwp3ZebPbqKVRiBxY5CfAROVauqNL8p9La0
	 myf+YGN68E87Qfe6b2sLZFpflRQpaDNIN5kTHUfimV2KBG3L5FW9bpnwBmVzitNjIT
	 97nm+4pFVH6T42zYUg/DANq2z6BWU8nUkl9+apz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/331] cifs: handle servers that still advertise multichannel after disabling
Date: Mon, 29 Jan 2024 09:01:31 -0800
Message-ID: <20240129170015.754571368@linuxfoundation.org>
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
index 0604696f59c1..8caf2cefc8a7 100644
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
index a3995c6dc1ad..d846c238b7dd 100644
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
 		if (mod_delayed_work(cifsiod_wq, &server->reconnect, 0))
-- 
2.43.0



