Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625683;
	b=gT6LlZflG+dHH+ee6pjV7dQNuYM0TlIYptGC2YxcBzPwOddFtA+yabg9MjCmwaI/rI/Y
	 uVuvg5XL2wTM/G6g/h35RaeTTVqJIWS8ZCIzcsW+SvRMkCqj5Ig35bia2JzS3+b5pcq8u
	 bDFx0ur0VuKLCiZRs6aJF43A4GtvYZqHQQbRNnimlWCDny5lhRX4Y0H6/7hN2rCFVzooe
	 v0aHScOHCBMd/JSo44N4mQOIog3MloMBsEBG36cJ0XvxWPIW5CfWucs3KrC/LWSPWFsuO
	 HOAAhPm8NXvfPpMMhDPQLlmGzZuQpNelc2szJ2XgIQpQak0sI87nVPKk/QsZCediEFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625683;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U7pcTVO95f2cuek+aJWAbwUBwemJqjpS6zdfA9zDqNU=;
	b=OxCmLhwjkvCMrxWdV7k0kMnbHZY3c7LY3bkiWyav2efKqyvb6FyyigzrdLQs3QtO7jbv
	 myoq+Ybi5984bfQ5K0E/3LOICzeR3qOE+2tHbPLp8JtPHxAV6xzYoGmBqHrz9e0KtE05v
	 SSCXpisyqnyI9DgBLqhyzknrr/dx4tfabm8gZxa509qCV7Kz5Go62seBNaBumhMvK/GKB
	 PqaVHRo5e2c4xMqMXIYXCDOwKu3hlV5N281A0G1iCTWdhjK2mISFMVYTYrYXUG8absSYX
	 hp64XBYMSDKkngucQxvMyLsgcyNy0bKsH1HFe2CBz0htelR8fgJq03ygExTDln9WhLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XBtkMo3D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C2C606A326;
	Wed, 25 Nov 2026 16:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XBtkMo3D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D5B51F000C4;
	Wed, 25 Nov 2026 16:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625683;
	bh=U7pcTVO95f2cuek+aJWAbwUBwemJqjpS6zdfA9zDqNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XBtkMo3DDlpeSF9Y0tMG/lGpl79cWNv7F+xSMYfxLj63zZp9toE9wq6CVLEVQddqa
	 9G/qs+RWSXoD/OF520SEg4bkJYwbT6epMWK1RQ1R8R2SzpTAU/AcBZd9Zqc8+S8Mxw
	 ROpfT/8EUyhqwVZ6U+UCpSqsnUR1+QzUmwOIOtFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joas Antonio dos Santos <joasantonio108@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 596/816] gtp: free the skb after handling an echo response
Date: Wed, 25 Nov 2026 15:35:44 +0100
Message-ID: <20261125143902.973677972@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
@@ -556,16 +556,19 @@ static int gtp0_handle_echo_resp(struct
 
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
@@ -742,16 +745,19 @@ static int gtp1u_handle_echo_resp(struct
 
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


