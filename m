Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1B13176E4;
	Fri,  9 Jan 2026 12:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961005; cv=none; b=SmrhNJXjrOTiQKW2Z7K7C+zEZgqS/fuuE7WQsGq9Cc/6wtS2VsOBbLyFnwouMExJDnmF7rEvzwHF0bfKLq1ia+xDWcsPFD/z0sriLhiVzz7hPpFzCmGK+tnSxquiXmg382KlEMF1Q3NsKfaH1l7TDHZVA/iwfhtYX3G67QUCDfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961005; c=relaxed/simple;
	bh=vXhdU9KhzkxU80rFHsB7Ez2cnyOIcz3Y1JWSFNuVkLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJxBv6hbavsWG2A57aUyawy8+BeY5klzq/GUIwFDAlQaY4o4HcVy8JTl5GACAaC6SbwqVvDde1QrrbunuLhgtQYpL5X/31jQI6PO58cKwS44+H9cW7BllrQPo8xHiZgXUsbiiYazEnznMXNJ5fxP0I0RlOnj9gPt52YQTwSbSsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bhdZ7TGw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bhdZ7TGw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B914C16AAE;
	Fri,  9 Jan 2026 12:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961004;
	bh=vXhdU9KhzkxU80rFHsB7Ez2cnyOIcz3Y1JWSFNuVkLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bhdZ7TGwxcE6gX5VZr+dN23bxumppq50Qmy6C7f/AImdPvx2eCREaHLjf5A4GUkTo
	 0iL5cStqgB8fJ12vfYmpeF+whD20XUZ7c7il2g6Zvdm3V9EbpybcNjmZkt8sz/skSl
	 OXo5rMvlTzTFQCno0dztv+3kBCD+NXsNZ8jOJ43c=
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
Subject: [PATCH 6.6 569/737] clk: samsung: exynos-clkout: Assign .num before accessing .hws
Date: Fri,  9 Jan 2026 12:41:48 +0100
Message-ID: <20260109112155.405557560@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -168,6 +168,7 @@ static int exynos_clkout_probe(struct pl
 	clkout->mux.shift = EXYNOS_CLKOUT_MUX_SHIFT;
 	clkout->mux.lock = &clkout->slock;
 
+	clkout->data.num = EXYNOS_CLKOUT_NR_CLKS;
 	clkout->data.hws[0] = clk_hw_register_composite(NULL, "clkout",
 				parent_names, parent_count, &clkout->mux.hw,
 				&clk_mux_ops, NULL, NULL, &clkout->gate.hw,
@@ -178,7 +179,6 @@ static int exynos_clkout_probe(struct pl
 		goto err_unmap;
 	}
 
-	clkout->data.num = EXYNOS_CLKOUT_NR_CLKS;
 	ret = of_clk_add_hw_provider(clkout->np, of_clk_hw_onecell_get, &clkout->data);
 	if (ret)
 		goto err_clk_unreg;


