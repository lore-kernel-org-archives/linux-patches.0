Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021617;
	b=yOWQ7yPrbJ7LG7YjK0OsHhwhPxHHDrNneUYQajXSwuO+KKLCObS44KN6G2yobTdwCFQY
	 UcWNVB9E3MEiaCoRpETLX41/Fv8p5oSjfxQkelGiHfRh0oStJ27SR+hD2cEiwpIl/V5Do
	 SZUDWRAEs8eXctoLvrJV8Xhts3Qf8uZbbmpFI5n+9typVCmmMMvCHzAXmBqF9fhCkdUK7
	 RmvKXgIF5/3OcijzhOQHvOF5uJSd38qEEk+ch7sve1ONtOObceCsmkKG15XGu+xEB8kdD
	 Mwmu+yHmei2iAb4twvCTBl67aRAjCpTZ6sJ6hfZhj3VRHUZsJY8p16B5f6v2m9jvqoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021617;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=L7sNvGnA/lCZJTwQ4YMW0bB7j39OjJDZvWSm3KdxnFI=;
	b=4hU+j9n2MzB0OEDAFxH4Pg6CAN2ob+7qA2O2sMP5bZdv0mkBTgxgG7NWzBRdJ/9SWKDg
	 t1h0tQ6SmLNsEXepuojl9mT2rLaO9iLDMVzkJGCoXVSI1tkT+C/7XbIcwSrxKSkHbKi2C
	 eHBsPXfnQcuFP8OqfwWCCqXw0FFle2O9imgXKrXaB+pMyUKXf0NYdkuUQZvUoNWYoe3Rc
	 00u3z6q8F4B6GKiYVZKitAkyMeZUm4sAKE0GXSPaNNbaO1H7eAOt/38YOU/k/vnfIr5PE
	 ex6bfaDfFEXVwYcDju9twXODN4PvkCWdfNyHJrQsuBfWpBJtDkAtDQNpFLLYmfBExgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vvjr6aKj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A43E606A33D;
	Wed, 18 Nov 2026 17:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vvjr6aKj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB5D1F000C4;
	Wed, 18 Nov 2026 17:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021617;
	bh=L7sNvGnA/lCZJTwQ4YMW0bB7j39OjJDZvWSm3KdxnFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vvjr6aKjyxL2uxMm0sY8M0dBMxftpXiqdrhEIyTxzjWWVdXETCQrXrCxbgGxuU+Se
	 mZgQm1zZE+8IKpDjxaZY0b2cPtuo5e4WOnYq6XV8zx+50UdMc2Lb9W9yK6OzexBjDa
	 mN+Ch1XUKA3AAdTxV8x3uOgW50Fwvsd5zU9f7zs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dimitri Daskalakis <daskald@meta.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2372/2651] eth: fbnic: Correct packet header prefetch
Date: Wed, 18 Nov 2026 16:00:12 +0100
Message-ID: <20261118150410.902983287@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dimitri Daskalakis <daskald@meta.com>

[ Upstream commit 286154ae6998a32cca698abd713e1d4728e81924 ]

The existing call to net_prefetch() fetched a stale address. The data
pointer is not initialized until after the call to xdp_prepare_buff().
Thus, making the prefetch ineffective.

Open code the address calcuation to give the prefetch as much time
as possible.

This was found by manual code inspection. No issues have been observed
from this.

Fixes: 9064ab485f04 ("eth: fbnic: Prefetch packet headers on Rx")
Signed-off-by: Dimitri Daskalakis <daskald@meta.com>
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261020172706.1090951-1-dimitri.daskalakis1@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
index 10caacffee0f0..69cd96a4508f3 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
@@ -1011,7 +1011,7 @@ static void fbnic_pkt_prepare(struct fbnic_napi_vector *nv, u64 rcd,
 
 	/* Build frame around buffer */
 	hdr_start = page_address(page) + hdr_pg_start;
-	net_prefetch(pkt->buff.data);
+	net_prefetch(hdr_start + headroom);
 	xdp_prepare_buff(&pkt->buff, hdr_start, headroom,
 			 len - FBNIC_RX_PAD, true);
 
-- 
2.53.0



