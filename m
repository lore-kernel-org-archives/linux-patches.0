Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8779827713;
	Tue,  9 Jul 2024 11:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524433; cv=none; b=MJWB/CAfvRQLHqVIs6jpbkAzTCfKEpJEGEilMX5+YLgW64wFjQ+LgWLpaNaE6pXsiRELzxgJhssCzvzNJhJ2kgMiEXvk5lm0ou1GVNqBY8gT0p6+L6Zf0R+tba3UTaqI58VoZYpgC8ptCmaX4kk9wkL427EJ5zdPqizOXV/EkAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524433; c=relaxed/simple;
	bh=ichJDMOej0X5RkzCGgrbbyxpOqRvMAEaxOWTxOTtqtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GzDoCUs7USpElsAZUjPnm4oyhlncDs3OydfcX7hwLO/i6+EIt5cJ5UCpjHqN2YBib7zOTetT1BkNUK7Ml5Ew1I1fj6zcpRFvIvGTWQNj7DNzH7RmZz30iZYCmKbzZGQzpLN2jAdc3b1LqdbuaBIzEKah/b7CLiPWomGXhbQ0W6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wyHkMNZ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wyHkMNZ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE75C3277B;
	Tue,  9 Jul 2024 11:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524433;
	bh=ichJDMOej0X5RkzCGgrbbyxpOqRvMAEaxOWTxOTtqtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wyHkMNZ1z/sHt6iPlBg73r+finNmw9LNrFvuS4g4c1GTbcYH33lNl6KniA5XXl4zY
	 jJeWnguDHpJFtdafneHBNepBwjuHM+X2/yQztBF1q6XBE/c3IekxySjnecclWvgZPH
	 WRZKRqSEX5PhbeIQ6B5ke0OKYcDyeHu3YSoLfo5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.9 163/197] mtd: rawnand: rockchip: ensure NVDDR timings are rejected
Date: Tue,  9 Jul 2024 13:10:17 +0200
Message-ID: <20240709110715.260855678@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Val Packett <val@packett.cool>

commit b27d8946b5edd9827ee3c2f9ea1dd30022fb1ebe upstream.

.setup_interface first gets called with a "target" value of
NAND_DATA_IFACE_CHECK_ONLY, in which case an error is expected
if the controller driver does not support the timing mode (NVDDR).

Fixes: a9ecc8c814e9 ("mtd: rawnand: Choose the best timings, NV-DDR included")
Signed-off-by: Val Packett <val@packett.cool>
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20240519031409.26464-1-val@packett.cool
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/rockchip-nand-controller.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/mtd/nand/raw/rockchip-nand-controller.c
+++ b/drivers/mtd/nand/raw/rockchip-nand-controller.c
@@ -420,13 +420,13 @@ static int rk_nfc_setup_interface(struct
 	u32 rate, tc2rw, trwpw, trw2c;
 	u32 temp;
 
-	if (target < 0)
-		return 0;
-
 	timings = nand_get_sdr_timings(conf);
 	if (IS_ERR(timings))
 		return -EOPNOTSUPP;
 
+	if (target < 0)
+		return 0;
+
 	if (IS_ERR(nfc->nfc_clk))
 		rate = clk_get_rate(nfc->ahb_clk);
 	else


