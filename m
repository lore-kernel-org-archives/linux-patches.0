Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B709B15B0E2;
	Mon, 29 Jan 2024 17:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548422; cv=none; b=T2XCUFW+xC/7N4m58zQqU4GDCE0140kNceb87mawdD1krHqBJfiXJbDdzaFgBEN40xI9NZu0tl3shbBFsdV8ey627SMcDikQ275qXEi+2uE6llrnj1jVYbdqVisWvbX+9uok5VsRoAI0XHzuiYScxQss8OxYAQVXMACFoJp9Ce0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548422; c=relaxed/simple;
	bh=Z1mFOraK2oTas6pepDNWJtegPgKJRk6KJEEEMDrbrv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SgYMJNVE7/27T1Bi4Sqp9c3dV+FiAIAV8dybpbyJ9hBlt08mQGnT1cnRH6K7e/PkTyr+N+EC6jhW20BsHgv8f1UxQYmra2wEhwEa9Q3+S/uutC24ZBqWReaqOJ1oz/soDCcT99oEFCkDxp7GYSXxIotyP13Qly45pqWe4oqc3Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nqOJTU4r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nqOJTU4r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81DEEC433C7;
	Mon, 29 Jan 2024 17:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548422;
	bh=Z1mFOraK2oTas6pepDNWJtegPgKJRk6KJEEEMDrbrv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nqOJTU4rOYU04C5/m2N8LY+MVQKaY7OixFdggPatrRXTGaHbAoxaUau2rLjZtdD4A
	 VKHtHAU1L+fFzC0znKfrpZvMlhT8toOPmawoEmx8fMMx9k8lhRv5Q+rCm8cZ7g97Ux
	 VI4ogiBcc2CnEXlaeqfZKAgbdtmeU2pWw37Z103A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/331] cifs: handle cases where a channel is closed
Date: Mon, 29 Jan 2024 09:01:25 -0800
Message-ID: <20240129170015.576380631@linuxfoundation.org>
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

[ Upstream commit 0c51cc6f2cb0108e7d49805f6e089cd85caab279 ]

So far, SMB multichannel could only scale up, but not
scale down the number of channels. In this series of
patch, we now allow the client to deal with the case
of multichannel disabled on the server when the share
is mounted. With that change, we now need the ability
to scale down the channels.

