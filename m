Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8602F260C;
	Thu, 28 May 2026 20:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998607; cv=none; b=ezcK9sSQ+eruw2+thU3q9nXdrJfzsOpaClxUw4/7ku3EgR4wt2CJfiSMccd1EsLJfSpm42qTCCViklPS852lIen2xnb21zmP9feTQa8hFxkPpj+JJu4R4Wsnjh64zBDrNMFmIyC67p/ekBCQKhh14VXj5V+kiyZO4h5lji0JCHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998607; c=relaxed/simple;
	bh=gfOV+8asKiqKbbdjGvoTAvx/lB7TSnbdZNtH2eyCg68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qNX5TROKw22Yp4YtuGFaBeRfp5Dl1e0OMllwP8SC0YsQuunR0kGG9TxHU/eaoNWDGxxj1dzx1j4soVL56w23AsSLa5Ndr4V2XxJc59I9hUc5/7LpNcy0DDJkTIlWlxmbvuqpnSNX5UCAi2wWmvSuOXOguIxPsw0omDqScfh6wUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UN5NmGQc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UN5NmGQc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3ECD1F000E9;
	Thu, 28 May 2026 20:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998606;
	bh=3E+K9AoPikFUyvwJPIg2ZP9HhDd6poGUR7N5jJNntYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UN5NmGQc9obMMl3Ebw/idRnEJStUOFSsnu/yy5N0Kl1HjO9OF9HLH6RuTrwucED9G
	 HUZvx1LFOpZ/aTSEZvGlrz27O7nqvV1zxLdg156pQAcCLROtRLBn0c6TKJI4N323Zu
	 yHwEMkaawLJojpyvrHU4BtoZLrDjE36AYQWlu6YQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mac Chiang <mac.chiang@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 232/461] ASoC: sdw_utils: Add quirk to ignore RT712 CODEC_MIC
Date: Thu, 28 May 2026 21:46:01 +0200
Message-ID: <20260528194653.855315382@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mac Chiang <mac.chiang@intel.com>

[ Upstream commit 9c37daee7c17fa17e8d41089ee1f658b06cb672a ]

Some devices do not use CODEC_MIC but use the host PCH_DMIC
instead. Add a quirk to skip the CODEC_MIC DAI when it is not present
in disco table, ensuring the correct capture device is used.

If CODEC_MIC is present, it continues to be used as default.

Fixes: 9489db97f6f0 ("ASoC: sdw_utils: add SmartMic DAI for RT712 VB")
Signed-off-by: Mac Chiang <mac.chiang@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20260508093224.1246282-2-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdw_utils/soc_sdw_utils.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/sdw_utils/soc_sdw_utils.c b/sound/soc/sdw_utils/soc_sdw_utils.c
index 0e67d9f34cba3..827243d09f008 100644
--- a/sound/soc/sdw_utils/soc_sdw_utils.c
+++ b/sound/soc/sdw_utils/soc_sdw_utils.c
@@ -189,6 +189,8 @@ struct asoc_sdw_codec_info codec_info_list[] = {
 				.dai_type = SOC_SDW_DAI_TYPE_MIC,
 				.dailink = {SOC_SDW_UNUSED_DAI_ID, SOC_SDW_DMIC_DAI_ID},
 				.rtd_init = asoc_sdw_rt_dmic_rtd_init,
+				.quirk = SOC_SDW_CODEC_MIC,
+				.quirk_exclude = true,
 			},
 		},
 		.dai_num = 3,
-- 
2.53.0



