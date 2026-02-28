Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658722DB7B2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301841; cv=none; b=U+XwuTLaERWvXlLOJNqqbhwCbD+vZlhLNgQU0dUSb5+hvNcXhZkVFHLcSEyRhiNxnJEmBtjNIiCPe7U5WgXPQBbbPEQJJxMDfvgr2Xv4qaNKhti6wKMi3TGPxI5PU2ZTL78wByqYeTcKr109FKlOQCBRc2/aIxxQ4HAEpzFyc4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301841; c=relaxed/simple;
	bh=8YrhDaBR9aNkf67zquQatHFqddMhDhei/u3L9B65JM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FYSAGoMZ0TgCYXceBPMbMifa7rhVoLhgnuQtOnWd5IPIvZemfcOTUvioRkQWbJb6DnlIZRc/N9PMMTvM3zcC3Ln5wVDxAN6Tn5zV/MhMRYp+4w1wLU0u3L/KjaONJuDKH8QYFHvaGF48gBYQ/vKC8GFqDcMo9fzEMnI21tIp7So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uA2xk2iH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uA2xk2iH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D77C19423;
	Sat, 28 Feb 2026 18:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301841;
	bh=8YrhDaBR9aNkf67zquQatHFqddMhDhei/u3L9B65JM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uA2xk2iHBHxYDEDKOWLEEZ2c7/BMCw8dksgOZ+iM6UjRQrYlrOyd4OiQ01ltdpwBA
	 a1OzGEXagbRfkbjihcXbfpKN7ZsXt27mrTRd7ieop0Ocno13uwT3f7LzmxWgYgDThG
	 nDYsQWVGrAjwC5yYr1KVk2v/fZgRWZt9I0G1C1rBP6Lamyz1hfQhY8c7/yDrzR6BsR
	 EqGkXUheIhSx8LpYjEJ4DnjlWGKTlOBGtUELUf4FBmjM/0lHLafQipSqYT/+D011sy
	 NodUBAzVHQ6znDVTRUea+pHyxiTFtElRdPEqX+EHX3Uqv5smgtjn3/6/VH3p0vvt0M
	 PWT7XDBcQUPig==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alexander Koskovich <AKoskovich@pm.me>,
	Alexander Koskovich <akoskovich@pm.me>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 260/385] power: reset: nvmem-reboot-mode: respect cell size for nvmem_cell_write
Date: Sat, 28 Feb 2026 12:58:02 -0500
Message-ID: <20260228180011.1568201-260-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 41530b70cfc48..d260715fccf67 100644
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

