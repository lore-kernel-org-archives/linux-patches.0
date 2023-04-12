Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F652F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:35:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26109C433D2;
	Wed, 12 Apr 2023 08:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288545;
	bh=OJ54zOM28btvHzPzhl2+rgRnouUbMjminDwj+SYANYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MphLBw3X0mH9EC364XtRCRVsKAK0pW0ZOYfyv6xq3Gz4W3tfwZwUDaQwcsX7Rk+OH
	 p4UnLe1m4LmoWP33fMlIjHSztRinxypksXVEYUIV804QT2/KTcJXyg9XekGHG+SZMH
	 RLwbQf/lnMdgYlaB+Y3vubQ+9EeiqBtG/QFPf0UQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Dooks <ben.dooks@sifive.com>,
	Zong Li <zong.li@sifive.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 03/93] soc: sifive: ccache: reduce printing on init
Date: Wed, 12 Apr 2023 10:33:04 +0200
Message-Id: <20230412082823.189001078@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ben Dooks <ben.dooks@sifive.com>

[ Upstream commit 3fb787e5bad50687a65ded7f3bb805cab70dff59 ]

The driver prints out 6 lines on startup, which can easily be redcued
to two lines without losing any information.

Note, to make the types work better, uint64_t has been replaced with
ULL to make the unsigned long long match the format in the print
statement.

Signed-off-by: Ben Dooks <ben.dooks@sifive.com>
Signed-off-by: Zong Li <zong.li@sifive.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20220913061817.22564-5-zong.li@sifive.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Stable-dep-of: 73e770f08502 ("soc: sifive: ccache: fix missing iounmap() in error path in sifive_ccache_init()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/sifive/sifive_ccache.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/soc/sifive/sifive_ccache.c b/drivers/soc/sifive/sifive_ccache.c
index b361b661ea09a..17080af7dfa00 100644
--- a/drivers/soc/sifive/sifive_ccache.c
+++ b/drivers/soc/sifive/sifive_ccache.c
@@ -81,20 +81,17 @@ static void setup_sifive_debug(void)
 
 static void ccache_config_read(void)
 {
-	u32 regval, val;
-
-	regval = readl(ccache_base + SIFIVE_CCACHE_CONFIG);
-	val = regval & 0xFF;
-	pr_info("CCACHE: No. of Banks in the cache: %d\n", val);
-	val = (regval & 0xFF00) >> 8;
-	pr_info("CCACHE: No. of ways per bank: %d\n", val);
-	val = (regval & 0xFF0000) >> 16;
-	pr_info("CCACHE: Sets per bank: %llu\n", (uint64_t)1 << val);
-	val = (regval & 0xFF000000) >> 24;
-	pr_info("CCACHE: Bytes per cache block: %llu\n", (uint64_t)1 << val);
-
-	regval = readl(ccache_base + SIFIVE_CCACHE_WAYENABLE);
-	pr_info("CCACHE: Index of the largest way enabled: %d\n", regval);
+	u32 cfg;
+
+	cfg = readl(ccache_base + SIFIVE_CCACHE_CONFIG);
+
+	pr_info("CCACHE: %u banks, %u ways, sets/bank=%llu, bytes/block=%llu\n",
+		(cfg & 0xff), (cfg >> 8) & 0xff,
+		BIT_ULL((cfg >> 16) & 0xff),
+		BIT_ULL((cfg >> 24) & 0xff));
+
+	cfg = readl(ccache_base + SIFIVE_CCACHE_WAYENABLE);
+	pr_info("CCACHE: Index of the largest way enabled: %u\n", cfg);
 }
 
 static const struct of_device_id sifive_ccache_ids[] = {
-- 
2.39.2



