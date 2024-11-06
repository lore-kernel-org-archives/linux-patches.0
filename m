Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2241D416E;
	Wed,  6 Nov 2024 12:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895196; cv=none; b=SnxaD1BU5mXwxYrY+mB2pdKaKASl5vNhTljQzdOCaddDMIiDChkVLTuiKoW1wc9o4m0ZRyL7o7fyLGdDtd61bQ2xsvNgNXcDYeldZlMjdpjrnZ1BpZDxMqqa3Jly/Dg13op6JTm77WLr4OzmZcQ1ZD82xPjoQgEA/21hoCbjiAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895196; c=relaxed/simple;
	bh=SD7ySQzJaN08FsUfXKr2J+BV3BP5z7JeMbyLRenusf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PUPGf79aTZ9K80Ucs/8J0jq52+rgmmhRz/ce/qZ+9eQ9t39LPcXdXd4jhtpMNhA3y+3nphvJRYr4UW/TkE9gOdXqMlNC+ZvFQ7jjMfKo1foFM3P2PTMJV1hyH+ao3hmQpja3mmqqwAwNQjJZ4rB4TJ7hwbMiTnLjMJ8r5K8q4K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uYq+3057; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uYq+3057"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA8BC4CECD;
	Wed,  6 Nov 2024 12:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895196;
	bh=SD7ySQzJaN08FsUfXKr2J+BV3BP5z7JeMbyLRenusf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uYq+3057l1gjH+ulImZqYqD2rYvGDCma+SgKatGIdUGAcFM3/xCexl7J92/jLBEc7
	 UbcvK0WopWXlh+8fN1SonZDtrietqDtQMWpHaZ4EMdIs46k3zRr2folTnYQbmb0QB6
	 Z39ks850Jgu50m++8Gdq0PdNDL8NYprmAbXYcvMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tommy Huang <tommy_huang@aspeedtech.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 4.19 129/350] i2c: aspeed: Update the stop sw state when the bus recovery occurs
Date: Wed,  6 Nov 2024 13:00:57 +0100
Message-ID: <20241106120324.092598147@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -159,6 +159,13 @@ struct aspeed_i2c_bus {
 
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
@@ -176,7 +183,7 @@ static int aspeed_i2c_recover_bus(struct
 			command);
 
 		reinit_completion(&bus->cmd_complete);
-		writel(ASPEED_I2CD_M_STOP_CMD, bus->base + ASPEED_I2C_CMD_REG);
+		aspeed_i2c_do_stop(bus);
 		spin_unlock_irqrestore(&bus->lock, flags);
 
 		time_left = wait_for_completion_timeout(
@@ -351,13 +358,6 @@ static void aspeed_i2c_do_start(struct a
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


