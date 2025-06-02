Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02764238C19;
	Mon,  2 Jun 2025 14:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874021; cv=none; b=uqKIsuDgMZSxYLUPZeij/dMGH3c1Mz/2Jgy8NyYb9G1GD6ng/zBv4/XMNCO2oa3zeWiknCemr2yIkTSDWJ8zMt8nVutJajcDfmSpZm4ZfowieOTDWV9ROr4a9P4vn29MybutzHtdJoCBO5KrR56VURq3bOGd57b26T8XgHNdH7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874021; c=relaxed/simple;
	bh=wNEX5h6oHV+4NaPktCLx3H6OMMo3enggxtvK37blxyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HO2deAmRWlan/SQ+XksSoF4w54O7GirSShliXodTBjaEcyPSMtwIRAGPVqZS1u6A9IIRVPwEWQFwa8EZrpgR2WOvPgcH+FB1vT6W9pXyEPs+zMsgKZ5RDqldZq7t1MR+QRz3yJJ7aTwg5SOS39obm9uWFl1+ktuW+0kwvCsLolI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D9BNjPkx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D9BNjPkx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E56C4CEEB;
	Mon,  2 Jun 2025 14:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874020;
	bh=wNEX5h6oHV+4NaPktCLx3H6OMMo3enggxtvK37blxyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D9BNjPkxNwW2VeA89XSXlA2nz2UnpwyKQopGg8NWwCjkWyW4ES6XFvUn+zvchQ+ft
	 7x2odH93SYiEUPxIUeLu4PU3nwfIbqYidl4jg8n8OhC23mgaAe/NJeJQKK8RMz/9Sl
	 T//0EXiufjPGs9Pvha394u3kD46ttn06tX6IqmhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 330/444] soundwire: bus: Fix race on the creation of the IRQ domain
Date: Mon,  2 Jun 2025 15:46:34 +0200
Message-ID: <20250602134354.329233314@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit fd15594ba7d559d9da741504c322b9f57c4981e5 ]

The SoundWire IRQ domain needs to be created before any slaves are added
to the bus, such that the domain is always available when needed. Move
the call to sdw_irq_create() before the calls to sdw_acpi_find_slaves()
and sdw_of_find_slaves().

Fixes: 12a95123bfe1 ("soundwire: bus: Allow SoundWire peripherals to register IRQ handlers")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20250409122239.1396489-1-ckeepax@opensource.cirrus.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/bus.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/soundwire/bus.c b/drivers/soundwire/bus.c
index e7553c38be59d..767942f19adb6 100644
--- a/drivers/soundwire/bus.c
+++ b/drivers/soundwire/bus.c
@@ -121,6 +121,10 @@ int sdw_bus_master_add(struct sdw_bus *bus, struct device *parent,
 	set_bit(SDW_GROUP13_DEV_NUM, bus->assigned);
 	set_bit(SDW_MASTER_DEV_NUM, bus->assigned);
 
+	ret = sdw_irq_create(bus, fwnode);
+	if (ret)
+		return ret;
+
 	/*
 	 * SDW is an enumerable bus, but devices can be powered off. So,
 	 * they won't be able to report as present.
@@ -137,6 +141,7 @@ int sdw_bus_master_add(struct sdw_bus *bus, struct device *parent,
 
 	if (ret < 0) {
 		dev_err(bus->dev, "Finding slaves failed:%d\n", ret);
+		sdw_irq_delete(bus);
 		return ret;
 	}
 
@@ -155,10 +160,6 @@ int sdw_bus_master_add(struct sdw_bus *bus, struct device *parent,
 	bus->params.curr_bank = SDW_BANK0;
 	bus->params.next_bank = SDW_BANK1;
 
-	ret = sdw_irq_create(bus, fwnode);
-	if (ret)
-		return ret;
-
 	return 0;
 }
 EXPORT_SYMBOL(sdw_bus_master_add);
-- 
2.39.5



