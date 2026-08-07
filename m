Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5D1396597;
	Fri,  7 Aug 2026 15:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117450; cv=none; b=hNqL7caBm1R+BLe1A52TxDhLAMrjpssTzRRSLv6v/YY5/GP7b0O8j4wnJ0Gn2ef7tNRF2+W3JYQNRSf9owV1dTzwujAfmXtFKJqaNYzAa0O5FSXGDBnoppWRAYksjngbVTTwAtsT4tHbSe2hvgR2gLcvOJxBrXryiG6f77WniFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117450; c=relaxed/simple;
	bh=/KQKQ39fFIZ+EbPU/dds5nkzPu7rAxNUUGC+VMrCGHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n1SgjIapCH/K/M54rFy/djtdS5XRisKIDNJ66KxuFVHN6/Gme2vJx/ePPsj/N7Sw2yJkv0P1X/NVebMaW3z17S4Riwk+/a1H77AoChCgSc7YMNt/f0NfaapN56rtGHOS971MKCQfaSGJzJC3XyMaqO0CXxIsxcZKeMexaA4jVGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wLkeh/GZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wLkeh/GZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E652E1F000E9;
	Fri,  7 Aug 2026 15:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117449;
	bh=6sk3MXQypLPFnRwJ3cq7wR8QvgTBhkK+hzNzdlRLRWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wLkeh/GZcpSdIvLgyOcnhom5a9i1I4oy2I94YWQwv4hfp/BC1lFi0qooqcBuqgdR7
	 jjGh+aa7QPNW3L7klgNh+6Cjv9GZR8hop2MFMauF6nv6AId9pq6NsJRXF9Xt+ZVJ7i
	 rs4VLx5nqGXE0qnU5FOd4uU37b2NXWsYrssHr+SI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 306/438] vxlan: re-fetch eth header after route_shortcircuit()
Date: Fri,  7 Aug 2026 16:38:22 +0200
Message-ID: <20260807143434.496221599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 1395a676ec15a0a02a2a6d86602324f2d5fd41d5 upstream.

Before route_shortcircuit(), the eth header pointer is cached from eth_hdr(skb).

Inside route_shortcircuit(), pskb_may_pull() can be called, which may
reallocate skb->head.

In this case, returning to vxlan_xmit() leaves the cached eth pointer pointing to
freed memory, leading to a use-after-free when dereferencing eth->h_dest.

Fix this by updating eth = eth_hdr(skb) after calling route_shortcircuit().

Fixes: ae8840825605 ("VXLAN: Allow L2 redirection with L3 switching")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20260723144249.759100-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan/vxlan_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2797,6 +2797,7 @@ static netdev_tx_t vxlan_xmit(struct sk_
 	    (ntohs(eth->h_proto) == ETH_P_IP ||
 	     ntohs(eth->h_proto) == ETH_P_IPV6)) {
 		did_rsc = route_shortcircuit(dev, skb);
+		eth = eth_hdr(skb);
 		if (did_rsc)
 			f = vxlan_find_mac_tx(vxlan, eth->h_dest, vni);
 	}


