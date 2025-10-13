Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B7830ACE5;
	Mon, 13 Oct 2025 14:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367181; cv=none; b=UtR/6ADQ1AjTxFzhnHPDPK0ZjJCVJSSd+BAlD+qBtkfssg14TIUXxRYQvN+bC5xfrAXUYOfwwy+j5zVWTPbNaH1j1HSW7Xyc3oPoMMH0y0HHriBiuPn7oIXS8EAlL6fPaod4ybrTPC2J9SU3RqDtqJIo4bzsF6Ba506QeaCpZkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367181; c=relaxed/simple;
	bh=8LZRH4oRiJliP69/F9FcQ/m94NYTJBMEmRHnXNyFWcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ez6Om3CRPAqsG2t7TqOzZZXaMRxqyiUH085nPEHyNDfkscfWgWtkLAm6P7GpTIjkg+cKkL3Sr6PzXT18/XnReVLdm6cxDe/NIXj0LosrRE12NACZ4xDiC47KJKYucEn6tu6t8L36g1yTf2GWdm3+dZ4BCH4IyxIsO0++dMwhINg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BdrmT8QT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BdrmT8QT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C98C4CEFE;
	Mon, 13 Oct 2025 14:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367181;
	bh=8LZRH4oRiJliP69/F9FcQ/m94NYTJBMEmRHnXNyFWcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BdrmT8QTG2Om8t9pwo/+wTP49COqCYMOwzQhH2Ulfx5dVK3/C1OwNBmtfXHTlvMDl
	 043HtZNCGyy27BE4QrbWKC4Om234TcO8p94/ceCJt2yXheUDxnTLIePWkzzqwpm2gy
	 BBtUpxl//YTIa5J1GSrTaKNuzKYKvPcHII0TmCas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 119/196] ASoC: Intel: bytcr_rt5640: Fix invalid quirk input mapping
Date: Mon, 13 Oct 2025 16:44:52 +0200
Message-ID: <20251013144319.002173094@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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
index b00a9fdd7a9cc..6af53a766c27d 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -68,7 +68,8 @@ enum {
 	BYT_RT5640_OVCD_SF_1P5		= (RT5640_OVCD_SF_1P5 << 13),
 };
 
-#define BYT_RT5640_MAP(quirk)		((quirk) &  GENMASK(3, 0))
+#define BYT_RT5640_MAP_MASK		GENMASK(3, 0)
+#define BYT_RT5640_MAP(quirk)		((quirk) & BYT_RT5640_MAP_MASK)
 #define BYT_RT5640_JDSRC(quirk)		(((quirk) & GENMASK(7, 4)) >> 4)
 #define BYT_RT5640_OVCD_TH(quirk)	(((quirk) & GENMASK(12, 8)) >> 8)
 #define BYT_RT5640_OVCD_SF(quirk)	(((quirk) & GENMASK(14, 13)) >> 13)
@@ -140,7 +141,9 @@ static void log_quirks(struct device *dev)
 		dev_info(dev, "quirk NO_INTERNAL_MIC_MAP enabled\n");
 		break;
 	default:
-		dev_err(dev, "quirk map 0x%x is not supported, microphone input will not work\n", map);
+		dev_warn_once(dev, "quirk sets invalid input map: 0x%x, default to DMIC1_MAP\n", map);
+		byt_rt5640_quirk &= ~BYT_RT5640_MAP_MASK;
+		byt_rt5640_quirk |= BYT_RT5640_DMIC1_MAP;
 		break;
 	}
 	if (byt_rt5640_quirk & BYT_RT5640_HSMIC2_ON_IN1)
-- 
2.51.0



