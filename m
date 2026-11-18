Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042487;
	b=LrBdaddG9ziRuDnRV38I5el0Z9e34h1Eje7GY/xCBARPy3JxsDjm4Rvmwaa0Af1RDS+H
	 g0WIaQiMiMNEQfOFuQBmIutXFjy5hnyr7ImN500ryyJe/DXnj7KzZ3CzzDMWtMvemtaYp
	 TDSggNWElYEsirf41NbFv+jjxZN9VPxpQJ4FGUFGbXV3Xy5MBAk8F3CgT0/MSLo43hlDL
	 DHKZWbLko9PpvOn/pmvTTSUwUkzqntAljzSGC0QmwYq9wn4BngCCEwiLdmmSjkbhsyepr
	 WYimlL3pjWBDXPXWDsvxQe3gQtO1Nj1zB4zJOtQsfH1ifThFofLNcOh1llC5NX9HKhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042487;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yijPPArb1hh4nMgeI/3iokqbrFQz14hwCUaC/PKwx9E=;
	b=vPokWZ5yIpMWchvk6cj3s4DIq5eJlDlu9kF2HdllgF252p+Tgtgytcr5HjFusQ8SStIR
	 ftkA6xfFARKPlVUrBblrIgwV8N54oRgO/XbFqjlNfO++eezzHO+Q4KWLHPCBmdJ2FBIKN
	 fn0gKh/gnOOUo4EYQpOP5y9oF1/iC6XS2w04uj6Us61754gwE/nrpNWIf9vC2zTIks5rW
	 zjHi8INh4SKodGCrV/o+DVYS9Iv1a4ECzwfDlOZvzn2OBscniFLzwZWXtE0gY8EZJE4er
	 ISYDBMo1ocRaT4raKHX+1CPgXl2QGFV1UZ/oadez/NTzXN5iLJDq0r6VWIeeQFduLtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hsjtt8jX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA11F606A31C;
	Wed, 18 Nov 2026 22:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hsjtt8jX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A9E1F000C4;
	Wed, 18 Nov 2026 22:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042487;
	bh=yijPPArb1hh4nMgeI/3iokqbrFQz14hwCUaC/PKwx9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hsjtt8jXmfKVZ7l2jaGqF5FbSqSeJK/M4zMLHlUJE3Ssu0slKaPfnPvcgcqBscZvN
	 9+GOdlQw6RaAlYpraY4y6J1ObFmrQT4ltKSk+Z8jG1RY5OGdwYCgf/sp+evq7kVos9
	 RDq7HJ7WJS5LkFEKtD3M+bWEJVcCVMCE8PGyeNnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3187/3318] net: usb: cdc_mbim: dont enable BHs in tx_fixup under netpoll
Date: Wed, 18 Nov 2026 16:03:29 +0100
Message-ID: <20261118150455.408648205@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit bfd7ced012c7857b5ab5edf7e416c2789b652702 ]

cdc_mbim_tx_fixup() has the same spin_unlock_bh() as cdc_ncm_tx_fixup().
Under netpoll it runs pending softirqs while the txq lock is held, and
a transmit from one of them spins on that lock.

Use plain spin_lock() as in cdc_ncm.

Fixes: 9bf211a30b3f ("net: cdc_mbim: adding MBIM driver")
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Link: https://patch.msgid.link/20261024-cdc-ncm-netpoll-v3-2-6284ca03f967@tipi-net.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/cdc_mbim.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/cdc_mbim.c b/drivers/net/usb/cdc_mbim.c
index de50405d7da04..f1ea8f808cb64 100644
--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -290,9 +290,10 @@ static struct sk_buff *cdc_mbim_tx_fixup(struct usbnet *dev, struct sk_buff *skb
 		}
 	}
 
-	spin_lock_bh(&ctx->mtx);
+	/* BHs or IRQs are always off here, see cdc_ncm_tx_fixup() */
+	spin_lock(&ctx->mtx);
 	skb_out = cdc_ncm_fill_tx_frame(dev, skb, sign);
-	spin_unlock_bh(&ctx->mtx);
+	spin_unlock(&ctx->mtx);
 	return skb_out;
 
 error:
-- 
2.53.0



