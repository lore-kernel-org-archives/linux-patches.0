Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CD048125B;
	Mon, 31 Aug 2026 14:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184889; cv=none; b=GAwh47BKh8nUGa4hBfvrHMWYHLv7PJaU64cZfb+XFV79bAzayT0O5KnzOdqf6rnKbLHpI4078Ku/dJ7VwHCmHX22FvBnfxvMwjD7T2HaXqAFMosKmqvagGmtNA7oacwNtGCiS22B73e5H4vkz1XG9XpjV9VcNuO/mAGC3dU+pzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184889; c=relaxed/simple;
	bh=cx/UIWsyI0USWI3v2B0VAa2KI3l93agY3Cw3yuG34ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HH/I9JsLxORJz9XUE8vwmgs/gCGZVO/1BQ/S3ThXzxcqZORmwslSVsJmofbWz0ngZAzWUG7m5aPI7hI3tQ1pEibho1FNXGGKcweImb4CbO2efk5r6FUdHm6oZAEeaTNpDi75t1ZZeHiyHngBDdRwWyIlLhTxiCavijq2Noyzw6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RhSwWO8E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RhSwWO8E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36261F000E9;
	Mon, 31 Aug 2026 14:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184888;
	bh=ETHFOKXMvyKpmESfQ3NGoRgqnvd10DiB4HOCWj8napI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RhSwWO8EGy/zJNiPtqyT6Mu2YKfW2U+rOJZ+rX6S3koCqltexTfuo1MFE5F+vAWOg
	 pym8RFk1pcqE1Geg28EAKO8ip76QGvYxQHIi3VgiLzfJu+HombkHwarPjHgXB/qMno
	 G1VoKqZcEX8CvYxG25AVYlsyksgwjItliIdccneo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <roxy520tt@gmail.com>,
	Ren Wei <enjou1224z@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 6.1 73/92] xfrm: drop ESP-in-TCP packets with no ingress device
Date: Mon, 31 Aug 2026 15:35:11 +0200
Message-ID: <20260831133403.383687080@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -38,6 +38,11 @@ static void handle_esp(struct sk_buff *s
 
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
@@ -46,6 +51,7 @@ static void handle_esp(struct sk_buff *s
 #endif
 		xfrm4_rcv_encap(skb, IPPROTO_ESP, 0, TCP_ENCAP_ESPINTCP);
 	local_bh_enable();
+out:
 	rcu_read_unlock();
 }
 


