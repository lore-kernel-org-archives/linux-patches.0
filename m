Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D5C21B9C8;
	Mon,  2 Jun 2025 14:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873572; cv=none; b=DIQSX+3GhAQzitamRRCHtEbLy8USbEFCrTpRDew0LGWpYp29CS5A3PJVfA/qqS+abtpvQnSN3QnL4IluYbwi5L5QNtjVCxeqV8gPP2SBj796K1Bkugxn+9VgocTqj8+QSGRVFBKUbgrmA1aT1fp/y6M5rUcxaJBWZps55IQIhlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873572; c=relaxed/simple;
	bh=Qm+qjWDPs1elgpPYpdLe/l6RPdm4F492gIRp3wMeoc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BMjQSK6nrCnc1V2lyS9EfcYoTRGZqDZQ+eLhOotGfPRlbtx8cZt9b+0Ib3trb+t52Crl5DKcp9Nn6PzpsBxLQQbm0cNuJJ1kb4+/Axpkehc8wJG8cL//pwdIbI+UP9VI9URIpwCXoya7xZykmhbo3eqIcB8qgKEw2H40hOtYcjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R/rdS7FE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R/rdS7FE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990DBC4CEEB;
	Mon,  2 Jun 2025 14:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873572;
	bh=Qm+qjWDPs1elgpPYpdLe/l6RPdm4F492gIRp3wMeoc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R/rdS7FECLDgLKamIKP6nVIcnJJ3rHe/MrUJzqedcU00KQiBqMaAF7cf7NS7PvrOP
	 lJhocqSwTNm62gKl9RuE/ET9mlhk1Mvel/RcZJRyK5/jvnSW2Inu4/zU/gXY2zg79u
	 G9IfKRsCIXNN+polfvqQr39geDmkkusZtxYk5Dec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 184/444] ASoC: mediatek: mt8188: Treat DMIC_GAINx_CUR as non-volatile
Date: Mon,  2 Jun 2025 15:44:08 +0200
Message-ID: <20250602134348.360636499@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 7d87bde21c73731ddaf15e572020f80999c38ee3 ]

The DMIC_GAINx_CUR registers contain the current (as in present) gain of
each DMIC. During capture, this gain will ramp up until a target value
is reached, and therefore the register is volatile since it is updated
automatically by hardware.

However, after capture the register's value returns to the value that
was written to it. So reading these registers returns the current gain,
and writing configures the initial gain for every capture.

>From an audio configuration perspective, reading the instantaneous gain
is not really useful. Instead, reading back the initial gain that was
configured is the desired behavior. For that reason, consider the
DMIC_GAINx_CUR registers as non-volatile, so the regmap's cache can be
used to retrieve the values, rather than requiring pm runtime resuming
the device.

Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/20250225-genio700-dmic-v2-3-3076f5b50ef7@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8188/mt8188-afe-pcm.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/sound/soc/mediatek/mt8188/mt8188-afe-pcm.c b/sound/soc/mediatek/mt8188/mt8188-afe-pcm.c
index 11f30b183520f..4a304bffef8ba 100644
--- a/sound/soc/mediatek/mt8188/mt8188-afe-pcm.c
+++ b/sound/soc/mediatek/mt8188/mt8188-afe-pcm.c
@@ -2855,10 +2855,6 @@ static bool mt8188_is_volatile_reg(struct device *dev, unsigned int reg)
 	case AFE_DMIC3_SRC_DEBUG_MON0:
 	case AFE_DMIC3_UL_SRC_MON0:
 	case AFE_DMIC3_UL_SRC_MON1:
-	case DMIC_GAIN1_CUR:
-	case DMIC_GAIN2_CUR:
-	case DMIC_GAIN3_CUR:
-	case DMIC_GAIN4_CUR:
 	case ETDM_IN1_MONITOR:
 	case ETDM_IN2_MONITOR:
 	case ETDM_OUT1_MONITOR:
-- 
2.39.5



