Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E44C1A76A5;
	Mon, 14 Oct 2024 15:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918598; cv=none; b=AoIXQ6DlX0mEWfTJh95MUeg4fYAKcqSBDWH5Vl9n+cj0MXlJ4DDCGqowvoPdSW5olwR5T1lAgff//9oSYii+lX8ZGffLfYDJtlV0pq0wFwDagGl0qLAdXAeZxKZstWrjYZPnKUmbxXRHOOLeoyP0lWLGz0OUq3QC9/65YUI1hHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918598; c=relaxed/simple;
	bh=DyEPTTvB9T9W/ZAuihN+FwdxRyPuJS0CxRBqGOesdmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aq5pz7hXyjX6TwnvuPxVT0dhkvbTkQ9tuG3sXNh03Y/eBUSn9B4utGfgR1Z/VogxvtvX8HCg3+vIIbEpSKltt3VI2/06u4znNZmM1CvUi4/fOrNrj6IzQgWPpuga5RuzfcBp8QspCiNA+NbNwEOmgpbrM2QGtaQf8HGlFKEBmzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CmmzM38Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CmmzM38Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E92ECC4CEC3;
	Mon, 14 Oct 2024 15:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918598;
	bh=DyEPTTvB9T9W/ZAuihN+FwdxRyPuJS0CxRBqGOesdmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CmmzM38ZdfKqFiClHVaE7+oVth/1yUWwEGcEsNOme/vYXgdRGjMcWErFYG+28A3kC
	 yR92ofyWBOtbmJfI14hqz2Mhe0FPaGOShaWZrC1fY5X7IfPc2EBP59EfVvsxJyfwra
	 u19TCtGR0AdCDY45+WpLAuy3Gre1TGoNDOxxBpj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tommy Huang <tommy_huang@aspeedtech.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.1 368/798] i2c: aspeed: Update the stop sw state when the bus recovery occurs
Date: Mon, 14 Oct 2024 16:15:22 +0200
Message-ID: <20241014141232.406261659@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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


