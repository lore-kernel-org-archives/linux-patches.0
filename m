Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621994;
	b=jSD+TvbhqYfPPPwqEtcxumjnQLLLvQ+pO7XVbQYFFQ+JCiZOEiHzaJBp4myJSvBdB34P
	 8/nagHfwMY2t2wIPo2iupotZ2xgTgE5vXuyB61GlehzCAC3JG5xyVHluSUfWlIlbqMzIW
	 wpd1X7abJKdyDZA2LXEJUdCl0GKSlNGut4SfadEsrUoac46gbo8eStVvnerauRQBESuYp
	 gim5stGoobFVB1PkK6cXhUy2/3alYSsR45Ktvzl92qBet9BOpk8nQOgmh0kVBUdAmzOws
	 lRfTya+p5RDxtkpMUM6n/QhS2moOq9TwQZlK90pfDKvSvz3KP7F77/uHX9cWta11d5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621994;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ysXD9rYq5eocGO4jTNc/oQsRHY2ZE09sZdSBIR20Z2c=;
	b=hTFIdzHdXc7w5Ggt1TbACFWzt53vUVH4JEuvDarX+Jlv54piGxtdpKZ2v1gOmxesxKt0
	 rqPVA42MFG36m17FB+gydJN3DYkK+Abol9qssvymojHRTIKOEI9aoWjkTejk8it7Vo6Jj
	 0Wz8Qwhtb6spNaUJaMSpWG4/43gX5pzAyXLny4CL6nEEAn+Mk9BBUykZV2MzKBBe1Thl/
	 cJz42auHN+KJJN2TomqiBACyUFcYbVd8qfXJQA3uGPExWLQjnz4OLASklYr1u2M7GwTZn
	 9LARjRX5Pm1vq8B7q7ShDsvbMUfOZqt8hpeofyNLrg0kpByU1Tm7+BiOKjFUiVv/C2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kitFPGnr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF30606A31E;
	Wed, 25 Nov 2026 15:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kitFPGnr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D297E1F000D0;
	Wed, 25 Nov 2026 15:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621994;
	bh=ysXD9rYq5eocGO4jTNc/oQsRHY2ZE09sZdSBIR20Z2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kitFPGnrfIp+KgiyZ5MD/hm9XfJDuKrpUC0qYJQAhwWHFYjXCJ9VK3fJFzse1U4PB
	 7Kl30uAeylA3J7/3BfjhUoSE0dLXf54cRrkqaqUzdFOKIcN2BJsv+u5AV1vZsjTAgp
	 lc/DE0SljHEQbq3z8bbrWPF6YobbmbwshvcOsr8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 395/990] ice: xsk: fix leaking Rx buffers in multi-buffer path
Date: Wed, 25 Nov 2026 15:29:22 +0100
Message-ID: <20261125143831.350024488@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 102631398af3c..6dfc6fd34c886 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -619,8 +619,11 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring,
 
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



