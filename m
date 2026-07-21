Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CDE43F4B8;
	Tue, 21 Jul 2026 21:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671200; cv=none; b=AyT9EqdPUgTosgjYk0XILTcCiCzJn+HDs+vBZQIoFCEDRGC3ELF96ufreguS2/YgGOdYSEureaqQdMpipabk7ghai+XFnnMzbEEHrZDhT+b216SP0fLa+CztBKZUj2/GO5WD+fxsUQC1YJK2Zrcsl12LtCt3bmUyUPrqbWK8cxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671200; c=relaxed/simple;
	bh=cN9+KaLudCbHvzxCcoogjzwFddzIfLPpJHo6chwXvxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lq4J2fP6U24mahQM9wTzkdM9x+9fqf1R8ImSoFR7luL/XKDq66/P47bGZ960sonWzwnqmAISoBQEacE7wU3hEvOiwfRuRjvMsJkfg5YN5OHsZja1OH9ltnJaRvvLYPQdUGlx+BP3FRQ+n+IG9YlwKvKkybxOAYoEU57lhe8hNJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Br7Be5nD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Br7Be5nD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626FC1F000E9;
	Tue, 21 Jul 2026 21:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671198;
	bh=BRo2erlaiXkBSFRYOb/nVYrTldg0/b6unKtAkgwiIfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Br7Be5nDXvwblX9vxY9ubFi7iAS71adMSNyUBXwCjgDENLoqkwn+LJC2nUCJsgma3
	 Wj+y4Txrhe/c0+brs3i60hqnAuWc6zP/Cs+kSumU59ezGMnkj70NKTY4UXHNYzyD1+
	 bQlEo9ZaSmfwNnLV1i1UBWA8YC17sqE9Vr/c2Tvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liviu Stan <liviu.stan@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 155/843] iio: temperature: ltc2983: Fix n_wires default bypassing rotation check
Date: Tue, 21 Jul 2026 17:16:30 +0200
Message-ID: <20260721152409.500173368@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/temperature/ltc2983.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/temperature/ltc2983.c b/drivers/iio/temperature/ltc2983.c
index ecc8b2e129b896..c6748cfc5d5ce2 100644
--- a/drivers/iio/temperature/ltc2983.c
+++ b/drivers/iio/temperature/ltc2983.c
@@ -697,7 +697,7 @@ static struct ltc2983_sensor *ltc2983_rtd_new(const struct device_node *child,
 	int ret = 0;
 	struct device *dev = &st->spi->dev;
 	struct device_node *phandle;
-	u32 excitation_current = 0, n_wires = 0;
+	u32 excitation_current = 0, n_wires = 2;
 
 	rtd = devm_kzalloc(dev, sizeof(*rtd), GFP_KERNEL);
 	if (!rtd)
-- 
2.53.0



