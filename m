Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB76A329C43;
	Mon, 27 Oct 2025 19:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593328; cv=none; b=nWH2cffYV1sb65k6dNsjx4oaAhXfuB4Z0vvqrUvH46EMe9yOimJm7vQfGi+MeQO1NjlWp3M5KRLZ70WkXXpevAuaBZQdOgXS5UrlDKlMGbUbG5ulZM/b8T1/qnKlx1cVBlcncJEzdNKbKmOvi0X2zzp+E91h+WKuwYFy5Ji0Pao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593328; c=relaxed/simple;
	bh=4cy9J1q5g8IHSoFogXYOXF8CqlbO4hzRslj73B2HHl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WUneqsCEzdx+gHqJtlk4ttVwHNrPhkjjbxs31wppkcZtGNTUi3lxQx8fzj5xOA5zjixVokF/DV561uhVDjPovwpju/VSv2X+2Bo2DOH5yhVhgQm+YJWuw9gEZO4Ms6SQ985ZTTVZ5dF5dyiwi2WOLI9mAEn9Nc6MeejdgUxYbxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bWsBTGTY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bWsBTGTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17CEC4CEF1;
	Mon, 27 Oct 2025 19:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593327;
	bh=4cy9J1q5g8IHSoFogXYOXF8CqlbO4hzRslj73B2HHl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bWsBTGTYhvMQyYTZGJnDbaNzVo/rXgRJe2WwTZJSLHomgYKl+T47HUqKLd57t7dwM
	 FpcW+bVKGFkjSJtKZ/5BtfKZYtBqCt1HgJe5Yj+lcH0ZFer+8H4EMuiyDfcVQ1dcfn
	 v8XKFKzLeNFxbyKSqg+30ry+ZA6XUhF1hCRcasdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.17 099/184] net: ravb: Enforce descriptor type ordering
Date: Mon, 27 Oct 2025 19:36:21 +0100
Message-ID: <20251027183517.578591273@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

commit 5370c31e84b0e0999c7b5ff949f4e104def35584 upstream.

Ensure the TX descriptor type fields are published in a safe order so the
DMA engine never begins processing a descriptor chain before all descriptor
fields are fully initialised.

For multi-descriptor transmits the driver writes DT_FEND into the last
descriptor and DT_FSTART into the first. The DMA engine begins processing
when it observes DT_FSTART. Move the dma_wmb() barrier so it executes
immediately after DT_FEND and immediately before writing DT_FSTART
(and before DT_FSINGLE in the single-descriptor case). This guarantees
that all prior CPU writes to the descriptor memory are visible to the
device before DT_FSTART is seen.

This avoids a situation where compiler/CPU reordering could publish
DT_FSTART ahead of DT_FEND or other descriptor fields, allowing the DMA to
start on a partially initialised chain and causing corrupted transmissions
or TX timeouts. Such a failure was observed on RZ/G2L with an RT kernel as
transmit queue timeouts and device resets.

Fixes: 2f45d1902acf ("ravb: minimize TX data copying")
Cc: stable@vger.kernel.org
Co-developed-by: Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Signed-off-by: Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Link: https://patch.msgid.link/20251017151830.171062-4-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/renesas/ravb_main.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2210,13 +2210,25 @@ static netdev_tx_t ravb_start_xmit(struc
 
 		skb_tx_timestamp(skb);
 	}
-	/* Descriptor type must be set after all the above writes */
-	dma_wmb();
+
 	if (num_tx_desc > 1) {
 		desc->die_dt = DT_FEND;
 		desc--;
+		/* When using multi-descriptors, DT_FEND needs to get written
+		 * before DT_FSTART, but the compiler may reorder the memory
+		 * writes in an attempt to optimize the code.
+		 * Use a dma_wmb() barrier to make sure DT_FEND and DT_FSTART
+		 * are written exactly in the order shown in the code.
+		 * This is particularly important for cases where the DMA engine
+		 * is already running when we are running this code. If the DMA
+		 * sees DT_FSTART without the corresponding DT_FEND it will enter
+		 * an error condition.
+		 */
+		dma_wmb();
 		desc->die_dt = DT_FSTART;
 	} else {
+		/* Descriptor type must be set after all the above writes */
+		dma_wmb();
 		desc->die_dt = DT_FSINGLE;
 	}
 	ravb_modify(ndev, TCCR, TCCR_TSRQ0 << q, TCCR_TSRQ0 << q);


