Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620316;
	b=0yvawxwUqeLzDfWvLW2h4rghJrReVcFiq1UaOQtNQXFYrlh8VrjisI1nYPW0Mbx/enJX
	 kpcWO5Ow/IRQ6qLaN4n+EkFNsCOZcuyMg/G/KQL+Tomb5f0i4o/BLkz53YuIN5giJhxDC
	 5fByTcqT2rVFx26KZy0JL1sAESp6h+bJY/Kz5hLePMYyQfJgXex87s/5ywI9I/zeSTL+z
	 vK9+3S8Ri+fUQubY4stgfJ92FaArLaLUA1IKjApdx4IiE8EnQzZ8JwQx1BWeu/QhpBRwK
	 JC62iQXq1hBMWwLs2KO3x6b43CERv8kYP/DQapUfts4nIDpcGcV0C4ltYxCMIQvfxyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620316;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wVAuxMSBboJbD0G3nHJ8PnRY2CGekFAqEY5lAcxiUzU=;
	b=VmzOyv8R++01KgDurZztgLNZAVITSRy4IMrJEzgnb0tRtRRm7P2flcq2gLKVVg4+041H
	 Z+g5rrUW1KFAYWCoLQzxHx9Fokq1EoDBz8DvxMuQlOW5K2W9Y/Ecr72mv8HaGEMxhYuQs
	 JWLlAJzs+ABPS2XXpBl7/cCR925/OzGYLvdtNtYsZEpo7BO90ts/VvgYf+0qdf8ZSi4IV
	 YoyVXD9iht2otzuYHvghjhb83C9+DZSTT80/ifxiduE1MRZh761tFLYGEXiHgq9nTidFM
	 fOcOJN2tQ1Mnzd7mDc+19sH5cUfjG3ckpuFVsiYaWrKMqsCJLOwGQVKyyH3qLHZtxkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2AEhI6rJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC3C606A321;
	Wed, 25 Nov 2026 15:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2AEhI6rJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35AFC1F000C0;
	Wed, 25 Nov 2026 15:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620315;
	bh=wVAuxMSBboJbD0G3nHJ8PnRY2CGekFAqEY5lAcxiUzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2AEhI6rJfaoyh9M8ugayWdBl6Hw5OnxKWRXAVF27HE0JWTpqsJ3xF2NUA74l7ZebN
	 /QaHArJQDIoAtUxJYkUeWJcea8tynDc1Wxp8J7pj/YwbI2xpTxlOcgwQwGvGLxgOOe
	 g57MIwG7JoGQ++6RgzlTc01dUTUT4J5JSFH4T66o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.3 0840/1005] smb: client: hold server ref while queueing reconnect work
Date: Wed, 25 Nov 2026 15:36:18 +0100
Message-ID: <20261125143841.394373676@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Qi <joseph.qi@linux.alibaba.com>

commit f02d249e9756b78990aaaa1635e47e06deb2cb51 upstream.

When query_server_interfaces() returns -EOPNOTSUPP on a secondary
channel, smb2_reconnect() calls smb3_update_ses_channels() which for a
channel runs cifs_chan_skip_or_disable().  That clears the channel's
slot in the session and calls cifs_put_tcp_session(), which can drop
the last reference of the channel and tear it down.

smb2_reconnect() then falls through to skip_add_channels and queues
reconnect work on that server, using a server that may already be
freed.  The send path obtained the channel from cifs_pick_channel(),
which does not take a reference, so the session's channel reference is
the only one.

Take our own reference on the channel before calling
smb3_update_ses_channels() and drop it after the reconnect work has
been queued, so the channel cannot be freed while it is still used.

Fixes: f591062bdbf4 ("cifs: handle servers that still advertise multichannel after disabling")
Cc: stable@vger.kernel.org
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2pdu.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -250,9 +250,10 @@ static int
 smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	       struct TCP_Server_Info *server, bool from_reconnect)
 {
+	bool hold_server_ref = false;
 	struct cifs_ses *ses;
-	int xid;
 	int rc = 0;
+	int xid;
 
 	/*
 	 * SMB2s NegProt, SessSetup, Logoff do not have tcon yet so
@@ -470,6 +471,20 @@ skip_sess_setup:
 			 * treat this as server not supporting multichannel
 			 */
 
+			/*
+			 * If server is a secondary channel,
+			 * cifs_chan_skip_or_disable() called below may
+			 * drop its last reference, so hold our own
+			 * reference until the reconnect work below has
+			 * been queued.
+			 */
+			spin_lock(&cifs_tcp_ses_lock);
+			if (server->srv_count) {
+				server->srv_count++;
+				hold_server_ref = true;
+			}
+			spin_unlock(&cifs_tcp_ses_lock);
+
 			rc = smb3_update_ses_channels(ses, server,
 						       from_reconnect,
 						       true /* disable_mchan */);
@@ -498,6 +513,8 @@ skip_add_channels:
 
 	if (smb2_command != SMB2_INTERNAL_CMD)
 		cifs_queue_server_reconn(server);
+	if (hold_server_ref)
+		cifs_put_tcp_session(server, from_reconnect);
 
 	atomic_inc(&tconInfoReconnectCount);
 out:


