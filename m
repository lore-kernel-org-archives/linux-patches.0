Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A0B43F8BF;
	Thu, 30 Jul 2026 15:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427179; cv=none; b=ln4RVMApPIjM60UeqDwPrD+DH7VgdQZodcjreoxGP7CTvPgWwzI0fiUKZYJEDiFpHj7uaRt6SaCZrZwQdTH18ioBg8p36hD8o63pNEzX+W+Qpr916qJ+zTXc77FZ7q3d/2j8IKs7tp9v//ekxwS2lIEJYqgme3JTjYeq8T5S/hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427179; c=relaxed/simple;
	bh=GBaM1aamyz5uw+bpISmGQNiOGk+24gmClP7YyT1cfQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qK/xBTOpH1Ix+B5kaKgE4thGU+Gh58q0LMH+77GNpUq1m8RonINQJlOnZDVRcjPRRh+d8YVYGFJzRSw3bVJ2oEBjAGxvvkDyrPQDDokn5yCIcCVjoATdd9ziczIGXB7O0U1dALQeBllnqzMlyxcSiqBEDTX/LtTFYrT0m53mJWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xbW9shlU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xbW9shlU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 715811F00A3D;
	Thu, 30 Jul 2026 15:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427178;
	bh=c8vAlcpXjn735y4Aux0MirZRqp7n6WjhgjQtR8h97+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xbW9shlUv8RIt2Dqfr936AXta+IrVtsaP8zaI5v4XOZPnNxWtOTbRFdXVYODW+geC
	 m6UR7xvKBxdO21buTRN2TyFiKjxmdZIu03gK7OrCGauFzoLBGf02t1zE2pxKeB9oxY
	 EGsYWajd5I9uzVvbYKJrNy5PLa242kVVWBi8BTcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/484] ata: sata_dwc_460ex: fix infinite loop in NCQ tag completion bit-scanning
Date: Thu, 30 Jul 2026 16:09:34 +0200
Message-ID: <20260730141425.110572266@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit c2130f6553f4a5cbdc259de069600117a995f197 ]

The hand-rolled bit-scanning loop in the NCQ completion path has an
infinite loop bug.  When tag_mask has only high bits set (e.g.
0x80000000), the inner while loop left-shifts tag_mask until it
overflows to 0.  At that point !(0 & 1) is always true and 0 <<= 1
stays 0, causing an infinite loop in hardirq context with a spinlock
held.

Replace the open-coded bit-scanning with __ffs() which correctly
finds the least significant set bit and is bounded by the width of
the argument.

Fixes: 62936009f35a ("[libata] Add 460EX on-chip SATA driver, sata_dwc_460ex")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/sata_dwc_460ex.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
index 74514608a7fada..66db8dd8ec2670 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -607,14 +607,9 @@ static irqreturn_t sata_dwc_isr(int irq, void *dev_instance)
 	status = ap->ops->sff_check_status(ap);
 	dev_dbg(ap->dev, "%s ATA status register=0x%x\n", __func__, status);
 
-	tag = 0;
 	while (tag_mask) {
-		while (!(tag_mask & 0x00000001)) {
-			tag++;
-			tag_mask <<= 1;
-		}
-
-		tag_mask &= (~0x00000001);
+		tag = __ffs(tag_mask);
+		tag_mask &= ~(1U << tag);
 		qc = ata_qc_from_tag(ap, tag);
 		if (unlikely(!qc)) {
 			dev_err(ap->dev, "failed to get qc");
-- 
2.53.0



