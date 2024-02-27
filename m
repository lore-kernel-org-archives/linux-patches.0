Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A02313DB98;
	Tue, 27 Feb 2024 13:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041750; cv=none; b=DzVpk5mcSv23opLu/2cK201uJMRXTqTeoIsEuZVVwcI16EFJS9Fuu7MIWJ0UcWedNvAq8/XjefTJ27Tp//sB6eKStFrOskukNk3IgY8UoVlyM6Zr+jOtqqsnrb7gxuu9MRoCeCu65Jc8XMKYNV9u68R5cp3FlW3yTXvNO6Cmp8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041750; c=relaxed/simple;
	bh=YxQYmz+BXDFInpHlziyve4SC+5DG5WpK0m0/iE+52rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NwVp8S+sKAPujXZSBGDxaPSGGOJnKgpVAovENLMMn3kss7Ivdl1dtpIVX3Qf8U3bqV+aNnM1Yc7YvZNGxombox5omoMszHAdKKRXFySxYV4M2muaSkYTt8H2B0y3guMxlnm5IHu8bJn8CXqnOxwDtJvuC+dSEy812fuRwnPK+Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x7lbeKTf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x7lbeKTf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E2FC433C7;
	Tue, 27 Feb 2024 13:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041749;
	bh=YxQYmz+BXDFInpHlziyve4SC+5DG5WpK0m0/iE+52rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x7lbeKTfbUsemgxHsSAUMwVBalOfDD7ZH3GCWOfyAq0nmWM9qMwwwwTj1KWTkn90q
	 t1eke4+SKbyHGzDW/leQdiEV3uXuQq6BlpOiVDTl+hBWjMRPK2KmK7siC2M9IUHTB0
	 HsbOnLnCbwwjnoq0w5VoSrvw7/8rfpparBv8xvn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 055/299] cifs: make sure that channel scaling is done only once
Date: Tue, 27 Feb 2024 14:22:46 +0100
Message-ID: <20240227131627.736254727@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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



