Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF2C4A8430;
	Wed, 30 Sep 2026 17:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788712; cv=none; b=CkF80XjF5GPiVfeEpaGYgTMmRY0T3vVmKbVohSdFMcLPt3F8+0g2Up6ZGwvuMmtUT52fBbhf4prop23mAxdK+3bEuEm9dytVz8GV9yuk+xzE5vtyYdMH7cbE7IaerwXElKcXLnPTmzxj2Nm8cBFJUN7EJkrtsMC5C/uObXqDKQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788712; c=relaxed/simple;
	bh=Q/+2pgxQI2gUnQsvaNrXp/xzETl8VspKvUSDxPulGdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TXfC/5RVoQfW80cxU3ZfRUf5fisrBCwwit6JAepJAIU36wC5Zdc7Ssg6+Jl0xJhWlD/hftj3w8FShF34tr+yseTWCz9VbzfAV66s3GuxJbpkkMTGDDgW+U9RNwkRpe1N9cvDnKdQbKsyA5Fhsh3J8JJgw8TtqTH4C/n31L4Qoks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tf8agtqt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tf8agtqt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C8C1F000FF;
	Wed, 30 Sep 2026 17:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788710;
	bh=mHqxUR1yn6PqLdg9hY48mWH2U7czvpIB7AtfLNnFT+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tf8agtqt6S9J6yRRFA00MnwMLXH3h7zwqqH0mdac4PClivmPt0O8eUZGdndH1RXsL
	 j+OyLOTnJwMWyHpvfQK+Dx5+NGloJw2JiWbGFRh30YbSPLbkHNWDnTYrERhmTnt1Fa
	 DW2o4S2v1Lj0v/xIRSq5ftYvA9Uv1TDVCCjPw2ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Ling <zhuling0805@qq.com>,
	Shawn Lin <shawn.lin@linux.dev>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.12 222/877] mmc: core: Fix OF node reference leak on card add failure
Date: Wed, 30 Sep 2026 17:18:53 +0200
Message-ID: <20260930152419.519126917@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -399,8 +399,8 @@ void mmc_remove_card(struct mmc_card *ca
 				mmc_hostname(card->host), card->rca);
 		}
 		device_del(&card->dev);
-		of_node_put(card->dev.of_node);
 	}
+	of_node_put(card->dev.of_node);
 
 	if (host->cqe_enabled) {
 		host->cqe_ops->cqe_disable(host);


