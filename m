Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D95C47CC85;
	Mon, 31 Aug 2026 13:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184699; cv=none; b=d6h0omw4BkhDiELbUCFBxR2+e2X6nVMbucNLCH8GRNdMvYUM52CO2jBCjtZlRScPnMdm4v1dFTgvAnfz+1eV1kP609sacdI29oLEUWdcMj8xItP2BcZd5rDQ4oIeXRFBewSnvb60ru5L96auy74mNveJEGQST8rLEX6zy0T9NXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184699; c=relaxed/simple;
	bh=kcT+eyevJtAyXfU1vfdp1Os5SITPoyJHLagDzUDqkTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AFMipT45JL2U68R/WVC6Gb+Hrxf5BwOMBJPF+2YbvCmOzySNraA/z5C10Ba4yZe0mA7nCm7mHxxK8FgKbRpBXA3nbyyEDY09WV3r7UKwBawOSP+i/+C3YSjZqxcqmM7uSwLxdNCRCwdXJeN5/ONB8NSxcRds8bPu0bmvWGM3N7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=REtIlT+w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="REtIlT+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854DF1F000E9;
	Mon, 31 Aug 2026 13:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184697;
	bh=r4VP8234tfloyZLWBk2/25A04Ubl9bLcH4qXmXGKgZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=REtIlT+weMZwnjequgONRvkFOwhXJDh8PRWUDwPBLIdakdgyEViTYsoFKzmxULduc
	 rpqm2+dCUgiBLGkv0ZW7uze2gfV24GN4sm0gQdOgD6W4xsrAyIYNAzzzQ/Zk3ms0nJ
	 oZdLPgTPJJDznsG0QpujUcTywPzgGPBZkt7WHZsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <roxy520tt@gmail.com>,
	Ren Wei <enjou1224z@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 6.6 73/91] xfrm: drop ESP-in-TCP packets with no ingress device
Date: Mon, 31 Aug 2026 15:35:01 +0200
Message-ID: <20260831133403.436045904@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -39,6 +39,11 @@ static void handle_esp(struct sk_buff *s
 
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
@@ -47,6 +52,7 @@ static void handle_esp(struct sk_buff *s
 #endif
 		xfrm4_rcv_encap(skb, IPPROTO_ESP, 0, TCP_ENCAP_ESPINTCP);
 	local_bh_enable();
+out:
 	rcu_read_unlock();
 }
 


