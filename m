Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D152741A0;
	Mon, 20 Apr 2026 15:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700366; cv=none; b=rHn5OUOjsyJ1vlbcJSql4nDc8Z8iY7HlVKr8sWyLwOyog5Ygc+3TeSvdr8v1fCiWY36zVZZBAchkVL1hGK00YmDpYkGkyNFWYHP2N3sQEYjeuH7CqTbmUogImLwRycm+K+kFE3Apx1QrtUGmb7LmmhGpcIM7MNCiFAMSZ+ceHaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700366; c=relaxed/simple;
	bh=uiswTQHbvj42FjcWpaFoCKkkpi+h4Rme+dkqZqTSbyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUCRL7ivjhGCJrIZMz9M1RQm0VrV8S2fTSekXYvck0Zt59JhuNYRN+exUslVdWkpQa9jPD7VcMQbgnfxc7Ew/UiJ8gST8mqt3s3pMt2J7+khgWQXdKTHsIZlrsRPYoVRqcbYgbN/ptLlGKUZMx1w8RKv4zuas/57mGOInyzQW8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sfp/zROo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sfp/zROo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 121BEC19425;
	Mon, 20 Apr 2026 15:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700366;
	bh=uiswTQHbvj42FjcWpaFoCKkkpi+h4Rme+dkqZqTSbyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sfp/zROoKXtAChWZLLF7ou6iH1SXPix0KPVBfEVdNUocH+GTKjk0yotDRcRpBT9wN
	 217MJDu1VbtH0GHmvb9g5WewvTN57aAAWTPQShynHKEx9YoActJt4Qew6+vSRBd7HR
	 WcO7BarDN54+WS7qtcswGMGqA9qa4ob0cxXzOu5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Lavra <flavra@baylibre.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 111/220] pinctrl: mcp23s08: Disable all pin interrupts during probe
Date: Mon, 20 Apr 2026 17:40:52 +0200
Message-ID: <20260420153938.028526484@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Lavra <flavra@baylibre.com>

[ Upstream commit db5b8cecbdf479ad13156af750377e5b43853fab ]

A chip being probed may have the interrupt-on-change feature enabled on
some of its pins, for example after a reboot. This can cause the chip to
generate interrupts for pins that don't have a registered nested handler,
which leads to a kernel crash such as below:

[    7.928897] Unable to handle kernel read from unreadable memory at virtual address 00000000000000ac
[    7.932314] Mem abort info:
[    7.935081]   ESR = 0x0000000096000004
[    7.938808]   EC = 0x25: DABT (current EL), IL = 32 bits
[    7.944094]   SET = 0, FnV = 0
[    7.947127]   EA = 0, S1PTW = 0
[    7.950247]   FSC = 0x04: level 0 translation fault
[    7.955101] Data abort info:
[    7.957961]   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
[    7.963421]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[    7.968447]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[    7.973734] user pgtable: 4k pages, 48-bit VAs, pgdp=00000000089b7000
[    7.980148] [00000000000000ac] pgd=0000000000000000, p4d=0000000000000000
[    7.986913] Internal error: Oops: 0000000096000004 [#1]  SMP
[    7.992545] Modules linked in:
[    8.073678] CPU: 0 UID: 0 PID: 81 Comm: irq/18-4-0025 Not tainted 7.0.0-rc6-gd2b5a1f931c8-dirty #199
[    8.073689] Hardware name: Khadas VIM3 (DT)
[    8.073692] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    8.094639] pc : _raw_spin_lock_irq+0x40/0x80
[    8.098970] lr : handle_nested_irq+0x2c/0x168
[    8.098979] sp : ffff800082b2bd20
[    8.106599] x29: ffff800082b2bd20 x28: ffff800080107920 x27: ffff800080104d88
[    8.106611] x26: ffff000003298080 x25: 0000000000000001 x24: 000000000000ff00
[    8.113707] x23: 0000000000000001 x22: 0000000000000000 x21: 000000000000000e
[    8.120850] x20: 0000000000000000 x19: 00000000000000ac x18: 0000000000000000
[    8.135046] x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
[    8.135062] x14: ffff800081567ea8 x13: ffffffffffffffff x12: 0000000000000000
[    8.135070] x11: 00000000000000c0 x10: 0000000000000b60 x9 : ffff800080109e0c
[    8.135078] x8 : 1fffe0000069dbc1 x7 : 0000000000000001 x6 : ffff0000034ede00
[    8.135086] x5 : 0000000000000000 x4 : ffff0000034ede08 x3 : 0000000000000001
[    8.163460] x2 : 0000000000000000 x1 : 0000000000000001 x0 : 00000000000000ac
[    8.170560] Call trace:
[    8.180094]  _raw_spin_lock_irq+0x40/0x80 (P)
[    8.184443]  mcp23s08_irq+0x248/0x358
[    8.184462]  irq_thread_fn+0x34/0xb8
[    8.184470]  irq_thread+0x1a4/0x310
[    8.195093]  kthread+0x13c/0x150
[    8.198309]  ret_from_fork+0x10/0x20
[    8.201850] Code: d65f03c0 d2800002 52800023 f9800011 (885ffc01)
[    8.207931] ---[ end trace 0000000000000000 ]---

This issue has always been present, but has been latent until commit
"f9f4fda15e72" ("pinctrl: mcp23s08: init reg_defaults from HW at probe and
switch cache type"), which correctly removed reg_defaults from the regmap
and as a side effect changed the behavior of the interrupt handler so that
the real value of the MCP_GPINTEN register is now being read from the chip
instead of using a bogus 0 default value; a non-zero value for this
register can trigger the invocation of a nested handler which may not exist
(yet).
Fix this issue by disabling all pin interrupts during initialization.

Fixes: f9f4fda15e72 ("pinctrl: mcp23s08: init reg_defaults from HW at probe and switch cache type")
Signed-off-by: Francesco Lavra <flavra@baylibre.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-mcp23s08.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-mcp23s08.c b/drivers/pinctrl/pinctrl-mcp23s08.c
index 586f2f67c6177..b89b3169e8be5 100644
--- a/drivers/pinctrl/pinctrl-mcp23s08.c
+++ b/drivers/pinctrl/pinctrl-mcp23s08.c
@@ -664,6 +664,15 @@ int mcp23s08_probe_one(struct mcp23s08 *mcp, struct device *dev,
 	if (mcp->irq && mcp->irq_controller) {
 		struct gpio_irq_chip *girq = &mcp->chip.irq;
 
+		/*
+		 * Disable all pin interrupts, to prevent the interrupt handler from
+		 * calling nested handlers for any currently-enabled interrupts that
+		 * do not (yet) have an actual handler.
+		 */
+		ret = mcp_write(mcp, MCP_GPINTEN, 0);
+		if (ret < 0)
+			return dev_err_probe(dev, ret, "can't disable interrupts\n");
+
 		gpio_irq_chip_set_chip(girq, &mcp23s08_irq_chip);
 		/* This will let us handle the parent IRQ in the driver */
 		girq->parent_handler = NULL;
-- 
2.53.0



