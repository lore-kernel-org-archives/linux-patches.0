Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46FBE381AFB;
	Thu, 20 Aug 2026 15:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239235; cv=none; b=Zd4o5DpsgrTt6Ce4wZzaENPASM3mNQWCUhWDv2x47EcRrqy73lg+cOQeKAMZw9eFqcoW+6meURbNqoN6GJM9+1ajkYTe49yY6QozieD731Im9rkpUk9Fbe2y1iEqpkwcYb+taqGwXzmPv0J4lVh4c1DBeRr9Otz1CSFqA70bQzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239235; c=relaxed/simple;
	bh=KiLxQgmzXQwpmyLd1Ob3tqDzyLQOFCthzPkrlzgWrck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBOZm5rVhzGbuXYWTJsw+TURopucp8HVivZzre4xPAPsCRNtoaBvWLVCuCi6ZvrD4gxVwLhZu3Zz8K1fGukh1dTMMb3KErijV4qG5eV3a441Ep1bAVwB0BTs2SjlL9JNe2fgSgb1dj5zKktOZXMwN3v0RW2eHXcF35FMel4IlHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o7g2hM9x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o7g2hM9x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C791F000E9;
	Thu, 20 Aug 2026 15:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239234;
	bh=uY9zIW1NrogQ/iKGO3827a7Mws/L45v8FHfZPjB6IXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o7g2hM9x0KyzVYaVJ+0HuWpAKUBFSRaxZmDTUQtgQrGMeHgnoht3nSGDb+xonQVg2
	 6KYksZUprvSS4Nvs3Fpr+BkpHivLti5BbPiMEsAGoxEUkugYUsxuOuBlXcEXympEto
	 vmCVrcUlP5u6QoS9RanHAR7b5g9XF3dphUCbaLjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ville Saarinen <wiza@saarinenkoti.fi>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 195/217] regmap: sdw-mbq: Fix swap of timeout and retry times
Date: Thu, 20 Aug 2026 16:56:03 +0200
Message-ID: <20260820145243.580399795@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit ae7fd6ff4c6713270d2efe6db87a4a58ccb7cc61 ]

When polling Function Busy using read_poll_timeout() the total timeout
and retry delay arguments are swapped. This leads to only a single retry
being processed, it seems the existing users typically do succeed before
the first retry.

Swap the arguments over to ensure the correct polling time.

Reported-by: Ville Saarinen <wiza@saarinenkoti.fi>
Link: https://lore.kernel.org/linux-sound/ansTPGgVNoDJlA5r@opensource.cirrus.com/T/#m680731a2f307f1f5176b27ed5aa560ddc94e5d62
Fixes: 5bc493bf0c37 ("regmap: sdw-mbq: Add support for SDCA deferred controls")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260811131816.332082-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap-sdw-mbq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap-sdw-mbq.c b/drivers/base/regmap/regmap-sdw-mbq.c
index 86644bbd07100..4895f532c806f 100644
--- a/drivers/base/regmap/regmap-sdw-mbq.c
+++ b/drivers/base/regmap/regmap-sdw-mbq.c
@@ -57,7 +57,7 @@ static int regmap_sdw_mbq_poll_busy(struct sdw_slave *slave, unsigned int reg,
 	if (ctx->readable_reg(dev, reg)) {
 		ret = read_poll_timeout(sdw_read_no_pm, val,
 					val < 0 || !(val & SDCA_CTL_ENTITY_0_FUNCTION_BUSY),
-					ctx->cfg.timeout_us, ctx->cfg.retry_us,
+					ctx->cfg.retry_us, ctx->cfg.timeout_us,
 					false, slave, reg);
 		if (val < 0)
 			return val;
-- 
2.53.0



