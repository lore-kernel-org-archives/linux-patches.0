Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699307F7F5;
	Mon,  8 Apr 2024 13:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582299; cv=none; b=ppL4RP5qRlBrYqnOqrvew7ISL5pCKvAmv3V6DTYL9b1O924y1TJ+7tB2o5kBQhBGkAyKUJ0zujfBpXDIOmK1ocfT0qT1D9MzQP2KoIHCWyYxu7q1xTWrtaqQ40YgZJ1HI6NLT+k8DR96LzzfVxZZetb4o0U5KBmYnNpuTi5KaDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582299; c=relaxed/simple;
	bh=i6VJ5jIXT1KXiuE9HTYrUVQISwsI7uPASK50whLH7pE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJ8aSivtHhuPIeYGPBxmkr3GME1XcQ/WeRkKJStQyOMpTK5XYO0QUqb8a9Al7h4U2QDjzVSEAu2N9H0fXIBsCUrRiOCLxUqgtrmUKiNRvJU7Ratuc0EGR28/sjy2yBSia9Sp1Wm4WdhQWxboBi2E7u1k45fehMK4nK+1Rj4U1xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wRX7JDXJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wRX7JDXJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E511DC433C7;
	Mon,  8 Apr 2024 13:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582299;
	bh=i6VJ5jIXT1KXiuE9HTYrUVQISwsI7uPASK50whLH7pE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wRX7JDXJGZHKqoMLMx/Obzt15nI/dliLcJgCPNGi+x3gsIasbXM2X9dq7Q+SrDZN9
	 44S8CYydMHt4Gi+NRYGO1yiLj54CEP4PaLXE8lYludUEukhgxAHDQYuOSn9380tEXb
	 zsvjt4gDWRGm7UaCY68hnHLUKbq/MZhsSvTCls0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Chao Song <chao.song@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 094/138] ASoC: rt711-sdca: fix locking sequence
Date: Mon,  8 Apr 2024 14:58:28 +0200
Message-ID: <20240408125259.156008691@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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
index 487d3010ddc19..931dbc68548ee 100644
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



