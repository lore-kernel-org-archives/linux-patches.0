Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8261F953
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:40:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55FB0C433C8;
	Tue,  1 Aug 2023 09:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882826;
	bh=NyjbPFyh8/vpO3bxQ6FOcJkSjE+lBnvIFvA3I59b6bA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e+L1VluteHWvF7AB3U+4O1wEpaAaehyUzAPcvFojD+OKxXXRxneCnqBikjycQ2T+T
	 yGEeX9Zjsbh991lQT5P2MBkCuUOiR9Kjt76DEewr4GFBJ7yPW/0Y1j73jLOamfPcrO
	 E13xaC6UCRXd55OiFvDtMeRTQbLvP1p79TK8X7VU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 017/239] regmap: Disable locking for RBTREE and MAPLE unit tests
Date: Tue,  1 Aug 2023 11:18:01 +0200
Message-ID: <20230801091926.266107629@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit a9e26169cfda651802f88262a315146fbe4bc74c ]

REGCACHE_RBTREE and REGCACHE_MAPLE dynamically allocate memory
for regmap operations. This is incompatible with spinlock based locking
which is used for fast_io operations. Disable locking for the associated
unit tests to avoid lockdep splashes.

Fixes: f033c26de5a5 ("regmap: Add maple tree based register cache")
Fixes: 2238959b6ad2 ("regmap: Add some basic kunit tests")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20230720032848.1306349-1-linux@roeck-us.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap-kunit.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/base/regmap/regmap-kunit.c b/drivers/base/regmap/regmap-kunit.c
index f76d416881349..0b3dacc7fa424 100644
--- a/drivers/base/regmap/regmap-kunit.c
+++ b/drivers/base/regmap/regmap-kunit.c
@@ -58,6 +58,9 @@ static struct regmap *gen_regmap(struct regmap_config *config,
 	int i;
 	struct reg_default *defaults;
 
+	config->disable_locking = config->cache_type == REGCACHE_RBTREE ||
+					config->cache_type == REGCACHE_MAPLE;
+
 	buf = kmalloc(size, GFP_KERNEL);
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
-- 
2.39.2



