Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F411D5CCD;
	Thu, 17 Apr 2025 18:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915899; cv=none; b=MxKdk0pRz+N7HdFgkhAb6Xash5VVLkdHpQz+rwvf5Zav4CZuifhUl4sGeFKvtEFv6Z416Y2tImtLZnU6jowSkUxgYAC5BOFqHMDZzqpWImO7pjlyyg8Qvd+HYOXf2QqkvBSqEnnsWbKV2hjQaiLqpN3ncyJaRhyaHMIM/uZ4BAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915899; c=relaxed/simple;
	bh=IqTVkdzl/A1f68/WVvJkAaC9jAZIMtSTnZlAye6CTfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DtlonjpWCb6fFx9DwEaAiC5trsVeOrQQs1A5TNso6CEBrz1wpYl+gRNE7ut/30pVwz2RjKfayDjMrtshcV0JS5FKVMyEzpjNj13lNa5ZyJM0O/sp1EpK4ol8zFksXQWE5FnoEdpRx26DlbBEw5by9DCDCs+7HPmy4qXKJnqVXu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ICwq+XCJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ICwq+XCJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96171C4CEE7;
	Thu, 17 Apr 2025 18:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915899;
	bh=IqTVkdzl/A1f68/WVvJkAaC9jAZIMtSTnZlAye6CTfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ICwq+XCJLoXkBEGxVA2Ex13ICgVL6uYHbBnyikjybTMoZAZgVhg5Uzps+gt5hYnTE
	 pt1qVb2Gm8tqUMCN6x/71Ltt+jstR1fMve1mahFUVwRnr1Xbrl8SyCLNvEhcLs5pzl
	 7Vf+xqunr6tAmJvthacb3hYnZqn0WY6jztQNKztE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Chenyuan Yang <chenyuan0y@gmail.com>
Subject: [PATCH 6.12 276/393] mfd: ene-kb3930: Fix a potential NULL pointer dereference
Date: Thu, 17 Apr 2025 19:51:25 +0200
Message-ID: <20250417175118.713066412@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Chenyuan Yang <chenyuan0y@gmail.com>

commit 4cdf1d2a816a93fa02f7b6b5492dc7f55af2a199 upstream.

The off_gpios could be NULL. Add missing check in the kb3930_probe().
This is similar to the issue fixed in commit b1ba8bcb2d1f
("backlight: hx8357: Fix potential NULL pointer dereference").

This was detected by our static analysis tool.

Cc: stable@vger.kernel.org
Fixes: ede6b2d1dfc0 ("mfd: ene-kb3930: Add driver for ENE KB3930 Embedded Controller")
Suggested-by: Lee Jones <lee@kernel.org>
Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Link: https://lore.kernel.org/r/20250224233736.1919739-1-chenyuan0y@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/ene-kb3930.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mfd/ene-kb3930.c
+++ b/drivers/mfd/ene-kb3930.c
@@ -162,7 +162,7 @@ static int kb3930_probe(struct i2c_clien
 			devm_gpiod_get_array_optional(dev, "off", GPIOD_IN);
 		if (IS_ERR(ddata->off_gpios))
 			return PTR_ERR(ddata->off_gpios);
-		if (ddata->off_gpios->ndescs < 2) {
+		if (ddata->off_gpios && ddata->off_gpios->ndescs < 2) {
 			dev_err(dev, "invalid off-gpios property\n");
 			return -EINVAL;
 		}


