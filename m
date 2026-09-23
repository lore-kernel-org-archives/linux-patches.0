Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3752B426D2E;
	Wed, 23 Sep 2026 14:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175057; cv=none; b=Hqc3qXwFYD+ezqBfILF7vtS35U/EcH8lcdpjRfnRoj2EEqoz9IHWugnJffbifboUBMtQUOSH5XoJEvMU5bF9jtZZdaY5/NuaxuqBCtS2EvGkx83lFWn+VidvN1U4SHnk1B54ktDfy8a3lBScbx6ZZnKGWViKWqHFj4f14jB/YFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175057; c=relaxed/simple;
	bh=ohlY1lUuMp8RbIMKMeq2dfEO/1LHmCaYD/8NhDZz/nI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=doQ/L1M4UhYluWPdCcxOh+H63FdfWLTYoelF6uL6H1awInjMlO2edPr6eQvPMUI4XvwYolpNRh/h3DDsKgRlWH7K0IXsOdEcOICIErCMKj8XkM6IRfWj93DxpW3lh5ia+uZsPE0AnYOW8H4gcu5bHG18NDG5Gy9yqEVSU28CwWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2jW5xJZM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2jW5xJZM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8C51F000FF;
	Wed, 23 Sep 2026 14:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175056;
	bh=fXLfOFUtUgnA1apRwDYfRwDzqVodnLZl0ZTgXJ0Lz3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2jW5xJZM+utKuIJCqRaPkDMOb//KqaY1hJeWt7AnSDWb4+Apc/ODK177tAe5zF5Zw
	 91X8TBMzTq0ipSYVis16AcqxvSkTGaRb0Vsy+reRXQWx5CMLYRENJCmVj77Xd4gbDg
	 6eYfJmRxkhqzKM8g9RaOt8NZ2tmsPkGCjPu873l8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Ling <zhuling0805@qq.com>,
	Shawn Lin <shawn.lin@linux.dev>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 281/398] mmc: core: Fix OF node reference leak on card add failure
Date: Wed, 23 Sep 2026 16:05:55 +0200
Message-ID: <20260923140650.699657985@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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
@@ -417,8 +417,8 @@ void mmc_remove_card(struct mmc_card *ca
 				mmc_hostname(card->host), card->rca);
 		}
 		device_del(&card->dev);
-		of_node_put(card->dev.of_node);
 	}
+	of_node_put(card->dev.of_node);
 
 	if (host->cqe_enabled) {
 		host->cqe_ops->cqe_disable(host);


