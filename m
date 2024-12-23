Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7228827;
	Mon, 23 Dec 2024 16:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970669; cv=none; b=YOPsd7KSmvS1IaZIQ6f+A+Ft7WvTife99FiHVRKmykl6uco1FuBjBbjtnwxtktRPQvzjqtEIcdWJSE5Mu1PI9NmU9TdZzV6+bUi/mzPcEvLqHbcBzfFP4ycSOnCH+BjEglzrr0qnJcZtbQBoZRSRXeoi00JgKyKB7lS4+C1J160=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970669; c=relaxed/simple;
	bh=fSx7AfLy4R3jM5HOHi5jHv6CsP9BIhLdhfdCq3urmWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=it9SrNvMiR8eHHj/11VBCSMLE3kPtcGtvTBEe9mlLTQt/6Uew/lBL/cKjZ2mkZrISM/WsYliU6o7D994wtbR2m+r6wRPjJN586BR6/OxmjkAUVTA3w6SuG6snAy5kEqgCfpKkHCw93EskGyjfLi1QpFh5G0yWB9lZsYNSv005Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dEM0MYQ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dEM0MYQ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3AAC4CED3;
	Mon, 23 Dec 2024 16:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970669;
	bh=fSx7AfLy4R3jM5HOHi5jHv6CsP9BIhLdhfdCq3urmWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dEM0MYQ3PP0cjqyzRMXWXPmFZopM6xwimumd4ILAesqXiOs/e/nRlQFpv7Oh0Z1Bk
	 pLZGsQUjtWy8vK3G93vZmRYex6Yw26Aue2zWnsZYOwghsiKCq2LPyJ54JJI8yDMqOk
	 ZM5hlA37Kg6zWKZDygAdcWh7JostBzRfab3cugKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 06/83] ASoC: Intel: sof_sdw: fix jack detection on ADL-N variant RVP
Date: Mon, 23 Dec 2024 16:58:45 +0100
Message-ID: <20241223155353.887403385@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d03de37e3578..cf501baf6f14 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -267,6 +267,15 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
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



