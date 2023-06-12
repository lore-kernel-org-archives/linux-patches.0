Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE94134A4
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:44:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF676C433D2;
	Mon, 12 Jun 2023 10:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566674;
	bh=ZG5XaFw0OdrhywYJYu1KG5HIMTP9aOTXR3y5qEcgeXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ur6l5/bLi/4taOjY0YBHlWDoU9iSFVI32ZXB7bica2MxdH5nA47BG1TxSuIUm4J0u
	 vMCRQ/tvaQ1lIZ5H/E3SxbVxmOuOdZJhELlUCcT+xHaX4ey5DiQpd7FZ1QphwHwyqn
	 bSrr5lKHAxDHBpXgKOT3LJGGLr+nWQLbVxb/a6xY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 114/132] i2c: mv64xxx: Fix reading invalid status value in atomic mode
Date: Mon, 12 Jun 2023 12:27:28 +0200
Message-ID: <20230612101715.484382293@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101710.279705932@linuxfoundation.org>
References: <20230612101710.279705932@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marek Behún <kabel@kernel.org>

[ Upstream commit 5578d0a79b6430fa1543640dd6f2d397d0886ce7 ]

There seems to be a bug within the mv64xxx I2C controller, wherein the
status register may not necessarily contain valid value immediately
after the IFLG flag is set in the control register.

My theory is that the controller:
- first sets the IFLG in control register
- then updates the status register
- then raises an interrupt

This may sometime cause weird bugs when in atomic mode, since in this
mode we do not wait for an interrupt, but instead we poll the control
register for IFLG and read status register immediately after.

I encountered -ENXIO from mv64xxx_i2c_fsm() due to this issue when using
this driver in atomic mode.

Note that I've only seen this issue on Armada 385, I don't know whether
other SOCs with this controller are also affected. Also note that this
fix has been in U-Boot for over 4 years [1] without anybody complaining,
so it should not cause regressions.

[1] https://source.denx.de/u-boot/u-boot/-/commit/d50e29662f78

Fixes: 544a8d75f3d6 ("i2c: mv64xxx: Add atomic_xfer method to driver")
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mv64xxx.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/i2c/busses/i2c-mv64xxx.c b/drivers/i2c/busses/i2c-mv64xxx.c
index 047dfef7a6577..878c076ebdc6b 100644
--- a/drivers/i2c/busses/i2c-mv64xxx.c
+++ b/drivers/i2c/busses/i2c-mv64xxx.c
@@ -520,6 +520,17 @@ mv64xxx_i2c_intr(int irq, void *dev_id)
 
 	while (readl(drv_data->reg_base + drv_data->reg_offsets.control) &
 						MV64XXX_I2C_REG_CONTROL_IFLG) {
+		/*
+		 * It seems that sometime the controller updates the status
+		 * register only after it asserts IFLG in control register.
+		 * This may result in weird bugs when in atomic mode. A delay
+		 * of 100 ns before reading the status register solves this
+		 * issue. This bug does not seem to appear when using
+		 * interrupts.
+		 */
+		if (drv_data->atomic)
+			ndelay(100);
+
 		status = readl(drv_data->reg_base + drv_data->reg_offsets.status);
 		mv64xxx_i2c_fsm(drv_data, status);
 		mv64xxx_i2c_do_action(drv_data);
-- 
2.39.2



