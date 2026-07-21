Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3697A44AB9D;
	Tue, 21 Jul 2026 21:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668611; cv=none; b=ozEy/nGhNKny68tab9AbU72axRRhuSG22JluQiLeZfqMzll7YwSg923FXeyWht052YNs4j6EFUm1GFx8xxBz4+h386b2q/n8hzRXT3RZRQscQt4kjO3XHba5X4dNdEaPZhgyIJLEFeFzrYB39OXpxhYuX8RNbFlKgjSv9N8reQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668611; c=relaxed/simple;
	bh=AdobWIyyyCKkc5Ck1sYudx9m7kCQBcs/gbHnQc4c6rI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JL3UJU/keyOTTwXYjc+07hgY/dATuNcan5wGCe+Ud0+4NDSinoH2HMYKH495CceWg4uCdDMhAnc6bcalfQzHXYhSP1td7uX9AySjcak7YXdiOmLBH55EcGD3hQqVdSO0/QQ9ypwZKbcfgY6vNGfXWNLKHBlAXDdyJwYCGGignek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HFBeKJad; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HFBeKJad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9962D1F000E9;
	Tue, 21 Jul 2026 21:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668610;
	bh=BRtkSND/PwpcOn8T0As0Ra3EVv5aSPtvUEbJatEwLDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HFBeKJadh1V4/SZo9RSHaWGEvluhZy491Pojcb+gRyd6vH7GvAKUDA2PXSneqMa8k
	 Rm3+rmoVZ3E6abB9W7hNFRZQmSv7QA+mnudCzQNOPces4P+HgYb9aiJvRoT79I2vMG
	 mFshqO0lKX3gVcQvDdBcwW1yw0uweW67rktls87E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liviu Stan <liviu.stan@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0197/1067] iio: temperature: ltc2983: Fix n_wires default bypassing rotation check
Date: Tue, 21 Jul 2026 17:13:18 +0200
Message-ID: <20260721152429.000358729@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liviu Stan <liviu.stan@analog.com>

[ Upstream commit 434c150752675f44dc52c384a7fa22e5176bc35a ]

When adi,number-of-wires is absent, n_wires is left at 0. The binding
documents a default of 2 wires, matching the hardware default. However
the current-rotate validation checks n_wires == 2 || n_wires == 3, so
with n_wires = 0 the guard is bypassed and adi,current-rotate is accepted
for a 2-wire RTD.

Initialize n_wires = 2 to match the binding default and ensure the
rotation check fires correctly when the property is absent.

Fixes: f110f3188e56 ("iio: temperature: Add support for LTC2983")
Signed-off-by: Liviu Stan <liviu.stan@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Liviu Stan <liviu.stan@analog.com>

[ Liviu Stan: resolve conflict - keep fwnode_handle *ref declaration
  which was removed upstream by a later refactor not in 6.1.y ]

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/temperature/ltc2983.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/temperature/ltc2983.c b/drivers/iio/temperature/ltc2983.c
index 8d18823be40f41..9d3fb988cd061a 100644
--- a/drivers/iio/temperature/ltc2983.c
+++ b/drivers/iio/temperature/ltc2983.c
@@ -706,7 +706,7 @@ ltc2983_rtd_new(const struct fwnode_handle *child, struct ltc2983_data *st,
 	int ret = 0;
 	struct device *dev = &st->spi->dev;
 	struct fwnode_handle *ref;
-	u32 excitation_current = 0, n_wires = 0;
+	u32 excitation_current = 0, n_wires = 2;
 
 	rtd = devm_kzalloc(dev, sizeof(*rtd), GFP_KERNEL);
 	if (!rtd)
-- 
2.53.0



