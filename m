Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0CC3C063F;
	Tue, 16 Jun 2026 16:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628145; cv=none; b=GucOHzQt0URHPJ6PxJUS4jhL1OaRHpgD+jLh0r6tcN4rFLRoEXRuz1Sp5kPdkJNzlHbDR6uZ68xIWdUEnVnkUdYUu1bmPo4guCYKjZwy9U5tTb0w1/b1Ug07pQANI+PqADPCsjQB4SDDNF4gwZxvaUZBGFaz5jtobWGlJhNq0QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628145; c=relaxed/simple;
	bh=g4CrVNmz4hCMlfaVdXrSdPisUotc4fZPZ5mgv6SlHNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PDxBjenw21l32bhmnDa+1iP1wPpDeK219Yod7mg8AOAxLyXVrukKc3bWUpsIe34gkkc9bE9fNgfCq1POnNWAWqtahBsm4d68RQhHQ/5NGg276dbLVZNPmLIBj3TrEVlRMiQcVTPFN7PZzXSSAx7nGwtgDVWAtHENzhKEJSYvyao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=19Ahj9Zq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="19Ahj9Zq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC691F000E9;
	Tue, 16 Jun 2026 16:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628143;
	bh=b68tOxsnMYlhQseVcxGxOGfT8JvnZT+DDczKTHVom8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=19Ahj9ZqZcXdwluxuXWEp8Ya+bt0JMzQSdYTqOjrLUJbm3mIU4c3F8ScO66vuYGsD
	 9f6VqQNcWHA89KF/rpYgOTFrWBjrpNqjaPu3pIvwULQCxCQB24w6keYV3n7bXpTh46
	 /WcYL4OgCImKMq/yXPpKIJbRGfPpWWJjTiNK8C/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Lin <leo@depthfirst.com>,
	David Ahern <dahern@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 010/452] xfrm: Check for underflow in xfrm_state_mtu
Date: Tue, 16 Jun 2026 20:23:57 +0530
Message-ID: <20260616145118.341195305@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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
index 8ba31cf9b31993..6e8860779e2154 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2860,10 +2860,14 @@ u32 xfrm_state_mtu(struct xfrm_state *x, int mtu)
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
@@ -2883,8 +2887,17 @@ u32 xfrm_state_mtu(struct xfrm_state *x, int mtu)
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



