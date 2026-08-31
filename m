Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2924559309;
	Mon, 31 Aug 2026 13:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184041; cv=none; b=ubqJkFwraRESIO6Q4jpPm8HfH366QdSa5WqGpri0UF4N0FlUdLQhHdEGOUKHPOthqA2LjIHdFTo/RqFqFBapP5sKEabS9gl4LAQM+mfpEdu2fUR0IvZkMSnlaxUoh5Z5cY3cTMDHPyuBKpw7Z0NHo2yYedUTjjL4ijQRe1urLqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184041; c=relaxed/simple;
	bh=2vswX9jpbQTPlRned2jej5ckctGRRJzxcb+71J6sBXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qIQ+Xz+IYNlkL3CN1UDJ3yQoqVcgd6Zre9RjhfoKx4Aohcn+UOw7z0HCWfFd6kX191Z2V2LtExDM+39NZyZJBUT5zbARPVtrPemRZvzSVlbI7l6o0MP3xgiHLrnw+emmPWbgVGbutVypVuvP2qqFieY0mX7Io9lUB7/lCs623lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EJKFDXfn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EJKFDXfn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D749E1F00A3E;
	Mon, 31 Aug 2026 13:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184039;
	bh=+rYEwCiV9kWHkwNI9dlFX/mPj/95Ldfh5wXia7DJGPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EJKFDXfnnF882Vr7jY1H/LOJxYsgZYlr9c1gA+jAREab/yuNdjx3oSZPEnJo6srZg
	 9YlhCodvncfI5atZ6BJQ9ZH6nCLNPPlgB6dA+oOJVKvUgACWrGkOkDH9CDzVcgcFl5
	 bQjHW52aOWv6nTDz7nWJKUF1NiotjY8isf8vXbKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <roxy520tt@gmail.com>,
	Ren Wei <enjou1224z@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 6.18 52/83] xfrm: drop ESP-in-TCP packets with no ingress device
Date: Mon, 31 Aug 2026 15:34:28 +0200
Message-ID: <20260831133402.164827927@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiling Zou <roxy520tt@gmail.com>

commit e1d7c5ac1c246ce5775f604515de0a59fbf2116e upstream.

ESP-in-TCP receives records through the TCP strparser. handle_esp()
restores skb->dev from the saved skb_iif before passing the packet into
the XFRM input path.

Queued TCP data can be processed after the original ingress device has
been removed, for example during veth or net namespace teardown. In that
case dev_get_by_index_rcu() returns NULL. The XFRM IPv4 and IPv6 input
paths both expect skb->dev to be valid while building the route lookup,
so queued ESP-in-TCP data can dereference a NULL device.

Drop the packet if the saved ingress device can no longer be resolved.
Such a packet can no longer be routed through the normal XFRM receive
path, and this preserves the existing behaviour for packets whose ingress
device still exists.

Fixes: e27cca96cd68 ("xfrm: add espintcp (RFC 8229)")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <roxy520tt@gmail.com>
Assisted-by: Codex:gpt-5.4
Reviewed-by: Ren Wei <enjou1224z@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/espintcp.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -40,6 +40,11 @@ static void handle_esp(struct sk_buff *s
 
 	rcu_read_lock();
 	skb->dev = dev_get_by_index_rcu(sock_net(sk), skb->skb_iif);
+	if (!skb->dev) {
+		XFRM_INC_STATS(sock_net(sk), LINUX_MIB_XFRMINERROR);
+		kfree_skb(skb);
+		goto out;
+	}
 	local_bh_disable();
 #if IS_ENABLED(CONFIG_IPV6)
 	if (sk->sk_family == AF_INET6)
@@ -48,6 +53,7 @@ static void handle_esp(struct sk_buff *s
 #endif
 		xfrm4_rcv_encap(skb, IPPROTO_ESP, 0, TCP_ENCAP_ESPINTCP);
 	local_bh_enable();
+out:
 	rcu_read_unlock();
 }
 


