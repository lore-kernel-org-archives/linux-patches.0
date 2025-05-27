Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9F2280038;
	Tue, 27 May 2025 17:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365926; cv=none; b=IcLo3wi+wQesuaptjtUCt1XhPMuzjdKGVdXA3kAxbHiJrOgwky+ggx1y8tKVfSsFlIh7zRK7KeCRN9D6juCusJUDVka3DhIuf0RSLIhLtyN6+GqQ1dpkZ3dhSsBal1UEl5wLDuXDG29SQWVOlzHgQaI7MIA4BWvySjjdcmpgXLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365926; c=relaxed/simple;
	bh=jUwNyQCD8l6yRBy6oaPNQIuva4X+9q5QaBWO8WZ8gvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gr6uFFlCWAKjjzAtIwmejy/mu04sg7Q6XlggovO3Tuc7hvBRd6g9LcOakd31hwVm55lnQ6hIQ784hXGpXq2GQqqoNtG8rGlYi3BhGoWSX5Su21X6Ppg2THxPwTU678V3ImwqrSSYcryel/TQKmWvAyZyn9Hf7nzcga/pcvmF13c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mggFhgY3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mggFhgY3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468B3C4CEE9;
	Tue, 27 May 2025 17:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365926;
	bh=jUwNyQCD8l6yRBy6oaPNQIuva4X+9q5QaBWO8WZ8gvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mggFhgY3tJ46F8Dul/G05JH/BTVlf3WCAfqXbQ7umzWF7k4PuvS0XHEn0yMw++FYL
	 uPmHu+gDqlVL9MNpo7EDGOyR1YTtE5SrdJGzjUEYlWT71jXbgwj4ZA8s34BjdiZFgt
	 26F/VZkTQaCPfL/wQ7pfqggYQ0BkMs5zsPbvITbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 534/626] soundwire: bus: Fix race on the creation of the IRQ domain
Date: Tue, 27 May 2025 18:27:07 +0200
Message-ID: <20250527162506.693179178@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 263ca32f0c5c3..6ca06cce41d3c 100644
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



