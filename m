Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D202A17E90E;
	Mon, 27 May 2024 19:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836690; cv=none; b=HTTTtfqA+UEqnJNA5RtO1B+tfekDBTLLO/quAodPbuuRr8n4N3PptOjxV2DPEuAf3pEcgs7nLPj9dftbYfqbK+Ts3kqSZzp+X3POiN/Ti3gYrA0bJ9qnBjhHWV0+0gsv62ywYDOS32bVGoHB08ogWiIkOC1Zuzjy42COx4Vc1VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836690; c=relaxed/simple;
	bh=LpQ0cHaBlzZ2JwpfgMc0T0tsrMME+ABT4roSQ3VWnkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mAJ24N3gFsndQl5cEoyWCyFcr+IWPQgfmUwWcth/nhvAzvmxF/SQ/L5gBelrr0P+Nal/yLKy2/RwR/UEgzOy/SKnO47z7qmdYAARlIJVp/OJAWMAzya5bnO2NDQE88rpfveqgI4acSSB1lt31lMpJ7HfceBP0YBUvB4vl0lb1VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rrgSjQEr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rrgSjQEr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038F6C2BBFC;
	Mon, 27 May 2024 19:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836690;
	bh=LpQ0cHaBlzZ2JwpfgMc0T0tsrMME+ABT4roSQ3VWnkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rrgSjQErDnFmKii0NRJIHqnOUhQRr6C+9zRep0Bznu1ck731arTdFojfw2CSotR5x
	 dQ4hMFY9pmcXH/mkrAA86K2bhrp/yEwjnaRx4gBNX3ti+Wc6d1aTjBdBJrclA1husM
	 xq2xnHjArjJ6sdbT7rnzX00l/qgE6fjrOA922gzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stafford Horne <shorne@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 151/427] openrisc: Use do_kernel_power_off()
Date: Mon, 27 May 2024 20:53:18 +0200
Message-ID: <20240527185616.519864786@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stafford Horne <shorne@gmail.com>

[ Upstream commit c94195a34e09dacfe2feef03602c911e82f49994 ]

After commit 14c5678720bd ("power: reset: syscon-poweroff: Use
devm_register_sys_off_handler(POWER_OFF)") setting up of pm_power_off
was removed from the driver, this causes OpenRISC platforms using
syscon-poweroff to no longer shutdown.

The kernel now supports chained power-off handlers. Use
do_kernel_power_off() that invokes chained power-off handlers.  All
architectures have moved away from using pm_power_off except OpenRISC.

This patch migrates openrisc to use do_kernel_power_off() instead of the
legacy pm_power_off().

Fixes: 14c5678720bd ("power: reset: syscon-poweroff: Use devm_register_sys_off_handler(POWER_OFF)")
Signed-off-by: Stafford Horne <shorne@gmail.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/openrisc/kernel/process.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/openrisc/kernel/process.c b/arch/openrisc/kernel/process.c
index 86e02929f3ace..3c27d1c727189 100644
--- a/arch/openrisc/kernel/process.c
+++ b/arch/openrisc/kernel/process.c
@@ -65,7 +65,7 @@ void machine_restart(char *cmd)
 }
 
 /*
- * This is used if pm_power_off has not been set by a power management
+ * This is used if a sys-off handler was not set by a power management
  * driver, in this case we can assume we are on a simulator.  On
  * OpenRISC simulators l.nop 1 will trigger the simulator exit.
  */
@@ -89,10 +89,8 @@ void machine_halt(void)
 void machine_power_off(void)
 {
 	printk(KERN_INFO "*** MACHINE POWER OFF ***\n");
-	if (pm_power_off != NULL)
-		pm_power_off();
-	else
-		default_power_off();
+	do_kernel_power_off();
+	default_power_off();
 }
 
 /*
-- 
2.43.0



