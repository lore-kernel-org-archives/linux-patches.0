Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763F221FF2B;
	Mon, 23 Jun 2025 22:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716434; cv=none; b=Mvc54VTGgUNxZXZyRvsM9hlNxPjgAAZUB4HxrlLx38rdBn/R65UluPsCipK6yoT3/QLpoBmJX3fhYsdzAbRhBexx6cMN5c57EFzHtXd/31L3qigeXbSEtccy1kzM8Jojenb7W3PARcElbRjrrqefPevffU0byK9lGcSMmqaGYM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716434; c=relaxed/simple;
	bh=W7E45Z4kxTjJcRYpjRCIDBM5C6owAPNPq4JxUTklBX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RNqfcF7QrKTguKbNCWxeIayFCTtuClNMdePGKdNV9fQoIRtsLFoqHXHpXcq/V50fhCcqklEvUesKJmaF6z2RQyUsrB8wJjyfSU+G5FxbEk9CEsd6d01WVEu7wPMqlOwsDSFCqeL8VyDlWJ8rmhmrXLx40z7axmnmc1xRfu/MXuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R3h/Rvch; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R3h/Rvch"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0048EC4CEEA;
	Mon, 23 Jun 2025 22:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716434;
	bh=W7E45Z4kxTjJcRYpjRCIDBM5C6owAPNPq4JxUTklBX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R3h/Rvchxf7bT2eUYBO+UzC6QsJeIWewQ9NObuFd8ArDGWnFaSir//2zdYHqo1wgV
	 lT3n7YXeSRs5rRiN26KmImInOO9x1bGkt/rTGRBt8ddC/BAhVgg7rU+0RumKCzmzyU
	 ndCeOjnHPrqxplcBVBNP6TvFHjaHYUGmi60ljB7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rengarajan S <rengarajan.s@microchip.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 263/290] net: microchip: lan743x: Reduce PTP timeout on HW failure
Date: Mon, 23 Jun 2025 15:08:44 +0200
Message-ID: <20250623130634.820519450@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Rengarajan S <rengarajan.s@microchip.com>

[ Upstream commit b1de3c0df7abc41dc41862c0b08386411f2799d7 ]

The PTP_CMD_CTL is a self clearing register which controls the PTP clock
values. In the current implementation driver waits for a duration of 20
sec in case of HW failure to clear the PTP_CMD_CTL register bit. This
timeout of 20 sec is very long to recognize a HW failure, as it is
typically cleared in one clock(<16ns). Hence reducing the timeout to 1 sec
would be sufficient to conclude if there is any HW failure observed. The
usleep_range will sleep somewhere between 1 msec to 20 msec for each
iteration. By setting the PTP_CMD_CTL_TIMEOUT_CNT to 50 the max timeout
is extended to 1 sec.

Signed-off-by: Rengarajan S <rengarajan.s@microchip.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240502050300.38689-1-rengarajan.s@microchip.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: e353b0854d3a ("net: lan743x: fix potential out-of-bounds write in lan743x_ptp_io_event_clock_get()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan743x_ptp.c | 2 +-
 drivers/net/ethernet/microchip/lan743x_ptp.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_ptp.c b/drivers/net/ethernet/microchip/lan743x_ptp.c
index 39e1066ecd5ff..47f2531198f62 100644
--- a/drivers/net/ethernet/microchip/lan743x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan743x_ptp.c
@@ -58,7 +58,7 @@ int lan743x_gpio_init(struct lan743x_adapter *adapter)
 static void lan743x_ptp_wait_till_cmd_done(struct lan743x_adapter *adapter,
 					   u32 bit_mask)
 {
-	int timeout = 1000;
+	int timeout = PTP_CMD_CTL_TIMEOUT_CNT;
 	u32 data = 0;
 
 	while (timeout &&
diff --git a/drivers/net/ethernet/microchip/lan743x_ptp.h b/drivers/net/ethernet/microchip/lan743x_ptp.h
index e26d4eff71336..0d29914cd4606 100644
--- a/drivers/net/ethernet/microchip/lan743x_ptp.h
+++ b/drivers/net/ethernet/microchip/lan743x_ptp.h
@@ -21,6 +21,7 @@
 #define LAN743X_PTP_N_EXTTS		4
 #define LAN743X_PTP_N_PPS		0
 #define PCI11X1X_PTP_IO_MAX_CHANNELS	8
+#define PTP_CMD_CTL_TIMEOUT_CNT		50
 
 struct lan743x_adapter;
 
-- 
2.39.5



