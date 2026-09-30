Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B895208D6;
	Wed, 30 Sep 2026 16:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784531; cv=none; b=R9nePHYKQTvGL6Cm6qb2G+KCPO2iB5VqKOqBvrkOT2O5hCfgyRDq1J+VMsozF7OnvvSdyFE0fDGFYYBL/lAkwNbUbVEPT981Kkl1axP1j/I9NEBPbjieCF5nFg3XEWPF+JX9YRGga+O0raFZSLiyuCh3nlPtLVDJzkfi3z2DxHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784531; c=relaxed/simple;
	bh=1w6fMXFw3PVFMVV7bIHG1f24t8dWn39mmpLxy1nBbRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YpAW95gG0i4oJFIEj57By6Lgu3Ww8EpYzdpRD3VT9z7+//q4rC26TsVGbn4Rc9sk9KDdmw2qx7rKCcCq2GymYnElkBikUTJsHcAD1suifWeQIj60t/b5AvvkZas9B56TT80m2m0EV8RHoWA1DQAE4mlrOxfct/bwr7WiD86v3c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lUIf3ggd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lUIf3ggd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4B021F000FF;
	Wed, 30 Sep 2026 16:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784527;
	bh=lBlhyH3Gh28r6H19JY5i0vg+L9RhDlcuuptdfvDqgIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lUIf3ggdmNvxa85IN6X+22dIxeFLxQ9IhvZgQYhZjK5IFyZWAaYV7dTziLzLV/kGe
	 ixlsz3yvG3l6sRNVkKp2zTlJ12hFKrYSAmTZSn4da39Ra57ijpzX9RZG+Zy6VRCl5F
	 7vw/wMPln/ttUlV+rCKVrk2mlrGdFjfs99jDmzQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI Review <sashiko-bot@kernel.org>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 187/982] ASoC: rockchip: spdif: Restore regcache cache-only mode on sync failure
Date: Wed, 30 Sep 2026 17:15:23 +0200
Message-ID: <20260930152420.833624350@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 3546e9aa691ac981e4734fedd1646d0180784893 ]

If regcache_sync() fails during runtime resume, the driver disables the
clocks and returns an error. However, the regmap cache-only mode is left
disabled.
Restore cache-only mode in the error path so subsequent register accesses
continue to use the cache while the device is inactive.

Reported-by: Sashiko AI Review <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260522103713.6C09D1F000E9@smtp.kernel.org/
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260602101608.45137-5-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rockchip_spdif.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/rockchip/rockchip_spdif.c b/sound/soc/rockchip/rockchip_spdif.c
index 5b4f004575879..d10fbae8d473c 100644
--- a/sound/soc/rockchip/rockchip_spdif.c
+++ b/sound/soc/rockchip/rockchip_spdif.c
@@ -98,6 +98,7 @@ static int __maybe_unused rk_spdif_runtime_resume(struct device *dev)
 
 	ret = regcache_sync(spdif->regmap);
 	if (ret) {
+		regcache_cache_only(spdif->regmap, true);
 		clk_disable_unprepare(spdif->mclk);
 		clk_disable_unprepare(spdif->hclk);
 	}
-- 
2.53.0



