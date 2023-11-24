Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93EE381DE;
	Fri, 24 Nov 2023 18:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i7uZLJqQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556F3C433C7;
	Fri, 24 Nov 2023 18:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849795;
	bh=j23WlqFdLHZgjp760fM0FILBbZUpVw+TNA+MU1v9twA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i7uZLJqQ21Qe2CbUeQaFJKIGm8mqbGshq+4gDt0gfLVpZaeocg2XoUIhS08iIfCEW
	 JA91qRxneocpUGHhXAu/latqy9J7DKpr2zwDnLXoDisbBpvHmyNL16rep5xjWa6POO
	 gNC1az6JrNc84RNaUA6kWBDCe6LuQGGqB+jbH9aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Stefan Wahren <stefan.wahren@i2se.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 299/530] pmdomain: bcm: bcm2835-power: check if the ASB register is equal to enable
Date: Fri, 24 Nov 2023 17:47:45 +0000
Message-ID: <20231124172037.135430106@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

commit 2e75396f1df61e1f1d26d0d703fc7292c4ae4371 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/bcm/bcm2835-power.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pmdomain/bcm/bcm2835-power.c
+++ b/drivers/pmdomain/bcm/bcm2835-power.c
@@ -175,7 +175,7 @@ static int bcm2835_asb_control(struct bc
 	}
 	writel(PM_PASSWORD | val, base + reg);
 
-	while (readl(base + reg) & ASB_ACK) {
+	while (!!(readl(base + reg) & ASB_ACK) == enable) {
 		cpu_relax();
 		if (ktime_get_ns() - start >= 1000)
 			return -ETIMEDOUT;


