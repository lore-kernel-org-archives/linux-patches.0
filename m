Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A498439FC3;
	Fri, 24 Nov 2023 18:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D6jriY+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FDBDC433C8;
	Fri, 24 Nov 2023 18:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849770;
	bh=nB9cyhiwwgH5vMXWQcOqx3VAtZrOQlwIP84GMCW+bpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D6jriY+DTOiaLeg08FRK3AfOSOui6LDtHYL+UU+OO25AjPyZkohjyeaxpeuxwnheZ
	 XiHiGrwcQZaVRFfBO500kd0srzsQLoZPUrriPFk/idM4T3J3xmHVr4QpAmMcjqEipQ
	 Q6ZifV+QIBXGfrzoad/MjXTmB67FG3YFgnZcNNAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.6 313/530] clk: socfpga: Fix undefined behavior bug in struct stratix10_clock_data
Date: Fri, 24 Nov 2023 17:47:59 +0000
Message-ID: <20231124172037.564834426@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Gustavo A. R. Silva <gustavoars@kernel.org>

commit d761bb01c85b22d5b44abe283eb89019693f6595 upstream.

`struct clk_hw_onecell_data` is a flexible structure, which means that
it contains flexible-array member at the bottom, in this case array
`hws`:

include/linux/clk-provider.h:
1380 struct clk_hw_onecell_data {
1381         unsigned int num;
1382         struct clk_hw *hws[] __counted_by(num);
1383 };

This could potentially lead to an overwrite of the objects following
`clk_data` in `struct stratix10_clock_data`, in this case
`void __iomem *base;` at run-time:

drivers/clk/socfpga/stratix10-clk.h:
  9 struct stratix10_clock_data {
 10         struct clk_hw_onecell_data      clk_data;
 11         void __iomem            *base;
 12 };

There are currently three different places where memory is allocated for
`struct stratix10_clock_data`, including the flex-array `hws` in
`struct clk_hw_onecell_data`:

drivers/clk/socfpga/clk-agilex.c:
469         clk_data = devm_kzalloc(dev, struct_size(clk_data, clk_data.hws,
470                                 num_clks), GFP_KERNEL);

drivers/clk/socfpga/clk-agilex.c:
509         clk_data = devm_kzalloc(dev, struct_size(clk_data, clk_data.hws,
510                                 num_clks), GFP_KERNEL);

drivers/clk/socfpga/clk-s10.c:
400         clk_data = devm_kzalloc(dev, struct_size(clk_data, clk_data.hws,
401                                                  num_clks), GFP_KERNEL);

I'll use just one of them to describe the issue. See below.

Notice that a total of 440 bytes are allocated for flexible-array member
`hws` at line 469:

include/dt-bindings/clock/agilex-clock.h:
 70 #define AGILEX_NUM_CLKS	55

drivers/clk/socfpga/clk-agilex.c:
459         struct stratix10_clock_data *clk_data;
460         void __iomem *base;
...
466
467         num_clks = AGILEX_NUM_CLKS;
468
469         clk_data = devm_kzalloc(dev, struct_size(clk_data, clk_data.hws,
470                                 num_clks), GFP_KERNEL);

`struct_size(clk_data, clk_data.hws, num_clks)`	above translates to
sizeof(struct stratix10_clock_data) + sizeof(struct clk_hw *) * 55 ==
16 + 8 * 55 == 16 + 440
		    ^^^
		     |
	allocated bytes for flex-array `hws`

474         for (i = 0; i < num_clks; i++)
475                 clk_data->clk_data.hws[i] = ERR_PTR(-ENOENT);
476
477         clk_data->base = base;

and then some data is written into both `hws` and `base` objects.

Fix this by placing the declaration of object `clk_data` at the end of
`struct stratix10_clock_data`. Also, add a comment to make it clear
that this object must always be last in the structure.

-Wflex-array-member-not-at-end is coming in GCC-14, and we are getting
ready to enable it globally.

Fixes: ba7e258425ac ("clk: socfpga: Convert to s10/agilex/n5x to use clk_hw")
Cc: stable@vger.kernel.org
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://lore.kernel.org/r/1da736106d8e0806aeafa6e471a13ced490eae22.1698117815.git.gustavoars@kernel.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/socfpga/stratix10-clk.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/clk/socfpga/stratix10-clk.h
+++ b/drivers/clk/socfpga/stratix10-clk.h
@@ -7,8 +7,10 @@
 #define	__STRATIX10_CLK_H
 
 struct stratix10_clock_data {
-	struct clk_hw_onecell_data	clk_data;
 	void __iomem		*base;
+
+	/* Must be last */
+	struct clk_hw_onecell_data	clk_data;
 };
 
 struct stratix10_pll_clock {


