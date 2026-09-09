Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5A6580394;
	Wed,  9 Sep 2026 14:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963792; cv=none; b=bUDzCi+Mr9wA5YBQSSQPlX56aIBghHh99X2eCy2AuB8gghFgmsMBUaCK1wR+rD/6comwnDMoXsG7UVhFRbGgspa4djWjOWd9TelC/ItlczPUpMLu8CDcC7oUn2HjIILlRL/jVY4t48MbA/4pynsIYZKxYaUjDSGJurqSypzabLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963792; c=relaxed/simple;
	bh=Q4kN4a1AQYw/qRzyQbi/qpxGM+S65Dn3Dsau3FX1Yb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g96c/ungCayuBP+MVqaSOgr29X07PDNqR4XyQhlXDJ/FYSELU9Odt1bnZ/hS0tKLAHrIip3lvc59LSnjXURpPFDH/BXA7Y80GI/mwulKPI+/nu8+Z8C1PNhJOZP2dViJUpp7J/c3bxVU3Ch2yspSlALxl92RrgOK6ZnqFiEc+bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ly9hXi97; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ly9hXi97"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED981F00A3A;
	Wed,  9 Sep 2026 14:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963791;
	bh=tgmjyWUyqsz+Bq3IR9rdrI4/g4yZXrNDJOZNlOL1bG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ly9hXi97zy7HJj88i79yXpg1kErNw5o/CflKgAA9I+8aunwCA+GAHnxtNAVm/J3gy
	 Qzdi988QBTD3QQ3C7rMFDgIGy2Iqn/DtfXq8mI/+SWsROZV0TtABLj2D8v27U5MPpG
	 5O77c7UhrXrhH3qI/elITcyeXOSY91pkW2AGrtE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 173/583] ASoC: rt1316-sdw: sort the register default table
Date: Wed,  9 Sep 2026 15:37:38 +0200
Message-ID: <20260909134244.192152164@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit 7b48eccfbb9bf15e9b7377a5296bfd01815c62d8 upstream.

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

rt1316_reg_defaults[] is not in address order, so the binary search does
not find one of its entries.  regcache_reg_needs_sync() then cannot
compare it against its default and reports that a sync is needed, so it
is written to the device on every regcache_sync() even when it was never
touched.

Sort the table by register address.

Fixes: 2b719fd20f32 ("ASoC: rt1316: Add RT1316 SDCA vendor-specific driver")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805090240.16991-16-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/rt1316-sdw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/rt1316-sdw.c
+++ b/sound/soc/codecs/rt1316-sdw.c
@@ -60,13 +60,13 @@ static const struct reg_default rt1316_r
 	{ 0xd101, 0x00 },
 	{ 0xd102, 0x30 },
 	{ 0xd103, 0x00 },
-	{ SDW_SDCA_CTL(FUNC_NUM_SMART_AMP, RT1316_SDCA_ENT_UDMPU21, RT1316_SDCA_CTL_UDMPU_CLUSTER, 0), 0x00 },
 	{ SDW_SDCA_CTL(FUNC_NUM_SMART_AMP, RT1316_SDCA_ENT_FU21, RT1316_SDCA_CTL_FU_MUTE, CH_L), 0x01 },
 	{ SDW_SDCA_CTL(FUNC_NUM_SMART_AMP, RT1316_SDCA_ENT_FU21, RT1316_SDCA_CTL_FU_MUTE, CH_R), 0x01 },
 	{ SDW_SDCA_CTL(FUNC_NUM_SMART_AMP, RT1316_SDCA_ENT_XU24, RT1316_SDCA_CTL_BYPASS, 0), 0x01 },
 	{ SDW_SDCA_CTL(FUNC_NUM_SMART_AMP, RT1316_SDCA_ENT_PDE23, RT1316_SDCA_CTL_REQ_POWER_STATE, 0), 0x03 },
 	{ SDW_SDCA_CTL(FUNC_NUM_SMART_AMP, RT1316_SDCA_ENT_PDE22, RT1316_SDCA_CTL_REQ_POWER_STATE, 0), 0x03 },
 	{ SDW_SDCA_CTL(FUNC_NUM_SMART_AMP, RT1316_SDCA_ENT_PDE24, RT1316_SDCA_CTL_REQ_POWER_STATE, 0), 0x03 },
+	{ SDW_SDCA_CTL(FUNC_NUM_SMART_AMP, RT1316_SDCA_ENT_UDMPU21, RT1316_SDCA_CTL_UDMPU_CLUSTER, 0), 0x00 },
 };
 
 static const struct reg_sequence rt1316_blind_write[] = {


