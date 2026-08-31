Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1DAC4432F8;
	Mon, 31 Aug 2026 13:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183549; cv=none; b=Z3fuuAo6fNHVFL40hhLCefHf9tttJD/DGk11GQ4PVjHC/kKGqGDhXv5BfS/dCebIV5P4Fvq9H4nlCM72Qfx1UdmFV/tDJN1rENPzxGfZ0fZl8BteJAjmM6zvkGGKtuWCvMY7VhW8iK2oN83V6hPNGi0/r6/hZNtW/KZGzQ9ljdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183549; c=relaxed/simple;
	bh=FbjK2nNStEEx3bwHKta5uj663jZ1WS9uhG/89rl+980=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XlON7JXHvPXa4bQs6cxbGUiBAE8VCALBQWIm3qqAkxZqI8vvlojXN+iWslwSmB8iTE7j+vIItMurtqMG0YUCDL77lpzj3ZhgHKqq5vDCX36cDsQ9kf+P6IxseDVtq0hTS2A4mmjze/NB2ouEJmbV8o9HgxQIcfTu8XalRga2qfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z5PIArOo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z5PIArOo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253901F00A3D;
	Mon, 31 Aug 2026 13:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183547;
	bh=ViKcaXTjCrdLleakiUycKJ3npOjAGWPQu59QWe/Gtxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z5PIArOoEQZdi9Am28GkLw80AYoMkUsa49A23P4wPBkRcWBjc3wxrfbmWDJGBJ30N
	 OsuQ3dZOphLTQNEPcu45gbW/Mrl7VAYsk3IDY14JLRX7I33+Rid3WSI/E+Ac+yhVYI
	 Da60gQKt9YUvmFe1qvkwYxZShI1DGUZxXcAVf6J4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <roxy520tt@gmail.com>,
	Ren Wei <enjou1224z@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 7.2 34/71] xfrm: drop ESP-in-TCP packets with no ingress device
Date: Mon, 31 Aug 2026 15:33:59 +0200
Message-ID: <20260831133400.863250641@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
References: <20260831133359.055927882@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -37,6 +37,11 @@ static void handle_esp(struct sk_buff *s
 
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
@@ -45,6 +50,7 @@ static void handle_esp(struct sk_buff *s
 #endif
 		xfrm4_rcv_encap(skb, IPPROTO_ESP, 0, TCP_ENCAP_ESPINTCP);
 	local_bh_enable();
+out:
 	rcu_read_unlock();
 }
 


