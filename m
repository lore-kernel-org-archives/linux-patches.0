Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC84134D4
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:29:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20B8C433CD;
	Mon, 11 Sep 2023 15:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694446147;
	bh=WyUP2yoGJ8hp2U6YkugJzU6K0BYbyAJS4zQcCB3SVWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qg2jNo5WtNRGfCgABhbpMWiwxaWrfW3pqIJxo75jckMIIOovQSkyEhvQ/Or19zi73
	 RGel2IWTYrVX7zng7vWsmJZnC4tX4W0xLFkhls8nECU4zfBsmYrgHIS0JXP+KY/QTS
	 y6OgvjB04yC/ipHiJ1GIBV0i6ppxrcmQj3yuLhYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Saravana Kannan <saravanak@google.com>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.1 598/600] clk: Mark a fwnode as initialized when using CLK_OF_DECLARE() macro
Date: Mon, 11 Sep 2023 15:50:31 +0200
Message-ID: <20230911134651.311386161@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saravana Kannan <saravanak@google.com>

commit c28cd1f3433c7e339315d1ddacaeacf0fdfbe252 upstream.

We already mark fwnodes as initialized when they are registered as clock
providers. We do this so that fw_devlink can tell when a clock driver
doesn't use the driver core framework to probe/initialize its device.
This ensures fw_devlink doesn't block the consumers of such a clock
provider indefinitely.

However, some users of CLK_OF_DECLARE() macros don't use the same node
that matches the macro as the node for the clock provider, but they
initialize the entire node. To cover these cases, also mark the nodes
that match the macros as initialized when the init callback function is
called.

An example of this is "stericsson,u8500-clks" that's handled using
CLK_OF_DECLARE() and looks something like this:

clocks {
	compatible = "stericsson,u8500-clks";

	prcmu_clk: prcmu-clock {
		#clock-cells = <1>;
	};

	prcc_pclk: prcc-periph-clock {
		#clock-cells = <2>;
	};

	prcc_kclk: prcc-kernel-clock {
		#clock-cells = <2>;
	};

	prcc_reset: prcc-reset-controller {
		#reset-cells = <2>;
	};
	...
};

This patch makes sure that "clocks" is marked as initialized so that
fw_devlink knows that all nodes under it have been initialized. If the
driver creates struct devices for some of the subnodes, fw_devlink is
smart enough to know to wait for those devices to probe, so no special
handling is required for those cases.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reported-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/lkml/CACRpkdamxDX6EBVjKX5=D3rkHp17f5pwGdBVhzFU90-0MHY6dQ@mail.gmail.com/
Fixes: 4a032827daa8 ("of: property: Simplify of_link_to_phandle()")
Signed-off-by: Saravana Kannan <saravanak@google.com>
Link: https://lore.kernel.org/r/20230302014639.297514-1-saravanak@google.com
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Tested-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/clk-provider.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -1361,7 +1361,13 @@ struct clk_hw_onecell_data {
 	struct clk_hw *hws[];
 };
 
-#define CLK_OF_DECLARE(name, compat, fn) OF_DECLARE_1(clk, name, compat, fn)
+#define CLK_OF_DECLARE(name, compat, fn) \
+	static void __init name##_of_clk_init_declare(struct device_node *np) \
+	{								\
+		fn(np);							\
+		fwnode_dev_initialized(of_fwnode_handle(np), true);	\
+	}								\
+	OF_DECLARE_1(clk, name, compat, name##_of_clk_init_declare)
 
 /*
  * Use this macro when you have a driver that requires two initialization


