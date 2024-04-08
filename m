Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4581880022;
	Mon,  8 Apr 2024 14:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585116; cv=none; b=OvIUEI8G2rcrOx37XVFZkUDFaCTwOEcTukYI0fGHgd4ylUbdfOUgrf/v/9LBeDZEz2AugayMwdK3l5oO/jUONduRJ8/AqG1u9d3M9HHrf8NBTIpdedGgWuKgCzw5Qzlkt90jzBsBs0kWIZYkMQ/UQ+vh+PtPrEnWLHTIQ9pPw6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585116; c=relaxed/simple;
	bh=/V2M7qHODPWi+4GM2EY8KoA0P4yowRr9ZBxqN1Yjbhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=db5KZaC4QUERDqYPtk7hCwxZFbztq9vLl/aw8WerDr1a5Esgj82v7qSacqD/S0jc9s7h8767f9V31xRAPw6yUYmYAabKUE7qH8jwMoq1cHP5pzquXndEZrTwSMqHyC6Um44HGWZPFqw9uk1zD4/vSCv+xW+gLMg0+R4F4Fmlkqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cT6nQJWY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cT6nQJWY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAEF1C433C7;
	Mon,  8 Apr 2024 14:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585116;
	bh=/V2M7qHODPWi+4GM2EY8KoA0P4yowRr9ZBxqN1Yjbhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cT6nQJWYfcnYf9pGoJPgqX9SC6IxMsuq7RUwsk0WwRMIqCC8qChhYjYVqcdCL+kYy
	 d54v1O+X8W9NJcKuoN1moc9zsr5NH3npSRJhdeKg9ivnysApQ9w/GH4PTFRzX5o041
	 LglOyvyTeWnnAyyTOpMa60fKdc0W7pQJPMLKhQZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Chao Song <chao.song@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 668/690] ASoC: rt711-sdca: fix locking sequence
Date: Mon,  8 Apr 2024 14:58:54 +0200
Message-ID: <20240408125423.897421555@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit ee287771644394d071e6a331951ee8079b64f9a7 ]

The disable_irq_lock protects the 'disable_irq' value, we need to lock
before testing it.

Fixes: 23adeb7056ac ("ASoC: rt711-sdca: fix for JD event handling in ClockStop Mode0")
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Chao Song <chao.song@linux.intel.com>
Link: https://msgid.link/r/20240325221817.206465-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt711-sdca-sdw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt711-sdca-sdw.c b/sound/soc/codecs/rt711-sdca-sdw.c
index 4faf6b8544ddd..25e8b9906f316 100644
--- a/sound/soc/codecs/rt711-sdca-sdw.c
+++ b/sound/soc/codecs/rt711-sdca-sdw.c
@@ -443,13 +443,13 @@ static int __maybe_unused rt711_sdca_dev_resume(struct device *dev)
 		return 0;
 
 	if (!slave->unattach_request) {
+		mutex_lock(&rt711->disable_irq_lock);
 		if (rt711->disable_irq == true) {
-			mutex_lock(&rt711->disable_irq_lock);
 			sdw_write_no_pm(slave, SDW_SCP_SDCA_INTMASK1, SDW_SCP_SDCA_INTMASK_SDCA_0);
 			sdw_write_no_pm(slave, SDW_SCP_SDCA_INTMASK2, SDW_SCP_SDCA_INTMASK_SDCA_8);
 			rt711->disable_irq = false;
-			mutex_unlock(&rt711->disable_irq_lock);
 		}
+		mutex_unlock(&rt711->disable_irq_lock);
 		goto regmap_sync;
 	}
 
-- 
2.43.0



