Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C78C17E90E;
	Mon, 27 May 2024 19:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837104; cv=none; b=OiahvmFMbpbkSQcoOaotWaThZW2ViCslc1udb0557EmX5QMiSrBxAE4Qm02sayMmfj3Gn/YA5n0huuB+CGGx4uUpF9eLYFQCfkdsG0cKeL4bgcRyks4P7S1B2oKgq+LB/itxb433QrUmsITbnUagdrJbboBo8O9hG/v7QEfHLXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837104; c=relaxed/simple;
	bh=bUb9c8pZgA2H9dKFuTY/6VMExjkd79uFa8ckqPf4QLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IYzDiFEo9k2IisNlaHo0tlDCzBWleuSeVkgUYoGX3fXgoUcNg/91S1X8W2K3UJDvIKDfXNPWXVvyptzfuRTDmZDUB8P+jv2+DyYlVh1Z0QA01Mhb/ELK4lfrscHhl8gFJGbpLwbWF+vqlmntOdM3UQOrLVQm/95ZR4HoprhqoIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yBPE8Jy2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yBPE8Jy2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280E2C2BBFC;
	Mon, 27 May 2024 19:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837104;
	bh=bUb9c8pZgA2H9dKFuTY/6VMExjkd79uFa8ckqPf4QLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yBPE8Jy2j2ddTxBngn3UBLDGQvmsOwe/OfdrRMIWh+sBtVWlils6t7FDh1Z0Jq+8F
	 lI6tAY0VP7PYQY8qCqoaHdXcvjRfIyfJnoxm9pqyXDFGsByarH4ZWsKeVLjOHzuKR5
	 P8HIrzL/D8AWwVO5qUjclL4k/BKILLDT9DjrBHS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 310/427] ASoC: Intel: avs: Fix potential integer overflow
Date: Mon, 27 May 2024 20:55:57 +0200
Message-ID: <20240527185630.880537919@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit c7e832cabe635df47c2bf6df7801e97bf3045b1e ]

While stream_tag for CLDMA on SKL-based platforms is always 1, function
hda_cldma_setup() uses AZX_SD_CTL_STRM() macro which does:
	stream_tag << 20

what combined with stream_tag type of 'unsigned int' generates a
potential overflow issue. Update the field type to fix that.

Fixes: 45864e49a05a ("ASoC: Intel: avs: Implement CLDMA transfer")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://msgid.link/r/20240405090929.1184068-8-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/cldma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/avs/cldma.c b/sound/soc/intel/avs/cldma.c
index d7a9390b5e483..585579840b646 100644
--- a/sound/soc/intel/avs/cldma.c
+++ b/sound/soc/intel/avs/cldma.c
@@ -35,7 +35,7 @@ struct hda_cldma {
 
 	unsigned int buffer_size;
 	unsigned int num_periods;
-	unsigned int stream_tag;
+	unsigned char stream_tag;
 	void __iomem *sd_addr;
 
 	struct snd_dma_buffer dmab_data;
-- 
2.43.0



