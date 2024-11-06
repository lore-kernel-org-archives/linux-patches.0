Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4369C1DFD9D;
	Wed,  6 Nov 2024 13:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898236; cv=none; b=RppibVbfS3LaWYjgFXfbYe13dQBzIq6sO1PZW2MwJyguKiG17H7kCSUCC0u6GRqSX+KfxoZZsjZolkqR/zEv5AykQwQbmqvV7RrptUKATEKYmvYUGV74sUBz//Rfldhh9MHe1hlS6mbxo7xh/o/zJ7OAyIshFnaO4BC0hoRkxDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898236; c=relaxed/simple;
	bh=WCHwHbCkF+Susy5mKck8daqK5BM6Vpq8a2HTuaGKPS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ScGqQyv/Q1a6j2xyiCaOhPHGe7Td4LY/ywD+MCgNTeqn7uEQUa6BrAEas+IVJ1vuBI0ohH6IIDQTo+0Z9o4xIJfLYpaDfWFQfUrop478m64QXy3DfWpr69v45omNnhONW6EUyczkBWL9toIZ+g8pmY7z8qyonxgvZB4BG5HagEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qaJtFor8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qaJtFor8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1ABC4CED4;
	Wed,  6 Nov 2024 13:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898236;
	bh=WCHwHbCkF+Susy5mKck8daqK5BM6Vpq8a2HTuaGKPS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qaJtFor8mKierxXSOSq1ZB7sfzTFmbHKhf9slr+Lzu3Xclf/xgM86xlHhy8J5/Hmq
	 8RTch6QcI8oifG290oJHtq2oBWDLapT5+Kxq8OgGScWS8E1Ix6aLX77kDun3qhRrj1
	 urBN+CHlQKLL8nnfbaFBMJKWLYF7s/uXAg0p0vbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tommy Huang <tommy_huang@aspeedtech.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.4 170/462] i2c: aspeed: Update the stop sw state when the bus recovery occurs
Date: Wed,  6 Nov 2024 13:01:03 +0100
Message-ID: <20241106120335.717457565@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tommy Huang <tommy_huang@aspeedtech.com>

commit 93701d3b84ac5f3ea07259d4ced405c53d757985 upstream.

When the i2c bus recovery occurs, driver will send i2c stop command
in the scl low condition. In this case the sw state will still keep
original situation. Under multi-master usage, i2c bus recovery will
be called when i2c transfer timeout occurs. Update the stop command
calling with aspeed_i2c_do_stop function to update master_state.

Fixes: f327c686d3ba ("i2c: aspeed: added driver for Aspeed I2C")
Cc: stable@vger.kernel.org # v4.13+
Signed-off-by: Tommy Huang <tommy_huang@aspeedtech.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-aspeed.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/i2c/busses/i2c-aspeed.c
+++ b/drivers/i2c/busses/i2c-aspeed.c
@@ -172,6 +172,13 @@ struct aspeed_i2c_bus {
 
 static int aspeed_i2c_reset(struct aspeed_i2c_bus *bus);
 
+/* precondition: bus.lock has been acquired. */
+static void aspeed_i2c_do_stop(struct aspeed_i2c_bus *bus)
+{
+	bus->master_state = ASPEED_I2C_MASTER_STOP;
+	writel(ASPEED_I2CD_M_STOP_CMD, bus->base + ASPEED_I2C_CMD_REG);
+}
+
 static int aspeed_i2c_recover_bus(struct aspeed_i2c_bus *bus)
 {
 	unsigned long time_left, flags;
@@ -189,7 +196,7 @@ static int aspeed_i2c_recover_bus(struct
 			command);
 
 		reinit_completion(&bus->cmd_complete);
-		writel(ASPEED_I2CD_M_STOP_CMD, bus->base + ASPEED_I2C_CMD_REG);
+		aspeed_i2c_do_stop(bus);
 		spin_unlock_irqrestore(&bus->lock, flags);
 
 		time_left = wait_for_completion_timeout(
@@ -386,13 +393,6 @@ static void aspeed_i2c_do_start(struct a
 }
 
 /* precondition: bus.lock has been acquired. */
-static void aspeed_i2c_do_stop(struct aspeed_i2c_bus *bus)
-{
-	bus->master_state = ASPEED_I2C_MASTER_STOP;
-	writel(ASPEED_I2CD_M_STOP_CMD, bus->base + ASPEED_I2C_CMD_REG);
-}
-
-/* precondition: bus.lock has been acquired. */
 static void aspeed_i2c_next_msg_or_stop(struct aspeed_i2c_bus *bus)
 {
 	if (bus->msgs_index + 1 < bus->msgs_count) {


