Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A505F143C5F;
	Thu, 13 Jun 2024 11:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279717; cv=none; b=FzUrQJN8WdG+MEbiCsEpFMP0QDQ3ONlXY/TaLvOwXq/Q6ZpD0BU54DjvXzj96SIt37jbW0mwbgBrqT3u2U5fB4dQe0x9+1lGLhVGEgfsM5BIc7y6VpmfcP3gWrYaZ0uL8ubR1baNzH3iw7HP9zf/xdhHA/uz1Hru5Bbj2VRzX/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279717; c=relaxed/simple;
	bh=Z0wx7cHZafc9InvVIAl8Tm+D2GAfbOqt5HtgSWT7xtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rmrIDpp5HXmbUYBlrVfdgQAxdAZ/ZkNmhmTo4Q7/PGsFS7AnhRDFUlZBJ/kkap/VdMn0mlFXc3E+BcBHkMLgNYbzRef84yuHhu4GVPzgvyz5yUnKzi1+CP/EEtxrjtb3cEAGWigovHVI+1ZMYdmbPksuWZdRDaigBNWJ8Wo+cPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tHFLw938; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tHFLw938"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20237C2BBFC;
	Thu, 13 Jun 2024 11:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279717;
	bh=Z0wx7cHZafc9InvVIAl8Tm+D2GAfbOqt5HtgSWT7xtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tHFLw938vUgaEv7fjX93NNgpVLoNHnl83yk15rgGJZxY4JyvliviQysHmZ4rvko+U
	 rSilvQsWO7UCHzFlwYBhFus5THWpNOkaHr7IivDvN5iG8yz+eOPqGEON1AMrazmcqD
	 J339kpCe2K8cQ6qqJx7oEiUp3/js0GYt9eoqfBeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 013/202] ASoC: da7219-aad: fix usage of device_get_named_child_node()
Date: Thu, 13 Jun 2024 13:31:51 +0200
Message-ID: <20240613113228.274589552@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index e4e314604c0a1..06caca22a55a0 100644
--- a/sound/soc/codecs/da7219-aad.c
+++ b/sound/soc/codecs/da7219-aad.c
@@ -630,8 +630,10 @@ static struct da7219_aad_pdata *da7219_aad_fw_to_pdata(struct snd_soc_component
 		return NULL;
 
 	aad_pdata = devm_kzalloc(dev, sizeof(*aad_pdata), GFP_KERNEL);
-	if (!aad_pdata)
+	if (!aad_pdata) {
+		fwnode_handle_put(aad_np);
 		return NULL;
+	}
 
 	aad_pdata->irq = i2c->irq;
 
@@ -706,6 +708,8 @@ static struct da7219_aad_pdata *da7219_aad_fw_to_pdata(struct snd_soc_component
 	else
 		aad_pdata->adc_1bit_rpt = DA7219_AAD_ADC_1BIT_RPT_1;
 
+	fwnode_handle_put(aad_np);
+
 	return aad_pdata;
 }
 
-- 
2.43.0



