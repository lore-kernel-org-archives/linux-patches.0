Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDD039B48E;
	Thu, 15 Jan 2026 17:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497650; cv=none; b=WgpiMRNS6AFpBu2vdhA70ZiGb4wAyEe7EE56UTkI3H5f8zEjcSF2UEDAfOwsHEKZ911xGqHiiSqCLgvPtxorMiPJrDgHPkCSjjpdjsaZPG+et8oMZyi8xlW6nb2zwGS5vD6YC42FeyEiEz/kyzgpJajpu9CmQ92QeLL7ceBQl7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497650; c=relaxed/simple;
	bh=jn5k7Rm0h+wEMonkGd32FvAEaahMXY8HH3ssS3KC0E8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G508ZrShcKr3MTx6xIhkszb2nFIE7PXieMuau639zrRM/VlncyFaDfVV6ZfoUyHux0jBlqTyqw9syKlfc21OsZnsLP2n47DVvR/rv5FPb36Sslsd4AvJlqu0ZkC6OoDjUe9vuSDtiSo51/k3IFY/K9/idmEDfHnFjQAvwRrBcUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TNiT7MqF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TNiT7MqF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18C80C116D0;
	Thu, 15 Jan 2026 17:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497650;
	bh=jn5k7Rm0h+wEMonkGd32FvAEaahMXY8HH3ssS3KC0E8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TNiT7MqFDuGs3PBYVN//+AwwNOogr9mlQZkAHUlmuSmNRQZFxZBiLASiydfLaM5bm
	 JcElxA3PJNtvpifE7yaksPWN0LRxlPrgevS0ROIN3i6gnZmDir48PVpqEYlYY6EnGT
	 Lmycs7JEpnxuqm5+GMz0YNsb7JTJljRe4U58T4EQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 155/554] ASoC: Intel: catpt: Fix error path in hw_params()
Date: Thu, 15 Jan 2026 17:43:41 +0100
Message-ID: <20260115164251.875987911@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 86a5b621be658fc8fe594ca6db317d64de30cce1 ]

Do not leave any resources hanging on the DSP side if
applying user settings fails.

Fixes: 768a3a3b327d ("ASoC: Intel: catpt: Optimize applying user settings")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20251126095523.3925364-4-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/catpt/pcm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/intel/catpt/pcm.c b/sound/soc/intel/catpt/pcm.c
index ebb27daeb1c77..1e737df264d99 100644
--- a/sound/soc/intel/catpt/pcm.c
+++ b/sound/soc/intel/catpt/pcm.c
@@ -417,8 +417,10 @@ static int catpt_dai_hw_params(struct snd_pcm_substream *substream,
 		return CATPT_IPC_ERROR(ret);
 
 	ret = catpt_dai_apply_usettings(dai, stream);
-	if (ret)
+	if (ret) {
+		catpt_ipc_free_stream(cdev, stream->info.stream_hw_id);
 		return ret;
+	}
 
 	stream->allocated = true;
 	return 0;
-- 
2.51.0



