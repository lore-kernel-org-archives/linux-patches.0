Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758DD35AC0F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302728; cv=none; b=dTNp3ECiZJqYmN1Fr73LEVOQPeKfYSmRdyj7K0TYyR82R37bRzs63iNMBwKV6E+DV2xcEIZQGUmCN+rKUfBkYNfBodQOX4O5108wHWYfl9hEUer8LuuiByVrSo8kBOb/cKHxR1oblUGwJuDq7SDXHQKe96Xrc5X/xvy3SPMgyNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302728; c=relaxed/simple;
	bh=Hs4w6l+cfUQviG4d0qm8C1PVPbWkF3fTSJF48h19n04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DMgC/jJIeitEdo9Mi8mV8uXOWA6JALmg85WJn76Uq5YMSOJqDLc3bw1WnyHdVZxZDAQqvWKqOyx1sIlqJ5fOn7XWHGsZA8Qkg1HNQEFHK2U+KgxKc75/AS5Ta8UGykr45GN9sKV2Xq52YBai5qTNclwyOec4Nd/Z+/6KwP5HrRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QO9qctQy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QO9qctQy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E3BC19423;
	Sat, 28 Feb 2026 18:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302728;
	bh=Hs4w6l+cfUQviG4d0qm8C1PVPbWkF3fTSJF48h19n04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QO9qctQygaEK1NVWI7J1To9/oxf++e4hXB3T7fEkiK9fyPTIbB9N5mcE95Yao7Lyo
	 55CBC9g6BRzWiPKVZYZ+5DBRiyw4qXjjt93g4am/68I/e+Q4rWE2yMU5q5+e0sExyn
	 XCLMMhe8r1qieHsTW8gTQM2Bgm97bLTP5sOITz3P3XQZPn7rRkfZa49sZnH3dqvadv
	 PUUHvR+DJeCCu4+652FTdJ5wb42/+maIslGN2ORqEdkzZwCBg/wkz2cqSOI7IeJeYD
	 V5Th/0XR2blcPRbEMprK8GfUhhrQBKa7CAAsMVBASSLpkPMAVN3Il0UqhFRyOniDJO
	 lYE8BS58qX9Wg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alexander Koskovich <AKoskovich@pm.me>,
	Alexander Koskovich <akoskovich@pm.me>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 090/147] power: reset: nvmem-reboot-mode: respect cell size for nvmem_cell_write
Date: Sat, 28 Feb 2026 13:16:38 -0500
Message-ID: <20260228181736.1605592-90-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Alexander Koskovich <AKoskovich@pm.me>

[ Upstream commit 36b05629226413836cfbb3fbe6689cd188bca156 ]

Some platforms expose reboot mode cells that are smaller than an
unsigned int, in which cases lead to write failures. Read the cell
first to determine actual size and only write the number of bytes the
cell can hold.

Fixes: 7a78a7f7695b ("power: reset: nvmem-reboot-mode: use NVMEM as reboot mode write interface")
Signed-off-by: Alexander Koskovich <akoskovich@pm.me>
Link: https://patch.msgid.link/20251214191529.2470580-1-akoskovich@pm.me
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/reset/nvmem-reboot-mode.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/power/reset/nvmem-reboot-mode.c b/drivers/power/reset/nvmem-reboot-mode.c
index e229308d43e25..819f11bae788b 100644
--- a/drivers/power/reset/nvmem-reboot-mode.c
+++ b/drivers/power/reset/nvmem-reboot-mode.c
@@ -10,6 +10,7 @@
 #include <linux/nvmem-consumer.h>
 #include <linux/platform_device.h>
 #include <linux/reboot-mode.h>
+#include <linux/slab.h>
 
 struct nvmem_reboot_mode {
 	struct reboot_mode_driver reboot;
@@ -19,12 +20,22 @@ struct nvmem_reboot_mode {
 static int nvmem_reboot_mode_write(struct reboot_mode_driver *reboot,
 				    unsigned int magic)
 {
-	int ret;
 	struct nvmem_reboot_mode *nvmem_rbm;
+	size_t buf_len;
+	void *buf;
+	int ret;
 
 	nvmem_rbm = container_of(reboot, struct nvmem_reboot_mode, reboot);
 
-	ret = nvmem_cell_write(nvmem_rbm->cell, &magic, sizeof(magic));
+	buf = nvmem_cell_read(nvmem_rbm->cell, &buf_len);
+	if (IS_ERR(buf))
+		return PTR_ERR(buf);
+	kfree(buf);
+
+	if (buf_len > sizeof(magic))
+		return -EINVAL;
+
+	ret = nvmem_cell_write(nvmem_rbm->cell, &magic, buf_len);
 	if (ret < 0)
 		dev_err(reboot->dev, "update reboot mode bits failed\n");
 
-- 
2.51.0

