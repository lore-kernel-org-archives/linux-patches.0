Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A6C2FF178;
	Tue,  6 Jan 2026 17:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720917; cv=none; b=eN5epRbrpYOqgjmq7fQHanmBjFimvRLwJ1xdljD0GhcusakZyt+yVQPwfMpG6PJQPF1pmcNB/tBkHkj0zSqBek3ONvtno+z2I+Pvnwrx0C4rBeIA2wJz79AeZhv00bI4168oU+oTmPw5xgnvuQfIg3/mPaLonkI6WyLmmP9Un60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720917; c=relaxed/simple;
	bh=CdmDM8cyOEc/KemKLhIeIqO8qqW0ifI/WkkrXK71WSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CpXIzXDI3Y6xMhV0NJ8PF8n/v9WpAtMD/3Fjkok3tZOQnigtw70PX7K7UcOFRo4jZVq5qTL7JNqyAc1DmXkSceb0KlQEQ8S8ahXDz/dw1I+DICkHYxVuSXjKU4kGMWM45p7c/oJUiuh7TbwVwSqAdKGcEG9z8KRt/WSkuUs7xj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BuOy5t3s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BuOy5t3s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CACCC16AAE;
	Tue,  6 Jan 2026 17:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720916;
	bh=CdmDM8cyOEc/KemKLhIeIqO8qqW0ifI/WkkrXK71WSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BuOy5t3sn4caKwQWViteajV3q458CjpUOJh40Jfhs1oEPrArhaQJRRus4Ar7H42Fk
	 Tek94nmt1ZjDv05Up/tTXIeZR7fZ7LomVeE5OQygeDvvLTuDQahvJ+FyStDQ7iYfmK
	 E0hpf2frS1ufcLR8vsVkSLi1287+mssSwvzRT1Do=
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
Subject: [PATCH 6.12 379/567] clk: samsung: exynos-clkout: Assign .num before accessing .hws
Date: Tue,  6 Jan 2026 18:02:41 +0100
Message-ID: <20260106170505.361990684@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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
@@ -174,6 +174,7 @@ static int exynos_clkout_probe(struct pl
 	clkout->mux.shift = EXYNOS_CLKOUT_MUX_SHIFT;
 	clkout->mux.lock = &clkout->slock;
 
+	clkout->data.num = EXYNOS_CLKOUT_NR_CLKS;
 	clkout->data.hws[0] = clk_hw_register_composite(NULL, "clkout",
 				parent_names, parent_count, &clkout->mux.hw,
 				&clk_mux_ops, NULL, NULL, &clkout->gate.hw,
@@ -184,7 +185,6 @@ static int exynos_clkout_probe(struct pl
 		goto err_unmap;
 	}
 
-	clkout->data.num = EXYNOS_CLKOUT_NR_CLKS;
 	ret = of_clk_add_hw_provider(clkout->np, of_clk_hw_onecell_get, &clkout->data);
 	if (ret)
 		goto err_clk_unreg;


