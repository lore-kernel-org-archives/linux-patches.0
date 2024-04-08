Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803837CF29;
	Mon,  8 Apr 2024 13:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583305; cv=none; b=P6dxx3QN8NER2GfmYSgBNV9DeVKWI05NYE8LToCS7Qo9CXoLZMTlAikZgFqA5tgbRSooE/lmk8Owi8L+LEDVlTxWDBkNqZzrLhJPMT2ob54YO+Y3UYjjruedm2C0q8RfrpZAn7+jzTs+MkP59v9WUG5B+/mEP02QLVQ3S69f4ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583305; c=relaxed/simple;
	bh=3lrdOp5x6O77jQ+7ObWFJ1qiQZl0eH2NlTaXcXJwfWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGXiolQplVudFmovuMWW4WdLJD9A/QW8m3vYB+jCo8XvKwxDPZVaFnH185mfNL5hvZ5Gg6920HhKCLYhqMJFuVnTdL64tn9LiAFVSk2LmnIyFRucxH6xL8Q/CVqxPN1Q3yc2+jkrA77bjz9k4wnyAVci6UMbu+sfyZX60T+TZ1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ABAMR3Uu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ABAMR3Uu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09134C433F1;
	Mon,  8 Apr 2024 13:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583305;
	bh=3lrdOp5x6O77jQ+7ObWFJ1qiQZl0eH2NlTaXcXJwfWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ABAMR3UuVdkNEwDv2PanB9KaoDwOUin9abU6wZipq5kmUL7/hoHaDIbYXDbFrPjkw
	 7DzgcCXWxVow5iwnwHPjBVXgBxfHl6CwEj2PTmhjVznYNT5fV4uzH4CNVqcS/HmrnJ
	 qV9JUF4CBm7rat9ABlk7EaAy+KGAqwDicr65syWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Chao Song <chao.song@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 162/273] ASoC: rt722-sdca-sdw: fix locking sequence
Date: Mon,  8 Apr 2024 14:57:17 +0200
Message-ID: <20240408125314.301506222@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit adb354bbc231b23d3a05163ce35c1d598512ff64 ]

The disable_irq_lock protects the 'disable_irq' value, we need to lock
before testing it.

Fixes: a0b7c59ac1a9 ("ASoC: rt722-sdca: fix for JD event handling in ClockStop Mode0")
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Chao Song <chao.song@linux.intel.com>
Link: https://msgid.link/r/20240325221817.206465-6-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt722-sdca-sdw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt722-sdca-sdw.c b/sound/soc/codecs/rt722-sdca-sdw.c
index e24b9cbdc10c9..e33836fffd5f2 100644
--- a/sound/soc/codecs/rt722-sdca-sdw.c
+++ b/sound/soc/codecs/rt722-sdca-sdw.c
@@ -467,13 +467,13 @@ static int __maybe_unused rt722_sdca_dev_resume(struct device *dev)
 		return 0;
 
 	if (!slave->unattach_request) {
+		mutex_lock(&rt722->disable_irq_lock);
 		if (rt722->disable_irq == true) {
-			mutex_lock(&rt722->disable_irq_lock);
 			sdw_write_no_pm(slave, SDW_SCP_SDCA_INTMASK1, SDW_SCP_SDCA_INTMASK_SDCA_6);
 			sdw_write_no_pm(slave, SDW_SCP_SDCA_INTMASK2, SDW_SCP_SDCA_INTMASK_SDCA_8);
 			rt722->disable_irq = false;
-			mutex_unlock(&rt722->disable_irq_lock);
 		}
+		mutex_unlock(&rt722->disable_irq_lock);
 		goto regmap_sync;
 	}
 
-- 
2.43.0



