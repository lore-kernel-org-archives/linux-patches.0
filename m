Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6EE31E0E6;
	Mon, 27 Oct 2025 19:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592377; cv=none; b=uT5MVBg1eGRckL4B7hpTIU0gNGgV/ZiRSyC+MOX63w+avLDNo+gpBe/potWqOfPjXsFShb+kSCm+vxqMcfsK13iRa11z1jbnny8oZ8y5WKs4x7qaitkyUriZyahPG9NL0OfLIFpXRW1Sb8wiWWZnFTjUUbfGGC9LvnZBpV8u8S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592377; c=relaxed/simple;
	bh=pWbQGJOww4I2M4ciK4yn0111l5v2UQPvbfX0T/Z1+Qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R/rcs7fkieEvuAqm27wqtqWGtsH8h9e9sFt3EUvmQIQImR1n2qFQX4Wum5fNmHZmKDKjl+iaKQUTBQwBdQm2jo34YN0dii18xhpMp35+bRVVE3s5kqlDKdWq6YdlMt025oPONGx+1N1UYkntjdpgaMhemE7d9mFbJFLYs5ECdsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PdT/teEb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PdT/teEb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EBF1C4CEF1;
	Mon, 27 Oct 2025 19:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592376;
	bh=pWbQGJOww4I2M4ciK4yn0111l5v2UQPvbfX0T/Z1+Qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PdT/teEbZOEWE0S0NCo1b3JLTez8XRqN0iy9jxT8TTh8RQE0UALEnwkJ2JXFErzFo
	 Xo/gWRi/vc6aYslazJ3mbplvFG80BXHppzZg47zEqwFD8Bs8pFCk3Sc8WpDu9JX/8j
	 Oa5KFceUEguuJPxjyHQl96nIHCfabU7KKgqkvJMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 097/157] net: ravb: Ensure memory write completes before ringing TX doorbell
Date: Mon, 27 Oct 2025 19:35:58 +0100
Message-ID: <20251027183503.867037546@linuxfoundation.org>
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

commit 706136c5723626fcde8dd8f598a4dcd251e24927 upstream.

Add a final dma_wmb() barrier before triggering the transmit request
(TCCR_TSRQ) to ensure all descriptor and buffer writes are visible to
the DMA engine.

According to the hardware manual, a read-back operation is required
before writing to the doorbell register to guarantee completion of
previous writes. Instead of performing a dummy read, a dma_wmb() is
used to both enforce the same ordering semantics on the CPU side and
also to ensure completion of writes.

Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
Cc: stable@vger.kernel.org
Co-developed-by: Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Signed-off-by: Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Link: https://patch.msgid.link/20251017151830.171062-5-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/renesas/ravb_main.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2075,6 +2075,14 @@ static netdev_tx_t ravb_start_xmit(struc
 		dma_wmb();
 		desc->die_dt = DT_FSINGLE;
 	}
+
+	/* Before ringing the doorbell we need to make sure that the latest
+	 * writes have been committed to memory, otherwise it could delay
+	 * things until the doorbell is rang again.
+	 * This is in replacement of the read operation mentioned in the HW
+	 * manuals.
+	 */
+	dma_wmb();
 	ravb_modify(ndev, TCCR, TCCR_TSRQ0 << q, TCCR_TSRQ0 << q);
 
 	priv->cur_tx[q] += num_tx_desc;


