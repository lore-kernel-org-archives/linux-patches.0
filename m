Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25443229
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F21FC433D2;
	Mon, 30 Jan 2023 14:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088815;
	bh=PTAN08f624d61xpyE0rHVMlxXktCuUz+QiffyKAkUKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vWY2XjCsBpN7jATjFfPFIohtB7xkxl5roR67QpwHwJtAjAgTZNEydtXoOQZj4lSQG
	 M6i96ZY6GX8xBByxTD0Y7PsUS3CmdSLOQrcvHizkkwjjwf/9FRH4ugrUB6KBMrmobg
	 4srUB+VCf/3nk5g85Oopg2yzZoiF+FLwgK607mHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.10 143/143] clk: Fix pointer casting to prevent oops in devm_clk_release()
Date: Mon, 30 Jan 2023 14:53:20 +0100
Message-Id: <20230130134312.771064196@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

commit 8b3d743fc9e2542822826890b482afabf0e7522a upstream.

The release function is called with a pointer to the memory returned by
devres_alloc(). I was confused about that by the code before the
generalization that used a struct clk **ptr.

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Fixes: abae8e57e49a ("clk: generalize devm_clk_get() a bit")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20220620171815.114212-1-u.kleine-koenig@pengutronix.de
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/clk-devres.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/clk-devres.c
+++ b/drivers/clk/clk-devres.c
@@ -11,7 +11,7 @@ struct devm_clk_state {
 
 static void devm_clk_release(struct device *dev, void *res)
 {
-	struct devm_clk_state *state = *(struct devm_clk_state **)res;
+	struct devm_clk_state *state = res;
 
 	if (state->exit)
 		state->exit(state->clk);


