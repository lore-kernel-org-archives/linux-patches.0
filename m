Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114514E9C21;
	Wed, 30 Sep 2026 15:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782658; cv=none; b=nQ1f6udd62a/O1HM1WSngZNIGW8Hc3qXNzqjyFqKEDgaIMkyIyjGgk5UOgD/U44ue81nV6z/WK9yePXkm2ghtB2OBA0uSe4mDvBJJgU8IX/W1VvVEGbz9X0EbB3JcKYOhx16DoEaMq5l+icHU8zt5KwNW7ieb3RnjDjuXSYIs+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782658; c=relaxed/simple;
	bh=RJ+8DY+fFCJ0zhO2L7jzJH39l7HIWCedW3ICeHMHp/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0VoKFTSFTIGGV9Qj+LCMNXeCt8vUdD3QZzKRMjpKFVA5lMOb3HhGTfFu+lUX3gcYvFti2yoZHZZUNckFWTeIJXWNUUGiFnKgy72Ncj1I5S9EDsdCurDMHdyNAnRn0qEW43VvH74RJXTyvft/iTCDFuNIKk7C3g/XJqu2p3oKo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Izhvzgix; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Izhvzgix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8AE61F0089D;
	Wed, 30 Sep 2026 15:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782652;
	bh=jDIzZQq6CEMQ2qv1/1iqGBHHRwWestH+y/d7SlGvNfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Izhvzgix65jiOphzLW+v3UYvrZ5FDetlVn2x7FDL2Vbmb1COLnqBGH7zTV4E+V3e5
	 sxWzSF2CHvJOCTquw9QEAUw5j1t+Xp+EN++DuKPs9EmrPhu7AZLblVSpFft1d0NadC
	 29rsEideQ0j+Jyct4GN93MWNtDagn6Sn9CpOXXjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI Review <sashiko-bot@kernel.org>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 123/595] ASoC: rockchip: spdif: Restore regcache cache-only mode on sync failure
Date: Wed, 30 Sep 2026 17:20:16 +0200
Message-ID: <20260930152350.385438898@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ccddcd9926af8..310e5ec7e6741 100644
--- a/sound/soc/rockchip/rockchip_spdif.c
+++ b/sound/soc/rockchip/rockchip_spdif.c
@@ -96,6 +96,7 @@ static int __maybe_unused rk_spdif_runtime_resume(struct device *dev)
 
 	ret = regcache_sync(spdif->regmap);
 	if (ret) {
+		regcache_cache_only(spdif->regmap, true);
 		clk_disable_unprepare(spdif->mclk);
 		clk_disable_unprepare(spdif->hclk);
 	}
-- 
2.53.0



