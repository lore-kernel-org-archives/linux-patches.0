Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA0A1AF0D7;
	Tue, 15 Oct 2024 13:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997709; cv=none; b=FL+5fM20XR1/Ex3cs3Cx2qJ6W0LqO4NXjRIcavsCkCSTv1tqOcHHw3pRqwIKzeKsZyYdApJ/pmrMMoT+/0A2XflsyJrunX4pwo1/zDVa2Z1/rzemd04m9JmUq4OexjMAlzmuFgovcw1mpj3Tfyz6ON0aBjJXGesEZPBlZUMGeV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997709; c=relaxed/simple;
	bh=El5HKR5glTHK8wRm76K2FsQ6IVktZeexnmuHKej2ZLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+DXY511sY/YW1C9bzY+VNnDBW/yrpVwWnAKSzukBWlKizC+pLZUVlXC+Loxzvsw11IKC7GR/PPrrthoE9FRsT1PO8yqQ4p3HcMuAViJZUumWabQEqjsg/lZSolvX731zTkw6mWwWXLO425CHNvIg4/IgJGe3gYGgF3aTmDW+Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M5VW4QPC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M5VW4QPC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32808C4CEC6;
	Tue, 15 Oct 2024 13:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997708;
	bh=El5HKR5glTHK8wRm76K2FsQ6IVktZeexnmuHKej2ZLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M5VW4QPCHAEgBuS22BZ2GUDKZAcnMpa0L2osDcMjyBVoopKqlTWgiEh1ofEe6FRqL
	 H8qHNDkx7Blo1tFeRZgIbZj7cuKR+iyfuo1wy281XwFBO6dVkpsJSL1CUB3zXwF+3w
	 JaRImclwsnFRVoFT5WhoPtCScORsF1ysSYe2B6GA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tommy Huang <tommy_huang@aspeedtech.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.10 262/518] i2c: aspeed: Update the stop sw state when the bus recovery occurs
Date: Tue, 15 Oct 2024 14:42:46 +0200
Message-ID: <20241015123927.104762431@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


