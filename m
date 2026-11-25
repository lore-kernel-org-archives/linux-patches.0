Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623006;
	b=bESIl6rsewvDJ9MWvnjcuBzvXApzhyecYfyK/1jyDu2YGKs0/50MkC29dicAj13SlgJ0
	 /8n0Ilgf6Ue7tklxNjkLVl+21YdoE1lfghx6E1S3u3uJG+KB+vwPKo0dxget5mZLS1ThO
	 qaINfDY/ev5ZF1mcK2uFFXfauIDkpI5L/v7Miu9Vihj96YJfP3CIUcMCXMw4CqgOaiurw
	 xXZS8oFzPSpaGljdvgk8NDoXCplsrZh5C6JL2fwbn5ju7dNgEULq9Zc7EGYIbXcGT043g
	 TMxX76EoNyW5JULXSrwISenfdWEWDGQdJyX4KPhz5XZRliMjizYMEjQ9SA5eSvmEMVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623006;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qTwv0/keDQuY0vUcgorEcFY2o9tcsevuzY7rchfOcFY=;
	b=nJtjrMnoVFMECPQ2EoIOKM2W8ci5p/wAulT/hFDj1H8nzU+tcwlizP6hreChdg8JNSoQ
	 RQbSGlHfH/oMcr9QXpO2v2fX8kghv12yLz+ecjBRrJ8BgF0/9CERz6qDMqPOWL5698//d
	 fIlMcY4O1qR97jmHmb3rIwH3UkX5weB8+LflGz8ocGfGCU0hAU3PI5tC9gA9hFus6bCez
	 mNnGngMjTzMEQjPP0qi9mxLo1sNeadbJv7zI2WEpE5tUi/1BZMVaKtfzyhTRBXg+7iKc5
	 wche7EcOKnXTAXvIWoTaXu6XgqALxgD+2+MbAI+FdigWOJfVXsR8GRyRV4D744U885g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bKTnwkem;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66EFD606A326;
	Wed, 25 Nov 2026 16:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bKTnwkem
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789801F000C0;
	Wed, 25 Nov 2026 16:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623006;
	bh=qTwv0/keDQuY0vUcgorEcFY2o9tcsevuzY7rchfOcFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bKTnwkemOJs0ThdZqk3clGLcISiZNVee1CdQyLxLcyvV97+kCTz3DWK2XhbwmEzZ2
	 S78Pg4tb37qO3dfPZT/UFKZq+ooLfkUosuhbSp02NcPDfjNXAcQBQljGN6b+kiE7xT
	 SWYBh87n4m6XUzyD2qRk+FqplR4LlMGvHZ1N6Ags=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joas Antonio dos Santos <joasantonio108@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 718/990] gtp: free the skb after handling an echo response
Date: Wed, 25 Nov 2026 15:34:45 +0100
Message-ID: <20261125143838.899379298@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joas Antonio dos Santos <joasantonio108@gmail.com>

commit f17b293d155f377e4cff582b8113991d2ad346d6 upstream.

gtp0_handle_echo_resp() and gtp1u_handle_echo_resp() return the result
of genlmsg_multicast_netns() to gtp_encap_recv().  When the netlink
notification is delivered that result is 0, and gtp_encap_recv() treats
0 as "the skb has been consumed":

	switch (ret) {
	case 1:
		netdev_dbg(gtp->dev, "pass up to the process\n");
		break;
	case 0:
		break;
	case -1:
		netdev_dbg(gtp->dev, "GTP packet has been dropped\n");
		kfree_skb(skb);
		ret = 0;
		break;
	}

The echo response handlers only read from the skb and never free it or
pass it on, so every echo response that is reported to a listener on the
gtp multicast group leaks the skb.  Echo responses are handled for any
peer when the UDP sockets were created by the kernel, so a remote host
can leak memory on the receiver by sending GTP echo responses while a
process with CAP_NET_ADMIN is subscribed to the gtp multicast group, for
example a daemon that monitors echo responses.

The error paths do not leak but have a related problem.  -ENOMEM and the error from
genlmsg_multicast_netns() (-ESRCH when nobody listens) are not -1, so
they are returned unchanged to the UDP stack, which takes a negative
value from encap_rcv() as a request to resubmit the packet to the
protocol with that number.

Return -1 when the notification cannot be built, so that
gtp_encap_recv() drops the skb, and consume the skb once the
notification has been handed to netlink, whether or not anybody is
listening.

Found by LLM-assisted source review, untested.

Fixes: d33bd757d362 ("gtp: Implement GTP echo request")
Cc: stable@vger.kernel.org
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
Link: https://patch.msgid.link/20261110-gtp-echo-rsp-leak-v1-1-192c032f3dfa@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/gtp.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -560,16 +560,19 @@ static int gtp0_handle_echo_resp(struct
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
 	if (!msg)
-		return -ENOMEM;
+		return -1;
 
 	ret = gtp_genl_fill_echo(msg, 0, 0, 0, GTP_CMD_ECHOREQ, echo);
 	if (ret < 0) {
 		nlmsg_free(msg);
-		return ret;
+		return -1;
 	}
 
-	return genlmsg_multicast_netns(&gtp_genl_family, dev_net(gtp->dev),
-				       msg, 0, GTP_GENL_MCGRP, GFP_ATOMIC);
+	genlmsg_multicast_netns(&gtp_genl_family, dev_net(gtp->dev),
+				msg, 0, GTP_GENL_MCGRP, GFP_ATOMIC);
+	consume_skb(skb);
+
+	return 0;
 }
 
 static int gtp_proto_to_family(__u16 proto)
@@ -747,16 +750,19 @@ static int gtp1u_handle_echo_resp(struct
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
 	if (!msg)
-		return -ENOMEM;
+		return -1;
 
 	ret = gtp_genl_fill_echo(msg, 0, 0, 0, GTP_CMD_ECHOREQ, echo);
 	if (ret < 0) {
 		nlmsg_free(msg);
-		return ret;
+		return -1;
 	}
 
-	return genlmsg_multicast_netns(&gtp_genl_family, dev_net(gtp->dev),
-				       msg, 0, GTP_GENL_MCGRP, GFP_ATOMIC);
+	genlmsg_multicast_netns(&gtp_genl_family, dev_net(gtp->dev),
+				msg, 0, GTP_GENL_MCGRP, GFP_ATOMIC);
+	consume_skb(skb);
+
+	return 0;
 }
 
 static int gtp_parse_exthdrs(struct sk_buff *skb, unsigned int *hdrlen)


