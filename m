Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364E94446F7;
	Thu, 30 Jul 2026 15:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425496; cv=none; b=Kp4eHbr3eHpNMy58463tJMSpTTZjradzsdN33xyofIB/g7Ekj/eqUZeu/Wx/kZzlXqZ6yJkxqnBeWBccLT79NwC6o4l9pUkSP8Wa/8BEDfTXY7hr2ZH3kOjZLvmNQjrFzItk3moqLEU1q/puSPNpp58THVO8GIHJoWvzKL2gLcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425496; c=relaxed/simple;
	bh=6gNcLAMIKZZsbdSHW+2ZzLVZuOZx8t2WnQ63YgkBKZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B55Y48ADtSZl2PhvC0k03NzSMmnq8uEmQwzduPdAuiSeuact5EJ7WXhry0yjA7bkxyDJc6JfPASLPcFZBGU+e6K3TL5DPlvE2ytA0Xe2ixjAOKUJ6AUUQui7iPm58/fr/uApuSHKpH+1CohAh8Bf5H6U/em1DWFqwjuksIiTugY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ib6mLXlh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ib6mLXlh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 304A31F000E9;
	Thu, 30 Jul 2026 15:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425494;
	bh=vpdKTpgZ7tilh4PMG3/gT+Ob3YVUD4BgmoVQjZTFRtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ib6mLXlhbYDpNo11itbqIroxX3ecw66iGABGeYoo4OddArmcKH8x+ng41iQTKE387
	 JlSfTkZDcdZDK6ZyzbCcXsn+nRul9+5rWEUW0uzTWhIdBvYTQwAa5sDVspC2rwKgoR
	 jNY8GP0C7y5sw3jpG0RsR4rcoa+D7f1IgGbaX1ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 087/602] ata: sata_dwc_460ex: fix clear_interrupt_bit() clearing all pending interrupts
Date: Thu, 30 Jul 2026 16:07:59 +0200
Message-ID: <20260730141437.823622177@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 66c4e310ad71f41e41736d33dd8a1fb5eaaec7f3 ]

clear_interrupt_bit() ignores the bit argument and performs a
read-write-back of the entire INTPR register.  If INTPR uses standard
Write-1-to-Clear semantics, this clears every pending interrupt bit,
not just the intended one.  Coalesced interrupts (e.g. DMAT + NEWFP)
would be cleared together, silently losing the second event.

Write only the specific bit to clear so that other pending interrupts
are preserved.

Fixes: 62936009f35a ("[libata] Add 460EX on-chip SATA driver, sata_dwc_460ex")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/sata_dwc_460ex.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
index 97b934fa116e26..74514608a7fada 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -394,8 +394,7 @@ static void clear_serror(struct ata_port *ap)
 
 static void clear_interrupt_bit(struct sata_dwc_device *hsdev, u32 bit)
 {
-	sata_dwc_writel(&hsdev->sata_dwc_regs->intpr,
-			sata_dwc_readl(&hsdev->sata_dwc_regs->intpr));
+	sata_dwc_writel(&hsdev->sata_dwc_regs->intpr, bit);
 }
 
 static u32 qcmd_tag_to_mask(u8 tag)
-- 
2.53.0



