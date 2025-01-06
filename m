Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7802A1CBA02;
	Mon,  6 Jan 2025 15:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178614; cv=none; b=XqNl2Dkv3PRK0SQieH5b1msrwAGxLlscRTL+FU1YxA5tmllU//iZVsJRXLmFtFkO9955SXepa01rD6EWUIoIGRJqY/V2lZbcSxLCWFtYjVOrIbZvWR0+dFWqIvxmYDP7GvlCyracypf7pQvM2suXDpBxU4APZ/MXGFpxjRpGBkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178614; c=relaxed/simple;
	bh=eKG4wY6OqdiFs0vHRD2k+1CjfFKlHQZv1PXSFg6XSW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBjHK6XQQOYCg2I1Ss3rD44hPzx2KPJExKGSb8ucXfW4QVuQX4eHCJ6aH4/iey/y84tOgLter5xrNRL/KEO9P24RBrgC+jOSQrZHyGTSfERzNOtXxSYuJV7I7frJou6IkeVE2teulKHhd200cP/DYoAwqzzCwUW0FUz+4ZZT5XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A9yzCAXz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A9yzCAXz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84EFC4CED2;
	Mon,  6 Jan 2025 15:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178614;
	bh=eKG4wY6OqdiFs0vHRD2k+1CjfFKlHQZv1PXSFg6XSW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A9yzCAXzxRoOworNuLkgmuBk+SHyNPvKRxVWWSNl4rIPwfzKKJ+/6P1CH9eLKVH6+
	 AmnZUdCtggU8R4qmvi9+bnuX8I0hT1YkLhVD+px+h49zzlZrQdQ+Hy9nYWXFtJFF5z
	 C1jBsxi23+wIeHGtucVIr9JzZ/l/x+H2LoLt2qtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 006/168] ASoC: Intel: sof_sdw: fix jack detection on ADL-N variant RVP
Date: Mon,  6 Jan 2025 16:15:14 +0100
Message-ID: <20250106151138.700065280@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 089b6c7994f9..cfa0c3eaffea 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -258,6 +258,15 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
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



