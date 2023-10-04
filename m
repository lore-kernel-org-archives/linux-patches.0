Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D821D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SKVe51+k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A45C433C9;
	Wed,  4 Oct 2023 18:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443389;
	bh=/IrOULaRNJk+sIpZBFXIHBteb0Ljj0p42aQeIDmcIvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SKVe51+kw9YKkKfwVJi7X2nk9dPAugz9OuWGB/1AtOwz0RhWSCx3xOlXS2g1WfLml
	 p36kz6+6uD6tfanrcTvfFYyjxOAEwITfiDTX3CZ/WeA3pZGarl3A5E5lGVS3fIJMQX
	 6IzL5IAJ968s3MqY/4j5CQyWJlivcaM/BAFdIEUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"William A. Kennington III" <william@wkennington.com>,
	Tali Perry <tali.perry1@gmail.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 140/259] i2c: npcm7xx: Fix callback completion ordering
Date: Wed,  4 Oct 2023 19:55:13 +0200
Message-ID: <20231004175223.744034979@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: William A. Kennington III <william@wkennington.com>

[ Upstream commit 92e73d807b68b2214fcafca4e130b5300a9d4b3c ]

Sometimes, our completions race with new master transfers and override
the bus->operation and bus->master_or_slave variables. This causes
transactions to timeout and kernel crashes less frequently.

To remedy this, we re-order all completions to the very end of the
function.

Fixes: 56a1485b102e ("i2c: npcm7xx: Add Nuvoton NPCM I2C controller driver")
Signed-off-by: William A. Kennington III <william@wkennington.com>
Reviewed-by: Tali Perry <tali.perry1@gmail.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-npcm7xx.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/i2c/busses/i2c-npcm7xx.c b/drivers/i2c/busses/i2c-npcm7xx.c
index 83457359ec450..767dd15b3c881 100644
--- a/drivers/i2c/busses/i2c-npcm7xx.c
+++ b/drivers/i2c/busses/i2c-npcm7xx.c
@@ -696,6 +696,7 @@ static void npcm_i2c_callback(struct npcm_i2c *bus,
 {
 	struct i2c_msg *msgs;
 	int msgs_num;
+	bool do_complete = false;
 
 	msgs = bus->msgs;
 	msgs_num = bus->msgs_num;
@@ -724,23 +725,17 @@ static void npcm_i2c_callback(struct npcm_i2c *bus,
 				 msgs[1].flags & I2C_M_RD)
 				msgs[1].len = info;
 		}
-		if (completion_done(&bus->cmd_complete) == false)
-			complete(&bus->cmd_complete);
-	break;
-
+		do_complete = true;
+		break;
 	case I2C_NACK_IND:
 		/* MASTER transmit got a NACK before tx all bytes */
 		bus->cmd_err = -ENXIO;
-		if (bus->master_or_slave == I2C_MASTER)
-			complete(&bus->cmd_complete);
-
+		do_complete = true;
 		break;
 	case I2C_BUS_ERR_IND:
 		/* Bus error */
 		bus->cmd_err = -EAGAIN;
-		if (bus->master_or_slave == I2C_MASTER)
-			complete(&bus->cmd_complete);
-
+		do_complete = true;
 		break;
 	case I2C_WAKE_UP_IND:
 		/* I2C wake up */
@@ -754,6 +749,8 @@ static void npcm_i2c_callback(struct npcm_i2c *bus,
 	if (bus->slave)
 		bus->master_or_slave = I2C_SLAVE;
 #endif
+	if (do_complete)
+		complete(&bus->cmd_complete);
 }
 
 static u8 npcm_i2c_fifo_usage(struct npcm_i2c *bus)
-- 
2.40.1



