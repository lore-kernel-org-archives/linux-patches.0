Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E46188006;
	Mon, 23 Dec 2024 16:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970269; cv=none; b=NDF8vkML5a66f4z4j0p4FXyY3l23shbm6Ms5lm+StErz2Gnok2+Z8ecfEP2XGKslWv8bpA5qznPeUsuzEH08LmQMhKYF9bBxzLKVjoPsmIkM16nm0DgQzDkS7e7Xuw6A/kq+MQ4y57oB4mQjwbP1Ff7uuMTo5JWupwMEelV2XO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970269; c=relaxed/simple;
	bh=/AZ+8zcmY8jnh3AedagA/FtvFKi2xgA2+QWLuhqLtD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ks1tTJAHAxUDeLbfsz8bqRS27zjwCOu4ixhNhjjqZsI97AuhxG6qUemDcR902tgNOaueAxPKz1+Y1JH4lUtUIwWjQIycfnM0YNOjk8d7y00KJ3rFpodKxfX35gEuBHouWFlANecmPs1XY1+lODlx/2kmh1rifjVqC/rySQqcGE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RN+z6d7e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RN+z6d7e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 900A0C4CED3;
	Mon, 23 Dec 2024 16:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970269;
	bh=/AZ+8zcmY8jnh3AedagA/FtvFKi2xgA2+QWLuhqLtD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RN+z6d7eJWJ+rcSDaFEs8Gq1ffvc6W5eJQbZ/32vtLOVBvcQusLl0EUnkiAnmaKgb
	 TZS2z1p9NhvUwpxbnrucHJaFijcuRvShyjIG8Z9oJmKLy1XxjXvFqw1P40XYJa9P2K
	 hUl9cgItpAV848vxaTn2uhJRqIDPVA0QjNaUyKtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/116] ASoC: Intel: sof_sdw: fix jack detection on ADL-N variant RVP
Date: Mon, 23 Dec 2024 16:57:57 +0100
Message-ID: <20241223155359.828219272@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 65c90df918205bc84f5448550cde76a54dae5f52 ]

Experimental tests show that JD2_100K is required, otherwise the jack
is detected always even with nothing plugged-in.

To avoid matching with other known quirks the SKU information is used.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://patch.msgid.link/20240624121119.91552-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 5980fce81797..dc144cd7e0e3 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -286,6 +286,15 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 					SOF_BT_OFFLOAD_SSP(2) |
 					SOF_SSP_BT_OFFLOAD_PRESENT),
 	},
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Intel Corporation"),
+			DMI_MATCH(DMI_PRODUCT_SKU, "0000000000070000"),
+		},
+		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
+					RT711_JD2_100K),
+	},
 	{
 		.callback = sof_sdw_quirk_cb,
 		.matches = {
-- 
2.39.5



