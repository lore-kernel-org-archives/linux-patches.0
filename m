Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF82D3B47EE;
	Thu, 30 Jul 2026 15:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423607; cv=none; b=ALvUKZ64u3qy7jK2cj41Wb6tmPGKIS/9W8ljSqOdQtY2Kf71NtuyO699+O1SW8uU4uwz70r8VRyFB3wO4Uf3NcGTMqZE15LCAle4MzdStVkB2pqQL7GNIItu+iZnKubMEro7CF73sSiZ2V5T0MLxnH8DQluBp2NsfyBtg7QUmkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423607; c=relaxed/simple;
	bh=Cgj7L5CMFIBMG+kzVKrQ8WkbBAJaA1sSVQWTSA6vMuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iBeMHnwjZ5dXaMficOHaqGwrCCXQYDJGqX+xharAqca+a8Yn+mR1nrlZwy+drOSYzOzY5Y0s+FPoYAjmfoT/sV/gdY4/TM4hO1fcMNjC+RIUZ5aAMNliXr/+nCRHWFJWdoPSXKDM5bmTUJ+qYdI6f0/2nWuRy8bq6Lvb+E7WS+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G5T7bNua; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G5T7bNua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265411F000E9;
	Thu, 30 Jul 2026 15:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423606;
	bh=FX++WsriSsvubLyPP8hl0s0cXX8E8VOZ0ekCSpyaRx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G5T7bNuanQUNLEM0E2vpcyNO3odSnI+vZYalYIykBvdfj8jzfQifWecbOW+sMdAzq
	 XyXqT+FKI4Kh4OxpsFsGB0A1FXIWQ7PwFwtw0KU9EKUFBFI3+63yf79V2ViSidRajn
	 33EODm8oZlasqNGsKMMmVIbVgGUR6QLLJR5ZI8yI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 103/675] ata: sata_dwc_460ex: fix clear_interrupt_bit() clearing all pending interrupts
Date: Thu, 30 Jul 2026 16:07:13 +0200
Message-ID: <20260730141447.325093591@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 639eab75210f29..d3472bfc606ffc 100644
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



