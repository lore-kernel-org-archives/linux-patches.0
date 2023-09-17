Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015AF63B3
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:19:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25567C433C7;
	Sun, 17 Sep 2023 19:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694978399;
	bh=tJexeGi2D1GkDw7yWjWw3Amm+74IbY8D0oEx82ZINyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vCpFKfLbmFa4VeQthSeNRUo8aXdayWtdGjr4nSrqNINR2GEgQ8aGZnLDwp3laT/2y
	 LCRqGk7A73kx5tsRMjxGOkU7bmObwVKB+xxyYS9z+EHECMv02omswb3kWOBB9OA5NW
	 e2pzuaYgC8xJ8XQm5+FdNChXbyP5XvXSKfUVlPak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <bard.liao@intel.com>,
	Oder Chiou <oder_chiou@realtek.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 5.10 023/406] ASoC: rt5682: Fix a problem with error handling in the io init function of the soundwire
Date: Sun, 17 Sep 2023 21:07:57 +0200
Message-ID: <20230917191101.767915786@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oder Chiou <oder_chiou@realtek.com>

commit 9266d95405ae0c078f188ec8bca3a004631be429 upstream.

The device checking error should be a jump to pm_runtime_put_autosuspend()
as done before returning value.

Fixes: 867f8d18df4f ('ASoC: rt5682: fix getting the wrong device id when the suspend_stress_test')
Reviewed-by: Bard Liao <bard.liao@intel.com>
Signed-off-by: Oder Chiou <oder_chiou@realtek.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210607222239.582139-13-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/rt5682-sdw.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/rt5682-sdw.c
+++ b/sound/soc/codecs/rt5682-sdw.c
@@ -413,9 +413,11 @@ static int rt5682_io_init(struct device
 		usleep_range(30000, 30005);
 		loop--;
 	}
+
 	if (val != DEVICE_ID) {
 		dev_err(dev, "Device with ID register %x is not rt5682\n", val);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err_nodev;
 	}
 
 	rt5682_calibrate(rt5682);
@@ -486,10 +488,11 @@ reinit:
 	rt5682->hw_init = true;
 	rt5682->first_hw_init = true;
 
+err_nodev:
 	pm_runtime_mark_last_busy(&slave->dev);
 	pm_runtime_put_autosuspend(&slave->dev);
 
-	dev_dbg(&slave->dev, "%s hw_init complete\n", __func__);
+	dev_dbg(&slave->dev, "%s hw_init complete: %d\n", __func__, ret);
 
 	return ret;
 }


