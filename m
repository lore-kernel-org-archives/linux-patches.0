Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481CC6A352;
	Mon,  8 Apr 2024 13:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583224; cv=none; b=Ruf0kWzmOXn+BHpAnNM0E+/DAATjo/8X7JfdD4w8d22gwyWPdvLlKFXOsL7Mi6mx4+v8a4WQb5Wi+h+NbD3h+sF+y54S6xnxMr+krtpYKUdOhZKQER9QIUpDokqM2ZYmlDk9m8A/5eYKbbgMm7tivBHtEP7wSLnXI0XCQHjpAto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583224; c=relaxed/simple;
	bh=KeTurwbzpiRMOqKSdMJSpcKMdVIU82+hLynqX9v+j84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wp/ZhU9/Wrrslr0IvksStvsb1v5ZYc2gKbutwTZ+FLv2R6Wu/nh8t/gNEyczgMbgwQpNk2RbGyWWh5TG0oQmKBRkLA5PVtH8ONpJnUpOfCNz/PH5NMK/xur2j3BpyX3lxal84YbA3UtQg/uJW8SlGj1hkn4iP16Qh/KOkKxfVSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hc+AE6Mk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hc+AE6Mk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72543C433C7;
	Mon,  8 Apr 2024 13:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583223;
	bh=KeTurwbzpiRMOqKSdMJSpcKMdVIU82+hLynqX9v+j84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hc+AE6MkdCKzuldUEYST6fNezG62SZPL7xas8sXjPN+EX9NNCg2Bi6jsfDgp5pfsP
	 6jVAeSXMZcVXZQr2X0baRogeqI6y1K0xIRl5r+3I9LfgC3GXURWKG+VEN5OQn2Nm2/
	 AMp7woQfT1gADhoyijNKJEsbCWalZPl2/shbrDlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Chao Song <chao.song@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 171/252] ASoC: rt712-sdca-sdw: fix locking sequence
Date: Mon,  8 Apr 2024 14:57:50 +0200
Message-ID: <20240408125311.966850608@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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



