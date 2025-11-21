Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99D326CE33;
	Fri, 21 Nov 2025 13:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731296; cv=none; b=N7C0Uha2LYGzjQkJt80CJlBVw/15gKtFnXQPU6rMUlrR5F7TtN31NO7WerpcJcRaVM0rVrM/Wzew5fImfJ9ZcSGPEPhmo7249vbrI1g7EkmRlPE8T5o8/Q2VhiiipzPtDK0aAeg49DiL342QVbpVp6SOS0qgFUcWbhp00xa/gqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731296; c=relaxed/simple;
	bh=CR7RMU00PbnKH3efDkvFXlkbeHtfo0L22s2HwQCOd3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HCpL77VJHv0KmrEfzMByZOYgnASciHqBsMakjzGo8nyGSv/LWUOwsgllTMA0LInA9aZGXlaHknmpXRKMSQEcGku00RS/XxU8m9jE2BVTliowHxdUBOZA+ZABI//pp+8IgoPPuPaWlZwRr9YIScjAOeUwuXWfrsXn1vw+kzfLc8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ML0r/TpL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ML0r/TpL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A188C4CEF1;
	Fri, 21 Nov 2025 13:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731295;
	bh=CR7RMU00PbnKH3efDkvFXlkbeHtfo0L22s2HwQCOd3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ML0r/TpLrIFgxpeT0k7FHj9qh7O2eYfNkz/W7gPRMVMa5ZSwlaW6U+I+08prI8B32
	 Ym5g8DLTZn5QQs/UcQTPHdJJqdaeAc+rvMfJCA1bFsh7SoDH/jrDudgGpoPlOxtw6p
	 HkmzC04dI4o0GN+qfRojOJ3C4IzgCyH5F5JKe8s4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 125/247] mtd: onenand: Pass correct pointer to IRQ handler
Date: Fri, 21 Nov 2025 14:11:12 +0100
Message-ID: <20251121130159.214728840@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 97315e7c901a1de60e8ca9b11e0e96d0f9253e18 ]

This was supposed to pass "onenand" instead of "&onenand" with the
ampersand.  Passing a random stack address which will be gone when the
function ends makes no sense.  However the good thing is that the pointer
is never used, so this doesn't cause a problem at run time.

Fixes: e23abf4b7743 ("mtd: OneNAND: S5PC110: Implement DMA interrupt method")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/onenand/onenand_samsung.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/onenand/onenand_samsung.c b/drivers/mtd/nand/onenand/onenand_samsung.c
index f37a6138e461f..6d6aa709a21f8 100644
--- a/drivers/mtd/nand/onenand/onenand_samsung.c
+++ b/drivers/mtd/nand/onenand/onenand_samsung.c
@@ -906,7 +906,7 @@ static int s3c_onenand_probe(struct platform_device *pdev)
 			err = devm_request_irq(&pdev->dev, r->start,
 					       s5pc110_onenand_irq,
 					       IRQF_SHARED, "onenand",
-					       &onenand);
+					       onenand);
 			if (err) {
 				dev_err(&pdev->dev, "failed to get irq\n");
 				return err;
-- 
2.51.0



