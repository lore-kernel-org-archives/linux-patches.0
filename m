Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89F02798E6;
	Tue, 27 May 2025 17:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366035; cv=none; b=EHHhH24bK/ciMT8TsWtJFUYlVn2UMVP6YtLxqrwgIhNejyxtxveuhKAFpXH5LfU+KY0/lmjYO19Gyijr887sMvBDkTgUJdseKwfq/G73PbAzoxmmMfwkjVoEI589LFxovvauhGi1maqRzoUcCcfDzu5XqxMeezKt9o2KJrkykEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366035; c=relaxed/simple;
	bh=hLqNCVLeMjzcm1ziOFoXkgx2tZ/Ub+17q5MvMwFbcLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cHSAhlM1bSI3UVVnx5SNVHbtDaGXwSeTp8KSFoDXkQI/WWZT9hkd4vtrHoMfJnT1Es73KmOpgrJQPNw9Oz4UXB+Z5d8umtpSQ2ZgI5IRnTzjZLmdqEg1Knyr64UTWJ3FrdwsS08JZzllYI8RhtqSWJZ+xr4OA6xo1A9Bz/8bJJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hYmT8YSt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hYmT8YSt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E534C4CEE9;
	Tue, 27 May 2025 17:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366034;
	bh=hLqNCVLeMjzcm1ziOFoXkgx2tZ/Ub+17q5MvMwFbcLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hYmT8YStW+M2TIqJxC81lCCxzoA3f4bdsVj+XuXPy1HvAkqswp65AtpvDlRyYsaGI
	 YY+WhhLkw3OZIZbgPLRlrETMPi9A26IMt7gDUfjDOoBQ0zqxBaccnP3J+DubkPfVYH
	 ubLM8oKl1fs6laSwiECWIgI2L79pYt9MsLs9XSLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.12 569/626] clk: s2mps11: initialise clk_hw_onecell_data::num before accessing ::hws[] in probe()
Date: Tue, 27 May 2025 18:27:42 +0200
Message-ID: <20250527162508.084316843@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Draszik <andre.draszik@linaro.org>

commit 3e14c7207a975eefcda1929b2134a9f4119dde45 upstream.

With UBSAN enabled, we're getting the following trace:

    UBSAN: array-index-out-of-bounds in .../drivers/clk/clk-s2mps11.c:186:3
    index 0 is out of range for type 'struct clk_hw *[] __counted_by(num)' (aka 'struct clk_hw *[]')

This is because commit f316cdff8d67 ("clk: Annotate struct
clk_hw_onecell_data with __counted_by") annotated the hws member of
that struct with __counted_by, which informs the bounds sanitizer about
the number of elements in hws, so that it can warn when hws is accessed
out of bounds.

As noted in that change, the __counted_by member must be initialised
with the number of elements before the first array access happens,
otherwise there will be a warning from each access prior to the
initialisation because the number of elements is zero. This occurs in
s2mps11_clk_probe() due to ::num being assigned after ::hws access.

Move the assignment to satisfy the requirement of assign-before-access.

Cc: stable@vger.kernel.org
Fixes: f316cdff8d67 ("clk: Annotate struct clk_hw_onecell_data with __counted_by")
Signed-off-by: André Draszik <andre.draszik@linaro.org>
Link: https://lore.kernel.org/r/20250326-s2mps11-ubsan-v1-1-fcc6fce5c8a9@linaro.org
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/clk-s2mps11.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/clk/clk-s2mps11.c
+++ b/drivers/clk/clk-s2mps11.c
@@ -137,6 +137,8 @@ static int s2mps11_clk_probe(struct plat
 	if (!clk_data)
 		return -ENOMEM;
 
+	clk_data->num = S2MPS11_CLKS_NUM;
+
 	switch (hwid) {
 	case S2MPS11X:
 		s2mps11_reg = S2MPS11_REG_RTC_CTRL;
@@ -186,7 +188,6 @@ static int s2mps11_clk_probe(struct plat
 		clk_data->hws[i] = &s2mps11_clks[i].hw;
 	}
 
-	clk_data->num = S2MPS11_CLKS_NUM;
 	of_clk_add_hw_provider(s2mps11_clks->clk_np, of_clk_hw_onecell_get,
 			       clk_data);
 


