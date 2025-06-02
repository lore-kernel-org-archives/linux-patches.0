Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5BE6223323;
	Mon,  2 Jun 2025 14:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874094; cv=none; b=DO1qn4UpJAFcdZkpDSNrgLjVxbZnoLfRuoSJvF1QADa5/ms6yYvVA2AfLDGTe2ZuY7IwY2UeuJx63eAfEFOHYMNHnwszpdIM8vgoJdZguDNPXyWuRxaAI//M9ZlAWX+CguulgX/4Z8IW6f5eMQqa64LiMPmCpJssWLnkxsJ0iuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874094; c=relaxed/simple;
	bh=Jz7HfWXKxCkF2Qrk39ak3vFfPUJ8cwmUrtjXBAVHdpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ed7mqav7jp/m62ZcKeZNJKd80AN3UNVDyu18jLjMq82X7AmyEyE/slGcSUfIBkudVejHxt4ywGhsr7f6/pqA6Pt4KUJ07poQRSGZIKSDwke+No7TOjobhLxNt5outuYvHbB+5T+chUQio7KIHRXUdySqLN/PBg9hR0glMAni9uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=byrAzFnJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="byrAzFnJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C74CC4CEF0;
	Mon,  2 Jun 2025 14:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874094;
	bh=Jz7HfWXKxCkF2Qrk39ak3vFfPUJ8cwmUrtjXBAVHdpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=byrAzFnJOaYSb/fezO7IXk32xv6z0r0BO9+XvlNTyEA/6N1ujkUuFnsXw6DVZnh3o
	 yqO8o+ilPDWf1VWmZE/KC6ZwPrDN9zdeuP5OOJBq/9lVzCrIAqW0cOBOx0MAwTL6y0
	 ibAvUgH6YH8nxca84nuKWG7PbLzgiPdWllMskz5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.6 355/444] clk: s2mps11: initialise clk_hw_onecell_data::num before accessing ::hws[] in probe()
Date: Mon,  2 Jun 2025 15:46:59 +0200
Message-ID: <20250602134355.336509746@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/clk/clk-s2mps11.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/clk-s2mps11.c b/drivers/clk/clk-s2mps11.c
index 014db6386624..8ddf3a9a53df 100644
--- a/drivers/clk/clk-s2mps11.c
+++ b/drivers/clk/clk-s2mps11.c
@@ -137,6 +137,8 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
 	if (!clk_data)
 		return -ENOMEM;
 
+	clk_data->num = S2MPS11_CLKS_NUM;
+
 	switch (hwid) {
 	case S2MPS11X:
 		s2mps11_reg = S2MPS11_REG_RTC_CTRL;
@@ -186,7 +188,6 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
 		clk_data->hws[i] = &s2mps11_clks[i].hw;
 	}
 
-	clk_data->num = S2MPS11_CLKS_NUM;
 	of_clk_add_hw_provider(s2mps11_clks->clk_np, of_clk_hw_onecell_get,
 			       clk_data);
 
-- 
2.49.0



