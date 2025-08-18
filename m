Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736E73218B5;
	Mon, 18 Aug 2025 13:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524172; cv=none; b=EgMK7exq2dI2oMi6S0EepM9xdrFznQGQxTNXe0XG20ggY8AbBzFmOuWo4U5W1KbuYmi8y7/+AF2i3tdnS2uji210o01V8257cu+tNrmKRYFc2rxK0fi8mTeq02J7JoDQsJkEkHKYxzHM0xqeXFgd3NKeWUw/gSuoNs8GQvrn4X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524172; c=relaxed/simple;
	bh=z1c8VKcR1deaxIVL83XlYAnnGiQXxucv+U6ICGlOhIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/ObyjgJi7+VjGeNDKW+KHTQBrMlCKKLcZcDT+H1yQ+52VjvzuYNTpIAsPMCOV1m1oywPQvYJ1itEp7Z3PgeK2vAjxICm8uB20+azP/HGSXP+0d3wwCFGgkR3ycpi55mtgN9w8RuzfzB8jJR1/Kf6OAQiTWPkRFPo7eKn35DlfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BXeH8aBl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BXeH8aBl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB640C4CEF1;
	Mon, 18 Aug 2025 13:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524172;
	bh=z1c8VKcR1deaxIVL83XlYAnnGiQXxucv+U6ICGlOhIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BXeH8aBlmmAk5gS5lObTPHoTLsd9PFbPJXgSrZAPZ6juJc4O7l45pS7PBe+NtBcG9
	 KDE9MIyNtMnX9rSkcc802PbvNaff9b1zGP+VdV3DvLQkvhsbE0qCaFfPSPfJcgI6Hp
	 cu6EJ8KGi8P+ubuJ2opAyGnnZDq9b5xar6NJH8N8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Adolfsson <johan.adolfsson@axis.com>,
	Jacek Anaszewski <jacek.anaszewski@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 362/515] leds: leds-lp50xx: Handle reg to get correct multi_index
Date: Mon, 18 Aug 2025 14:45:48 +0200
Message-ID: <20250818124512.343376421@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 02cb1565a9fb..94f8ef6b482c 100644
--- a/drivers/leds/leds-lp50xx.c
+++ b/drivers/leds/leds-lp50xx.c
@@ -476,6 +476,7 @@ static int lp50xx_probe_dt(struct lp50xx *priv)
 			return -ENOMEM;
 
 		fwnode_for_each_child_node(child, led_node) {
+			int multi_index;
 			ret = fwnode_property_read_u32(led_node, "color",
 						       &color_id);
 			if (ret) {
@@ -483,8 +484,16 @@ static int lp50xx_probe_dt(struct lp50xx *priv)
 				dev_err(priv->dev, "Cannot read color\n");
 				return ret;
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



