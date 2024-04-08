Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5807BAE7;
	Mon,  8 Apr 2024 13:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583297; cv=none; b=lsKwSGuAkD5DV3jDzRUGLyn/hkPSw4YBv1jyB3ziwY+VNZ6RWI1Tl6mWzCDFzKAdFBxTkuTuxIBGLqFREeS5kQ+b/TNRBupv0mfj54SXs+mkFv+Do/ItpUdOWSSY986ZzY/Hma5nVYr4nsxxfjN3iANaZoqyJwM6bfM2E4VXD5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583297; c=relaxed/simple;
	bh=oBItHM/fNLUxLwNXZUoCt3zaXOxGBh9UEhC185lDc6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xrh63tovIOcl0rdO6lXtAC/F3Wl+93brYajc8kfhGBBhtcpIhnbplHDhwhv0J+wxXt1YyutzDq2xHZ+UkZ4Kv+wvyhBcyRGGXOv5HajKXwHmAEwpASiUGbNud3thmg9FQ9vZAFooetp5nwMDPndyOeRHyepivq6gN/N2ezYCVKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PGaxlpBO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PGaxlpBO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D195C433C7;
	Mon,  8 Apr 2024 13:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583296;
	bh=oBItHM/fNLUxLwNXZUoCt3zaXOxGBh9UEhC185lDc6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PGaxlpBOt6yvLsn3TDa90+RLI9FOZu8p48v12KLLEyz/OGq9omlY3JbXeBf/HDQA3
	 kto0xxnMdLT2553M13Ufbp/V+1V2UjBM9qdvS/JAo/fzqxzuniNFraHWWJYghGG/3S
	 aAWqwZhR0rRfwrXksy1axpw6SRT7CJ6pQgqpbhq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Chao Song <chao.song@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 161/273] ASoC: rt712-sdca-sdw: fix locking sequence
Date: Mon,  8 Apr 2024 14:57:16 +0200
Message-ID: <20240408125314.270649546@linuxfoundation.org>
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

[ Upstream commit c8b2e5c1b959d100990e4f0cbad38e7d047bb97c ]

The disable_irq_lock protects the 'disable_irq' value, we need to lock
before testing it.

Fixes: 7a8735c1551e ("ASoC: rt712-sdca: fix for JD event handling in ClockStop Mode0")
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Chao Song <chao.song@linux.intel.com>
Link: https://msgid.link/r/20240325221817.206465-5-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt712-sdca-sdw.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt712-sdca-sdw.c b/sound/soc/codecs/rt712-sdca-sdw.c
index 6b644a89c5890..ba877432cea61 100644
--- a/sound/soc/codecs/rt712-sdca-sdw.c
+++ b/sound/soc/codecs/rt712-sdca-sdw.c
@@ -438,13 +438,14 @@ static int __maybe_unused rt712_sdca_dev_resume(struct device *dev)
 		return 0;
 
 	if (!slave->unattach_request) {
+		mutex_lock(&rt712->disable_irq_lock);
 		if (rt712->disable_irq == true) {
-			mutex_lock(&rt712->disable_irq_lock);
+
 			sdw_write_no_pm(slave, SDW_SCP_SDCA_INTMASK1, SDW_SCP_SDCA_INTMASK_SDCA_0);
 			sdw_write_no_pm(slave, SDW_SCP_SDCA_INTMASK2, SDW_SCP_SDCA_INTMASK_SDCA_8);
 			rt712->disable_irq = false;
-			mutex_unlock(&rt712->disable_irq_lock);
 		}
+		mutex_unlock(&rt712->disable_irq_lock);
 		goto regmap_sync;
 	}
 
-- 
2.43.0



