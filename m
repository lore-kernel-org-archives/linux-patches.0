Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CCE346E70
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302365; cv=none; b=gZ4udMiQCBojcdAmfuES7v1ErxzFzBY8K3glEqcvI+XrpV8p9URLojdzsTeICCIYmQRJot7C9w81hmnmLhYBdeThYH6LVg76y5iJlxOZRucc35oTilmRV7fxEUCuOquveSBUhkLTqhOZeK9hhrlKPym6UblvLbtYDvuKEFIHBQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302365; c=relaxed/simple;
	bh=7s5r+1ie2ry8z5orN0KoHwGI/OljXSCHco53DShLsLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bJ7qx9MNcULX7ytQRp16Be0xrrTfGJSvZNmzGzgb43B5J4+tKYjY7sXgsdQ1YES6WfxNnKMUmDAI6Wspo3OEY/hZqNndc5y0zrvM/Ff5hBSxDt1U+ei2d6JbcCjEAdcGZkwhTmvXbTfqAMNB5fy/oq0dn/NKsfvYD/zJ+OiwLoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BIGoTIyu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BIGoTIyu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B08C116D0;
	Sat, 28 Feb 2026 18:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302365;
	bh=7s5r+1ie2ry8z5orN0KoHwGI/OljXSCHco53DShLsLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BIGoTIyuxJi2hlC4lsFvqM0/fhf9yakA8WQi2bF+0A3Ek8SCy8kqKo1q89541OcXR
	 eyqmxZv05GdaCr3cQOvB91ihKTO/OOj3p6Y70UKa+Azv4kO/HfK7RcHxOBA69wfBtn
	 SvhTvzezxn7bsQe6rUwpKgAYVbKZ4V/o5LIlwKRyE8sCqahzI3JndT0WgBH8NlRkN2
	 RNIoS+/s+Oiw9tbbQzfAhwvM7u7fciLHTFit0e1Alv9c4HzjqGCUcPZ6bmBZ2M9APc
	 TR/j455449hHFmozMUFj0f7PBbUJZOhutBkzTlQJ35O7lWF5oNlzanYSPy+wqoQ/5O
	 sz1daHT0L+9fA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 092/232] PCI/portdrv: Fix potential resource leak
Date: Sat, 28 Feb 2026 13:09:05 -0500
Message-ID: <20260228181127.1592657-92-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 332315183cd45..8b7aadc716ae8 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -540,10 +540,10 @@ static int pcie_port_remove_service(struct device *dev)
 
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

