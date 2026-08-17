Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8050242925;
	Mon, 17 Aug 2026 15:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978967; cv=none; b=kdtz6cYTB2+4gW+dwvzS3ysfVGNj/0gS6HKMW/BE9PU5kr5TcXEts8UotyyaSO0dC+BUv7xWa3oNpYGYOPhnJ+RVq+eujCWy0k/Dn6KjWvcGqZTZ7MGu+C+2JBEiZjK59TCi+cXgsIiNedIY+0xzvagt1BfDBR6+aQUrNnGOusA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978967; c=relaxed/simple;
	bh=9K98OHhIIk44w+hIpV4rgULdErEUcEJsGBwHo/YWQeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQlTbIpyoF+PYlWdaXsOWaJd9APo86c7zW3o90+WRzDvVDChDmOLZURVW7ayh4AzTMG+XYALw9wtdML/Aaj0dikddsfsIxY3fBPE5XN9L2kBSJCYUhQ2TjiyhptLjqGbQfuE/wTmwj2uOxX8sxr8HV4t5TvYbnHpwDC686tHuvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZdP+dQea; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZdP+dQea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF7C1F000E9;
	Mon, 17 Aug 2026 15:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978966;
	bh=2lra5YueIVaFKnrulFhXfxaahXcSodiPnYcH1CAfqGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZdP+dQeaVzpfKapFBZqM7dwSpoTAlIr2ZOCm83lvu+lkyj6MiEuiNNszuNgsNgteq
	 6q+PvbXs5IdnHx91W29y7jGOcuR4ZfJvhgy3KyTKX1xcqA0i6F+Gs8TK2Gy0cGfN1c
	 eSHc586x/b6xCvinMSSrpVpZ94yI+aMEfiH6c6yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/609] ata: sata_dwc_460ex: fix clear_interrupt_bit() clearing all pending interrupts
Date: Mon, 17 Aug 2026 15:25:57 +0200
Message-ID: <20260817132545.505707494@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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
index 9a4e12a09910a0..24bc1b755dc748 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -403,8 +403,7 @@ static void clear_serror(struct ata_port *ap)
 
 static void clear_interrupt_bit(struct sata_dwc_device *hsdev, u32 bit)
 {
-	sata_dwc_writel(&hsdev->sata_dwc_regs->intpr,
-			sata_dwc_readl(&hsdev->sata_dwc_regs->intpr));
+	sata_dwc_writel(&hsdev->sata_dwc_regs->intpr, bit);
 }
 
 static u32 qcmd_tag_to_mask(u8 tag)
-- 
2.53.0



