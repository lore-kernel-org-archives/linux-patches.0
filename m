Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1F531CA50;
	Mon, 27 Oct 2025 18:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591068; cv=none; b=L8Y81UTZdhQPmDIcttz67JvRKeQPHBTGkdQ4wHVonVLBtjP8imqn5rgUAhkFCKz8kueBjbBbDuaexf4Ap2YHn6BaU7/svDFjM3LiQTFaLfLXlWnHXVjq6TaMf7Zp/shMmhWUEoKDFgmV4jfFi/3KFidLrSeYt5tukJriLlIDaHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591068; c=relaxed/simple;
	bh=jrwEi71QmX4Dj/6yw2nZYHPj1AVqHKPKw3Jzs3iJUxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qqK0P9a6jkeoO6HxqosP7bNCF54VKnYm0+gNkmZ/xELQofEgm27vrdYMCnYnlJwXkAn8dgjJjNZAaGJFXYbdNbhfVsxv1FhQ2DoYfxyj57bvNlksQZJHGyCP52XgptafLB+EncjkWoyo8HEl1m2sycteU+R+etey9b7429B1ktk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BbXIQeJ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BbXIQeJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31D3C4CEF1;
	Mon, 27 Oct 2025 18:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591068;
	bh=jrwEi71QmX4Dj/6yw2nZYHPj1AVqHKPKw3Jzs3iJUxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BbXIQeJ0tjd1K74exqaRhRok4LXLWti0zuGf2Sy5h/t1XPMk1ZA0IdSRtL9DV0NvH
	 wnBEyAhQaWTG7IB9BVhRnsNG0zdJHBJwRImaWRWLyxSYKxufD1Ug1bV82K8ZDufzgE
	 PNzApqL297G+rscXl64e0eUgCe1L7j6/D6olvtMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 055/332] ASoC: Intel: bytcr_rt5640: Fix invalid quirk input mapping
Date: Mon, 27 Oct 2025 19:31:48 +0100
Message-ID: <20251027183526.071689634@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit fba404e4b4af4f4f747bb0e41e9fff7d03c7bcc0 ]

When an invalid value is passed via quirk option, currently
bytcr_rt5640 driver only shows an error message but leaves as is.
This may lead to unepxected results like OOB access.

This patch corrects the input mapping to the certain default value if
an invalid value is passed.

Fixes: 063422ca2a9d ("ASoC: Intel: bytcr_rt5640: Set card long_name based on quirks")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Message-ID: <20250902171826.27329-3-tiwai@suse.de>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_rt5640.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index b4b2781ad22e8..381b525db2b14 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -59,7 +59,8 @@ enum {
 	BYT_RT5640_OVCD_SF_1P5		= (RT5640_OVCD_SF_1P5 << 13),
 };
 
-#define BYT_RT5640_MAP(quirk)		((quirk) &  GENMASK(3, 0))
+#define BYT_RT5640_MAP_MASK		GENMASK(3, 0)
+#define BYT_RT5640_MAP(quirk)		((quirk) & BYT_RT5640_MAP_MASK)
 #define BYT_RT5640_JDSRC(quirk)		(((quirk) & GENMASK(7, 4)) >> 4)
 #define BYT_RT5640_OVCD_TH(quirk)	(((quirk) & GENMASK(12, 8)) >> 8)
 #define BYT_RT5640_OVCD_SF(quirk)	(((quirk) & GENMASK(14, 13)) >> 13)
@@ -119,7 +120,9 @@ static void log_quirks(struct device *dev)
 		dev_info(dev, "quirk IN3_MAP enabled\n");
 		break;
 	default:
-		dev_err(dev, "quirk map 0x%x is not supported, microphone input will not work\n", map);
+		dev_warn_once(dev, "quirk sets invalid input map: 0x%x, default to DMIC1_MAP\n", map);
+		byt_rt5640_quirk &= ~BYT_RT5640_MAP_MASK;
+		byt_rt5640_quirk |= BYT_RT5640_DMIC1_MAP;
 		break;
 	}
 	if (BYT_RT5640_JDSRC(byt_rt5640_quirk)) {
-- 
2.51.0



