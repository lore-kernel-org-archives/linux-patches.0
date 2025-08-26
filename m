Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C68244667;
	Tue, 26 Aug 2025 13:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214580; cv=none; b=q5WVWkD9BSdicQD4HaK8+OfTtawSbcxDKiNYEL78nzZ+14FjBu+r4x9NjbujS2jJI82tW6Paghn6A9GEDBSfhumhuZOlNV/R1yguQ1/mH/sZWRAjJZ9R4DQ/d2AXWnREgBi82YphuqKPI6iG6A+hJMdxt0aN+v00zgNrjpDQU+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214580; c=relaxed/simple;
	bh=n64Qwo/hJ2GoiKn5Gq9Zm0NrqOs12os5SlMoAObqUZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4dRIKysUzjH7/kmoGa69zHt4u415ZHySfjzFSWlGKJiUn1tsWvoqmJTIDHASAG9a1OmiemfnSOFPhnn06KkzsH8/AlS8TmZuDVqlCsoEqnoKILbsSZKA9fGekMSzVFlFYLBfO+YkEcRItnjVftBq8sBXbSH5Ki1fxS2FgYLzDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p9kbv7py; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p9kbv7py"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B6BC4CEF1;
	Tue, 26 Aug 2025 13:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214580;
	bh=n64Qwo/hJ2GoiKn5Gq9Zm0NrqOs12os5SlMoAObqUZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p9kbv7pyETH1v+dnvdQCxQM0DxR6Kihx3SdYN1xTD3iQ+3UlMDYIoky5gQzF81JQv
	 8lGYlXsNGMo5/F+uDz3sWF7kmzHtvgMak53VMRFbbgILreWAu6hlhF8741vHIs8tAj
	 8vIASVOuJuD4fLrzMdrfR3bZaNCpK0kOLfaRfkFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Adolfsson <johan.adolfsson@axis.com>,
	Jacek Anaszewski <jacek.anaszewski@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 192/482] leds: leds-lp50xx: Handle reg to get correct multi_index
Date: Tue, 26 Aug 2025 13:07:25 +0200
Message-ID: <20250826110935.546325070@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 28d6b39fa72d..cda62e3d3a3a 100644
--- a/drivers/leds/leds-lp50xx.c
+++ b/drivers/leds/leds-lp50xx.c
@@ -486,6 +486,7 @@ static int lp50xx_probe_dt(struct lp50xx *priv)
 		}
 
 		fwnode_for_each_child_node(child, led_node) {
+			int multi_index;
 			ret = fwnode_property_read_u32(led_node, "color",
 						       &color_id);
 			if (ret) {
@@ -493,8 +494,16 @@ static int lp50xx_probe_dt(struct lp50xx *priv)
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



