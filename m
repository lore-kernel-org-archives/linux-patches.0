Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04FE43F8B2;
	Sat, 12 Sep 2026 08:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202749; cv=none; b=GVb4GT1j4nNTaAYruzAPG3YHonSq+M4JPKv9tO80+ceG3lgX4Cyus4ZcS+dJ+teveenqHQ0tWohBuWQsLAxs5Zwvn2LtrVBeUQxtQQEBqOWjc0n1ehWXpLW+7v60BebjpKafxN41SAMEpAVZ0N9ETxDCKE55fybXo5kwOYa7km8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202749; c=relaxed/simple;
	bh=lvn/Z+HZC6deYdXttkiOnwq8CIvHbXXfDbo4qYs9fuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rIhTiJEWItiqgpW10jorzHBWb8xNCWQTvKvtDR7IVdYhee5UybpGKc24B/NvflJYryWtDN7Ae5479ISSV34AGVdiAL+3siZa2Q2wu97vqmKkaY44Bxkzg986jtAjjKvYGlfo8hw7QiBMm/ZjrJ8jiBQYBUthF2D/ExoAC1LmH70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dNK4y/ky; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dNK4y/ky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8C71F000FF;
	Sat, 12 Sep 2026 08:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202748;
	bh=8jniDCDEE+STfyGkjhMRGHQrQ/HoMM6ifaeTjewG//g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dNK4y/kyBI3kaOyYvHDXt1eDxoN47/N4s2nN9OP14F5YK+y7hDnlIXYAVhh3adQOX
	 qgQHcV2EztWfF64ADTjhvmv2iE7wBbs4vGMkbOyCDE8ISg8MyneCdQYD3y9oV7noQb
	 hlvOsMKzUpNUMIbj9kuriVw9c/XlA3FjfwLWDD+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1266/1815] i3c: renesas: Follow a unified pattern for transfer and command initialization
Date: Sat, 12 Sep 2026 08:50:16 +0200
Message-ID: <20260912065718.737045465@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit 234a26e6febcf789d9f6779d67c01e3d0c1df5bc ]

Follow a unified pattern for transfer and command initialization across
the driver. This keeps the code cleaner and easier to follow. Also, in
some cases the I3C device was enabled before the transfer data structure
was even allocated.

Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Tested-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Link: https://patch.msgid.link/20260713130545.568657-12-claudiu.beznea+renesas@tuxon.dev
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: b6e56fd8c8a8 ("i3c: renesas: Don't register devices when ENTDAA times out")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/renesas-i3c.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/i3c/master/renesas-i3c.c b/drivers/i3c/master/renesas-i3c.c
index 424bc239c132f..d219900bb33af 100644
--- a/drivers/i3c/master/renesas-i3c.c
+++ b/drivers/i3c/master/renesas-i3c.c
@@ -663,6 +663,10 @@ static int renesas_i3c_daa(struct i3c_master_controller *m)
 	if (!xfer)
 		return -ENOMEM;
 
+	init_completion(&xfer->comp);
+	cmd = xfer->cmds;
+	cmd->rx_count = 0;
+
 	/* Enable I3C bus. */
 	renesas_i3c_bus_enable(m, true);
 
@@ -684,10 +688,6 @@ static int renesas_i3c_daa(struct i3c_master_controller *m)
 		renesas_writel(i3c->regs, DATBAS(pos), datbas_dvdyad_with_parity(ret));
 	}
 
-	init_completion(&xfer->comp);
-	cmd = xfer->cmds;
-	cmd->rx_count = 0;
-
 	ret = renesas_i3c_get_free_pos(i3c);
 	if (ret < 0)
 		return ret;
@@ -779,13 +779,13 @@ static int renesas_i3c_send_ccc_cmd(struct i3c_master_controller *m,
 	if (!xfer)
 		return -ENOMEM;
 
-	renesas_i3c_bus_enable(m, true);
-
 	init_completion(&xfer->comp);
 	cmd = xfer->cmds;
 	cmd->rnw = ccc->rnw;
 	cmd->cmd0 = 0;
 
+	renesas_i3c_bus_enable(m, true);
+
 	/* Calculate the command descriptor. */
 	switch (ccc->id) {
 	case I3C_CCC_SETDASA:
@@ -835,15 +835,15 @@ static int renesas_i3c_i3c_xfers(struct i3c_dev_desc *dev, struct i3c_xfer *i3c_
 	struct renesas_i3c_i2c_dev_data *data = i3c_dev_get_master_data(dev);
 	int i;
 
-	/* Enable I3C bus. */
-	renesas_i3c_bus_enable(m, true);
-
 	struct renesas_i3c_xfer *xfer __free(kfree) = renesas_i3c_alloc_xfer(i3c, 1);
 	if (!xfer)
 		return -ENOMEM;
 
 	init_completion(&xfer->comp);
 
+	/* Enable I3C bus. */
+	renesas_i3c_bus_enable(m, true);
+
 	for (i = 0; i < i3c_nxfers; i++) {
 		struct renesas_i3c_cmd *cmd = xfer->cmds;
 
@@ -964,12 +964,12 @@ static int renesas_i3c_i2c_xfers(struct i2c_dev_desc *dev,
 	if (!xfer)
 		return -ENOMEM;
 
-	renesas_i3c_bus_enable(m, false);
-
 	init_completion(&xfer->comp);
 	xfer->is_i2c_xfer = true;
 	cmd = xfer->cmds;
 
+	renesas_i3c_bus_enable(m, false);
+
 	if (!(renesas_readl(i3c->regs, BCST) & BCST_BFREF)) {
 		cmd->err = -EBUSY;
 		return cmd->err;
-- 
2.53.0



