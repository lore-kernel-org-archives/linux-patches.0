Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBEE1D043E;
	Wed,  2 Oct 2024 13:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877183; cv=none; b=Z9Kn05FBg5eV19zbN2EqXxkXAWlUh8uoBG3Jkr4Y0VyD07/ZM7ZC/7FHiwxQqlCeCsQT/Y4wQLoXONqh6d0p9lqzVmmnus99rYbLAiUaN7rZx1J6e1aM771Gfbaw0u4wizQEs8bvB6L/vAERl/uFpZrzcq/if8VZB83m3lA8cTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877183; c=relaxed/simple;
	bh=tmBTO7OfJr0i1fe2j+fEttO1wNKa/xzlHT8BQzz9gRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=teugueF4pHVsrnOTRUO1931ktwjD2CsW3t3z6XbFPbexkT9C1D32TycoD+6yzM42nApnb5IczJdO2ArwIu4hD1fP1kXTTYkX84fd+i5MxohZ/7F6OlDeb7fTQ21X5cJzQvU+42L0bWduk6+cP6bIOTDMcEyQeTE8QbhO5fbdmoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OOnXbfMj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OOnXbfMj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA5CC4CEC2;
	Wed,  2 Oct 2024 13:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877183;
	bh=tmBTO7OfJr0i1fe2j+fEttO1wNKa/xzlHT8BQzz9gRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OOnXbfMjJVdER5S80x4vIHSfLKvmi7pSsI1y+YHEvOC0OJLEyIgYZcW03ya2839vq
	 o0J3/OdGrQ1jwoJPx2yqnKu3ZTCru7SnGAL+zMOsq3ZGi+FaSAG9rlK26yRYutKyCX
	 qYvEwpB9t3z3Rb8TVJAdEyKotskHLtpoOM7VUTCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tommy Huang <tommy_huang@aspeedtech.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.11 691/695] i2c: aspeed: Update the stop sw state when the bus recovery occurs
Date: Wed,  2 Oct 2024 15:01:29 +0200
Message-ID: <20241002125850.102373264@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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
@@ -170,6 +170,13 @@ struct aspeed_i2c_bus {
 
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
@@ -187,7 +194,7 @@ static int aspeed_i2c_recover_bus(struct
 			command);
 
 		reinit_completion(&bus->cmd_complete);
-		writel(ASPEED_I2CD_M_STOP_CMD, bus->base + ASPEED_I2C_CMD_REG);
+		aspeed_i2c_do_stop(bus);
 		spin_unlock_irqrestore(&bus->lock, flags);
 
 		time_left = wait_for_completion_timeout(
@@ -391,13 +398,6 @@ static void aspeed_i2c_do_start(struct a
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


