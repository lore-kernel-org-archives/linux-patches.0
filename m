Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD182572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:42:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C50C433D2;
	Tue, 18 Apr 2023 12:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821778;
	bh=UfVJAro4hS0sb7wS/UaCLZeYCdQCigB984hcleKeoXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tyvKepTKlSfkUXoIq4Sl0/b/h0jRTTwgHvT86FzNqH2VBEJXzFjmTvS4P2OCPDdnN
	 NjYwC0+tOQ1571PJ79V6iVnf4Q2YG7Z6g5yCVDnYZL3nvFSgrltznCHejwhu26mYuq
	 B7qXxNmdKchrGC44NOZtzGkqOMkjLmFISy+V8XJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/134] clk: rs9: Fix suspend/resume
Date: Tue, 18 Apr 2023 14:21:33 +0200
Message-Id: <20230418120314.250845994@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 632e04739c8f45c2d9ca4d4c5bd18d80c2ac9296 ]

Disabling the cache in commit 2ff4ba9e3702 ("clk: rs9: Fix I2C accessors")
without removing cache synchronization in resume path results in a
kernel panic as map->cache_ops is unset, due to REGCACHE_NONE.
Enable flat cache again to support resume again. num_reg_defaults_raw
is necessary to read the cache defaults from hardware. Some registers
are strapped in hardware and cannot be provided in software.

Fixes: 2ff4ba9e3702 ("clk: rs9: Fix I2C accessors")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://lore.kernel.org/r/20230310074940.3475703-1-alexander.stein@ew.tq-group.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-renesas-pcie.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/clk-renesas-pcie.c b/drivers/clk/clk-renesas-pcie.c
index e6247141d0c05..3e98a16eba6bb 100644
--- a/drivers/clk/clk-renesas-pcie.c
+++ b/drivers/clk/clk-renesas-pcie.c
@@ -144,8 +144,9 @@ static int rs9_regmap_i2c_read(void *context,
 static const struct regmap_config rs9_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
-	.cache_type = REGCACHE_NONE,
+	.cache_type = REGCACHE_FLAT,
 	.max_register = RS9_REG_BCP,
+	.num_reg_defaults_raw = 0x8,
 	.rd_table = &rs9_readable_table,
 	.wr_table = &rs9_writeable_table,
 	.reg_write = rs9_regmap_i2c_write,
-- 
2.39.2



