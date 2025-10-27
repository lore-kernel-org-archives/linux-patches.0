Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A03322547;
	Mon, 27 Oct 2025 19:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593516; cv=none; b=sYcg9c0Vh2ex8iNfkLrkCpUhtsHZ0PxKm/FFbQAKIZ3w5XHnaS2wmHIFDAo0mf0CVSAZQ4YSm2TpKECl9I2hNYmhE6Y2SXJNN5gtik+qzpxMjuHHhdxQ9DNYKds3A8SnjSHgU6aNrIV9c7TM0LZ1Z0r1jYFPhyYL5a3CFocFKn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593516; c=relaxed/simple;
	bh=vHq6Bxh+CMdgk8txM8tjyzhEJWagLv9X5svXthT4pAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VIfSgEHiGvBeXBZUZtQi0HprTwuWRMwc4b2WMlzJg6NfRWEDPrz8Aswkw2hNBFLMRccU7RfzhTfZfz0I46t1u0NL5VtY3ortPxZ7OI1uLayM5C2hufddrOi77tGFXl4vHNS7tRQodm6kSoFE8QgBLXSHk3d+edwP04GSlFVlla4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QLJXyMoi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QLJXyMoi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80AC5C4CEF1;
	Mon, 27 Oct 2025 19:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593515;
	bh=vHq6Bxh+CMdgk8txM8tjyzhEJWagLv9X5svXthT4pAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QLJXyMoi3kQyj2XWA+1a1wofVIz5/Y9Nr5zH28yxslTIE0H6DdmmWFnVvQp8pvzS+
	 ddw3oShcHJZO8YspVJZZUh849iAAmnpPFmlcbG/KmhFG77Kc2fkHlkB2k1zLUjgBvK
	 FXySGbpMr39eQcL4el8eWSGmeu+UEmN40TYmMhTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haibo Chen <haibo.chen@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 117/184] spi: spi-nxp-fspi: re-config the clock rate when operation require new clock rate
Date: Mon, 27 Oct 2025 19:36:39 +0100
Message-ID: <20251027183518.092807885@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit a89103f67112453fa36c9513e951c19eed9d2d92 ]

Current operation contain the max_freq, so new coming operation may use
new clock rate, need to re-config the clock rate to match the requirement.

Fixes: 26851cf65ffc ("spi: nxp-fspi: Support per spi-mem operation frequency switches")
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Link: https://patch.msgid.link/20250922-fspi-fix-v1-1-ff4315359d31@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-nxp-fspi.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-nxp-fspi.c b/drivers/spi/spi-nxp-fspi.c
index 7cbe774f1f39b..542d6f57c1aef 100644
--- a/drivers/spi/spi-nxp-fspi.c
+++ b/drivers/spi/spi-nxp-fspi.c
@@ -402,6 +402,8 @@ struct nxp_fspi {
 #define FSPI_NEED_INIT		BIT(0)
 #define FSPI_DTR_MODE		BIT(1)
 	int flags;
+	/* save the previous operation clock rate */
+	unsigned long pre_op_rate;
 };
 
 static inline int needs_ip_only(struct nxp_fspi *f)
@@ -757,11 +759,17 @@ static void nxp_fspi_select_mem(struct nxp_fspi *f, struct spi_device *spi,
 	uint64_t size_kb;
 
 	/*
-	 * Return, if previously selected target device is same as current
-	 * requested target device. Also the DTR or STR mode do not change.
+	 * Return when following condition all meet,
+	 * 1, if previously selected target device is same as current
+	 *    requested target device.
+	 * 2, the DTR or STR mode do not change.
+	 * 3, previous operation max rate equals current one.
+	 *
+	 * For other case, need to re-config.
 	 */
 	if ((f->selected == spi_get_chipselect(spi, 0)) &&
-	    (!!(f->flags & FSPI_DTR_MODE) == op_is_dtr))
+	    (!!(f->flags & FSPI_DTR_MODE) == op_is_dtr) &&
+	    (f->pre_op_rate == op->max_freq))
 		return;
 
 	/* Reset FLSHxxCR0 registers */
@@ -807,6 +815,8 @@ static void nxp_fspi_select_mem(struct nxp_fspi *f, struct spi_device *spi,
 	if (rate > 100000000)
 		nxp_fspi_dll_calibration(f);
 
+	f->pre_op_rate = op->max_freq;
+
 	f->selected = spi_get_chipselect(spi, 0);
 }
 
-- 
2.51.0



