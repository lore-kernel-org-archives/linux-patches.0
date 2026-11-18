Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017931;
	b=wEmHtQ3EUk1UvV3AO8jrpVUSDmusOVe6xDgt9xdj9D/+cmcNtbdVAhJ+WXX8j4Wl3xyI
	 aeowAqifLDelzR0BRn8BfNTFqIwslknz0XruVF4AWKDRBPI19koYEgFj8rHv0mZsUGPiW
	 H2UDKl0NoSINP7FpOGaMNzV7PWf5eh9bxkr55303BZUEQDoirrS+mHr9TGw7QT8oIpVDd
	 OuziNdXnPigMbhr1jgkzIi8ro+4v+A3ItIUJBB8fwnlHBf/mIf5LCTEKn1P5u2YlcW2xU
	 sb0qiFIPY43xAZdkiSZ9PuR0AkVbBCHrpaT75KfSeB5TZaj/dqAgXsrSlqP5822i0Cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017931;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5QKtBdTXeXkb2cWEogdWYBKTYS2KDsOjLGn0/GJLm84=;
	b=owRfR8StRFApukvqCBfnixrMVRpzdvPyOEQaNFzYnjhX8vuXBHeJFhpc3ihdjsvFwbDv
	 +AgJnl+6ZugH3LWHr71GSaQB26f8dU8xX+2F8X5i8mONEfA/jmVjcLjLETVg994ytSGSu
	 Zvofp13/m5NE4GC0bk7ZwgJx+mNeIIQbsQvNiT2+1fSVcgcc0YxdYOly3eU68J30YW9k2
	 uLn3lnyI1vhX6vbSW/WMBdn38s7Keuk4AgY6KKLFx3HTeLxQqNuhUg9QZvvifCZdCY5f9
	 B4/aNCiD7XPx2b3cNdWQuIwLOYd25oKUEReKd1dUZn9SknS9oyVcjJK6svq6bJVVlTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pxdbym5H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF810606A320;
	Wed, 18 Nov 2026 16:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pxdbym5H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1731F000C5;
	Wed, 18 Nov 2026 16:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017931;
	bh=5QKtBdTXeXkb2cWEogdWYBKTYS2KDsOjLGn0/GJLm84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pxdbym5HJwN/fzV0N2x2BdfktcDZOBnEe038giRf9w86Ka4RFkQlNzEK4dEEBzuqu
	 bYfy6S/ZRHJN6kQ023E1JeePg6wGy4I7y8REKRGlOCE54Xu4yLl6Tp8lnGg4WAuCvp
	 DWxVAovtWTw4Itdr9UTk+wozzO8ClBzBC5V/ACy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1043/2651] RDMA/mad: Reject receive completions shorter than GRH
Date: Wed, 18 Nov 2026 15:38:03 +0100
Message-ID: <20261118150325.511871505@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 2dc2126e690203d6adbddc7675927a242d810e43 ]

ib_mad_recv_done() derives the OPA MAD length by subtracting the GRH
size from wc->byte_len without ensuring the receive completion covers
the GRH. If it is shorter, the subtraction wraps before the result is
stored in mad_len and an invalid length can be passed downstream.

Reject receive completions shorter than the GRH before inspecting the
MAD header or deriving the MAD length.

Fixes: 8e4349d13f33 ("IB/mad: Add final OPA MAD processing")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260926105927.3183294-1-yaojiale02@163.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/mad.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 3c91f00d09c6b..8124e0b5a87da 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -2342,6 +2342,8 @@ static void ib_mad_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			    recv->header.mapping,
 			    mad_priv_dma_size(recv),
 			    DMA_FROM_DEVICE);
+	if (unlikely(wc->byte_len < sizeof(struct ib_grh)))
+		goto out;
 
 	/* Setup MAD receive work completion from "normal" work completion */
 	recv->header.wc = *wc;
-- 
2.53.0



