Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CDD57D235;
	Wed,  9 Sep 2026 14:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964055; cv=none; b=OU4vdrOK2A0hSrI3tRkCjHruXEUBiL1+8SQ7O/HeKb2Ot/6q6+E2bxrzj8/l2EIF5YTMvW09chl02ORkNwYx6rN62E//SXco5ELjsnkkBbfJwxbbH2e7f1zOBfuPZKBQwJX8RRTZWFU2pLcsqHaWAhpR7Fnl+jV8y5c4GhQbOTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964055; c=relaxed/simple;
	bh=YUzlO/DWX0QVzaP37cTXJfmYDBDaZv61uaMaDaxCqEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aXUt8GT60w/geVkWOtW2UaiWYyjgQRxX+arUP4pwjmLIjRWjLsxNaC9RBQeBPgnsJ6k2VI6Tq6DXjP1ek72WrbrBVyuoTEtQbjeo5l0J2lRqVqV5tFP5KA9as8CzFBYFTju0FYRKV+kZI3N2aYpPdpn4M6RcPg9FfRSRd3bEiAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PO0pZev/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PO0pZev/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64FDD1F00A3D;
	Wed,  9 Sep 2026 14:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964053;
	bh=PWiT9VPZ3F2FzJE9HRuSoQie5iW/q8gHLvul7uWXEKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PO0pZev/OIQxKtdK4pPlAsxTZPWm0PvxbclEo90uyNm/Bkh4XNHLbKTEwvNoWzHOf
	 ZyyZ3ZG2WSjKHQsSvkJzqdfexFibgwoTBBeyV07h4o+p3a+S6KgOMziTSrI2PG3ZdY
	 +JmnqpyBwwT568hxgXPUdeN6n29I70ImkCym9LM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biren Pandya <birenpandya@gmail.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 6.18 291/583] media: i2c: ov02a10: fix endpoint parsing use-after-free
Date: Wed,  9 Sep 2026 15:39:36 +0200
Message-ID: <20260909134248.121139410@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biren Pandya <birenpandya@gmail.com>

commit 94971ba0592ca77ec99b292226a4b398763315b8 upstream.

The ov02a10_check_hwcfg() function calls fwnode_handle_put(ep)
immediately after allocating and parsing the endpoint. However, it
subsequently calls fwnode_property_read_u32() using the same 'ep'
handle, leading to a potential use-after-free.

Additionally, reading the optional 'ovti,mipi-clock-voltage' property
used to overwrite the 'ret' variable. If the property was missing,
'ret' would become negative, and this failure code would be incorrectly
returned at the end of the function, causing probe to fail entirely.

Fix the use-after-free by moving fwnode_property_read_u32() before
the endpoint is parsed and freed. Avoid the error leak by not
assigning the result of fwnode_property_read_u32() to 'ret'.

Fixes: 91807efbe8ec ("media: i2c: add OV02A10 image sensor driver")
Cc: stable@vger.kernel.org
Signed-off-by: Biren Pandya <birenpandya@gmail.com>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ov02a10.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/media/i2c/ov02a10.c
+++ b/drivers/media/i2c/ov02a10.c
@@ -820,18 +820,16 @@ static int ov02a10_check_hwcfg(struct de
 	if (!ep)
 		return -ENXIO;
 
+	/* Optional indication of MIPI clock voltage unit */
+	if (!fwnode_property_read_u32(ep, "ovti,mipi-clock-voltage",
+				      &clk_volt))
+		ov02a10->mipi_clock_voltage = clk_volt;
+
 	ret = v4l2_fwnode_endpoint_alloc_parse(ep, &bus_cfg);
 	fwnode_handle_put(ep);
 	if (ret)
 		return ret;
 
-	/* Optional indication of MIPI clock voltage unit */
-	ret = fwnode_property_read_u32(ep, "ovti,mipi-clock-voltage",
-				       &clk_volt);
-
-	if (!ret)
-		ov02a10->mipi_clock_voltage = clk_volt;
-
 	for (i = 0; i < ARRAY_SIZE(link_freq_menu_items); i++) {
 		for (j = 0; j < bus_cfg.nr_of_link_frequencies; j++) {
 			if (link_freq_menu_items[i] ==


