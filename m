Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E6413A25D;
	Tue, 27 Feb 2024 13:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040730; cv=none; b=L9hGmgiDZtj4rQ4O1vi9F+22Zn3qvgSuo34r4t8U0AZT3oW72MBv4U143oCr3SpsKB0GsuKAHjkntuofWhjcCPNky2vkZMKEpm1Ahpg4zjHGTN2VCCa+wcZVtshixg5eJMB9ANSE6EJElu7voVV1s75jOF9TIvwyAa2TEflh7xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040730; c=relaxed/simple;
	bh=mAJtNYjeV2GC+ZaUc/OSmZRu5C+U06pbVJdPyQlIeZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fvRohdQByzwSl7Sf1lo7l3XLx9ghEQbmBNYA0skW7QN7gQN6IExbk9Utf4QkrRvgUhdIZtldkcM50aH7PCelFB4dPGGT9Q3xdw5RcKhsAWnJ9MixOjkoOTg/V/JO7uY4Ng2Vbw2fCiusC6UbV9TLRE/tBng8lhzjGff15cRNwWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u8s6S/ow; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u8s6S/ow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AFB9C433C7;
	Tue, 27 Feb 2024 13:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040730;
	bh=mAJtNYjeV2GC+ZaUc/OSmZRu5C+U06pbVJdPyQlIeZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u8s6S/owtr8y/BxytFHRDYiPmmXrrkKcUClwYl44X4YsWtq5vnpNRu/qdZW6RUwzO
	 s1jJoOzRknNKh51k+n5cLFJBa+lEE0wSRapeaxdElmoB0S5vDGTYfkKaMRNtVTxdOz
	 8cW55J8STh6HokAvLEbKQDCZ4esh/7NGGt6vj5xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 060/334] cifs: make sure that channel scaling is done only once
Date: Tue, 27 Feb 2024 14:18:38 +0100
Message-ID: <20240227131632.508475895@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

[ Upstream commit ee36a3b345c433a846effcdcfba437c2298eeda5 ]

Following a successful cifs_tree_connect, we have the code
to scale up/down the number of channels in the session.
However, it is not protected by a lock today.

As a result, this code can be executed by several processes
that select the same channel. The core functions handle this
well, as they pick chan_lock. However, we've seen cases where
smb2_reconnect throws some warnings.

To fix that, this change introduces a flags bitmap inside the
cifs_ses structure. A new flag type is used to ensure that
only one process enters this section at any time.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsglob.h |  3 +++
 fs/smb/client/smb2pdu.c  | 18 +++++++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index f794b16095e43..dcc41fe33b705 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1018,6 +1018,8 @@ struct cifs_chan {
 	__u8 signkey[SMB3_SIGN_KEY_SIZE];
 };
 
+#define CIFS_SES_FLAG_SCALE_CHANNELS (0x1)
+
 /*
  * Session structure.  One of these for each uid session with a particular host
  */
@@ -1050,6 +1052,7 @@ struct cifs_ses {
 	enum securityEnum sectype; /* what security flavor was specified? */
 	bool sign;		/* is signing required? */
 	bool domainAuto:1;
+	unsigned int flags;
 	__u16 session_flags;
 	__u8 smb3signingkey[SMB3_SIGN_KEY_SIZE];
 	__u8 smb3encryptionkey[SMB3_ENC_DEC_KEY_SIZE];
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 5d9c87d2e1e01..ce2d28537bc8a 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -399,6 +399,15 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 		goto out;
 	}
 
+	spin_lock(&ses->ses_lock);
+	if (ses->flags & CIFS_SES_FLAG_SCALE_CHANNELS) {
+		spin_unlock(&ses->ses_lock);
+		mutex_unlock(&ses->session_mutex);
+		goto skip_add_channels;
+	}
+	ses->flags |= CIFS_SES_FLAG_SCALE_CHANNELS;
+	spin_unlock(&ses->ses_lock);
+
 	if (!rc &&
 	    (server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
 		mutex_unlock(&ses->session_mutex);
@@ -428,15 +437,22 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 		if (ses->chan_max > ses->chan_count &&
 		    ses->iface_count &&
 		    !SERVER_IS_CHAN(server)) {
-			if (ses->chan_count == 1)
+			if (ses->chan_count == 1) {
 				cifs_server_dbg(VFS, "supports multichannel now\n");
+				queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
+						 (SMB_INTERFACE_POLL_INTERVAL * HZ));
+			}
 
 			cifs_try_adding_channels(ses);
 		}
 	} else {
 		mutex_unlock(&ses->session_mutex);
 	}
+
 skip_add_channels:
+	spin_lock(&ses->ses_lock);
+	ses->flags &= ~CIFS_SES_FLAG_SCALE_CHANNELS;
+	spin_unlock(&ses->ses_lock);
 
 	if (smb2_command != SMB2_INTERNAL_CMD)
 		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
-- 
2.43.0



