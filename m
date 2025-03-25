Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011A529B233;
	Tue, 25 Mar 2025 12:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905867; cv=none; b=UdnKYx01OoRMW2NcD2V4Z/RXKCE2WVKgsmQcXQNEojJUL9r43Lj0Q3nm4dezSIFKVu9MW1wuKj1XRO4DwG6fxoMOZ+VUkUFMt65Htsn23YwlAwDr3POMHETuH86dt2aCb1FiMtzsLbOs9ZvGPOBNc3jLkijJ5bBX2fE/zMEksuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905867; c=relaxed/simple;
	bh=K5z3lHx/r0Wq7JpVWttljqRVyKGtly4Ty8XX5LmUNkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u/Bbc9lBdCYL2FFbFe8Xz77incgchmz5Sp97OdIjZqWYUDxbxAxMlEsgN454EmejxUO3GeT5fPeXXh5XzY7xcF+hqPvyUYtmSOmbFDOZfIu1njUh749IsUzP1Ub5jK9d0PjFgQq1wn+9LxmcQS8181JptSvJ++0jEAYpwEHG+Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PqkrVN7M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PqkrVN7M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC17C4CEE4;
	Tue, 25 Mar 2025 12:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905866;
	bh=K5z3lHx/r0Wq7JpVWttljqRVyKGtly4Ty8XX5LmUNkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PqkrVN7M3tdIWkfVKs9a3WeVYFPVCwTZliJ5/N+8UBZ3WYAv05UqYLFU1vEN18o0S
	 9LVd0avzv1j/XWmVEzFnPP/oNYiQJcNpPUCCxPpr7B4kUgojiclBm+8YkaH6ik5284
	 Aah/VSornTI2VsnTNrsE8W3LK/M+x0lfGQGmx9BY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.1 169/198] can: rcar_canfd: Fix page entries in the AFL list
Date: Tue, 25 Mar 2025 08:22:11 -0400
Message-ID: <20250325122201.082160607@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Biju Das <biju.das.jz@bp.renesas.com>

commit 1dba0a37644ed3022558165bbb5cb9bda540eaf7 upstream.

There are a total of 96 AFL pages and each page has 16 entries with
registers CFDGAFLIDr, CFDGAFLMr, CFDGAFLP0r, CFDGAFLP1r holding
the rule entries (r = 0..15).

Currently, RCANFD_GAFL* macros use a start variable to find AFL entries,
which is incorrect as the testing on RZ/G3E shows ch1 and ch4
gets a start value of 0 and the register contents are overwritten.

Fix this issue by using rule_entry corresponding to the channel
to find the page entries in the AFL list.

Fixes: dd3bd23eb438 ("can: rcar_canfd: Add Renesas R-Car CAN FD driver")
Cc: stable@vger.kernel.org
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20250307170330.173425-3-biju.das.jz@bp.renesas.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/rcar/rcar_canfd.c |   28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -772,22 +772,14 @@ static void rcar_canfd_configure_control
 }
 
 static void rcar_canfd_configure_afl_rules(struct rcar_canfd_global *gpriv,
-					   u32 ch)
+					   u32 ch, u32 rule_entry)
 {
-	u32 cfg;
-	int offset, start, page, num_rules = RCANFD_CHANNEL_NUMRULES;
+	int offset, page, num_rules = RCANFD_CHANNEL_NUMRULES;
+	u32 rule_entry_index = rule_entry % 16;
 	u32 ridx = ch + RCANFD_RFFIFO_IDX;
 
-	if (ch == 0) {
-		start = 0; /* Channel 0 always starts from 0th rule */
-	} else {
-		/* Get number of Channel 0 rules and adjust */
-		cfg = rcar_canfd_read(gpriv->base, RCANFD_GAFLCFG(ch));
-		start = RCANFD_GAFLCFG_GETRNC(gpriv, 0, cfg);
-	}
-
 	/* Enable write access to entry */
-	page = RCANFD_GAFL_PAGENUM(start);
+	page = RCANFD_GAFL_PAGENUM(rule_entry);
 	rcar_canfd_set_bit(gpriv->base, RCANFD_GAFLECTR,
 			   (RCANFD_GAFLECTR_AFLPN(gpriv, page) |
 			    RCANFD_GAFLECTR_AFLDAE));
@@ -803,13 +795,13 @@ static void rcar_canfd_configure_afl_rul
 		offset = RCANFD_C_GAFL_OFFSET;
 
 	/* Accept all IDs */
-	rcar_canfd_write(gpriv->base, RCANFD_GAFLID(offset, start), 0);
+	rcar_canfd_write(gpriv->base, RCANFD_GAFLID(offset, rule_entry_index), 0);
 	/* IDE or RTR is not considered for matching */
-	rcar_canfd_write(gpriv->base, RCANFD_GAFLM(offset, start), 0);
+	rcar_canfd_write(gpriv->base, RCANFD_GAFLM(offset, rule_entry_index), 0);
 	/* Any data length accepted */
-	rcar_canfd_write(gpriv->base, RCANFD_GAFLP0(offset, start), 0);
+	rcar_canfd_write(gpriv->base, RCANFD_GAFLP0(offset, rule_entry_index), 0);
 	/* Place the msg in corresponding Rx FIFO entry */
-	rcar_canfd_set_bit(gpriv->base, RCANFD_GAFLP1(offset, start),
+	rcar_canfd_set_bit(gpriv->base, RCANFD_GAFLP1(offset, rule_entry_index),
 			   RCANFD_GAFLP1_GAFLFDP(ridx));
 
 	/* Disable write access to page */
@@ -1825,6 +1817,7 @@ static int rcar_canfd_probe(struct platf
 	unsigned long channels_mask = 0;
 	int err, ch_irq, g_irq;
 	int g_err_irq, g_recc_irq;
+	u32 rule_entry = 0;
 	bool fdmode = true;			/* CAN FD only mode - default */
 	enum rcanfd_chip_id chip_id;
 	int max_channels;
@@ -2003,7 +1996,8 @@ static int rcar_canfd_probe(struct platf
 		rcar_canfd_configure_tx(gpriv, ch);
 
 		/* Configure receive rules */
-		rcar_canfd_configure_afl_rules(gpriv, ch);
+		rcar_canfd_configure_afl_rules(gpriv, ch, rule_entry);
+		rule_entry += RCANFD_CHANNEL_NUMRULES;
 	}
 
 	/* Configure common interrupts */


