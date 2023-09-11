Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B4714F81
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:29:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC2EC43395;
	Mon, 11 Sep 2023 15:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694446176;
	bh=8ABMsgVXMHDcQXJPDfm8BrOSo7OCB7e9pcicEahb8g0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ToqA4yMwdJmlsoasWcJqw8THT7mwG0npOBPUEM11f7UrJy5K0bFzaNaMxryIVwRLc
	 Yq2YV+IKyWAA0jFcrn8+3fG6NMTlVoDyCYRVDebFujKsDU5ElPvr0YC2FsObj43DD4
	 9SRYty0tr+YlEm4XnVaY164mqWIewnotDOf8F7A0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saravana Kannan <saravanak@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.1 600/600] clk: Avoid invalid function names in CLK_OF_DECLARE()
Date: Mon, 11 Sep 2023 15:50:33 +0200
Message-ID: <20230911134651.374782834@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

commit 5cf9d015be160e2d90d29ae74ef1364390e8fce8 upstream.

After commit c28cd1f3433c ("clk: Mark a fwnode as initialized when using
CLK_OF_DECLARE() macro"), drivers/clk/mvebu/kirkwood.c fails to build:

 drivers/clk/mvebu/kirkwood.c:358:1: error: expected identifier or '('
 CLK_OF_DECLARE(98dx1135_clk, "marvell,mv98dx1135-core-clock",
 ^
 include/linux/clk-provider.h:1367:21: note: expanded from macro 'CLK_OF_DECLARE'
         static void __init name##_of_clk_init_declare(struct device_node *np) \
                            ^
 <scratch space>:124:1: note: expanded from here
 98dx1135_clk_of_clk_init_declare
 ^
 drivers/clk/mvebu/kirkwood.c:358:1: error: invalid digit 'd' in decimal constant
 include/linux/clk-provider.h:1372:34: note: expanded from macro 'CLK_OF_DECLARE'
         OF_DECLARE_1(clk, name, compat, name##_of_clk_init_declare)
                                         ^
 <scratch space>:125:3: note: expanded from here
 98dx1135_clk_of_clk_init_declare
   ^
 drivers/clk/mvebu/kirkwood.c:358:1: error: invalid digit 'd' in decimal constant
 include/linux/clk-provider.h:1372:34: note: expanded from macro 'CLK_OF_DECLARE'
         OF_DECLARE_1(clk, name, compat, name##_of_clk_init_declare)
                                         ^
 <scratch space>:125:3: note: expanded from here
 98dx1135_clk_of_clk_init_declare
   ^
 drivers/clk/mvebu/kirkwood.c:358:1: error: invalid digit 'd' in decimal constant
 include/linux/clk-provider.h:1372:34: note: expanded from macro 'CLK_OF_DECLARE'
         OF_DECLARE_1(clk, name, compat, name##_of_clk_init_declare)
                                         ^
 <scratch space>:125:3: note: expanded from here
 98dx1135_clk_of_clk_init_declare
   ^

C function names must start with either an alphabetic letter or an
underscore. To avoid generating invalid function names from clock names,
add two underscores to the beginning of the identifier.

Fixes: c28cd1f3433c ("clk: Mark a fwnode as initialized when using CLK_OF_DECLARE() macro")
Suggested-by: Saravana Kannan <saravanak@google.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20230308-clk_of_declare-fix-v1-1-317b741e2532@kernel.org
Reviewed-by: Saravana Kannan <saravanak@google.com>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/clk-provider.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -1362,12 +1362,12 @@ struct clk_hw_onecell_data {
 };
 
 #define CLK_OF_DECLARE(name, compat, fn) \
-	static void __init name##_of_clk_init_declare(struct device_node *np) \
+	static void __init __##name##_of_clk_init_declare(struct device_node *np) \
 	{								\
 		fn(np);							\
 		fwnode_dev_initialized(of_fwnode_handle(np), true);	\
 	}								\
-	OF_DECLARE_1(clk, name, compat, name##_of_clk_init_declare)
+	OF_DECLARE_1(clk, name, compat, __##name##_of_clk_init_declare)
 
 /*
  * Use this macro when you have a driver that requires two initialization


