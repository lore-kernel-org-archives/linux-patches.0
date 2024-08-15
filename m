Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B3122066;
	Thu, 15 Aug 2024 00:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723683326; cv=none; b=H2jPwD21WFlu4S0ZuzGUC/r8ZtJgKpMdFvsdiQr1VWYybBAJsi8nWj0BxqInLyI8N5IWh0lkj38VSEDGM31kylQeUxro++Ymz4C5vWDvkJHJSGDQmy7zsLx5cQGoY47ySB3mMJYQ922OKZPOcgEHNgzaGFoA5y9RjtiPCSbL+x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723683326; c=relaxed/simple;
	bh=pGnw6NjZ5xmeS+E6bWsQ7R8PsJMyNZclyOz9tTfAZqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pX91KvlqtPvumpBrVR8/C+HqmQ4T/DizUw/6FgX0NVijVacS49DDuhH7yHeMysXC+jOoWC5RPKZS6DqHeJfLSQ4w6eKOLTUvQKjGzweapTCym9BfIIYtBWBk0ZrFAYv6TNNOibIf5ffEDHKkmhceVFQrSzGT+JHcMu4AyGWY7Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c7xA9zSe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c7xA9zSe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D04C4AF14;
	Thu, 15 Aug 2024 00:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723683325;
	bh=pGnw6NjZ5xmeS+E6bWsQ7R8PsJMyNZclyOz9tTfAZqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c7xA9zSeEVEYyILl5b9Q/IuEg7xFY0PmvwGQxfRR9aOGgVGi7dcPkBWN/HSlZqHoY
	 dcnQnkO0tsS3QRzHDJWLVwkHTc207lhkS2zqfDPOeEFQsXCcJZ7XVCz9yycoSSUuUG
	 Vwu3ViEhmCzhz4qbB0uZ9B2JRmGfFqhfbuGxTbF2BaFv1OcAXXcXdSt70ODHZcIszC
	 CCsWsMQE493NP88okqRi4Z8TfBYs7n3vxcZ5ok+bicyFT6IRGc/yqqVt08PsQlx1l2
	 hsfxeWg+GzZaJjDcADv6vrRtOSGMc+f9ucEBYo8p5v5SqYRfzHw8P42S5xbZqhaNsH
	 mCzIGz1ofaaZg==
From: Stephen Boyd <sboyd@kernel.org>
To: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>
Subject: [PATCH 07/12] clk: Fail duty cycle APIs after clk_hw is unregistered
Date: Wed, 14 Aug 2024 17:55:13 -0700
Message-ID: <20240815005520.1192374-8-sboyd@kernel.org>
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

The clk duty cycle APIs don't fail when a clk_hw is unregistered. Add a
nodrv clk_op that returns failure so that clk_set_duty_cycle() starts
failing after a clk_hw is unregistered.

Cc: Nuno Sá <nuno.sa@analog.com>
Fixes: 9fba738a53dd ("clk: add duty cycle support")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/clk/clk.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 8909294cc52e..a0c275e156ad 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -4518,6 +4518,11 @@ static int clk_nodrv_set_phase(struct clk_hw *hw, int degrees)
 	return -ENXIO;
 }
 
+static int clk_nodrv_set_duty_cycle(struct clk_hw *hw, struct clk_duty *duty)
+{
+	return -ENXIO;
+}
+
 static const struct clk_ops clk_nodrv_ops = {
 	.enable		= clk_nodrv_prepare_enable_get_phase,
 	.disable	= clk_nodrv_disable_unprepare,
@@ -4528,6 +4533,7 @@ static const struct clk_ops clk_nodrv_ops = {
 	.set_parent	= clk_nodrv_set_parent,
 	.get_phase	= clk_nodrv_prepare_enable_get_phase,
 	.set_phase	= clk_nodrv_set_phase,
+	.set_duty_cycle	= clk_nodrv_set_duty_cycle,
 };
 
 static void clk_core_evict_parent_cache_subtree(struct clk_core *root,
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

