Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D6343D4F4
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301151; cv=none; b=BqdZswzGstHReWri8elVz2e2l2lORdryqA7JoxOVVZdQxlhUYgQzPndCxbUXOCa6PFSLs2UEM+nkqxPxzfPLYfbkkt56MWIg00o/gTXKAT+ouBdlXXmCtzHixtYAkNAGT4fB34JO0wyMtzI2vCAV0Ypq/lhMzpZStd1m/ZgoiuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301151; c=relaxed/simple;
	bh=NwjbWlJVFuM2LLQdrqo6HtOXS/ngQ5Uh0I5P+jPDxCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u27nKCxL5Y9PFdZQ41aKjfgMEGvGHhzH0gCEbtLx11beY7EPs/h+YlHrshLfjEYKtm/WeLoh4mCgopRTrXHgeG0wdlUj5I9t5BYtc3tIEHcqh7TGN8ul4eQ4OOTNpzcMp7wLs337jhr2I7fD1otu5mLap+l21FdBtfQwI2AgNrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CHiVZ348; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CHiVZ348"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20803C19425;
	Sat, 28 Feb 2026 17:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301151;
	bh=NwjbWlJVFuM2LLQdrqo6HtOXS/ngQ5Uh0I5P+jPDxCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CHiVZ348MBngE9/zSm7UclQMabfKKZ4R9bbeYwjkQxS3tyRR9Hcm106uWRwOjZEDu
	 iXAARyQpONbOqK3oav7jbjVSwTF7Mt53xHW7EAKRpz8+NkFlV68kxwVXOd0biiB5DV
	 cy/220+4vD2j2r4QQOHGwq+iaDWjLTu7CfZy6pd9RgIUd0YjgbzZVrv5vG2JRvP8P0
	 Q6IJtn+HxGWHZsNgHSsDNa4UaCGRl/3Yrbnb5SOoaiG3lB11aD2rWdp+K2RI2XJTRS
	 rkk+MAEDoi+c/O9I7GFHB9REivPFw70RS1FUQvStgfq7naRZuWkyLpyjIvaKyt6Yrg
	 5sbpkeFi76zWg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Otto=20Pfl=C3=BCger?= <otto.pflueger@abscue.de>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 314/752] mailbox: sprd: mask interrupts that are not handled
Date: Sat, 28 Feb 2026 12:40:25 -0500
Message-ID: <20260228174750.1542406-314-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Otto Pflüger <otto.pflueger@abscue.de>

[ Upstream commit 75df94d05fc03fd9d861eaf79ce10fbb7a548bd8 ]

To reduce the amount of spurious interrupts, disable the interrupts that
are not handled in this driver.

Signed-off-by: Otto Pflüger <otto.pflueger@abscue.de>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/sprd-mailbox.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/mailbox/sprd-mailbox.c b/drivers/mailbox/sprd-mailbox.c
index ee8539dfcef54..c1a5fe6cc8771 100644
--- a/drivers/mailbox/sprd-mailbox.c
+++ b/drivers/mailbox/sprd-mailbox.c
@@ -243,21 +243,19 @@ static int sprd_mbox_startup(struct mbox_chan *chan)
 		/* Select outbox FIFO mode and reset the outbox FIFO status */
 		writel(0x0, priv->outbox_base + SPRD_MBOX_FIFO_RST);
 
-		/* Enable inbox FIFO overflow and delivery interrupt */
-		val = readl(priv->inbox_base + SPRD_MBOX_IRQ_MSK);
-		val &= ~(SPRD_INBOX_FIFO_OVERFLOW_IRQ | SPRD_INBOX_FIFO_DELIVER_IRQ);
+		/* Enable inbox FIFO delivery interrupt */
+		val = SPRD_INBOX_FIFO_IRQ_MASK;
+		val &= ~SPRD_INBOX_FIFO_DELIVER_IRQ;
 		writel(val, priv->inbox_base + SPRD_MBOX_IRQ_MSK);
 
 		/* Enable outbox FIFO not empty interrupt */
-		val = readl(priv->outbox_base + SPRD_MBOX_IRQ_MSK);
+		val = SPRD_OUTBOX_FIFO_IRQ_MASK;
 		val &= ~SPRD_OUTBOX_FIFO_NOT_EMPTY_IRQ;
 		writel(val, priv->outbox_base + SPRD_MBOX_IRQ_MSK);
 
 		/* Enable supplementary outbox as the fundamental one */
 		if (priv->supp_base) {
 			writel(0x0, priv->supp_base + SPRD_MBOX_FIFO_RST);
-			val = readl(priv->supp_base + SPRD_MBOX_IRQ_MSK);
-			val &= ~SPRD_OUTBOX_FIFO_NOT_EMPTY_IRQ;
 			writel(val, priv->supp_base + SPRD_MBOX_IRQ_MSK);
 		}
 	}
-- 
2.51.0

