Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10D56FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:15:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28DA3C433C8;
	Sun, 17 Sep 2023 20:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981722;
	bh=hB0Qe4kvhW3cq7iu+JSDO41lyTKxaeJoLcyQ3xrJIZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xYA2sATg3G1tSDymxsFHjPlJ8fSovDH3e0YU1oUDLO/sj7pzPm+lyehBy2Mjeumqb
	 KUwaZvzmD0am1pOr223BctR4PLdfObKyEe7cJJhTRkHbe4KrNKh0WPbmVSYiVsVpAm
	 vuj7pLT5lOUjVQqZKfrpMZFa0wCPz/pZSWx8/WCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Zhang <william.zhang@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Kursad Oney <kursad.oney@broadcom.com>,
	Kamal Dasu <kamal.dasu@broadcom.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.1 163/219] mtd: rawnand: brcmnand: Fix crash during the panic_write
Date: Sun, 17 Sep 2023 21:14:50 +0200
Message-ID: <20230917191046.930305809@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

From: William Zhang <william.zhang@broadcom.com>

commit e66dd317194daae0475fe9e5577c80aa97f16cb9 upstream.

When executing a NAND command within the panic write path, wait for any
pending command instead of calling BUG_ON to avoid crashing while
already crashing.

Fixes: 27c5b17cd1b1 ("mtd: nand: add NAND driver "library" for Broadcom STB NAND controller")
Signed-off-by: William Zhang <william.zhang@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Kursad Oney <kursad.oney@broadcom.com>
Reviewed-by: Kamal Dasu <kamal.dasu@broadcom.com>
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20230706182909.79151-4-william.zhang@broadcom.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/brcmnand/brcmnand.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/brcmnand/brcmnand.c
+++ b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
@@ -1592,7 +1592,17 @@ static void brcmnand_send_cmd(struct brc
 
 	dev_dbg(ctrl->dev, "send native cmd %d addr 0x%llx\n", cmd, cmd_addr);
 
-	BUG_ON(ctrl->cmd_pending != 0);
+	/*
+	 * If we came here through _panic_write and there is a pending
+	 * command, try to wait for it. If it times out, rather than
+	 * hitting BUG_ON, just return so we don't crash while crashing.
+	 */
+	if (oops_in_progress) {
+		if (ctrl->cmd_pending &&
+			bcmnand_ctrl_poll_status(ctrl, NAND_CTRL_RDY, NAND_CTRL_RDY, 0))
+			return;
+	} else
+		BUG_ON(ctrl->cmd_pending != 0);
 	ctrl->cmd_pending = cmd;
 
 	ret = bcmnand_ctrl_poll_status(ctrl, NAND_CTRL_RDY, NAND_CTRL_RDY, 0);


