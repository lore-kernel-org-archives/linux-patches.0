Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4979115DBA3;
	Mon, 29 Jan 2024 17:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548424; cv=none; b=D+buKir9aPiiRDoySe2rsIgC5dB7EBRBkQvv3lrqOG4oubuC3nTeoB/ahFjUdL0FCoxERFg908qAAa2J5BouvMCSf87J4I3qVNwSYaX6jhQyC0kOQgMxHUkVG6g4qsU+tXQJFsEcGG25HNfVlDtUIOSnk1VMtOLWmN2vyIiRMZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548424; c=relaxed/simple;
	bh=rZlEqqunQ+58+Fq8wdvmVl/cLNDLMwycY1pw+iW4WoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cAcX/OMqmwpw7tBgo14k7d4v5mxFcw5GeUpZhAC/MtKvzv0qqusR9eK21CbYzLhiUOWmUO3upXZGMAdIagHUeqz2pzKFYH3W4WEgSKFnAR9IEbT354c9wIak5P7X2bCtJdu6ta6R98KYAE6sVB8CXrnJOKwUl8EQaD+QIt12s6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iP9gZWWq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iP9gZWWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10501C433F1;
	Mon, 29 Jan 2024 17:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548424;
	bh=rZlEqqunQ+58+Fq8wdvmVl/cLNDLMwycY1pw+iW4WoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iP9gZWWqOkQFDwuNfIAGDTc7epE6otQ5sfCNDgTqWzpjf/WzCYeS9qPMIVg8gqEuA
	 KJC0MVvWh91ao0aDDJYsQBs+eE1wfxvXki4h8PWlhx4OaYmsCx/GAYmkCeI9uGrsQw
	 2HOWVZt5KZAEAu6tKNkY3PCVUcKs02FwBCkoQp2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/331] cifs: handle when server starts supporting multichannel
Date: Mon, 29 Jan 2024 09:01:27 -0800
Message-ID: <20240129170015.632675499@linuxfoundation.org>
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

[ Upstream commit 705fc522fe9d58848c253ee0948567060f36e2a7 ]

When the user mounts with multichannel option, but the
server does not support it, there can be a time in future
where it can be supported.

With this change, such a case is handled.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Stable-dep-of: 78e727e58e54 ("cifs: update iface_last_update on each query-and-update")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsproto.h |  1 +
 fs/smb/client/connect.c   |  3 +++
 fs/smb/client/smb2pdu.c   | 32 ++++++++++++++++++++++++++++++--
 3 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 0eb62ccd476f..4a28cff87038 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -132,6 +132,7 @@ extern int SendReceiveBlockingLock(const unsigned int xid,
 			struct smb_hdr *in_buf,
 			struct smb_hdr *out_buf,
 			int *bytes_returned);
+
 void
 cifs_signal_cifsd_for_reconnect(struct TCP_Server_Info *server,
 				      bool all_channels);
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 2f5be7dcd1f9..c0b1f30eecd7 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -128,6 +128,9 @@ static void smb2_query_server_interfaces(struct work_struct *work)
 	 */
 	rc = SMB3_request_interfaces(0, tcon, false);
 	if (rc) {
+		if (rc == -EOPNOTSUPP)
+			return;
+
 		cifs_dbg(FYI, "%s: failed to query server interfaces: %d\n",
 				__func__, rc);
 	}
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 0274ef67457b..288f22050c20 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -163,6 +163,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	int rc = 0;
 	struct nls_table *nls_codepage = NULL;
 	struct cifs_ses *ses;
+	int xid;
 
 	/*
 	 * SMB2s NegProt, SessSetup, Logoff do not have tcon yet so
@@ -307,17 +308,44 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 		tcon->need_reopen_files = true;
 
 	rc = cifs_tree_connect(0, tcon, nls_codepage);
-	mutex_unlock(&ses->session_mutex);
 
 	cifs_dbg(FYI, "reconnect tcon rc = %d\n", rc);
 	if (rc) {
 		/* If sess reconnected but tcon didn't, something strange ... */
+		mutex_unlock(&ses->session_mutex);
 		cifs_dbg(VFS, "reconnect tcon failed rc = %d\n", rc);
 		goto out;
 	}
 
+	if (!rc &&
+	    (server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
+		mutex_unlock(&ses->session_mutex);
+
+		/*
+		 * query server network interfaces, in case they change
+		 */
+		xid = get_xid();
+		rc = SMB3_request_interfaces(xid, tcon, false);
+		free_xid(xid);
+
+		if (rc)
+			cifs_dbg(FYI, "%s: failed to query server interfaces: %d\n",
+				 __func__, rc);
+
+		if (ses->chan_max > ses->chan_count &&
+		    !SERVER_IS_CHAN(server)) {
+			if (ses->chan_count == 1)
+				cifs_server_dbg(VFS, "supports multichannel now\n");
+
+			cifs_try_adding_channels(ses);
+		}
+	} else {
+		mutex_unlock(&ses->session_mutex);
+	}
+
 	if (smb2_command != SMB2_INTERNAL_CMD)
-		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
+		if (mod_delayed_work(cifsiod_wq, &server->reconnect, 0))
+			cifs_put_tcp_session(server, false);
 
 	atomic_inc(&tconInfoReconnectCount);
 out:
-- 
2.43.0



