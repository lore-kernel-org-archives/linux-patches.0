Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9B143FD01;
	Thu, 30 Jul 2026 14:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421410; cv=none; b=iGS4npsLwRIsWfdSzFSBhY0I2L34xePxuhWC4vZItVsjDTn0HamKGo8CZT5LFJPijio2SuLM8iu9ObeH+4QztuuiG67D8r1dJzhYVvC+O4givwitwMbOXJFQqVOqsP745M2oMRXk4icIP/cIcH5FFepadgI2ckpBIPBJrPpFch4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421410; c=relaxed/simple;
	bh=MOA657++0GHy/Tn1TDeXvAiwPEyRt5xxhf/vdIkDySo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKjRPsT6XqMj3Z1LZaWGQbK7Qt60vFRlMKNfFTrNGWAuW6B0yTAhjNyv2C3A6TzIa6+kk4zPaFY4Pv5/rQV12KMmlZlnGllz+ikdewa47fvnYM5boUh07D1zI4Pfje2LLP4qasSQiCPSfktwGUexqcnFLOcTLMctKmLj5XYm5ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I4VqbGQw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I4VqbGQw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 156921F000E9;
	Thu, 30 Jul 2026 14:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421409;
	bh=j34l0lbJJpD2/2SmCyg1amlmtMRo6hfPy8kzSJJW8kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I4VqbGQw7VxLmINrvnY1gcv2QAJ9MwZ6f5JYs7Vq3tXh67wtuqS+W/1X+Baq1Ycd6
	 7Wn5ryul+wTI6Y9fvxqawtbYykYxZ0KfhbNAIgLAhcaZWcVqRw7x2d5eE8nnRMhHfn
	 G47hEQuo1fN0bRVu9Eg0a+BRUdYZcSj+EpTjGlvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 095/744] ata: sata_dwc_460ex: fix clear_interrupt_bit() clearing all pending interrupts
Date: Thu, 30 Jul 2026 16:06:08 +0200
Message-ID: <20260730141446.285995050@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index e9b821d6fd6362..6c062efa2c6fda 100644
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



