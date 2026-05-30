Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8134633F5A0;
	Sat, 30 May 2026 17:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161926; cv=none; b=Jp+5jWVdk5J57YHow1uwE93W0n6mmd5FOKEPXlATozFjn9hqxC60yjjJSL/19vZjRHpC5hTTNM5/sJDp+47ElzfHRq1o5f/Jip/6sXCwjdtuVxVFvhEsJx7fF/qiYuMpULT2H2t7Ovl9u9se5P/7y7kn3j1BifBa55jyhgb0VwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161926; c=relaxed/simple;
	bh=a/O2d0Kw6dGfueEckSUwWXhuoSAvi9brAQKCiA+RePQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NY3aL0+F/hqzCenlJLrre5WUOJIjjIPAG+CIZXkoK9JEfLeEh1wWwR3aU8YeIeAGKegYjMuy58mQ4LGdOT+R/Dw/ROIiZYBpVLzq4GYNketM+QAejg8PNHvOHnQAoYayxEdUwGktJZ6ZwqynX3LuDBIrTHbGOGEuXZVbxpBt71Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z19wRhBE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z19wRhBE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53541F00893;
	Sat, 30 May 2026 17:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161925;
	bh=PuSV25+5XAABN5zNVDYuJhdKpELY35qbHB1LIVxgveo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z19wRhBEnoqaFYyxp+UocC7SbH/8hGd7DIMAG2iaUyQiR8dE/Ntyfxlk5sXAdtpIz
	 iSsN734fcMaaJDDtFQDqBF82OVcBqA46F/VdJoiChK4OJQWrDlU70yJ43ST5K4Tchy
	 e7VrVYnvKdvpzvP4s8wR0mn9A0oeI42UJDUXKfj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 729/969] mailbox: mailbox-test: initialize struct earlier
Date: Sat, 30 May 2026 18:04:13 +0200
Message-ID: <20260530160320.673416136@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit bbcf9af68bfedb3d9cc3c7eae62f5c844d8b78b9 ]

The waitqueue must be initialized before the debugfs files are created
because from that time, requests from userspace can already be made.
Similarily, drvdata and spinlock needs to be initialized before we
request the channel, otherwise dangling irqs might run into problems
like a NULL pointer exception.

Fixes: 8ea4484d0c2b ("mailbox: Add generic mechanism for testing Mailbox Controllers")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox-test.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/mailbox/mailbox-test.c b/drivers/mailbox/mailbox-test.c
index 247e83af060e3..41efe64976598 100644
--- a/drivers/mailbox/mailbox-test.c
+++ b/drivers/mailbox/mailbox-test.c
@@ -365,6 +365,12 @@ static int mbox_test_probe(struct platform_device *pdev)
 	if (!tdev)
 		return -ENOMEM;
 
+	tdev->dev = &pdev->dev;
+	spin_lock_init(&tdev->lock);
+	mutex_init(&tdev->mutex);
+	init_waitqueue_head(&tdev->waitq);
+	platform_set_drvdata(pdev, tdev);
+
 	/* It's okay for MMIO to be NULL */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	tdev->tx_mmio = devm_ioremap_resource(&pdev->dev, res);
@@ -396,12 +402,6 @@ static int mbox_test_probe(struct platform_device *pdev)
 	if (!tdev->rx_channel && (tdev->rx_mmio != tdev->tx_mmio))
 		tdev->rx_channel = tdev->tx_channel;
 
-	tdev->dev = &pdev->dev;
-	platform_set_drvdata(pdev, tdev);
-
-	spin_lock_init(&tdev->lock);
-	mutex_init(&tdev->mutex);
-
 	if (tdev->rx_channel) {
 		tdev->rx_buffer = devm_kzalloc(&pdev->dev,
 					       MBOX_MAX_MSG_LEN, GFP_KERNEL);
@@ -415,7 +415,6 @@ static int mbox_test_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_free_chans;
 
-	init_waitqueue_head(&tdev->waitq);
 	dev_info(&pdev->dev, "Successfully registered\n");
 
 	return 0;
-- 
2.53.0



