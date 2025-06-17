Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503EE188006;
	Tue, 17 Jun 2025 16:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177987; cv=none; b=gxEfooXsD7Yvsu7JTZ3haynpltRgFP4z/6eX9/azK0UmZIL9AbeL7waEYW2QKC2e6tWLioHHP2z5Jx9MNcYm2PZpvhK5TphJnN3vuIAfxingTIIGs4ebzesFqfM0wV9go0z9Phtg02GY4kA62KzTLPXhtb5x1g7dRfP2owCTRGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177987; c=relaxed/simple;
	bh=+hca7Cbi6Sbv9nHeLCZTtP6ZHDZHeRFoNAFsf+YKHRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dpWmxKcED69sZCfUS2P3Tr00V8Hk1z7h3N4oLZyejydzJwFmZr/MGiunZj0KNzbVc8BauwvVoqmYJpPtacM2fgZEzLhUYt7sWL8lTOvUOrnh7aUkx1XSn577znWdbxcSHYKJLYGHmrX7HEaA7x/pHMy3N8YF32b4LNw6eouqhhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dbqeeN5p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dbqeeN5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45C1C4CEE3;
	Tue, 17 Jun 2025 16:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177987;
	bh=+hca7Cbi6Sbv9nHeLCZTtP6ZHDZHeRFoNAFsf+YKHRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dbqeeN5p0rBgV2uaertH0Ecu5Ia18KQwmPSvoAkGoilIzF2g5mmLqy4cV4rDnbnPn
	 ALCG/96euVSUDjNJ1HcppjxcfpBBeElq5xFUsb7nFlVDYkIj0jdT2BDfbIJFHGSg9u
	 jQRtMQ1d7LbtqozWIqbDCSpg51O7OHotfOws7SC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Connolly <caleb.connolly@linaro.org>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 428/512] ath10k: snoc: fix unbalanced IRQ enable in crash recovery
Date: Tue, 17 Jun 2025 17:26:34 +0200
Message-ID: <20250617152436.909693050@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Caleb Connolly <caleb.connolly@linaro.org>

[ Upstream commit 1650d32b92b01db03a1a95d69ee74fcbc34d4b00 ]

In ath10k_snoc_hif_stop() we skip disabling the IRQs in the crash
recovery flow, but we still unconditionally call enable again in
ath10k_snoc_hif_start().

We can't check the ATH10K_FLAG_CRASH_FLUSH bit since it is cleared
before hif_start() is called, so instead check the
ATH10K_SNOC_FLAG_RECOVERY flag and skip enabling the IRQs during crash
recovery.

This fixes unbalanced IRQ enable splats that happen after recovering from
a crash.

Fixes: 0e622f67e041 ("ath10k: add support for WCN3990 firmware crash recovery")
Signed-off-by: Caleb Connolly <caleb.connolly@linaro.org>
Tested-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Link: https://patch.msgid.link/20250318205043.1043148-1-caleb.connolly@linaro.org
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 0fe47d51013c7..59f7ccb33fde3 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -937,7 +937,9 @@ static int ath10k_snoc_hif_start(struct ath10k *ar)
 
 	dev_set_threaded(ar->napi_dev, true);
 	ath10k_core_napi_enable(ar);
-	ath10k_snoc_irq_enable(ar);
+	/* IRQs are left enabled when we restart due to a firmware crash */
+	if (!test_bit(ATH10K_SNOC_FLAG_RECOVERY, &ar_snoc->flags))
+		ath10k_snoc_irq_enable(ar);
 	ath10k_snoc_rx_post(ar);
 
 	clear_bit(ATH10K_SNOC_FLAG_RECOVERY, &ar_snoc->flags);
-- 
2.39.5



