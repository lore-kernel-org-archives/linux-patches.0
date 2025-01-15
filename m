Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C3F1E98E4;
	Wed, 15 Jan 2025 10:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938620; cv=none; b=OyOJzCi9Y3TZG7NZpUD2WKdah6N/Fq23V+nxYPuBcKt09WekyXveg2AIiUdXuCMohdmH5x00J723Fk+jDmsK2S3xgvh0DXgyMv/bQnhkRi6549mj4B1UxPouNojq0JToE0zMQjmEhsn0Irr2EtU05GC65jclTSNBq4EZU0ACA10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938620; c=relaxed/simple;
	bh=ZAJiKgJ3xZc40tE7gDvTkPo4UyivKHnlcDrQcXFs0ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iHvBFW5MY6Sxn2mjglYIa/TLbF7LzuwMrg7mdrVS1jjPrsrVqZmt5L7/S0DXPiZbC+ZpJIAnj35jbRoYE6vGeJNPi3BxTTGCUpuli13aBAigd2LGpQ8Hsh9p9bxg5T5Bqm9pizZRIZnSkG2O1kqkH+0L9UQ/lOjluNCEkLJz+2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NuoVf5Kj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NuoVf5Kj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36AE0C4CEDF;
	Wed, 15 Jan 2025 10:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938619;
	bh=ZAJiKgJ3xZc40tE7gDvTkPo4UyivKHnlcDrQcXFs0ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NuoVf5KjxGg76dLO08qV0dkV0/ZMrqgvylNAUerfiXMLnTdaZpwSgGU6k6Cr2kAuF
	 R271ogcXuERjZyy/1iu8sTO4XoCztIqF4GrJNdPaErWUdw76ZQPswiXopvGqKWeJpU
	 +rEHtPszcLzctMgkLeGI6aMHBMnsEkaQ67dTzhwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuming Fan <shumingf@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/129] ASoC: rt722: add delay time to wait for the calibration procedure
Date: Wed, 15 Jan 2025 11:36:30 +0100
Message-ID: <20250115103554.980007723@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuming Fan <shumingf@realtek.com>

[ Upstream commit c9e3ebdc52ebe028f238c9df5162ae92483bedd5 ]

The calibration procedure needs some time to finish.
This patch adds the delay time to ensure the calibration procedure is completed correctly.

Signed-off-by: Shuming Fan <shumingf@realtek.com>
Link: https://patch.msgid.link/20241218091307.96656-1-shumingf@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt722-sdca.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt722-sdca.c b/sound/soc/codecs/rt722-sdca.c
index b9b330375add..0f9f592744ad 100644
--- a/sound/soc/codecs/rt722-sdca.c
+++ b/sound/soc/codecs/rt722-sdca.c
@@ -1466,13 +1466,18 @@ static void rt722_sdca_jack_preset(struct rt722_sdca_priv *rt722)
 		0x008d);
 	/* check HP calibration FSM status */
 	for (loop_check = 0; loop_check < chk_cnt; loop_check++) {
+		usleep_range(10000, 11000);
 		ret = rt722_sdca_index_read(rt722, RT722_VENDOR_CALI,
 			RT722_DAC_DC_CALI_CTL3, &calib_status);
-		if (ret < 0 || loop_check == chk_cnt)
+		if (ret < 0)
 			dev_dbg(&rt722->slave->dev, "calibration failed!, ret=%d\n", ret);
 		if ((calib_status & 0x0040) == 0x0)
 			break;
 	}
+
+	if (loop_check == chk_cnt)
+		dev_dbg(&rt722->slave->dev, "%s, calibration time-out!\n", __func__);
+
 	/* Set ADC09 power entity floating control */
 	rt722_sdca_index_write(rt722, RT722_VENDOR_HDA_CTL, RT722_ADC0A_08_PDE_FLOAT_CTL,
 		0x2a12);
-- 
2.39.5



