Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A2C8593C;
	Mon,  8 Apr 2024 13:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583288; cv=none; b=jVgxZ8zLJ929ftOfd0d2lGSE7hn10MqHa3XELDCx6BYNdnvV2j994TCG2nRbfjfjIIV34Ux8CI08xf4w9OITV+i0rTgwqLBJmNZx8r4EkSukbmkSAHLEj0ks8fS4ElZjW3sRk5IlIt/SEgnqrhP+03sxHWM/9MIY7CoPDe6l+vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583288; c=relaxed/simple;
	bh=u01GUJB3z8HRCe7XLeIIRqh00aDyDB40cLgSs8CtYsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BLbNbNcdNc4mWsqLXf91kqkapGCizO/HC3OV6oAJpMqUxHa385vB2TT1nZkDcvEv3ZHynWepMSALo9uzEDKX0OKoCs72jFPswsIuiWhcg+qo8SFoJTtVtSL2TJ6lXGZyH47tPWv7BVi2/RLCx4mSrfdQphqjA+PPOtHhP+FUZ/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zif/j3wr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zif/j3wr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15F8C433C7;
	Mon,  8 Apr 2024 13:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583288;
	bh=u01GUJB3z8HRCe7XLeIIRqh00aDyDB40cLgSs8CtYsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zif/j3wrynskidXMPIUZBz4l3wepSOC+F0Mco7v6UtbLVxTmKbAdfkKLjgG72XyKE
	 R4PDoiDWoqm7tQ7rny1DBDDo2cbUMGiGhv52xA4GrA5JKmzdRj08t6BqL22lIZu9od
	 MkSn+Z2svW7mWBwTIf1Q46NA4GfsL99m4SA5Xlm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Chao Song <chao.song@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 160/273] ASoC: rt711-sdw: fix locking sequence
Date: Mon,  8 Apr 2024 14:57:15 +0200
Message-ID: <20240408125314.240751952@linuxfoundation.org>
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

[ Upstream commit aae86cfd8790bcc7693a5a0894df58de5cb5128c ]

The disable_irq_lock protects the 'disable_irq' value, we need to lock
before testing it.

Fixes: b69de265bd0e ("ASoC: rt711: fix for JD event handling in ClockStop Mode0")
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Chao Song <chao.song@linux.intel.com>
Link: https://msgid.link/r/20240325221817.206465-4-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt711-sdw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt711-sdw.c b/sound/soc/codecs/rt711-sdw.c
index 3f5773310ae8c..988451f24a756 100644
--- a/sound/soc/codecs/rt711-sdw.c
+++ b/sound/soc/codecs/rt711-sdw.c
@@ -536,12 +536,12 @@ static int __maybe_unused rt711_dev_resume(struct device *dev)
 		return 0;
 
 	if (!slave->unattach_request) {
+		mutex_lock(&rt711->disable_irq_lock);
 		if (rt711->disable_irq == true) {
-			mutex_lock(&rt711->disable_irq_lock);
 			sdw_write_no_pm(slave, SDW_SCP_INTMASK1, SDW_SCP_INT1_IMPL_DEF);
 			rt711->disable_irq = false;
-			mutex_unlock(&rt711->disable_irq_lock);
 		}
+		mutex_unlock(&rt711->disable_irq_lock);
 		goto regmap_sync;
 	}
 
-- 
2.43.0



