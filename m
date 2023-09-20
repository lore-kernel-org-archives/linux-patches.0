Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85E015AD3
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:39:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF92C433CD;
	Wed, 20 Sep 2023 12:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213572;
	bh=4V8cky9ZelKUpPtbm6xqKJwiUmgfSeCAF08s8EMgBOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OFH63XhQeC1Mi4n2pRBJqiLd7B2m0u/ensMcUgnIfi2Ksgr1CX1kXgv4kQu17qR9B
	 pLJJ2ny4vDBUkKlKGGA0b35Qs8etd9VFII4MppPFH5f/Md3twQNV+R5L3m4SNbam9R
	 IVYKbRjRjzHPDPnZklsjjm1kpvXuYD5CCV6JVfrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Zhang <william.zhang@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.4 286/367] mtd: rawnand: brcmnand: Fix potential false time out warning
Date: Wed, 20 Sep 2023 13:31:03 +0200
Message-ID: <20230920112905.967102883@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

From: William Zhang <william.zhang@broadcom.com>

commit 9cc0a598b944816f2968baf2631757f22721b996 upstream.

If system is busy during the command status polling function, the driver
may not get the chance to poll the status register till the end of time
out and return the premature status.  Do a final check after time out
happens to ensure reading the correct status.

Fixes: 9d2ee0a60b8b ("mtd: nand: brcmnand: Check flash #WP pin status before nand erase/program")
Signed-off-by: William Zhang <william.zhang@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20230706182909.79151-3-william.zhang@broadcom.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/brcmnand/brcmnand.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/mtd/nand/raw/brcmnand/brcmnand.c
+++ b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
@@ -891,6 +891,14 @@ static int bcmnand_ctrl_poll_status(stru
 		cpu_relax();
 	} while (time_after(limit, jiffies));
 
+	/*
+	 * do a final check after time out in case the CPU was busy and the driver
+	 * did not get enough time to perform the polling to avoid false alarms
+	 */
+	val = brcmnand_read_reg(ctrl, BRCMNAND_INTFC_STATUS);
+	if ((val & mask) == expected_val)
+		return 0;
+
 	dev_warn(ctrl->dev, "timeout on status poll (expected %x got %x)\n",
 		 expected_val, val & mask);
 


