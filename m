Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14C44B04A7;
	Mon, 17 Aug 2026 14:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976606; cv=none; b=ouU/X1yrDh8QKWTWUX9IPDe6BeEIFrysU5cJIoqWfpZ6rJEHXx9fV1eYFcgHdQNWW93ykzaxyH5PraZpc+c1gnn8Nromqr8S5Yp56UAfkugiNPeZtmn+olwLBXsGEoD1uOhQ9Sj1hAogH43izXxlZsv5YusZUCmDTC/foW7LMe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976606; c=relaxed/simple;
	bh=I7Bmk59HlnH5gVQYtR0sAQMfi4s1CCj8dhGkzu3GwhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AhLRTXPFPHVqRXlZRnwXU5lC10SouvZB7XmrYPb2KGJBGnf5c30t8hZg/5FHttuvBbvc26Uh/RKlvS0OW7BG9V0OQLWZPBvVBLSzN6frK6XcQa+Th0gpY5edS1ou7EHV3IfDmougfAbaSdpJSUagmUTyTNQI9af+rAnFzFl4tkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Do2Xr3u+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Do2Xr3u+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1640A1F000E9;
	Mon, 17 Aug 2026 14:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976605;
	bh=NHpol7kYijIqa+6ufAFo2+yEV3Uy4F+m0ZAj5CPn9WM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Do2Xr3u++0b0EcoFkZQdv3bcULptn3x7vbS3E3gjuSuYOoVzQz90TI8qo0Qj0/b6k
	 h8yINMoMNWRVWlJQZKo0CPc8uSbdp43pTuaVUathWgNA4sDnKLoHYKbpvjgjz1R6c5
	 8qOjZLI/3MnNKpOdSmNSkP/kPHtk6DMy/Hhn9hqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 041/456] ata: sata_dwc_460ex: fix clear_interrupt_bit() clearing all pending interrupts
Date: Mon, 17 Aug 2026 15:27:11 +0200
Message-ID: <20260817132541.643651778@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index dc9d91eacac82e..0023b232aeca2f 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -443,8 +443,7 @@ static void clear_serror(struct ata_port *ap)
 
 static void clear_interrupt_bit(struct sata_dwc_device *hsdev, u32 bit)
 {
-	sata_dwc_writel(&hsdev->sata_dwc_regs->intpr,
-			sata_dwc_readl(&hsdev->sata_dwc_regs->intpr));
+	sata_dwc_writel(&hsdev->sata_dwc_regs->intpr, bit);
 }
 
 static u32 qcmd_tag_to_mask(u8 tag)
-- 
2.53.0



