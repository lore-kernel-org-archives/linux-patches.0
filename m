Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DA3511E66;
	Wed, 30 Sep 2026 15:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783569; cv=none; b=CZpKZs6oH4NNwiqURT3oJRmSA7+jqOB+/YxbnRHmGBg5xxborPU2TtASNvigO3He9NM03ztM8OqmP6a2n7Xn1Or4Rb6Cfv859rimL8XVjh1Rvmjse86qWAbNfprPJv6SRuOm2ukDRH1Hj7WW6BPpLtAr5pXrazS1+1Rx2RBuF50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783569; c=relaxed/simple;
	bh=BAN5Peees2Ecesjs6o7LNxQg3Dzp/nQssKendOJyWLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lkiO0BJ3FdK2uhWHsryJ2L4QjAuPCdygnLWhQIKsPqw6q4l+xpROV1hbr0cz355YoTDJllHIGyO/Qvh9vP9FJ1lRFHLgewzQDVtx6JexFuEHoFvokUGBnH6AiVAlwkUHH2pBSzYWheTOUt6UbM39sohSvwlFOCtvh7Pa9X5ma28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T/5JsyRT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T/5JsyRT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773901F000FF;
	Wed, 30 Sep 2026 15:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783563;
	bh=MuBYkejqEyr1R5Q3lOd2rCoNxZRAHRdq7ZOIHoQLlgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T/5JsyRThnw71d/TtsrKRZGQUEAxQHNmY/gh0uHxVKv4Ir8FbEpAtFG9k4XtpwOkn
	 w7JnqOSMZY0dEYPk/unjSjreGv+eL96ScN83IhQloPyG54wnPX79xL8GM0oGu4XX1p
	 KZMaVUTpJq7Dn/HEVMPcUYUPsk2aDyFDfRas7AP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Ling <zhuling0805@qq.com>,
	Shawn Lin <shawn.lin@linux.dev>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 5.10 441/595] mmc: core: Fix OF node reference leak on card add failure
Date: Wed, 30 Sep 2026 17:25:34 +0200
Message-ID: <20260930152357.166501308@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -410,8 +410,8 @@ void mmc_remove_card(struct mmc_card *ca
 				mmc_hostname(card->host), card->rca);
 		}
 		device_del(&card->dev);
-		of_node_put(card->dev.of_node);
 	}
+	of_node_put(card->dev.of_node);
 
 	if (host->cqe_enabled) {
 		host->cqe_ops->cqe_disable(host);


