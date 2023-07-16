Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7809A8F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:50:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE58C433C7;
	Sun, 16 Jul 2023 20:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540627;
	bh=FaqdUIyMkvgk6FJ8+pmVw35p6XeNUShefM2Z/+8wY4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Em/siksayBDteC8eXUF1UeEuBDoePXiy4hlsd072Fu6+51D3bH/Gtz3LCq0zBLNBm
	 K/fDa3yLY3wicmgTwUwrvIyOtxV2XLjA9hSXMJzv9fVUDzCQP2MbJSTFl3BJrmAlb9
	 yCOYLTXh7gku53jG/DK/SqmJQFO1HkBEM1BiKOZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Marko <robimarko@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 403/591] clk: qcom: reset: support resetting multiple bits
Date: Sun, 16 Jul 2023 21:49:02 +0200
Message-ID: <20230716194934.345237089@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Robert Marko <robimarko@gmail.com>

[ Upstream commit 4a5210893625f89723ea210d7c630b730abb37ad ]

This patch adds the support for giving the complete bitmask
in reset structure and reset operation will use this bitmask
for all reset operations.

Currently, reset structure only takes a single bit for each reset
and then calculates the bitmask by using the BIT() macro.

However, this is not sufficient anymore for newer SoC-s like IPQ8074,
IPQ6018 and more, since their networking resets require multiple bits
to be asserted in order to properly reset the HW block completely.

So, in order to allow asserting multiple bits add "bitmask" field to
qcom_reset_map, and then use that bitmask value if its populated in the
driver, if its not populated, then we just default to existing behaviour
and calculate the bitmask on the fly.

Signed-off-by: Robert Marko <robimarko@gmail.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221107132901.489240-1-robimarko@gmail.com
Stable-dep-of: 349b5bed539b ("clk: qcom: ipq6018: fix networking resets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/reset.c | 4 ++--
 drivers/clk/qcom/reset.h | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/reset.c b/drivers/clk/qcom/reset.c
index 2a16adb572d2b..0e914ec7aeae1 100644
--- a/drivers/clk/qcom/reset.c
+++ b/drivers/clk/qcom/reset.c
@@ -30,7 +30,7 @@ qcom_reset_assert(struct reset_controller_dev *rcdev, unsigned long id)
 
 	rst = to_qcom_reset_controller(rcdev);
 	map = &rst->reset_map[id];
-	mask = BIT(map->bit);
+	mask = map->bitmask ? map->bitmask : BIT(map->bit);
 
 	return regmap_update_bits(rst->regmap, map->reg, mask, mask);
 }
@@ -44,7 +44,7 @@ qcom_reset_deassert(struct reset_controller_dev *rcdev, unsigned long id)
 
 	rst = to_qcom_reset_controller(rcdev);
 	map = &rst->reset_map[id];
-	mask = BIT(map->bit);
+	mask = map->bitmask ? map->bitmask : BIT(map->bit);
 
 	return regmap_update_bits(rst->regmap, map->reg, mask, 0);
 }
diff --git a/drivers/clk/qcom/reset.h b/drivers/clk/qcom/reset.h
index b8c113582072b..9a47c838d9b1b 100644
--- a/drivers/clk/qcom/reset.h
+++ b/drivers/clk/qcom/reset.h
@@ -12,6 +12,7 @@ struct qcom_reset_map {
 	unsigned int reg;
 	u8 bit;
 	u8 udelay;
+	u32 bitmask;
 };
 
 struct regmap;
-- 
2.39.2



