Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B45471753;
	Mon,  8 Apr 2024 13:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583205; cv=none; b=FXK6EqSwax3Z/3hvz0ZuArfPDx3cggIc/IkRT6wzfYFtaMgdDut68CzVBOpcAz7iEcWVc301iiAoFS32DA8/AOsDspCN20MPokelKBtVaQ8t08MB2/O+/j3J9+BX2JDMc3s0SgWlMafDUlG1Dn9VPSXMmmcU7AKQusG0jIqiay0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583205; c=relaxed/simple;
	bh=F45qppFRIwIbzP/wB6s2kZVOIpgiRw86yyroc49fcfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eMzULLJWeeN7LYEo4sy4WHWcw9DJ3FcppwEmcYOktoI0345NbVgDYbnOAVykDxL7AYj/qSe0f16KJfHpCy7jZ50FjAZml1IWIJDjg5GYsMHH8Y9c+epIuFKAXN2Nmd3f+gYDne37id0MEYn+0kWgeiLOKaiQSaaELDVQNVGggwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q6vu5sXW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q6vu5sXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46FECC43390;
	Mon,  8 Apr 2024 13:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583203;
	bh=F45qppFRIwIbzP/wB6s2kZVOIpgiRw86yyroc49fcfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q6vu5sXWb/oeg3H7CphJ3NmTN7RGSp8DfgkQXH4vQXusCC7ac3s6F8ggIRo6ax4tK
	 pG5lgAeD9R8eWT+424IE+t/xmQX86mqe4bLVXEsqW+fX4EG4NE1yMGJSH8S4xTYGWQ
	 cCPGnMKdwczFpNrD8HHDhwQ3QbU/EaK7W7sYItuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Chao Song <chao.song@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 169/252] ASoC: rt711-sdca: fix locking sequence
Date: Mon,  8 Apr 2024 14:57:48 +0200
Message-ID: <20240408125311.906808642@linuxfoundation.org>
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
index 935e597022d32..b8471b2d8f4f1 100644
--- a/sound/soc/codecs/rt711-sdca-sdw.c
+++ b/sound/soc/codecs/rt711-sdca-sdw.c
@@ -438,13 +438,13 @@ static int __maybe_unused rt711_sdca_dev_resume(struct device *dev)
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



