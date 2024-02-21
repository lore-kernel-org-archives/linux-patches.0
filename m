Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBB5360BA;
	Wed, 21 Feb 2024 14:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525820; cv=none; b=TawRvkkas0843PVBCMiT0pJC4BJcvaSWHR3apkkBQdeQy3ZYSx9/sENn6dCHJtnxS/0IrzAfamxpRugR/BEx5HrEIfLVytJKg84sJN9rt/vB7v5hy6xRYKeJGDys8rYTQTPQS5tTmB0QiX3/I8A6eITONTSUZrgM7EXwzWnXzFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525820; c=relaxed/simple;
	bh=LnbhIVbQxoY8oMy8ilia6kikqzSZ0tANYorYKR33rMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sckm81HNGy8ycTjqQ0T6S7u/meP+ay7pFwUKK7s6Az4YJb0yt0HkSWb/fitaHWq0stpgdqOexPm0iy63TvBkBfJ8VlkyPl09hvTKT9S1hFVD870eUoLnqjH0oufdIj9f41A8vBkHrw+Uq/2HmHdQN5wOLoyTL2xCLoFSrljEc30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lp3joF/3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lp3joF/3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F83CC433F1;
	Wed, 21 Feb 2024 14:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525819;
	bh=LnbhIVbQxoY8oMy8ilia6kikqzSZ0tANYorYKR33rMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lp3joF/3IdFdBkuFQuvwrX9PyR8TzewEFllXm/cOKJ7fBSRhYItI9ypmFT/ZXfCYC
	 2rXpuPGUPh4636hI4dB0CyiUtrRi97hZ9qIhNLZwPTPhIZomfaQpsPyqDnpnJDzQ9U
	 UhC3PFNjyDbIOafZrr15uz9Y/2Ml8vgYz1MOWTu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Krummenacher <max.krummenacher@toradex.com>
Subject: [PATCH 5.4 264/267] Revert "Revert "mtd: rawnand: gpmi: Fix setting busy timeout setting""
Date: Wed, 21 Feb 2024 14:10:05 +0100
Message-ID: <20240221125948.527361391@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

From: Max Krummenacher <max.krummenacher@toradex.com>

This reverts commit 15a3adfe75937c9e4e0e48f0ed40dd39a0e526e2.

The backport of [1] relies on having [2] also backported. Having only
one of the two results in a bogus hw->timing1 setting.

If only [2] is backportet the 16 bit register value likely underflows
resulting in a busy_wait_timeout of 0.
Or if only [1] is applied the value likely overflows with chances of
having last 16 LSBs all 0 which would then result in a
busy_wait_timeout of 0 too.

Both cases may lead to NAND data corruption, e.g. on a Colibri iMX7
setup this has been seen.

[1] commit 0fddf9ad06fd ("mtd: rawnand: gpmi: Set WAIT_FOR_READY timeout based on program/erase times")
[2] commit 06781a5026350 ("mtd: rawnand: gpmi: Fix setting busy timeout setting")

Signed-off-by: Max Krummenacher <max.krummenacher@toradex.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
@@ -684,7 +684,7 @@ static void gpmi_nfc_compute_timings(str
 	hw->timing0 = BF_GPMI_TIMING0_ADDRESS_SETUP(addr_setup_cycles) |
 		      BF_GPMI_TIMING0_DATA_HOLD(data_hold_cycles) |
 		      BF_GPMI_TIMING0_DATA_SETUP(data_setup_cycles);
-	hw->timing1 = BF_GPMI_TIMING1_BUSY_TIMEOUT(busy_timeout_cycles * 4096);
+	hw->timing1 = BF_GPMI_TIMING1_BUSY_TIMEOUT(DIV_ROUND_UP(busy_timeout_cycles, 4096));
 
 	/*
 	 * Derive NFC ideal delay from {3}:


