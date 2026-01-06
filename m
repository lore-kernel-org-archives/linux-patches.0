Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773F73644AD;
	Tue,  6 Jan 2026 17:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722001; cv=none; b=a3QwJcj8cFyGoSjuPePxIkep3jiLSI7REFRxcNvwdY0tpxoGK4gm+7jgSNjvWxKGxADKfj6YyWNHLElv8o6/jr+sGg0+t5Cccc2kuhL/wC/4laZZikZFhTsChTbE6UD3s/xDS9IL/mYNZOE5EdQoSNGeC4E+gyqvxpfq0HOKapg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722001; c=relaxed/simple;
	bh=YXYa3DlS535JIXYY58Po6ptG3xXC53Zsw9ldtZQ4UoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUAjf4sP+4lizx6JAuiTxPe5cUKDnJ1a7NwCvLhlbYG3uLFRoMUQUHQnCfhv6MAiWplzdCDMAg2wWywqzY5jT1RJCqBOkGXj1ZUwY2ki2hDdZwkwdiLnEtZxOUDB5yZtqP03s+8ky3/FRSAQVEiKG3IQT+xEwBxtKJda8oHYqlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y2G/0iHb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y2G/0iHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2EA3C16AAE;
	Tue,  6 Jan 2026 17:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722001;
	bh=YXYa3DlS535JIXYY58Po6ptG3xXC53Zsw9ldtZQ4UoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y2G/0iHb1VUC1ZMHP4HI5q/JAm8rp1XNc19atEWNZDqd84fEj72zsJ1SKLTWronQJ
	 8POzwL+sR6KThpAjSC52kgqdbkTS/TDfYL3Oh+elvmrbuvzEBULS2wlf+gQ3gJfvyc
	 0DKxegOF2tZhvJGNQGUS8t5o5zlEjIkAP2UR+cmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jochen Sprickerhof <jochen@sprickerhof.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Sam Protsenko <semen.protsenko@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.18 136/312] clk: samsung: exynos-clkout: Assign .num before accessing .hws
Date: Tue,  6 Jan 2026 18:03:30 +0100
Message-ID: <20260106170552.762010161@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

commit cf33f0b7df13685234ccea7be7bfe316b60db4db upstream.

Commit f316cdff8d67 ("clk: Annotate struct clk_hw_onecell_data with
__counted_by") annotated the hws member of 'struct clk_hw_onecell_data'
with __counted_by, which informs the bounds sanitizer (UBSAN_BOUNDS)
about the number of elements in .hws[], so that it can warn when .hws[]
is accessed out of bounds. As noted in that change, the __counted_by
member must be initialized with the number of elements before the first
array access happens, otherwise there will be a warning from each access
prior to the initialization because the number of elements is zero. This
occurs in exynos_clkout_probe() due to .num being assigned after .hws[]
has been accessed:

  UBSAN: array-index-out-of-bounds in drivers/clk/samsung/clk-exynos-clkout.c:178:18
  index 0 is out of range for type 'clk_hw *[*]'

Move the .num initialization to before the first access of .hws[],
clearing up the warning.

Cc: stable@vger.kernel.org
Fixes: f316cdff8d67 ("clk: Annotate struct clk_hw_onecell_data with __counted_by")
Reported-by: Jochen Sprickerhof <jochen@sprickerhof.de>
Closes: https://lore.kernel.org/aSIYDN5eyKFKoXKL@eldamar.lan/
Tested-by: Jochen Sprickerhof <jochen@sprickerhof.de>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Kees Cook <kees@kernel.org>
Reviewed-by: Sam Protsenko <semen.protsenko@linaro.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/samsung/clk-exynos-clkout.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/samsung/clk-exynos-clkout.c
+++ b/drivers/clk/samsung/clk-exynos-clkout.c
@@ -175,6 +175,7 @@ static int exynos_clkout_probe(struct pl
 	clkout->mux.shift = EXYNOS_CLKOUT_MUX_SHIFT;
 	clkout->mux.lock = &clkout->slock;
 
+	clkout->data.num = EXYNOS_CLKOUT_NR_CLKS;
 	clkout->data.hws[0] = clk_hw_register_composite(NULL, "clkout",
 				parent_names, parent_count, &clkout->mux.hw,
 				&clk_mux_ops, NULL, NULL, &clkout->gate.hw,
@@ -185,7 +186,6 @@ static int exynos_clkout_probe(struct pl
 		goto err_unmap;
 	}
 
-	clkout->data.num = EXYNOS_CLKOUT_NR_CLKS;
 	ret = of_clk_add_hw_provider(clkout->np, of_clk_hw_onecell_get, &clkout->data);
 	if (ret)
 		goto err_clk_unreg;