This change allows the client to deal with cases of
missing channels more gracefully.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 78e727e58e54 ("cifs: update iface_last_update on each query-and-update")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifs_debug.c    |  5 +++++
 fs/smb/client/cifsglob.h      |  1 +
 fs/smb/client/cifsproto.h     |  2 +-
 fs/smb/client/connect.c       |  6 +++++-
 fs/smb/client/sess.c          | 28 ++++++++++++++++++++++++----
 fs/smb/client/smb2transport.c |  8 +++++++-
 6 files changed, 43 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index a2584ad8808a..3230ed7eadde 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -138,6 +138,11 @@ cifs_dump_channel(struct seq_file *m, int i, struct cifs_chan *chan)
 {
 	struct TCP_Server_Info *server = chan->server;
 
+	if (!server) {
+		seq_printf(m, "\n\n\t\tChannel: %d DISABLED", i+1);
+		return;
+	}
+
 	seq_printf(m, "\n\n\t\tChannel: %d ConnectionId: 0x%llx"
 		   "\n\t\tNumber of credits: %d,%d,%d Dialect 0x%x"
 		   "\n\t\tTCP status: %d Instance: %d"
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index ec1e5e20a36b..e3ef8eee68d1 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1060,6 +1060,7 @@ struct cifs_ses {
 	spinlock_t chan_lock;
 	/* ========= begin: protected by chan_lock ======== */
 #define CIFS_MAX_CHANNELS 16
+#define CIFS_INVAL_CHAN_INDEX (-1)
 #define CIFS_ALL_CHANNELS_SET(ses)	\
 	((1UL << (ses)->chan_count) - 1)
 #define CIFS_ALL_CHANS_GOOD(ses)		\
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index c858feaf4f92..0eb62ccd476f 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -622,7 +622,7 @@ bool is_server_using_iface(struct TCP_Server_Info *server,
 bool is_ses_using_iface(struct cifs_ses *ses, struct cifs_server_iface *iface);
 void cifs_ses_mark_for_reconnect(struct cifs_ses *ses);
 
-unsigned int
+int
 cifs_ses_get_chan_index(struct cifs_ses *ses,
 			struct TCP_Server_Info *server);
 void
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index b82f60d6f47e..a482afa3fa42 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -169,8 +169,12 @@ cifs_signal_cifsd_for_reconnect(struct TCP_Server_Info *server,
 	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
 		spin_lock(&ses->chan_lock);
 		for (i = 0; i < ses->chan_count; i++) {
+			if (!ses->chans[i].server)
+				continue;
+
 			spin_lock(&ses->chans[i].server->srv_lock);
-			ses->chans[i].server->tcpStatus = CifsNeedReconnect;
+			if (ses->chans[i].server->tcpStatus != CifsExiting)
+				ses->chans[i].server->tcpStatus = CifsNeedReconnect;
 			spin_unlock(&ses->chans[i].server->srv_lock);
 		}
 		spin_unlock(&ses->chan_lock);
diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 80050e36f045..650a3ec9e6e5 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -69,7 +69,7 @@ bool is_ses_using_iface(struct cifs_ses *ses, struct cifs_server_iface *iface)
 
 /* channel helper functions. assumed that chan_lock is held by caller. */
 
-unsigned int
+int
 cifs_ses_get_chan_index(struct cifs_ses *ses,
 			struct TCP_Server_Info *server)
 {
@@ -85,14 +85,17 @@ cifs_ses_get_chan_index(struct cifs_ses *ses,
 		cifs_dbg(VFS, "unable to get chan index for server: 0x%llx",
 			 server->conn_id);
 	WARN_ON(1);
-	return 0;
+	return CIFS_INVAL_CHAN_INDEX;
 }
 
 void
 cifs_chan_set_in_reconnect(struct cifs_ses *ses,
 			     struct TCP_Server_Info *server)
 {
-	unsigned int chan_index = cifs_ses_get_chan_index(ses, server);
+	int chan_index = cifs_ses_get_chan_index(ses, server);
+
+	if (chan_index == CIFS_INVAL_CHAN_INDEX)
+		return;
 
 	ses->chans[chan_index].in_reconnect = true;
 }
@@ -102,6 +105,8 @@ cifs_chan_clear_in_reconnect(struct cifs_ses *ses,
 			     struct TCP_Server_Info *server)
 {
 	unsigned int chan_index = cifs_ses_get_chan_index(ses, server);
+	if (chan_index == CIFS_INVAL_CHAN_INDEX)
+		return;
 
 	ses->chans[chan_index].in_reconnect = false;
 }
@@ -111,6 +116,8 @@ cifs_chan_in_reconnect(struct cifs_ses *ses,
 			  struct TCP_Server_Info *server)
 {
 	unsigned int chan_index = cifs_ses_get_chan_index(ses, server);
+	if (chan_index == CIFS_INVAL_CHAN_INDEX)
+		return true;	/* err on the safer side */
 
 	return CIFS_CHAN_IN_RECONNECT(ses, chan_index);
 }
@@ -120,6 +127,8 @@ cifs_chan_set_need_reconnect(struct cifs_ses *ses,
 			     struct TCP_Server_Info *server)
 {
 	unsigned int chan_index = cifs_ses_get_chan_index(ses, server);
+	if (chan_index == CIFS_INVAL_CHAN_INDEX)
+		return;
 
 	set_bit(chan_index, &ses->chans_need_reconnect);
 	cifs_dbg(FYI, "Set reconnect bitmask for chan %u; now 0x%lx\n",
@@ -131,6 +140,8 @@ cifs_chan_clear_need_reconnect(struct cifs_ses *ses,
 			       struct TCP_Server_Info *server)
 {
 	unsigned int chan_index = cifs_ses_get_chan_index(ses, server);
+	if (chan_index == CIFS_INVAL_CHAN_INDEX)
+		return;
 
 	clear_bit(chan_index, &ses->chans_need_reconnect);
 	cifs_dbg(FYI, "Cleared reconnect bitmask for chan %u; now 0x%lx\n",
@@ -142,6 +153,8 @@ cifs_chan_needs_reconnect(struct cifs_ses *ses,
 			  struct TCP_Server_Info *server)
 {
 	unsigned int chan_index = cifs_ses_get_chan_index(ses, server);
+	if (chan_index == CIFS_INVAL_CHAN_INDEX)
+		return true;	/* err on the safer side */
 
 	return CIFS_CHAN_NEEDS_RECONNECT(ses, chan_index);
 }
@@ -151,6 +164,8 @@ cifs_chan_is_iface_active(struct cifs_ses *ses,
 			  struct TCP_Server_Info *server)
 {
 	unsigned int chan_index = cifs_ses_get_chan_index(ses, server);
+	if (chan_index == CIFS_INVAL_CHAN_INDEX)
+		return true;	/* err on the safer side */
 
 	return ses->chans[chan_index].iface &&
 		ses->chans[chan_index].iface->is_active;
@@ -293,7 +308,7 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 
 	spin_lock(&ses->chan_lock);
 	chan_index = cifs_ses_get_chan_index(ses, server);
-	if (!chan_index) {
+	if (chan_index == CIFS_INVAL_CHAN_INDEX) {
 		spin_unlock(&ses->chan_lock);
 		return 0;
 	}
@@ -403,6 +418,11 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 
 	spin_lock(&ses->chan_lock);
 	chan_index = cifs_ses_get_chan_index(ses, server);
+	if (chan_index == CIFS_INVAL_CHAN_INDEX) {
+		spin_unlock(&ses->chan_lock);
+		return 0;
+	}
+
 	ses->chans[chan_index].iface = iface;
 
 	/* No iface is found. if secondary chan, drop connection */
diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index a136fc4cc2b5..5a3ca62d2f07 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -413,7 +413,13 @@ generate_smb3signingkey(struct cifs_ses *ses,
 		      ses->ses_status == SES_GOOD);
 
 	chan_index = cifs_ses_get_chan_index(ses, server);
-	/* TODO: introduce ref counting for channels when the can be freed */
+	if (chan_index == CIFS_INVAL_CHAN_INDEX) {
+		spin_unlock(&ses->chan_lock);
+		spin_unlock(&ses->ses_lock);
+
+		return -EINVAL;
+	}
+
 	spin_unlock(&ses->chan_lock);
 	spin_unlock(&ses->ses_lock);
 
-- 
2.43.0



