Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B252E64F;
	Fri, 24 Nov 2023 18:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kCrbI01t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1D47C433C8;
	Fri, 24 Nov 2023 18:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852259;
	bh=8jn9shcVCu1NVne4ujzuJwhNpKwx2PRXIn0cHzuvbAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kCrbI01tVjm76ytqGgbIlCe8Jjf2kBSR7zxSnKEwc/7uMp6EpieOLsCOPf2+RY8El
	 NX+BIz1pPDRKFxe9V1Kqhuaekjqcu9CEkGrYtqk4npSsm1vpeO0MnMDMpV9epZ3Zs0
	 BzJYpD8UPZIzrzIX3Eo0IOtVyUKVF6dLop9KPKV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Stefan Wahren <stefan.wahren@i2se.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 284/372] pmdomain: bcm: bcm2835-power: check if the ASB register is equal to enable
Date: Fri, 24 Nov 2023 17:51:11 +0000
Message-ID: <20231124172019.901080585@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit 2e75396f1df61e1f1d26d0d703fc7292c4ae4371 ]

The commit c494a447c14e ("soc: bcm: bcm2835-power: Refactor ASB control")
refactored the ASB control by using a general function to handle both
the enable and disable. But this patch introduced a subtle regression:
we need to check if !!(readl(base + reg) & ASB_ACK) == enable, not just
check if (readl(base + reg) & ASB_ACK) == true.

Currently, this is causing an invalid register state in V3D when
unloading and loading the driver, because `bcm2835_asb_disable()` will
return -ETIMEDOUT and `bcm2835_asb_power_off()` will fail to disable the
ASB slave for V3D.

Fixes: c494a447c14e ("soc: bcm: bcm2835-power: Refactor ASB control")
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Stefan Wahren <stefan.wahren@i2se.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20231024101251.6357-2-mcanal@igalia.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/bcm/bcm2835-power.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/bcm/bcm2835-power.c b/drivers/soc/bcm/bcm2835-power.c
index 5bcd047768b60..cbcd1298ef5bd 100644
--- a/drivers/soc/bcm/bcm2835-power.c
+++ b/drivers/soc/bcm/bcm2835-power.c
@@ -175,7 +175,7 @@ static int bcm2835_asb_control(struct bcm2835_power *power, u32 reg, bool enable
 	}
 	writel(PM_PASSWORD | val, base + reg);
 
-	while (readl(base + reg) & ASB_ACK) {
+	while (!!(readl(base + reg) & ASB_ACK) == enable) {
 		cpu_relax();
 		if (ktime_get_ns() - start >= 1000)
 			return -ETIMEDOUT;
-- 
2.42.0



