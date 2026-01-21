Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0ED628312F;
	Wed, 21 Jan 2026 18:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020518; cv=none; b=jwTS5k5fYDXBvE5HM6mjWW/58eJkUg4TzLL2XbCUy5mKziIvZIk7JkFSTCQaARmVQJPz6HQ2eZdyER9iOW9yA7llP6Qb1aupWmkbVctjErQ0YGk1SAAPxzIbPYdFwByhRiCXmlqi6jCFhyZMC2FSmG8pBvnYZqv1iWFjBaj5g2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020518; c=relaxed/simple;
	bh=qteJBztG0gXAgGoBC/l5iVlww9ueTTLYq5UjJns9Sws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Acnf79/wEnhbrE3EuytkrzHJ1Fi0TEMCOktXgCCO37Sr5trBEmSNMnQPH8rfABc6aH2Pz1QiE7p6kHz7HQrFSk1xL0QPXWvbTHVmWJ2kg8oLHQR+odqw2CEVO+mSNQJ/fm67pdVioyoK94HTa9WoRvZcjD3H0wgNFyNzitVdN9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UBPRrjWG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UBPRrjWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BFEBC19422;
	Wed, 21 Jan 2026 18:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020518;
	bh=qteJBztG0gXAgGoBC/l5iVlww9ueTTLYq5UjJns9Sws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UBPRrjWGT7ighWDSDAeeEnB2CqKFyo6Xf6YwXmki9Ipu05QXhW4T6vUbtfjxYP9lt
	 7OYw1KWLpu/2Hn/9oa/deFsl6xScghWxRWy3EbbiPbgZ4A01bCqrGTXpsH0DUqjKq+
	 dMxLNLLg3cmeHkt9O66JFV0chppzy7EKz34RGph4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grygorii Strashko <grygorii.strashko@ti.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Johan Hovold <johan@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.18 183/198] dmaengine: ti: k3-udma: fix device leak on udma lookup
Date: Wed, 21 Jan 2026 19:16:51 +0100
Message-ID: <20260121181425.137823421@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 430f7803b69cd5e5694e5dfc884c6628870af36e upstream.

Make sure to drop the reference taken when looking up the UDMA platform
device.

Note that holding a reference to a platform device does not prevent its
driver data from going away so there is no point in keeping the
reference after the lookup helper returns.

Fixes: d70241913413 ("dmaengine: ti: k3-udma: Add glue layer for non DMAengine users")
Fixes: 1438cde8fe9c ("dmaengine: ti: k3-udma: add missing put_device() call in of_xudma_dev_get()")
Cc: stable@vger.kernel.org	# 5.6: 1438cde8fe9c
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20251117161258.10679-17-johan@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/ti/k3-udma-private.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/ti/k3-udma-private.c
+++ b/drivers/dma/ti/k3-udma-private.c
@@ -42,9 +42,9 @@ struct udma_dev *of_xudma_dev_get(struct
 	}
 
 	ud = platform_get_drvdata(pdev);
+	put_device(&pdev->dev);
 	if (!ud) {
 		pr_debug("UDMA has not been probed\n");
-		put_device(&pdev->dev);
 		return ERR_PTR(-EPROBE_DEFER);
 	}
 


