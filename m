Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1083BFE59;
	Tue, 17 Mar 2026 16:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766548; cv=none; b=B4YCr6OTmIuCh8SBqIS1vYXHpWvS94nyzxv/hwub688EulVOJi5pTQ3/EQq61bftK5SihYWSBowQu0qYneyvFeZlxliimbjnx4yDvqbtKvgHSOO05zNeFSmvk+FWaE4yLVLBvbBQ59IwEJakuP1IJV/2x/Cd+E43e4pL8r/KCXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766548; c=relaxed/simple;
	bh=bbX8JaQOmW+1rBUbDhyjkV4f82ilhULX6cP/k3rCq8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=guqtg8yvgaK18yajA01lQhE4XosJi5JbSW2RlyLil9k8jTOaSUHTIdiZkL4OYKUFyxLJNOYGT6w1t423Qq6t5x/jpwvWDyO3STiFR5K+B3tRQOwDvM+Mm47WJZTxdNtG6WgUwwhxF/dfmxu9+V7z0RrACNy9mOQ8+HjMB2dVFlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wxVGqwg6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wxVGqwg6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A74C4CEF7;
	Tue, 17 Mar 2026 16:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766547;
	bh=bbX8JaQOmW+1rBUbDhyjkV4f82ilhULX6cP/k3rCq8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wxVGqwg6Zfl3Su4/lzAzsqN5jkllRgWT6aI0FXyPKmVYe8jHiAuZ4aTpz7D9H1B3F
	 VwCRF796CboD1Bo0ofi1nJL2w95Cyzo/Sl5558saMih5TdBP5yl6lR2f20BWf8W+VR
	 3efuoE3NwwvNDU+GddIbRVGEV18gpeRkPjM76z3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Zenghui Yu <zenghui.yu@linux.dev>
Subject: [PATCH 6.19 237/378] irqchip/gic-v3-its: Limit number of per-device MSIs to the range the ITS supports
Date: Tue, 17 Mar 2026 17:33:14 +0100
Message-ID: <20260317163015.733822836@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit ce9e40a9a5e5cff0b1b0d2fa582b3d71a8ce68e8 upstream.

The ITS driver blindly assumes that EventIDs are in abundant supply, to the
point where it never checks how many the hardware actually supports.

It turns out that some pretty esoteric integrations make it so that only a
few bits are available, all the way down to a single bit.

Enforce the advertised limitation at the point of allocating the device
structure, and hope that the endpoint driver can deal with such limitation.

Fixes: 84a6a2e7fc18d ("irqchip: GICv3: ITS: device allocation and configuration")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Zenghui Yu <zenghui.yu@linux.dev>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260206154816.3582887-1-maz@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-gic-v3-its.c   |    4 ++++
 include/linux/irqchip/arm-gic-v3.h |    1 +
 2 files changed, 5 insertions(+)

--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3475,6 +3475,7 @@ static struct its_device *its_create_dev
 	int lpi_base;
 	int nr_lpis;
 	int nr_ites;
+	int id_bits;
 	int sz;
 
 	if (!its_alloc_device_table(its, dev_id))
@@ -3486,7 +3487,10 @@ static struct its_device *its_create_dev
 	/*
 	 * Even if the device wants a single LPI, the ITT must be
 	 * sized as a power of two (and you need at least one bit...).
+	 * Also honor the ITS's own EID limit.
 	 */
+	id_bits = FIELD_GET(GITS_TYPER_IDBITS, its->typer) + 1;
+	nvecs = min_t(unsigned int, nvecs, BIT(id_bits));
 	nr_ites = max(2, nvecs);
 	sz = nr_ites * (FIELD_GET(GITS_TYPER_ITT_ENTRY_SIZE, its->typer) + 1);
 	sz = max(sz, ITS_ITT_ALIGN);
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -394,6 +394,7 @@
 #define GITS_TYPER_VLPIS		(1UL << 1)
 #define GITS_TYPER_ITT_ENTRY_SIZE_SHIFT	4
 #define GITS_TYPER_ITT_ENTRY_SIZE	GENMASK_ULL(7, 4)
+#define GITS_TYPER_IDBITS		GENMASK_ULL(12, 8)
 #define GITS_TYPER_IDBITS_SHIFT		8
 #define GITS_TYPER_DEVBITS_SHIFT	13
 #define GITS_TYPER_DEVBITS		GENMASK_ULL(17, 13)


