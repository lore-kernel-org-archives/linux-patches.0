Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C901317C9;
	Thu, 15 Aug 2024 00:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723683322; cv=none; b=kp4lEDu3QkpObxRpgmyNwx1SVE4SUM03OFhvoK2+ZglYsymc2OMDs523P5SXIVrWd0l2c8+wVt/b/HXXh7A02a6S4Pw4lcHllpsoM1FZDwA3Ry4n5UUeGtHNdkAldcaeXKoHZl9uZpD4iZ4zn3xv3cQ43f88T2fCuM/7dwrAQ1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723683322; c=relaxed/simple;
	bh=E6GsvcugWdwE3j2MGg8isjW5X4BIFzTI3KQjqfhME5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LLNMjIll4Qq3t2xAL1T0rPayJHJojMZ8KYy3IgR0F6fJ7QVO/upRv2s8DAmWrsngNc6sAeGUFlvTRlV9DS3u6DSYF15U3+NmRA9uktle+XkyQPCDiPtBXwLwf9CY3dGgdXT4qOt2Fk47HOLxFOqv9X2mO3CpLuRX3ywVIGfCqKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WGU1+dlZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WGU1+dlZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89F1C4AF0B;
	Thu, 15 Aug 2024 00:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723683322;
	bh=E6GsvcugWdwE3j2MGg8isjW5X4BIFzTI3KQjqfhME5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WGU1+dlZOR0Iftx6+ZCP/6QyznKCgpF/x6hyX4uGaBDZKBCaK9XYlsCj/q55msETM
	 nSNu0cGnavucJJR5XPpiqH8APnDH6X7QLSpj7Cw93dvIa4Q5N0Fpnyx5bdw4oh4JPg
	 HTD97Cys/ujGV/n2GNKAJK1Ks/9c5p3olmc19dxkmii0/ipAb4GYmsuU2yK+KNCTb2
	 NTjm1fHKGIEzZugpEWCrApyPmbTBxokkUfwFz+1IzX/f9fNP6sx+c/p7U3h0gK2zsz
	 x0MqL+wGw8bwebuYzIzlO8oRVPXFXV8bZhYgy/Ol5exbZ769JHLmdmukLZS/1FoGbj
	 MqEnZoJagwMYA==
From: Stephen Boyd <sboyd@kernel.org>
To: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>
Cc: =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 01/12] clk: Fix clk not being unlinked from consumers list
Date: Wed, 14 Aug 2024 17:55:07 -0700
Message-ID: <20240815005520.1192374-2-sboyd@kernel.org>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
In-Reply-To: <20240815005520.1192374-1-sboyd@kernel.org>
References: <20240815005520.1192374-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nuno Sá <nuno.sa@analog.com>

When a clk_hw is registered we add a struct clk handle to it's
consumers list. This handle is created in '__clk_register()' per the
'alloc_clk()' call.

As such, we need to remove this handle when unregistering the
clk_hw. This can actually lead to a use after free if a provider gets
removed before a consumer. When removing the consumer, '__clk_put()' is
called and that will do 'hlist_del(&clk->clks_node)' which will touch in
already freed memory.

Fixes: 1df4046a93e0 ("clk: Combine __clk_get() and __clk_create_clk()")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20240710-dev-clk-misc-v1-1-cd9d960099a2@analog.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/clk/clk.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 285ed1ad8a37..f5415aa70f81 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -4606,6 +4606,8 @@ void clk_unregister(struct clk *clk)
 	if (clk->core->protect_count)
 		pr_warn("%s: unregistering protected clock: %s\n",
 					__func__, clk->core->name);
+
+	clk_core_unlink_consumer(clk);
 	clk_prepare_unlock();
 
 	kref_put(&clk->core->ref, __clk_release);
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

