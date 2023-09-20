Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66FB2AB22
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:07:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59652C433C8;
	Wed, 20 Sep 2023 12:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211676;
	bh=92n9t0pvXYsdGbcI5rIbougYnQfvtB7DX2OzvzuHwGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qgbuGwi2/TNHU+Z6Q7GhBrym3TLyo1xOAj3I3wGCIAOwebdz+CsnahQNMBlVKCtHr
	 084FBtofHy/4iITZbrun+m2o9Wd0qO/qqqtMscGhSBpgk/KfVIcU8l25wownhScTt/
	 mYDxbQfWRVcY82+hYPVSg6v7xVZHzJ/mfTqwMpss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Zhang <william.zhang@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Kursad Oney <kursad.oney@broadcom.com>,
	Kamal Dasu <kamal.dasu@broadcom.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 4.14 181/186] mtd: rawnand: brcmnand: Fix crash during the panic_write
Date: Wed, 20 Sep 2023 13:31:24 +0200
Message-ID: <20230920112843.428027657@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112836.799946261@linuxfoundation.org>
References: <20230920112836.799946261@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/mtd/nand/brcmnand/brcmnand.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/mtd/nand/brcmnand/brcmnand.c
+++ b/drivers/mtd/nand/brcmnand/brcmnand.c
@@ -1271,7 +1271,17 @@ static void brcmnand_send_cmd(struct brc
 
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


