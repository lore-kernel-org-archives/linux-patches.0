Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618964;
	b=vhil3XlrVaG/zwRP/Skz2QXc55zZSl1YY60PezL2EsFTXQHFNwitmXD36Od3GFubbkm8
	 iYEHWkHfJoCq0+cABZ5pVXSmpRmdJmDU1r5NOhsGGLUDZr/JS7SExXntWDCfnxUDAbs5J
	 HxCzNhzmbcGvywSmkjc7LfWbdv3/2h3HBtrtkSEvBP9JwkTiyKcVYnLlo9En8XQH9OJKn
	 qUFPOTCM+xcnERmVcNHQEC3yvf0eDP7E1ApZgkFLSwkRWr8LmGSm82b6WZdCgV0k1xm3J
	 kYbHCoWa78j8xkUB5OYCf3G2IzeJNZvpFLyapYA6Yv4a6dn6DVcOieqSjYMMVJJuepw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618964;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=H39KkRwE2mgQCB5QCTizwlQF26nfUir0kwSUPSYldOs=;
	b=4uNW6R9VPWJVerWQ69dlIPxmpnUedbvhSFazod+X6K+qNWwgrvd1gCSwagftTyzBUuII
	 IJWGfRFKTg4NtCXj+baVO1aqMvGPEr450h4Es7SCLzak8TXGjWt/5m55OI7c2Ib9ixzdR
	 NQxYdwlVJfcKMiZs+NnYCQL3/FsyZF4xI0MKT7juQkZ3oV4vAmrnGifU5HvW7Q+lC6B1I
	 QeWsr+CqrBcgep7ZOrvB8GAvsSmW4kvOEXBV5uqnmro69G2jeXbfMAh8WGnzokamTU4+f
	 F5tUyumNPztVW1LBkAs0QsTpTTQARVdXu+pEfJgyWFToyHW4C5WabQfqs9yrOAAElTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ccmoKrKI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47CB606A323;
	Wed, 25 Nov 2026 15:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ccmoKrKI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A701F000C4;
	Wed, 25 Nov 2026 15:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618964;
	bh=H39KkRwE2mgQCB5QCTizwlQF26nfUir0kwSUPSYldOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ccmoKrKIUY+qJV4b6me0+8Fly9P1k69YXb7LOqEb5hwbrwszH0473okQPFU4Pf5Tb
	 RVyNKLcsWU5gP4TPBFxdabESo9F0g5qb4LALhDBXX1zaExtiaSAev9UrSIFBsMv5rC
	 Lm/oL8UA0rLIR1/uHxRLcvzNSOGq7i4UmlUCTN54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0444/1005] ice: xsk: fix leaking Rx buffers in multi-buffer path
Date: Wed, 25 Nov 2026 15:29:42 +0100
Message-ID: <20261125143832.148865179@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit 8b7bd01b9c56c0d1f65d0e2ad304b775e0d709e3 ]

ice_clean_rx_irq_zc() consumes a descriptor without freeing its buffer
when a frag has zero length or when xsk_buff_add_frag() fails, which
happens if the frags array is full or the fill ring has duplicates.
Such buffers are lost to user space until the socket is closed.

Free the buffer in both cases. xp_free() skips a duplicate already
freed with the frame.

Fixes: 1bbc04de607b ("ice: xsk: add RX multi-buffer support")
Fixes: 93f53db9f9dc ("ice: switch to Page Pool")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Link: https://patch.msgid.link/20261102124950.958345-4-maciej.fijalkowski@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 0643017541c35..ea8ac0fcdf6ef 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -618,8 +618,11 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring,
 
 		if (!first) {
 			first = xdp;
-		} else if (likely(size) && !xsk_buff_add_frag(first, xdp)) {
+		} else if (unlikely(!size)) {
+			xsk_buff_free(xdp);
+		} else if (!xsk_buff_add_frag(first, xdp)) {
 			xsk_buff_free(first);
+			xsk_buff_free(xdp);
 			first = NULL;
 		}
 
-- 
2.53.0



