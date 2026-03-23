Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF8E3BE17D;
	Mon, 23 Mar 2026 16:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283229; cv=none; b=fHT9MqSsEJOX4fbWDLZilKMruBKYA55r0Q03puTk/8JzbX+GymInTgVdVl0nnjoLRStA/oZV66pQiNVErmfdhcVBhubxYb8+DICnH++lXFA7nVbsLzfKMH19df8bdcjDEhzbWVbhGj75PAnq/YJPMPTo7k+T1NnD5TI+x4QhpW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283229; c=relaxed/simple;
	bh=Yn89+znhR9DoSRja4jSXiriumXDddx5rUe0rO5LC/DI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CiwWz1AoyVzE6CiEdLXG61GgfV+t5Fsd3RFABDTOAOn/oMFjVek1Q7X3q3Xk0yDgjrmkBRmutHmIFCK7X066IVJltEuECYHnEkU8DuUzg6Y41gu/6ypCE75NDOONfWHFc4ZjKfNTsqHZsR6SfjpF4qlilByhoHCo9UEmfj+uRps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BytGSI9Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BytGSI9Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181A9C4CEF7;
	Mon, 23 Mar 2026 16:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283229;
	bh=Yn89+znhR9DoSRja4jSXiriumXDddx5rUe0rO5LC/DI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BytGSI9Zw283q1jJXfijAFk9SRcgkJoOHmuwgG1igZpf7F3zDye3U1qS/YRNdfvXW
	 RMd/U4ssJJQyqgQxAxuULCdf4U0Jz+1mjrDUzmaRwb09E5h7wmgGYktIoHxUI/AYfu
	 ts1Uc6MR3XeEevPJNnoSNhgAbrgHHSdT+8S9XIts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamal Dasu <kamal.dasu@broadcom.com>,
	William Zhang <william.zhang@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 449/481] mtd: rawnand: brcmnand: skip DMA during panic write
Date: Mon, 23 Mar 2026 14:47:11 +0100
Message-ID: <20260323134536.156962621@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kamal Dasu <kamal.dasu@broadcom.com>

[ Upstream commit da9ba4dcc01e7cf52b7676f0ee9607b8358c2171 ]

When oops_panic_write is set, the driver disables interrupts and
switches to PIO polling mode but still falls through into the DMA
path. DMA cannot be used reliably in panic context, so make the
DMA path an else branch to ensure only PIO is used during panic
writes.

Fixes: c1ac2dc34b51 ("mtd: rawnand: brcmnand: When oops in progress use pio and interrupt polling")
Signed-off-by: Kamal Dasu <kamal.dasu@broadcom.com>
Reviewed-by: William Zhang <william.zhang@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/brcmnand/brcmnand.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/raw/brcmnand/brcmnand.c b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
index 20c6aeef107c8..99e0d7aa2f4bd 100644
--- a/drivers/mtd/nand/raw/brcmnand/brcmnand.c
+++ b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
@@ -2410,14 +2410,12 @@ static int brcmnand_write(struct mtd_info *mtd, struct nand_chip *chip,
 	for (i = 0; i < ctrl->max_oob; i += 4)
 		oob_reg_write(ctrl, i, 0xffffffff);
 
-	if (mtd->oops_panic_write)
+	if (mtd->oops_panic_write) {
 		/* switch to interrupt polling and PIO mode */
 		disable_ctrl_irqs(ctrl);
-
-	if (use_dma(ctrl) && (has_edu(ctrl) || !oob) && flash_dma_buf_ok(buf)) {
+	} else if (use_dma(ctrl) && (has_edu(ctrl) || !oob) && flash_dma_buf_ok(buf)) {
 		if (ctrl->dma_trans(host, addr, (u32 *)buf, oob, mtd->writesize,
 				    CMD_PROGRAM_PAGE))
-
 			ret = -EIO;
 
 		goto out;
-- 
2.51.0



