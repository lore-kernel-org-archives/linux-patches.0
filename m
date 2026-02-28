Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13E639B95C
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302557; cv=none; b=PQ937gt6r5K4Ud8ylDPVSaICdCJq/E/vJq2fNGageEtpIL5LmWw7yUpneXKHLb8xZP7EDj3UVrdYg1w34kjfjvP/tsGyOHbIkpxM7f8xDwpskOMVEQS1DfAo7M3T3R71AOoO1PFpVjU1xMfdXTawnqxHuqh0eQ/qleS84N25r6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302557; c=relaxed/simple;
	bh=8ZKCMfBxBsNeeUo24kWWw55cbjuO2EDIHhZPEq+s12k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qxvw/sH0BDzIxF8+w1t52ELyQzyAtFiKAtUNOOlJu6JcEfZZSNa3ud9XY/iCgd1Od25G0S1Iv4JAdkvcFFLbn+6GFywpmmWQMsbu0ATjF4a46R4uaDDmg8P92FvReiDJfQsc5Zdibqm01h2ILaeDSGCyCGdajMUyE+yjkuMLEYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZG6bEH9h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZG6bEH9h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B44C19424;
	Sat, 28 Feb 2026 18:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302556;
	bh=8ZKCMfBxBsNeeUo24kWWw55cbjuO2EDIHhZPEq+s12k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZG6bEH9hjellR05jAk02bPsR5nhDc9QIoHMJvpEwyT9fF3RQmnkRFFyJtq3oRnWLs
	 rniePiTeVjcK223H5Hbk1nvqx22s9TU/re45rnFktHSZXBbWdk+6W5alh9z+UYBgZy
	 lbsv/RlMZQbyDwp7Jx8CdOnw74QWwxVW1dgva32GMzstoa7W3G7+1SntLxO/DdX5Xb
	 kNmijC2D+6E9YiIugtwwfekEzTHBp5wsYwL+KZTRoyA0Wt2JQp8zrDk5UOdP7Aqwh7
	 dRVWpDSJhMJhF1lHZ8zFK/VScwkm7acqxmvgACRQTTwbZEeQPSAccHMSrD1JQMWDIk
	 0xtOHkjnumegw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/164] PCI/portdrv: Fix potential resource leak
Date: Sat, 28 Feb 2026 13:13:20 -0500
Message-ID: <20260228181505.1600663-61-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit 01464a3fdf91c041a381d93a1b6fefbdb819a46f ]

pcie_port_probe_service() unconditionally calls get_device() (unless it
fails). So drop that reference also unconditionally as it's fine for a
PCIe driver to not have a remove callback.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Link: https://patch.msgid.link/e1c68c3b3f1af8427e98ca5e2c79f8bf0ebe2ce4.1764688034.git.u.kleine-koenig@baylibre.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/portdrv_core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
index 3e5274ad60f10..4c57ddfd6275d 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -547,10 +547,10 @@ static int pcie_port_remove_service(struct device *dev)
 
 	pciedev = to_pcie_device(dev);
 	driver = to_service_driver(dev->driver);
-	if (driver && driver->remove) {
+	if (driver && driver->remove)
 		driver->remove(pciedev);
-		put_device(dev);
-	}
+
+	put_device(dev);
 	return 0;
 }
 
-- 
2.51.0

