Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1840A1F790F;
	Tue, 26 Aug 2025 14:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217905; cv=none; b=A+WTLh381DacWhmDmMO6m8VsC/Xn6DrNVH1g5KTx8n6myNS2SFis4Wz23ZqX4E4N0X4C+UrCc4k9jzabb8MssmODu+3Y3cskHTXl+Dxy8sNTXeWqMPKqrCrRGto14A62i1iQX357mcFqpXB6518/ERK9Etlqj4GJQQpI7dLAIWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217905; c=relaxed/simple;
	bh=gI+Bt2a+jFoqnFCzdgbyy/w/uT694nu9Kh2kSVoEIRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VDj3T5J766syDyEdrvIQBquCJR3wjzvb7PsxPBV6iOMVl0ZkJtgI7hYR6lkEU2MlFTXn42gW0faw/WlGIxO5sQ8/SBRYddOsNh6bm+aH8aKJmhgdtPQrhDuCd02stkCrL26f4YVxAg9vGHNCDFJ1cg4mL1APTnn4UA7Pi2vF3AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qm2cMDdF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qm2cMDdF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF7BC4CEF1;
	Tue, 26 Aug 2025 14:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217905;
	bh=gI+Bt2a+jFoqnFCzdgbyy/w/uT694nu9Kh2kSVoEIRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qm2cMDdFw6K8Zg6Y7oVEU8/52oDSccwcpEuOajHayb0RXhFwQ7mi23B5eVPhkpsNc
	 PRzOx8vk/3m99yxHn0stYU9x64Wfuuvs5KCIaUmJi7xt9eLTjQRIE93YBK1gbrw1s2
	 oQSQLHXuBUXc9JiC1pYvaHDn3vWSbHzt7SGb0ALU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Adolfsson <johan.adolfsson@axis.com>,
	Jacek Anaszewski <jacek.anaszewski@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 302/523] leds: leds-lp50xx: Handle reg to get correct multi_index
Date: Tue, 26 Aug 2025 13:08:32 +0200
Message-ID: <20250826110931.903080747@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Adolfsson <johan.adolfsson@axis.com>

[ Upstream commit 2e84a5e5374232e6f356ce5c079a5658d7e4af2c ]

mc_subled used for multi_index needs well defined array indexes,
to guarantee the desired result, use reg for that.

If devicetree child nodes is processed in random or reverse order
you may end up with multi_index "blue green red" instead of the expected
"red green blue".
If user space apps uses multi_index to deduce how to control the leds
they would most likely be broken without this patch if devicetree
processing is reversed (which it appears to be).

arch/arm/boot/dts/aspeed/aspeed-bmc-facebook-fuji.dts has reg set
but I don't see how it can have worked without this change.

If reg is not set, an error is returned,
If reg is out of range, an error is returned.
reg within led child nodes starts with 0, to map to the iout in each bank.

Signed-off-by: Johan Adolfsson <johan.adolfsson@axis.com>
Reviewed-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Link: https://lore.kernel.org/r/20250617-led-fix-v7-1-cdbe8efc88fa@axis.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-lp50xx.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/leds-lp50xx.c b/drivers/leds/leds-lp50xx.c
index d4529082935b..279f3958e0ab 100644
--- a/drivers/leds/leds-lp50xx.c
+++ b/drivers/leds/leds-lp50xx.c
@@ -493,6 +493,7 @@ static int lp50xx_probe_dt(struct lp50xx *priv)
 		}
 
 		fwnode_for_each_child_node(child, led_node) {
+			int multi_index;
 			ret = fwnode_property_read_u32(led_node, "color",
 						       &color_id);
 			if (ret) {
@@ -500,8 +501,16 @@ static int lp50xx_probe_dt(struct lp50xx *priv)
 				dev_err(priv->dev, "Cannot read color\n");
 				goto child_out;
 			}
+			ret = fwnode_property_read_u32(led_node, "reg", &multi_index);
+			if (ret != 0) {
+				dev_err(priv->dev, "reg must be set\n");
+				return -EINVAL;
+			} else if (multi_index >= LP50XX_LEDS_PER_MODULE) {
+				dev_err(priv->dev, "reg %i out of range\n", multi_index);
+				return -EINVAL;
+			}
 
-			mc_led_info[num_colors].color_index = color_id;
+			mc_led_info[multi_index].color_index = color_id;
 			num_colors++;
 		}
 
-- 
2.39.5



