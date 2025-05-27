Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586AF28001F;
	Tue, 27 May 2025 17:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368453; cv=none; b=nvQ9H3zFI4PSHRfRZo69EY8qL3rC5NmrgYeRx7XuaWTnQJke2rrihAIstZn6RUhv8NJk9ncfa1SiJmP0kiVHRJv0Hd6AEELNoke8otjP6yp6wzisqcoLUa0WhANVNBLvPzXwp/iWBARqZT9ahDsvsb6pQc0qVe5wjdOBE3JrJRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368453; c=relaxed/simple;
	bh=Gr9GNepdHE1NTmcygRiluljI2mNgv3GXKV0A1I7CL9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQ7i3mPyzR43ZXFumtBRhK+nUV1QXXulvJEKSUU7YZek4avJlqgZojWFiSr6eLYeEu+HwqqyEGKseMXXFOzaIpDsx+jk2H7GJ113D6Ki2jAhQ8UTIJKNXoZ5bJva/BbD6TB6CKZ4/22gAjkzFvXPcp1aHbNwxSm4wp5Ii9VV0Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a3mWOl/j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a3mWOl/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC62FC4CEE9;
	Tue, 27 May 2025 17:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368453;
	bh=Gr9GNepdHE1NTmcygRiluljI2mNgv3GXKV0A1I7CL9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a3mWOl/jh7V5ncArb7DBgcw7V/o2HY9/nPcRAfwEOrVE8DEAjGelHkm2GHyjSnUy4
	 lGV+QZYsZbjZivAcx7cgYsm2Fl1LKF3Ngv52rOvnH52FLzuQFxSJkfo+oSlz745ghd
	 SiVS89KZmQ58wTpxEUM6WsWtP/LD6zdg5DqLQC9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 681/783] soundwire: bus: Fix race on the creation of the IRQ domain
Date: Tue, 27 May 2025 18:27:58 +0200
Message-ID: <20250527162540.861621855@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 9b295fc9acd53..df73e2c040904 100644
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



