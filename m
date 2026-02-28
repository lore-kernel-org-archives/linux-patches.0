Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3FB34252B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301774; cv=none; b=g4Td/fn+tRe4vuaDM3yJklpH66ghkM00Pupr0oDpIuTdfP7+AEGxq/UztUqHvsQicDJHlMlKVsCMJI+KLsEswhjD8jMHEJChmCK0hpO6zMmLHLU1SP4ALi1ywSjVcOp/4+TaEPkTMqyrW01AxQtzSSs6aNWK/eJCHLY0hZmOcLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301774; c=relaxed/simple;
	bh=FNCbpSuOGTbr7l5beODturTNZGmgq/0NHyk6+m26uuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dt1xtIM6dYeiTpeuVPoQGcym5vWMBmXoKky+u0YDAs6jGM57Xaj8qmlqYNhSaY4r/nwWrG7WAOg8LYUKIiv/mU9RCcSN0mmEC0R+w/IwRTa2pRTUfNmo7vq0llkbmVaQrS4by5MfF4Q/xMOKMRxVHcbJVRvKZYr2uDNoUFwZ5A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BXpoiOgM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BXpoiOgM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C4C6C19423;
	Sat, 28 Feb 2026 18:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301774;
	bh=FNCbpSuOGTbr7l5beODturTNZGmgq/0NHyk6+m26uuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BXpoiOgM4jY58/GKI/6B/C6tsvs4+p252EIMVC4OgCmBDr75dPK7EWY8SzsVQR+m2
	 U3BW0ggfuIPeANOXvZbv8tleYe15SFwDIp1g4qL9DeiGdiAKjeLj2exQ5rNFGpPJR0
	 8SDnblsNk89lrbELLZ0yLEG6nM1mrRvutWTflTxHcXyiuk4L6XXTc2No/NiFvadbA+
	 k6dk6U7cIcLc5a6EnAhEnV1bKI9KlG59DQ/ibxrvNS/FTFASO0vW2GbZ6BPboq4dF5
	 UDSklIanljZwtrDW/r9OJljWCIHI4nS6W8nsxShBAkpPyeoxRBJnTEXT6kSYQrzLUG
	 T0bPGdiEgYp0w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 182/385] PCI/portdrv: Fix potential resource leak
Date: Sat, 28 Feb 2026 12:56:44 -0500
Message-ID: <20260228180011.1568201-182-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
 drivers/pci/pcie/portdrv.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pcie/portdrv.c b/drivers/pci/pcie/portdrv.c
index ec2c768c687f0..75068c5029b01 100644
--- a/drivers/pci/pcie/portdrv.c
+++ b/drivers/pci/pcie/portdrv.c
@@ -555,10 +555,10 @@ static int pcie_port_remove_service(struct device *dev)
 
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

