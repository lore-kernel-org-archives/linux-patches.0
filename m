Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A363171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:45:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B89C433D2;
	Mon, 22 May 2023 19:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784727;
	bh=vPKYro4QLlskCwG8Mem35oe25rxm3WPf7BbJoyHZhbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ODeSONtcfTBDZcSgaW3ksZNHmsUgJmm5ga5ZMQVIxvvHlrJCa2/kygdJjQajdkpys
	 iNbmkycrU41YsUhB6hqYZgI0k54p8BGlNsmcpzCCWATRcFt1rTonBu5uRFjBwPT3Xe
	 0oSfKz1YXvxOu9OmkZ+BO/HDRVXRk53QAzvhJOZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 181/364] clk: tegra20: fix gcc-7 constant overflow warning
Date: Mon, 22 May 2023 20:08:06 +0100
Message-Id: <20230522190417.254055971@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit b4a2adbf3586efa12fe78b9dec047423e01f3010 ]

Older gcc versions get confused by comparing a u32 value to a negative
constant in a switch()/case block:

drivers/clk/tegra/clk-tegra20.c: In function 'tegra20_clk_measure_input_freq':
drivers/clk/tegra/clk-tegra20.c:581:2: error: case label does not reduce to an integer constant
  case OSC_CTRL_OSC_FREQ_12MHZ:
  ^~~~
drivers/clk/tegra/clk-tegra20.c:593:2: error: case label does not reduce to an integer constant
  case OSC_CTRL_OSC_FREQ_26MHZ:

Make the constants unsigned instead.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20230227085914.2560984-1-arnd@kernel.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/tegra/clk-tegra20.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra20.c b/drivers/clk/tegra/clk-tegra20.c
index 422d782475532..dcacc5064d339 100644
--- a/drivers/clk/tegra/clk-tegra20.c
+++ b/drivers/clk/tegra/clk-tegra20.c
@@ -21,24 +21,24 @@
 #define MISC_CLK_ENB 0x48
 
 #define OSC_CTRL 0x50
-#define OSC_CTRL_OSC_FREQ_MASK (3<<30)
-#define OSC_CTRL_OSC_FREQ_13MHZ (0<<30)
-#define OSC_CTRL_OSC_FREQ_19_2MHZ (1<<30)
-#define OSC_CTRL_OSC_FREQ_12MHZ (2<<30)
-#define OSC_CTRL_OSC_FREQ_26MHZ (3<<30)
-#define OSC_CTRL_MASK (0x3f2 | OSC_CTRL_OSC_FREQ_MASK)
-
-#define OSC_CTRL_PLL_REF_DIV_MASK (3<<28)
-#define OSC_CTRL_PLL_REF_DIV_1		(0<<28)
-#define OSC_CTRL_PLL_REF_DIV_2		(1<<28)
-#define OSC_CTRL_PLL_REF_DIV_4		(2<<28)
+#define OSC_CTRL_OSC_FREQ_MASK (3u<<30)
+#define OSC_CTRL_OSC_FREQ_13MHZ (0u<<30)
+#define OSC_CTRL_OSC_FREQ_19_2MHZ (1u<<30)
+#define OSC_CTRL_OSC_FREQ_12MHZ (2u<<30)
+#define OSC_CTRL_OSC_FREQ_26MHZ (3u<<30)
+#define OSC_CTRL_MASK (0x3f2u | OSC_CTRL_OSC_FREQ_MASK)
+
+#define OSC_CTRL_PLL_REF_DIV_MASK	(3u<<28)
+#define OSC_CTRL_PLL_REF_DIV_1		(0u<<28)
+#define OSC_CTRL_PLL_REF_DIV_2		(1u<<28)
+#define OSC_CTRL_PLL_REF_DIV_4		(2u<<28)
 
 #define OSC_FREQ_DET 0x58
-#define OSC_FREQ_DET_TRIG (1<<31)
+#define OSC_FREQ_DET_TRIG (1u<<31)
 
 #define OSC_FREQ_DET_STATUS 0x5c
-#define OSC_FREQ_DET_BUSY (1<<31)
-#define OSC_FREQ_DET_CNT_MASK 0xFFFF
+#define OSC_FREQ_DET_BUSYu (1<<31)
+#define OSC_FREQ_DET_CNT_MASK 0xFFFFu
 
 #define TEGRA20_CLK_PERIPH_BANKS	3
 
-- 
2.39.2



