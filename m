Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96597326D6D;
	Mon, 27 Oct 2025 19:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592371; cv=none; b=qqyDAXzpd8VqQD/+UJFI/LRuPtu5lNNFEw669GZWeymPZZH0CrZZhl5r8OKmVqNtcwwuqtHuWmd759XBj54lpzNrPqs0tmYPMFKnkNs0edxP9u6lmq/gnQ/qeduCkUk4tUAT3FrcrQ7Vg3wq4PLWtgLLtwkF0HizaMPq9lkVdcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592371; c=relaxed/simple;
	bh=YkfATgtGCwCTHmXsJ8DKQ8g7uBxnour4gzDjKHPAOag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VjLZv8P6M0yl5NtPIo9tzBM/b2woi5G6+4tKLK5SaoVrAZJ5HVS/3+dmVMvJbohHteBTwD4LHnEUdVMpQbpkAys+JZ5j4ifleX0ZckUj5ILHAZiE0x1Cs2NWe+lrtG1VqqWUbfcnfFQ8uLmNKqjKeTEp9G4dIaTXqUnTDGYNZ84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jQAfntKq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jQAfntKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28599C4CEF1;
	Mon, 27 Oct 2025 19:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592371;
	bh=YkfATgtGCwCTHmXsJ8DKQ8g7uBxnour4gzDjKHPAOag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jQAfntKqmXbVyJkEsDsbp5ikJ7IKfKGTbRJDjVmpkHzA/ISHd+nEX/pwPHKhMS3ta
	 h9/ZJ3yohr3RCJQJm/hbSb/QoRNMsC/+UEv/M2OQaTGPK6cWYdqW0hKllA8FZ7/nrk
	 x1jwV11CtDpgdRaaxM9U/2vYKX03IWPqm208cUt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 096/157] net: ravb: Enforce descriptor type ordering
Date: Mon, 27 Oct 2025 19:35:57 +0100
Message-ID: <20251027183503.842710818@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2054,13 +2054,25 @@ static netdev_tx_t ravb_start_xmit(struc
 
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


