Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3D139B976
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302593; cv=none; b=WasnZeJeBXwZpoym/n2VA0OgYeks7zrLLz984+xgwp+fXIH55CWSP2qLmXLvMCBlVIiBN998TrLbOmEmG2FWxco7/suO95stnteDSbAEvbXnTjPOfNjFoK/DT7ZojcAz/vG5LSraCpk5VTs4bCOwDCvSfvxxbwb4CKymkpHH1so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302593; c=relaxed/simple;
	bh=Hs4w6l+cfUQviG4d0qm8C1PVPbWkF3fTSJF48h19n04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hlQY0lnKe+h0pKWi0x6EUSleOkuwdejNTPJn+v0PHfsECCPlP7UP3LlVSwUraJ7WaeAdaAk9jeYgTCJlfUZID/w5oRISMHYqq2tdOpSsKasd5roFpXcMZT4/436hTk4clFYFGerLd72YNHjbOkU+0YZsbCi6+TZEsn+GBxo30nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YVDZsgMf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YVDZsgMf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C59C116D0;
	Sat, 28 Feb 2026 18:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302593;
	bh=Hs4w6l+cfUQviG4d0qm8C1PVPbWkF3fTSJF48h19n04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YVDZsgMfPYsBVZNV+7APg5f86T0NGozY/xqNhril4MZZLtCjH0AsSAJDTdc5iYIG4
	 n3wJwPWjwUBz5DzrzJNEw/pIyzEMFlaG0CyMsic7aZrHPfD036U9iUlkQPjE5pfftw
	 0RHN6zESxpoUfG1qmkb3KPrFx14FLNPQYNCLhzQ9zTh6hMNNpJod48Snhyxh+WS/on
	 95+ieZlKap7exxKnIis5dz0VDUpf/bpCCb3PSt/l94K3+MlsPqesAqBJ2G44/whLvb
	 DSyl0wN8vvN0SDubQzcg6xXHWcHwXyf4UinirtHoTNCq3hjfxOMrV3+0R/C4wjbOCo
	 ohX1xj+aWm4/A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alexander Koskovich <AKoskovich@pm.me>,
	Alexander Koskovich <akoskovich@pm.me>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 104/164] power: reset: nvmem-reboot-mode: respect cell size for nvmem_cell_write
Date: Sat, 28 Feb 2026 13:14:03 -0500
Message-ID: <20260228181505.1600663-104-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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

