Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F6E8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:11:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A56AC433C7;
	Sun, 16 Jul 2023 20:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538290;
	bh=YlodnbUFJXb4lIyu3JpaArbvJlF+M+ZzwzlB3xj8AZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dBPnB11JJbEREZflH07XheZKkjcHECiAgnDY35oEOzukdO0kRFaDDMDWP5nlZA5Vk
	 u7HEUj1V3Y1W7Zq5mF7QqcIOJVg7u1VjUw8cHqS8m8cBMaMTesBUQ4Z6lV8JpQYBdk
	 4DlQlFS4qnFPAlyIM6NUv76MoeXHsQ8DpH9mwlyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Connolly <caleb.connolly@linaro.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 355/800] Input: pm8941-powerkey - fix debounce on gen2+ PMICs
Date: Sun, 16 Jul 2023 21:43:28 +0200
Message-ID: <20230716194957.324761534@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Caleb Connolly <caleb.connolly@linaro.org>

[ Upstream commit 8c9cce9cb81b5fdc6e66bf3f129727b89e8daab7 ]

Since PM8998/PM660, the power key debounce register was redefined to
support shorter debounce times. On PM8941 the shortest debounce time
(represented by register value 0) was 15625us, on PM8998 the shortest
debounce time is 62us, with the default being 2ms.

Adjust the bit shift to correctly program debounce on PM8998 and newer.

Fixes: 68c581d5e7d8 ("Input: add Qualcomm PM8941 power key driver")
Signed-off-by: Caleb Connolly <caleb.connolly@linaro.org>
Link: https://lore.kernel.org/r/20230529-pm8941-pwrkey-debounce-v1-2-c043a6d5c814@linaro.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/pm8941-pwrkey.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/input/misc/pm8941-pwrkey.c b/drivers/input/misc/pm8941-pwrkey.c
index b6a27ebae977b..74d77d8aaeff2 100644
--- a/drivers/input/misc/pm8941-pwrkey.c
+++ b/drivers/input/misc/pm8941-pwrkey.c
@@ -50,7 +50,10 @@
 #define  PON_RESIN_PULL_UP		BIT(0)
 
 #define PON_DBC_CTL			0x71
-#define  PON_DBC_DELAY_MASK		0x7
+#define  PON_DBC_DELAY_MASK_GEN1	0x7
+#define  PON_DBC_DELAY_MASK_GEN2	0xf
+#define  PON_DBC_SHIFT_GEN1		6
+#define  PON_DBC_SHIFT_GEN2		14
 
 struct pm8941_data {
 	unsigned int	pull_up_bit;
@@ -247,7 +250,7 @@ static int pm8941_pwrkey_probe(struct platform_device *pdev)
 	struct device *parent;
 	struct device_node *regmap_node;
 	const __be32 *addr;
-	u32 req_delay;
+	u32 req_delay, mask, delay_shift;
 	int error;
 
 	if (of_property_read_u32(pdev->dev.of_node, "debounce", &req_delay))
@@ -336,12 +339,20 @@ static int pm8941_pwrkey_probe(struct platform_device *pdev)
 	pwrkey->input->phys = pwrkey->data->phys;
 
 	if (pwrkey->data->supports_debounce_config) {
-		req_delay = (req_delay << 6) / USEC_PER_SEC;
+		if (pwrkey->subtype >= PON_SUBTYPE_GEN2_PRIMARY) {
+			mask = PON_DBC_DELAY_MASK_GEN2;
+			delay_shift = PON_DBC_SHIFT_GEN2;
+		} else {
+			mask = PON_DBC_DELAY_MASK_GEN1;
+			delay_shift = PON_DBC_SHIFT_GEN1;
+		}
+
+		req_delay = (req_delay << delay_shift) / USEC_PER_SEC;
 		req_delay = ilog2(req_delay);
 
 		error = regmap_update_bits(pwrkey->regmap,
 					   pwrkey->baseaddr + PON_DBC_CTL,
-					   PON_DBC_DELAY_MASK,
+					   mask,
 					   req_delay);
 		if (error) {
 			dev_err(&pdev->dev, "failed to set debounce: %d\n",
-- 
2.39.2



