Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BFDFBF0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:51:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7997C433D2;
	Mon, 15 May 2023 16:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169516;
	bh=2CpyPyxBfC2wsCt3WW3S9wDelkzwsiNvUhAcLcGys0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bltw/BdZvq3yh6jVyoJAcaWRpp7RdO7pVtHNHtNgMQXebnQ5RHdiIfo/o6KaNmCMO
	 w/0Lq1Q2jUeOvZrPIg5S7cWtq1CdZftQuO5JLwDe/VpyDuLp8Je2dRTWUwoQoXzdNg
	 RNn5SfuPTyNXESYuOLS4KHRb6wBV4LjnAOBfRMaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Nick Hawkins <nick.hawkins@hpe.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 082/246] i2c: gxp: fix build failure without CONFIG_I2C_SLAVE
Date: Mon, 15 May 2023 18:24:54 +0200
Message-Id: <20230515161725.038027340@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 5d388143fa6c351d985ffd23ea50c91c8839141b ]

The gxp_i2c_slave_irq_handler() is hidden in an #ifdef, but the
caller uses an IS_ENABLED() check:

drivers/i2c/busses/i2c-gxp.c: In function 'gxp_i2c_irq_handler':
drivers/i2c/busses/i2c-gxp.c:467:29: error: implicit declaration of function 'gxp_i2c_slave_irq_handler'; did you mean 'gxp_i2c_irq_handler'? [-Werror=implicit-function-declaration]

It has to consistently use one method or the other to avoid warnings,
so move to IS_ENABLED() here for readability and build coverage, and
move the #ifdef in linux/i2c.h to allow building it as dead code.

Fixes: 4a55ed6f89f5 ("i2c: Add GXP SoC I2C Controller")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Nick Hawkins <nick.hawkins@hpe.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-gxp.c | 2 --
 include/linux/i2c.h          | 4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-gxp.c b/drivers/i2c/busses/i2c-gxp.c
index d4b55d989a268..8ea3fb5e4c7f7 100644
--- a/drivers/i2c/busses/i2c-gxp.c
+++ b/drivers/i2c/busses/i2c-gxp.c
@@ -353,7 +353,6 @@ static void gxp_i2c_chk_data_ack(struct gxp_i2c_drvdata *drvdata)
 	writew(value, drvdata->base + GXP_I2CMCMD);
 }
 
-#if IS_ENABLED(CONFIG_I2C_SLAVE)
 static bool gxp_i2c_slave_irq_handler(struct gxp_i2c_drvdata *drvdata)
 {
 	u8 value;
@@ -437,7 +436,6 @@ static bool gxp_i2c_slave_irq_handler(struct gxp_i2c_drvdata *drvdata)
 
 	return true;
 }
-#endif
 
 static irqreturn_t gxp_i2c_irq_handler(int irq, void *_drvdata)
 {
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 5ba89663ea865..13a1ce38cb0c5 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -385,7 +385,6 @@ static inline void i2c_set_clientdata(struct i2c_client *client, void *data)
 
 /* I2C slave support */
 
-#if IS_ENABLED(CONFIG_I2C_SLAVE)
 enum i2c_slave_event {
 	I2C_SLAVE_READ_REQUESTED,
 	I2C_SLAVE_WRITE_REQUESTED,
@@ -396,9 +395,10 @@ enum i2c_slave_event {
 
 int i2c_slave_register(struct i2c_client *client, i2c_slave_cb_t slave_cb);
 int i2c_slave_unregister(struct i2c_client *client);
-bool i2c_detect_slave_mode(struct device *dev);
 int i2c_slave_event(struct i2c_client *client,
 		    enum i2c_slave_event event, u8 *val);
+#if IS_ENABLED(CONFIG_I2C_SLAVE)
+bool i2c_detect_slave_mode(struct device *dev);
 #else
 static inline bool i2c_detect_slave_mode(struct device *dev) { return false; }
 #endif
-- 
2.39.2



