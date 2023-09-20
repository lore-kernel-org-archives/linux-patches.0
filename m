Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008E22AB21
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:59:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 785F4C433C7;
	Wed, 20 Sep 2023 11:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211160;
	bh=HfoLi1XQ62l5Zodsw+xyPpfUDE1ItawbuG7BhhWKQz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tAITdk2EpY+fRDwRdMANvFnC+1T0iFmmbYB7E3H2Sxz3huMGXhSleLat/gV4hJiP7
	 GtlN9G02nmVTwtUsNwxMeGKAC9pDlpFuBgSKPSpfEXUQ8tRESzZV4rKRRo3j8f7xZx
	 WTP73lrXERU7mxvuldf7NRVA6UlKd9IZeZsVAcVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tommy Huang <tommy_huang@aspeedtech.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 6.1 130/139] i2c: aspeed: Reset the i2c controller when timeout occurs
Date: Wed, 20 Sep 2023 13:31:04 +0200
Message-ID: <20230920112840.458771895@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>
References: <20230920112835.549467415@linuxfoundation.org>
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

From: Tommy Huang <tommy_huang@aspeedtech.com>

commit fee465150b458351b6d9b9f66084f3cc3022b88b upstream.

Reset the i2c controller when an i2c transfer timeout occurs.
The remaining interrupts and device should be reset to avoid
unpredictable controller behavior.

Fixes: 2e57b7cebb98 ("i2c: aspeed: Add multi-master use case support")
Cc: <stable@vger.kernel.org> # v5.1+
Signed-off-by: Tommy Huang <tommy_huang@aspeedtech.com>
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-aspeed.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/i2c/busses/i2c-aspeed.c
+++ b/drivers/i2c/busses/i2c-aspeed.c
@@ -698,13 +698,16 @@ static int aspeed_i2c_master_xfer(struct
 
 	if (time_left == 0) {
 		/*
-		 * If timed out and bus is still busy in a multi master
-		 * environment, attempt recovery at here.
+		 * In a multi-master setup, if a timeout occurs, attempt
+		 * recovery. But if the bus is idle, we still need to reset the
+		 * i2c controller to clear the remaining interrupts.
 		 */
 		if (bus->multi_master &&
 		    (readl(bus->base + ASPEED_I2C_CMD_REG) &
 		     ASPEED_I2CD_BUS_BUSY_STS))
 			aspeed_i2c_recover_bus(bus);
+		else
+			aspeed_i2c_reset(bus);
 
 		/*
 		 * If timed out and the state is still pending, drop the pending


