Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC163A2AEF
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302705; cv=none; b=QA1LtZQJ0fOqyiERPKmDb4PKXmbJc0Y7ibNnAa59EQS1aC6Yordu4box5Umjy1xfRMLzsXPfnVqrby269dVb+zUQZ+c/SbqqnCJ+Ei7c6jsPvDeZ+mQxS0ZmPsidxlTlQKE9BccvwdkSu/A8i1R1PeBuUwsQ6Gd9fL8YUNHmGM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302705; c=relaxed/simple;
	bh=xt6lNV6bCJ6OycsqAXldRUF6BEbdM/4j1CGn8LazFes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UhC1zDT3/rHrkPKuKNACrVc793vvvLQQDnqUPv22rXOiTuhDFM6nqjXqkyI0hvb8YNaxf+1zQy1Zcwc6IhmmvN6HwUaPYb2tsHIfgbBz4icn2aJ1yGDi2o6Kyy9GstAgrPwLDy4v/EMs0iHpnq88ga+I6xd3N9fACuwPVks9eX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=te8GBS7F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="te8GBS7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A7F6C116D0;
	Sat, 28 Feb 2026 18:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302705;
	bh=xt6lNV6bCJ6OycsqAXldRUF6BEbdM/4j1CGn8LazFes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=te8GBS7FFDL3giJ/L2f9fZkdyDbKIwI7BPqHc39To0kvvvSZ9hwxD4zAmKXN6aeOA
	 5rWA0Jo1f1TabX1agLzC7ruGEvTORfrAqOw5l2dJLlj3kLoLBd/fdwf7r/0a8mURM9
	 fZi6+iu0c0CkxgS29Fy1/TCKad+Fmaw3kmw+k0oOj2TOgngRTMdo2qh0scXVs6z5n8
	 quiyba6zNi4adSEA2l5EnszQktEuTBw6G7GV4i+jTTji9wk8CQt/ODvuLDF15ZRwYx
	 ve/bU5VcKYD2a9maaMJFurtneA5pBGH4FgXk32mFIGX4B0a+DQkDUlakck0ETLX292
	 mF7H6uMP6Bd1g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 062/147] PCI/portdrv: Fix potential resource leak
Date: Sat, 28 Feb 2026 13:16:10 -0500
Message-ID: <20260228181736.1605592-62-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index e3d998173433f..0ebf3b2674036 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -550,10 +550,10 @@ static int pcie_port_remove_service(struct device *dev)
 
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

