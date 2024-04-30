Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D0112CD91;
	Tue, 30 Apr 2024 10:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474257; cv=none; b=aYuR7P0pb8Zkz0Q+tJoXGcLuJltPUz4Rs5mJY6sG//6Q5A97ehNeJp79Is9OqhbpqM3OoovJAJIbENT8OsEn8aMWW09/sc5qin/woJh4arflciTBIKtOUaqfsafTirtuqFFI/wIEYBHVoz+vBOxLdixELzHYdUZhzST5qLUKYdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474257; c=relaxed/simple;
	bh=dD474iZjxdTOnDyK+knPb4VT3LTleoi3WQ8Da94+g94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=No0K9/dcN8kFXfvNxmRZlUbuJ6nUOL9AFT9Qwbq2T/Nj54fkCH1d/Uq8qSvcWv2mFSOWlfr3j1YyO+PM+I7I5f81I0bMLi273zVQtRfXzR3lF/nG4Jdtz52so/MI2+c6rMUSQMcKljCa8gIyIltGH0sOGl0+ZhbsEGpLTFhTDNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i20nAI5h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i20nAI5h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B0FFC2BBFC;
	Tue, 30 Apr 2024 10:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474257;
	bh=dD474iZjxdTOnDyK+knPb4VT3LTleoi3WQ8Da94+g94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i20nAI5h0ur9zW4OovyO5GW18j7jMAiYk+yfnGATUfhxlI3X1rmS1TU9FFkaMS1+e
	 2GHxIHLOUrseRRlBBvZFs5IJDOZeYHbGr4F9Gt4uRiuJeicHO9iV55XhsAZcIsy0Ye
	 3Cn4xUwpi6UEqxvUgyMHZgmfy53oRv8xenTekG1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 065/228] soc: mediatek: mtk-svs: Append "-thermal" to thermal zone names
Date: Tue, 30 Apr 2024 12:37:23 +0200
Message-ID: <20240430103105.684117215@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 7ca803b489455b9242c81b4befe546ea3a692e5c ]

The thermal framework registers thermal zones as specified in DT and
including the "-thermal" suffix: append that to the driver specified
tzone_name to actually match the thermal zone name as registered by
the thermal API.

Fixes: 2bfbf82956e2 ("soc: mediatek: mtk-svs: Constify runtime-immutable members of svs_bank")
Link: https://lore.kernel.org/r/20240318113237.125802-1-angelogioacchino.delregno@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/mtk-svs.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/mediatek/mtk-svs.c b/drivers/soc/mediatek/mtk-svs.c
index c832f5c670bcf..9a91298c12539 100644
--- a/drivers/soc/mediatek/mtk-svs.c
+++ b/drivers/soc/mediatek/mtk-svs.c
@@ -1768,6 +1768,7 @@ static int svs_bank_resource_setup(struct svs_platform *svsp)
 	const struct svs_bank_pdata *bdata;
 	struct svs_bank *svsb;
 	struct dev_pm_opp *opp;
+	char tz_name_buf[20];
 	unsigned long freq;
 	int count, ret;
 	u32 idx, i;
@@ -1819,10 +1820,12 @@ static int svs_bank_resource_setup(struct svs_platform *svsp)
 		}
 
 		if (!IS_ERR_OR_NULL(bdata->tzone_name)) {
-			svsb->tzd = thermal_zone_get_zone_by_name(bdata->tzone_name);
+			snprintf(tz_name_buf, ARRAY_SIZE(tz_name_buf),
+				 "%s-thermal", bdata->tzone_name);
+			svsb->tzd = thermal_zone_get_zone_by_name(tz_name_buf);
 			if (IS_ERR(svsb->tzd)) {
 				dev_err(svsb->dev, "cannot get \"%s\" thermal zone\n",
-					bdata->tzone_name);
+					tz_name_buf);
 				return PTR_ERR(svsb->tzd);
 			}
 		}
-- 
2.43.0



