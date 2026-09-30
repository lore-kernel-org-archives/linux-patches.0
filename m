Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3643B1016;
	Wed, 30 Sep 2026 18:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792130; cv=none; b=qqa3atZsRLPHQTKG2v5yQkKHiNP4RK1ls1RJau6sG719xr2iimliv1dsxbPY2FijtN2G2zaPoxkU8GZWz4X3wxSsg2OY6ReWgpEbBKxKvC/uokM1hniq2RyCRT0o8jlH6VZiRuQaA3LJGZsU6P8aDW93xr8EmXFD951NvNMswFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792130; c=relaxed/simple;
	bh=5teCyVbfCQ0AF30MmuDIag8kEptMM7OVGaOtoPVY5PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=km7NFfJv7bZQVUMdmd7qsczRVIvx89mjNDla9Fpdw0Q0ORqI6lbHP3wSfUUFxqwo+tA1Sj6yCCQ4421+uCn+9HhaetB385Jpr+OCX0U48t+XAAb+7E2khjl5YDrKeU0KpujdVMKH/H1vZBUbyPrkmI62DUXyleOpkr5p9SEhMtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h/8DG3gE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h/8DG3gE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C624C1F000FF;
	Wed, 30 Sep 2026 18:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792129;
	bh=BV6KRtOTWus2OGcE4ce1r0uUpv8GkGej6rM+5SFGScI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h/8DG3gEbIgL+qvxlRiL4xJsogQLJlCwXE5an4M28zpsYHzcO7EFpjttisq7TH1C6
	 s83qwWMoz2AuwuWHv1ZhyGBUE7B1OV5cOWmnZJ/Qj/RbMB4v702S3WVfbdE4w0Et73
	 fYT8P/IAL/xrH/YjfMt5X1PnZSFd3cErFtrdr2VQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Ling <zhuling0805@qq.com>,
	Shawn Lin <shawn.lin@linux.dev>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 5.15 545/752] mmc: core: Fix OF node reference leak on card add failure
Date: Wed, 30 Sep 2026 17:26:55 +0200
Message-ID: <20260930152410.039539140@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhu Ling <zhuling0805@qq.com>

commit 08b54e16d547d5c1aa61bf7a3595bb1620975eeb upstream.

mmc_of_find_child_device() returns a device node with its reference count
incremented. mmc_add_card() stores the reference before calling
device_add(), while the card is marked present only after device_add()
succeeds.

If device_add() fails, the callers release the card through
mmc_remove_card(). However, mmc_remove_card() only drops the OF node
reference for a present card, leaking the reference on this error path.

Move of_node_put() outside the present-card conditional so the reference
is released for both registered cards and card-add failures.

Fixes: 25185f3f31c9 ("mmc: Add SDIO function devicetree subnode parsing")
Cc: stable@vger.kernel.org
Signed-off-by: Zhu Ling <zhuling0805@qq.com>
Reviewed-by: Shawn Lin <shawn.lin@linux.dev>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/bus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -409,8 +409,8 @@ void mmc_remove_card(struct mmc_card *ca
 				mmc_hostname(card->host), card->rca);
 		}
 		device_del(&card->dev);
-		of_node_put(card->dev.of_node);
 	}
+	of_node_put(card->dev.of_node);
 
 	if (host->cqe_enabled) {
 		host->cqe_ops->cqe_disable(host);


