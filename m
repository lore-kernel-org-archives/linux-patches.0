Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061515;
	b=OTCDLfeeN7yfd1xZWOpMqZxKU5J/Sw07dP5Dit8hqPYNenyRNQ1mnO3veQMMIyQhvPjQ
	 g42Vt3kwAfy3lZXBtAWYroBnJC3n0YmDJ84WgVwz8r67BQFswOEdob9JMMeQxdc+6RQnQ
	 zZ7du7uXNMxPMpoDgwBrAq3Kcd4zOGlR1AqlzLEU1nisb0LFsOh9lAbc5yx/4MbWKDlQD
	 Xw9Sg1gF30mFkhbSFcBnb2MsyhIq1COG/wH2ZofpVlCWyWHj55sPFeqVIk9rHYnZGyOmE
	 vzhhd54+wihQA9PcjrAoVn3K+TjJM3MQZbaPGaAiL5oYkMFBDmxoBt9YjVe6CHG7eMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061515;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DbqvKRmCqsmZqfE7gtX7Zf5l1sxqZboOle97IxVSMGM=;
	b=GlKrh0F6z4VpZAW7kFF4i3a9zg/fj2va+/XOkwp+cq68pmo5A3/em8w8aenJH8sdUaAq
	 mA8+ZOmEp7BGhsl5Ci9LHZVO+dFnQKOOqrY/E0ghiflY6IM5QFX8g7/7dVOhYvxmTbeqR
	 rZv/FSuI7x8aQhx3BuzZ/SuHEzLekIuCyOqlEvkVZMeoswrltsJ4prtk8HvsYDus9sJBl
	 /Dd358sr+zzzL076k5qe9catGeuAck4WvGudy0EvGoXKZciWIiHxsnVmqlVxeTWhBPu4v
	 6GNqOb2K9oGNZijwAXoP1v7sNoHq255WeSvFB6aDVI8MW7s41CCD8qCkw07WWsf9IbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xmD9ybd0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BE2606A32D;
	Sat,  7 Nov 2026 14:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xmD9ybd0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842CC1F008A1;
	Sat,  7 Nov 2026 14:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061514;
	bh=DbqvKRmCqsmZqfE7gtX7Zf5l1sxqZboOle97IxVSMGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xmD9ybd0BGKF4r2vrOS0QKq8AF1gc/63huNrKzeJBb7Z1zfg+OaH3PQE9IHnh1L/v
	 dKLnf10qkSNajqBkE/ySTadSUaloYi7My21V6046Z4f9ZQfLw8KJoJnrZ4BsrRuSKp
	 TPgEyUuIUnPgdNWUZQQLKj4af4S5OpYzBTedJP3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.12 0605/1536] smb: client: fix use-after-free in cifs_ses_add_channel()
Date: Sat,  7 Nov 2026 08:43:41 -0500
Message-ID: <20261107135014.537096433@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henry Martin <bsdhenrymartin@gmail.com>

commit 031278577380e7875d95aed81a2b2bcac39be923 upstream.

The error path of cifs_ses_add_channel() calls cifs_put_tcp_session()
before cifs_chan_clear_need_reconnect().  The latter reaches
cifs_ses_get_chan_index(), which dereferences server->terminate; if
the put was the final reference, TCP_Server_Info is already freed and
this is a use-after-free.  Same put-then-use pattern as the recently
fixed sibling in commit 717e0a25036b ("cifs: Fix server use-after-free
in cifs_chan_skip_or_disable()").

Move the put last, but do not read chan->server after dropping
chan_lock: chan points into ses->chans[], and once chan_count is
decremented a concurrent add_channel can reuse the slot and overwrite
the pointer, so the put would act on the new channel's server.  Cache
the pointer under chan_lock, clear the reconnect bit and decrement
chan_count while still holding the reference, and release it after
the unlock.

This issue was discovered by Tencent CodeBuddy Security.

Fixes: ee1d21794e55a ("cifs: handle when server stops supporting multichannel")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Cc: stable@vger.kernel.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/sess.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -648,12 +648,13 @@ cifs_ses_add_channel(struct cifs_ses *se
 
 out:
 	if (rc && chan->server) {
-		cifs_put_tcp_session(chan->server, 0);
+		struct TCP_Server_Info *pserver;
 
 		spin_lock(&ses->chan_lock);
+		pserver = chan->server;
 
 		/* we rely on all bits beyond chan_count to be clear */
-		cifs_chan_clear_need_reconnect(ses, chan->server);
+		cifs_chan_clear_need_reconnect(ses, pserver);
 		ses->chan_count--;
 		/*
 		 * chan_count should never reach 0 as at least the primary
@@ -661,6 +662,7 @@ out:
 		 */
 		WARN_ON(ses->chan_count < 1);
 		spin_unlock(&ses->chan_lock);
+		cifs_put_tcp_session(pserver, 0);
 	}
 
 	kfree(ctx->UNC);


