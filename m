Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9224F3F20FA;
	Wed, 20 May 2026 17:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299353; cv=none; b=jMPI+kmSIc4S/+dmGDuxDAX/iUCYSWGT+8gGp5MXOFlDFcxD0Gbem2MZZR8y1uaF++eTByt9gGAjJ1qN/2iWwWHeop13sxz1FcbfW/XT0gr4tGM212+YHzTTiYm8dYpqWPL4A4PkizL2K6tObwT0auwyCwQYkFjYgRdAk7wrXRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299353; c=relaxed/simple;
	bh=fsCbya3z+6RjHKUnDSQZznLRga0qnx01sZ+RO2PFfHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rx+0XRVCkaDOmY20E+VyGRt24XQFMh3Tpu7AD4Z/6bxW2IzopVEcRzx6jFj9S8snGFyY1Ma/7kdyqqViVSlCa78WPPDfhnwrxCGlLmrUFnsTh7ZYwoyxGxcxYUs0Si2vUU3W2Ty7ZZppPsxSkgE7g7g013LAubNz2K1ixzi9QF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QhaaWlPk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QhaaWlPk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153121F000E9;
	Wed, 20 May 2026 17:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299350;
	bh=CI9O1GpfPa0ODSFhN/C2QaZb+jx94c78U+OyEvm+vkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QhaaWlPkgWl8At7Rr6fXdosdRWY/npCdocLxCGAvigiNRRIQMGkcDNDt2kQErYdyd
	 Z4NKrK/OV5b5yCbjYbbcAGBwTBCZxAd3btIKPdEY/5jUTogldiuZ6SfVok9cXAJjyb
	 vhm0FdUo9/e7K1/p7HgM6mfp7IwxiOrBldbyzSjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 738/957] mailbox: mailbox-test: initialize struct earlier
Date: Wed, 20 May 2026 18:20:21 +0200
Message-ID: <20260520162150.564704819@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index 210f6077f475c..a0a7908c9cc26 100644
--- a/drivers/mailbox/mailbox-test.c
+++ b/drivers/mailbox/mailbox-test.c
@@ -366,6 +366,12 @@ static int mbox_test_probe(struct platform_device *pdev)
 	if (!tdev)
 		return -ENOMEM;
 
+	tdev->dev = &pdev->dev;
+	spin_lock_init(&tdev->lock);
+	mutex_init(&tdev->mutex);
+	init_waitqueue_head(&tdev->waitq);
+	platform_set_drvdata(pdev, tdev);
+
 	/* It's okay for MMIO to be NULL */
 	tdev->tx_mmio = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
 	if (PTR_ERR(tdev->tx_mmio) == -EBUSY) {
@@ -395,12 +401,6 @@ static int mbox_test_probe(struct platform_device *pdev)
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
@@ -414,7 +414,6 @@ static int mbox_test_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_free_chans;
 
-	init_waitqueue_head(&tdev->waitq);
 	dev_info(&pdev->dev, "Successfully registered\n");
 
 	return 0;
-- 
2.53.0



