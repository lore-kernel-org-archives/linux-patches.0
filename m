Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63FC13DBBF;
	Tue, 27 Feb 2024 13:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041777; cv=none; b=MWLOZa7UO0CnjeXlwUDiEG0tZCH8YnsOZ9qWMdBIlxrgbOdrpvuwStjrGyEnjLQ/f2RPniW6refcfAtL7A3w41dB8Een24KE29hAhv1loyObA17uxbBCZlaZ2f6M6xxvCIdCX7Hjb0icI8XXFQLlTg4z7v7cO7PDeoixx4MCvhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041777; c=relaxed/simple;
	bh=KnYepcWCw0+7eILqROQjAR2/StHgSqiOtaND8rCMSNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AeZlGLCQg9HJbGgFtCglBVXAhlUkyRI6YndM0FmBBR1wrXg5m2aXmByU0QRg+AFaTDBcYO0zHAtGfNtjnTobjKHDXnSFReW1t5GLXWLs0E/U5zaby7K1HEkteMLsu851gK4hkyJ5pPdd9HUGSXh3EX8zglnpw/+FvDhxat5Xttk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BUBBHgfP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BUBBHgfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0240C433F1;
	Tue, 27 Feb 2024 13:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041777;
	bh=KnYepcWCw0+7eILqROQjAR2/StHgSqiOtaND8rCMSNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BUBBHgfP0IGfRYMUiBtIrTRqayRa+NwNSWqyu7zAhIgwF4wfaIyWuxbV9eImj/KY1
	 EHCWoy+KHREK62F6jmiAfdkyAvmRPZnSiP5WOC5CsJTOsBj+VAJpVdLyXvm1mIPyKF
	 bGpBM64KFJgIHmHM7+pc6lk8mV+9sLvaQKC2rET0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 037/299] dmaengine: ti: edma: Add some null pointer checks to the edma_probe
Date: Tue, 27 Feb 2024 14:22:28 +0100
Message-ID: <20240227131627.174250117@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Kunwu Chan <chentao@kylinos.cn>

[ Upstream commit 6e2276203ac9ff10fc76917ec9813c660f627369 ]

devm_kasprintf() returns a pointer to dynamically allocated memory
which can be NULL upon failure. Ensure the allocation was successful
by checking the pointer validity.

Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Link: https://lore.kernel.org/r/20240118031929.192192-1-chentao@kylinos.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/edma.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/dma/ti/edma.c b/drivers/dma/ti/edma.c
index 33d6d931b33bb..155c409d2b434 100644
--- a/drivers/dma/ti/edma.c
+++ b/drivers/dma/ti/edma.c
@@ -2404,6 +2404,11 @@ static int edma_probe(struct platform_device *pdev)
 	if (irq > 0) {
 		irq_name = devm_kasprintf(dev, GFP_KERNEL, "%s_ccint",
 					  dev_name(dev));
+		if (!irq_name) {
+			ret = -ENOMEM;
+			goto err_disable_pm;
+		}
+
 		ret = devm_request_irq(dev, irq, dma_irq_handler, 0, irq_name,
 				       ecc);
 		if (ret) {
@@ -2420,6 +2425,11 @@ static int edma_probe(struct platform_device *pdev)
 	if (irq > 0) {
 		irq_name = devm_kasprintf(dev, GFP_KERNEL, "%s_ccerrint",
 					  dev_name(dev));
+		if (!irq_name) {
+			ret = -ENOMEM;
+			goto err_disable_pm;
+		}
+
 		ret = devm_request_irq(dev, irq, dma_ccerr_handler, 0, irq_name,
 				       ecc);
 		if (ret) {
-- 
2.43.0



