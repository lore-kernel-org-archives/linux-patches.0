Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46B4196D91;
	Thu,  6 Jun 2024 14:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683178; cv=none; b=SL/H09sXS7+mgiS+rw2d0Fwk/pOtGD+jHaGmKvabaj5b+pvZvaNlv8qxSJCpOeBRdCNr+5tUz3IXbhQsnFZyGGCv6yh1Ra6wfwmpACrLb2SflJTy9C4/oOPv99r8V2lzxY2BEvaGZlrbSrYQyk4XmI45t1DCMbdtpl5Uhf32m+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683178; c=relaxed/simple;
	bh=zVGT7NAsx1k2RxLjcNFv+VG0XeDVJFmJHBHkV+v5DJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t0++uqmcbiKPhjaNyD44TuGkVMAFhFSyvgUK7Oq0vk+otI6Ja7FEBRm8h8TIdt8FgL4fNYyT5uI1a4h60uoBAAf3p1YxFcmQL3K4t9h64qYqu2+M/AL2anAIfS596vdoTAeeMgu48PSrk6/wg2wsrwwyhzjzKFK5Wb/x0fdbIkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DyXt6st2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DyXt6st2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48A6C32781;
	Thu,  6 Jun 2024 14:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683178;
	bh=zVGT7NAsx1k2RxLjcNFv+VG0XeDVJFmJHBHkV+v5DJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DyXt6st2VbV9w0xJLEHeDR9Tf9T7WaeKAg9Br7mDzWRknd8UV7K6eyKxlt/ZAnOEi
	 ITyQD8OOcgE/Wo8veJGYYS8Xmga245Tz27IZqh3lljeERJQ5ey1hCrP8l0M8ucx/Br
	 +CmyssI0y5K6x4YdmokV/4lnDtN/kwkAbmN22EUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 053/473] ASoC: da7219-aad: fix usage of device_get_named_child_node()
Date: Thu,  6 Jun 2024 15:59:42 +0200
Message-ID: <20240606131701.632753998@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

[ Upstream commit e8a6a5ad73acbafd98e8fd3f0cbf6e379771bb76 ]

The documentation for device_get_named_child_node() mentions this
important point:

"
The caller is responsible for calling fwnode_handle_put() on the
returned fwnode pointer.
"

Add fwnode_handle_put() to avoid a leaked reference.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20240426153033.38500-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/da7219-aad.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/da7219-aad.c b/sound/soc/codecs/da7219-aad.c
index c8410769188a0..d613f1074524a 100644
--- a/sound/soc/codecs/da7219-aad.c
+++ b/sound/soc/codecs/da7219-aad.c
@@ -638,8 +638,10 @@ static struct da7219_aad_pdata *da7219_aad_fw_to_pdata(struct device *dev)
 		return NULL;
 
 	aad_pdata = devm_kzalloc(dev, sizeof(*aad_pdata), GFP_KERNEL);
-	if (!aad_pdata)
+	if (!aad_pdata) {
+		fwnode_handle_put(aad_np);
 		return NULL;
+	}
 
 	aad_pdata->irq = i2c->irq;
 
@@ -714,6 +716,8 @@ static struct da7219_aad_pdata *da7219_aad_fw_to_pdata(struct device *dev)
 	else
 		aad_pdata->adc_1bit_rpt = DA7219_AAD_ADC_1BIT_RPT_1;
 
+	fwnode_handle_put(aad_np);
+
 	return aad_pdata;
 }
 
-- 
2.43.0



