Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986572C327E;
	Mon,  2 Jun 2025 14:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874719; cv=none; b=Q40oNtDO4xdzEKQuy4Hwr/LstxWAxCCIu3+Jvv9xvNWt+f5dE9j9SpojNGFhvZ4tYc1T+HTW/h/zTUPygt4O5z+p6pVDCxbUCoaIvIsB5K1hZDKJ4ObG9oVJ9XidgkRz5t8C7dFdo1ihOe2Nv88rzrW1joPkIoVSI25Wwl0ZJn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874719; c=relaxed/simple;
	bh=quPG+f1KHOoyhMBxuk3r4sGxhGSqGUfk4aYzCFsB0QM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IuI/8U5RNED/phU7MWr6tVYggZ3ojv4bYQYbGmErK399nQaoWmLeMvLC+bkWyjDvf/BVP5XpGK5a0zlx97SnbCn/+ph6JlrnY00WMuGsyfQezdT6Hw9qiWYUnH9Y9JEZarOc9jz0P72pd+IL29q8w9aoMofhubhd+EiR10UFEFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LCp8n+uP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LCp8n+uP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21217C4CEEE;
	Mon,  2 Jun 2025 14:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874719;
	bh=quPG+f1KHOoyhMBxuk3r4sGxhGSqGUfk4aYzCFsB0QM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LCp8n+uPrBINZ1Meq2XAadu6psCdZ9Qh2+kyn/xwd3/g8U7qXFUG2pYmDhvffN1m+
	 X5vD04BR+GXdYho+0DzCHO9w5Rrguo3QO1WIF1r2ZQQJZnzZVBEdhFewCIpiCIxMpL
	 qpfl/mRX6d5b0XPOy/QER4dLJO4fjeenG80m1IBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 115/204] rtc: ds1307: stop disabling alarms on probe
Date: Mon,  2 Jun 2025 15:47:28 +0200
Message-ID: <20250602134300.178286808@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit dcec12617ee61beed928e889607bf37e145bf86b ]

It is a bad practice to disable alarms on probe or remove as this will
prevent alarms across reboots.

Link: https://lore.kernel.org/r/20250303223744.1135672-1-alexandre.belloni@bootlin.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ds1307.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index 99b93f56a2d50..40532a36ae67c 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -1680,10 +1680,8 @@ static int ds1307_probe(struct i2c_client *client,
 		 * For some variants, be sure alarms can trigger when we're
 		 * running on Vbackup (BBSQI/BBSQW)
 		 */
-		if (want_irq || ds1307_can_wakeup_device) {
+		if (want_irq || ds1307_can_wakeup_device)
 			regs[0] |= DS1337_BIT_INTCN | chip->bbsqi_bit;
-			regs[0] &= ~(DS1337_BIT_A2IE | DS1337_BIT_A1IE);
-		}
 
 		regmap_write(ds1307->regmap, DS1337_REG_CONTROL,
 			     regs[0]);
-- 
2.39.5



