Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8542D198A35;
	Thu,  6 Jun 2024 14:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683389; cv=none; b=Gx7GqKKgrmChnYu4hnPRFaCOuSGew6FU6Ig9E7CIupYhD0k6MiBuxgyi3fW6ybmhFkYbAKditDbkOblqF4yDoBL6uwlQSDV9FGWEANfmLKnwU8nwS9+ieD6TbjXz53Mf0/KJK9VuEb6ZO/RqS8O+TcHNoZ+Afxm6l82EUiUlD3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683389; c=relaxed/simple;
	bh=SrXmUC9Yx8JOFOVg2iFqhQmr1J4dSvr0QXVGy1vU1WA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ia8lM5Y5xX2gdZmIR64Uspbq+s37tPo2vQI42Ac1Wq9/w1721H35ifm+fRCq2Bag0GqtfM5v9RHxMngWfLefczxToKv4dTlwkbMAZYmzSN+/Ag4J0ItkUB77SiK4AxTPp5BdA9gydql8JhHBuXLNSI50atfj66b074i134Z/9Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SWILyeSw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SWILyeSw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624CEC2BD10;
	Thu,  6 Jun 2024 14:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683389;
	bh=SrXmUC9Yx8JOFOVg2iFqhQmr1J4dSvr0QXVGy1vU1WA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SWILyeSwCFGu7BVSh3AMmoayyddXhKdVHVkcP4Rf3iZocQ+7IYqd64RACG1l+4vAY
	 JJalRxjQP74HEUo+u34W1/QOiQQUPwcGn/FuWPdupt1JZLuTSxcBGH06vM6ytTsCrM
	 P53NRp61dxYcR9tspMhtBpZHkld7K8iuVrUGRuDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 301/744] ASoC: Intel: avs: Fix potential integer overflow
Date: Thu,  6 Jun 2024 15:59:33 +0200
Message-ID: <20240606131742.036107452@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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



