Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69841DF97D;
	Wed,  6 Nov 2024 12:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895762; cv=none; b=DOykNhVwAHz2l5LQhQQbbXMGVAma6R24OqodEvVjW+BeeO3rbShaUjCE94/bMpaPiOqei+ojq2k0l+TupwScKNvowFJbmQs31qfaT34NlNo62of6MWCaSO5hyjk25IMZNh4OMEVph4HbgBNrzawFx1553WSYBm21sI1Xp4qqC8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895762; c=relaxed/simple;
	bh=Nc+iGaeNRpJ992JRh1mM4qxA2P6ifloFVMyrQr9ALb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QOTvjzKRww14i80PFoN0qFtd2G/hlMrQXqL6/LoGt2OLIPC1DYKkvCyOZy7s6RuDTSWKDDBIt6dByTph7Rp+Yiw73iP7vcN+8mgj9Q+nEGbdFnqK2SZ94CeLHV+YJPWhkbXeWG8ykPDtKE060l11Rt6zLGXgzw4OE0ChIW48edk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hPxfRCB/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hPxfRCB/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47794C4CECD;
	Wed,  6 Nov 2024 12:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895762;
	bh=Nc+iGaeNRpJ992JRh1mM4qxA2P6ifloFVMyrQr9ALb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hPxfRCB/9/C5NcosHbXRpuO/T5KXjP8TAjaFPwtwz3joA5NALeJC+d63DCubnyHSt
	 SxBpPJCibgH6yvls5kY3tcjdakABp7o+qW+ym2MyOMw4/gSPxIuDD3kamo6CZ7fUDq
	 +84OmXUiJveH3VvJI46WfzuKY22gwTl/18g2OSHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 4.19 291/350] clk: Fix pointer casting to prevent oops in devm_clk_release()
Date: Wed,  6 Nov 2024 13:03:39 +0100
Message-ID: <20241106120328.019276092@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
@@ -16,7 +16,7 @@ struct devm_clk_state {
 
 static void devm_clk_release(struct device *dev, void *res)
 {
-	struct devm_clk_state *state = *(struct devm_clk_state **)res;
+	struct devm_clk_state *state = res;
 
 	if (state->exit)
 		state->exit(state->clk);


