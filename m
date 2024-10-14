Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657CE1AAE19;
	Mon, 14 Oct 2024 14:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916017; cv=none; b=KXYMhW1jYZlIVgc2I1wuJ1odGRSinEbWr0QWgeRXBJqPV9Ue1/X2yCxjLsxYTzSLOQ8vMe+hHPIIoBvP2UnY1wrfk0Ki5FCpjpfyVdJUfUXd5CY5I6qC1DfW35ZtFzdqlxpWmrGCAfZi/Fl53mYHwb6qmKh2Equj27uii5y53Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916017; c=relaxed/simple;
	bh=SIGXFGKrgSmUmgyzxbkvPIyUiYvNQLK2/jvIlacML5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PEqW3lUqM1A7pTD7TmpK1QLzjMuf4/OVClB1myrCB/L1Bq+CFb7pEPE74oweRNecnvPsa7BD+wIjFsz5TtOQM8QAgcr++HOZ8XmixnTBcMwO3vOjqXqw9561SwD7HKZ3UFN50mQaTEQmgqvSWeRsINEPOfsIK4jbpEs9Livarx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h15A6ijV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h15A6ijV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB77C4CEC3;
	Mon, 14 Oct 2024 14:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916017;
	bh=SIGXFGKrgSmUmgyzxbkvPIyUiYvNQLK2/jvIlacML5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h15A6ijVBUWJPvHIVxYVGhv4aFnDJF8ECVD5byboRm+5VLbDw/ETlba3TZ/xevxSF
	 1w3ayMSUwbDipYOdVGeUoLhpggK34LirNUaCDJ/yj4UHXzjxvR/jUjy01X40ZYrxXI
	 MyHNv3g2lB9CtKNqrj9nhZXN/b4pvzH1L8yN/UCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 030/214] soundwire: intel_bus_common: enable interrupts before exiting reset
Date: Mon, 14 Oct 2024 16:18:13 +0200
Message-ID: <20241014141046.166802282@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 5aedb8d8336b0a0421b58ca27d1b572aa6695b5b ]

The existing code enables the Cadence IP interrupts after the bus
reset sequence. The problem with this sequence is that it might be
pre-empted, giving SoundWire devices time to sync and report as
ATTACHED before the interrupts are enabled. In that case, the Cadence
IP will not detect a state change and will not throw an interrupt to
proceed with the enumeration of a Device0.

In our overnight stress tests, we observed that a slight
sub-millisecond delay in enabling interrupts after the reset was
correlated with detection failures. This problem is more prevalent on
the LunarLake silicon, likely due to SOC integration changes, but it
was observed on earlier generations as well.

This patch reverts the sequence, with the interrupts enabled before
performing the bus reset. This removes the race condition and makes
sure the Cadence IP is able to detect the presence of a Device0 in all
cases.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20240805115003.88035-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/intel_bus_common.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/soundwire/intel_bus_common.c b/drivers/soundwire/intel_bus_common.c
index df944e11b9caa..a75e5d7d87154 100644
--- a/drivers/soundwire/intel_bus_common.c
+++ b/drivers/soundwire/intel_bus_common.c
@@ -45,15 +45,15 @@ int intel_start_bus(struct sdw_intel *sdw)
 		return ret;
 	}
 
-	ret = sdw_cdns_exit_reset(cdns);
+	ret = sdw_cdns_enable_interrupt(cdns, true);
 	if (ret < 0) {
-		dev_err(dev, "%s: unable to exit bus reset sequence: %d\n", __func__, ret);
+		dev_err(dev, "%s: cannot enable interrupts: %d\n", __func__, ret);
 		return ret;
 	}
 
-	ret = sdw_cdns_enable_interrupt(cdns, true);
+	ret = sdw_cdns_exit_reset(cdns);
 	if (ret < 0) {
-		dev_err(dev, "%s: cannot enable interrupts: %d\n", __func__, ret);
+		dev_err(dev, "%s: unable to exit bus reset sequence: %d\n", __func__, ret);
 		return ret;
 	}
 
@@ -136,15 +136,15 @@ int intel_start_bus_after_reset(struct sdw_intel *sdw)
 			return ret;
 		}
 
-		ret = sdw_cdns_exit_reset(cdns);
+		ret = sdw_cdns_enable_interrupt(cdns, true);
 		if (ret < 0) {
-			dev_err(dev, "unable to exit bus reset sequence during resume\n");
+			dev_err(dev, "cannot enable interrupts during resume\n");
 			return ret;
 		}
 
-		ret = sdw_cdns_enable_interrupt(cdns, true);
+		ret = sdw_cdns_exit_reset(cdns);
 		if (ret < 0) {
-			dev_err(dev, "cannot enable interrupts during resume\n");
+			dev_err(dev, "unable to exit bus reset sequence during resume\n");
 			return ret;
 		}
 
-- 
2.43.0



