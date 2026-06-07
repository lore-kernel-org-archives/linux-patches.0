Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453E278C9C;
	Sun,  7 Jun 2026 10:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826791; cv=none; b=eFk5yToYwxHFW0nsWW2S7fiXwQfDwlzF+KoTVqetdL6U9DtQDOIiPlRdMkdB8zmTMmt0f8CnUSKwpZMfr3pC7aImuCAS4fxULE6KcLHTAFRVtcgvcEk1f1KiEMSZ/FoMem36vzpiyPLr/VuPoF2Bb9rpUAzm7aqmi01J3GTHYjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826791; c=relaxed/simple;
	bh=rQKtHVG7ilWvXcOBUDihxz9sRMpn3DZXEizyknqVlnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdSKWknwcmdmovzLtDb/4NQ/KioeB3PLzAZi/zAP9hiBmsskGs5GKg7ejFWjkd8GUNB9GwBaFsDXvH6PZiQlSN2EiHYa7vj1J0sKtivUPGao6nQIgskztgjwZ6P7FDpFEt6b2gxuTTVFmJGxmkDVIC5BHb+xU1sEBgfWwAGGvWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pi+g3jMr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pi+g3jMr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E5141F00893;
	Sun,  7 Jun 2026 10:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826789;
	bh=WUYJIpGG6ZT1CZ2lZajJx5S/UfnWZW7MWC0+eEPH4Kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pi+g3jMr0h9+EQuq8kgf6ZaaEquMEQP5jiNvzB+o/T3zrwK2H8MEzWHYOU4C0nS91
	 7Boe++f+7Eo25yVM4lxkKZ63LEIduwSvMg89vk8sX4D71w2u+Xf69XKmBFgEKaiyHB
	 moSLMHtuUy7M0yWFoWvOzXLPVWzPg4eHA0iKNEsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Lin <leo@depthfirst.com>,
	David Ahern <dahern@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 009/332] xfrm: Check for underflow in xfrm_state_mtu
Date: Sun,  7 Jun 2026 11:56:18 +0200
Message-ID: <20260607095728.366920276@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Ahern <dahern@nvidia.com>

[ Upstream commit 742b04d0550b0ec89dcbc99537ec88653bd1ad90 ]

Leo Lin reported OOB write issue in esp component:

  xfrm_state_mtu() returns u32 but performs its arithmetic in unsigned
  modulo-2^32 space using an attacker-influenced "header_len + authsize +
  net_adj" subtracted from a small "mtu" argument. A nobody user can
  install an IPv4 ESP tunnel SA with a large authentication key
  (XFRMA_ALG_AUTH_TRUNC, e.g. hmac(sha512), 64-byte key, 64-byte trunc),
  configure a small interface MTU (68 bytes), and set XFRMA_TFCPAD to a
  large value. When a single UDP datagram is then sent through the
  tunnel, xfrm_state_mtu() underflows to a near-2^32 value, and
  esp_output() consumes it as a signed int via:

        padto      = min(x->tfcpad, xfrm_state_mtu(x, mtu_cached))
        esp.tfclen = padto - skb->len   (assigned to int)

  esp.tfclen ends up negative (e.g. -207). It is sign-extended to size_t
  when passed to memset() inside esp_output_fill_trailer(), producing a
  ~16 EB write of zeroes at skb_tail_pointer(skb). KASAN logs it as
  "Write of size 18446744073709551537 at addr ffff888...".

Check for underflow and return 1. This causes the sendmsg attempt to
fail with ENETUNREACH.

Fixes: c5c252389374 ("[XFRM]: Optimize MTU calculation")
Reported-by: Leo Lin <leo@depthfirst.com>
Assisted-by: Codex:26.506.31004
Signed-off-by: David Ahern <dahern@nvidia.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_state.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 686014d394298c..f597e4996bb28a 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -3114,10 +3114,14 @@ u32 xfrm_state_mtu(struct xfrm_state *x, int mtu)
 	const struct xfrm_type *type = READ_ONCE(x->type);
 	struct crypto_aead *aead;
 	u32 blksize, net_adj = 0;
+	u32 overhead, payload_mtu;
 
 	if (x->km.state != XFRM_STATE_VALID ||
-	    !type || type->proto != IPPROTO_ESP)
+	    !type || type->proto != IPPROTO_ESP) {
+		if (mtu <= x->props.header_len)
+			return 1;
 		return mtu - x->props.header_len;
+	}
 
 	aead = x->data;
 	blksize = ALIGN(crypto_aead_blocksize(aead), 4);
@@ -3140,8 +3144,17 @@ u32 xfrm_state_mtu(struct xfrm_state *x, int mtu)
 		break;
 	}
 
-	return ((mtu - x->props.header_len - crypto_aead_authsize(aead) -
-		 net_adj) & ~(blksize - 1)) + net_adj - 2;
+	overhead = x->props.header_len + crypto_aead_authsize(aead) + net_adj;
+	if (mtu <= overhead)
+		return 1;
+
+	payload_mtu = mtu - overhead;
+	payload_mtu &= ~(blksize - 1);
+	if (payload_mtu <= 2)
+		return 1;
+
+	return payload_mtu + net_adj - 2;
+
 }
 EXPORT_SYMBOL_GPL(xfrm_state_mtu);
 
-- 
2.53.0



