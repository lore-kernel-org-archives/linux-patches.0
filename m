Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C32A19AD64;
	Thu,  6 Jun 2024 14:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683340; cv=none; b=Vf2YQBNuaWDAHa7Q76hx6vfCdK/nKb7NdlKwRuPSOtSztq89feJKVQlzBEin+K1JEwTqvJoVJGLp+9E9+vTXtt4scrAFGRHoiAKCamgbQ/hmKhiX6ULWARd70vaJE7ljXVLG4cGOo4yKvI6aUvkDRtImlqySsxIRS8Gtiwq1gmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683340; c=relaxed/simple;
	bh=mBrN89M04+PKYScXzOnl/k2eBi14z6Z0i/qS5dGt1mw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lPZWBK5Xl60jeO4b7cD0EXYO5VNpKU/G12CFpX+kW/eLUks8ySDccG1QRvx8lLF0X93ZUKkvo+YE/W2VyqUQdyW4LqVU28kz/qdgLPzxzcxc5D+dBUaiYUicKfBYYYIV9pFVAG6PfvuJLarV0hsCIlAPsNAaR6iAYUASBG911fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1xFeLSRf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1xFeLSRf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02CCC32782;
	Thu,  6 Jun 2024 14:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683339;
	bh=mBrN89M04+PKYScXzOnl/k2eBi14z6Z0i/qS5dGt1mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1xFeLSRfJzI/zMpIJONf+D8qoo+UkE0d19mgupWJcSr0p0LlBjtxFKdTTjD9M7LJ9
	 hBidIEX7LOliTFwKwQVrORNbQte+HZfLBH2miCB6XiCZ3IDpCSp0VhqKZRUkufv/KP
	 Zej31WvCTzuh2xWJjPO+Gh+LIvXAv69H4y7yckF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 208/473] ASoC: Intel: avs: Fix potential integer overflow
Date: Thu,  6 Jun 2024 16:02:17 +0200
Message-ID: <20240606131706.803369046@linuxfoundation.org>
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



