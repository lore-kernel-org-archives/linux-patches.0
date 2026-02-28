Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA28833A6F2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302178; cv=none; b=HE+8F2NJoAR0fk+I/sWmbSFy3l5QgA0sQfrKBQdDD9dmnCJ0nDZTVBOOpEyHLDhu3APF/+mgNJS1qaSmvN99Bpogmdd0fkDfcv0YbrhcRu00dePAQOJ5b9gjq2mA9N8L7NL6V3xAfVAamHkStEZrJjPV6nIsvW1KM9d1RhXZtEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302178; c=relaxed/simple;
	bh=Hs4w6l+cfUQviG4d0qm8C1PVPbWkF3fTSJF48h19n04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FZU/evYG9u0eQczEk2WlCZ2EbHLIMl/odJx+Yp48eBB7qUw0eQb4wHJWQvRSys5cRI/pSdNaaIP5Njvkaneuc2/nfpf0OimbRVmm+qK213uGX497UdW7e/QNkV5aFV32K8Er+maN0xNKOePEXfJxangrkCoC+CJWzQ4XoQ8ONew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nA48L34m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nA48L34m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FB5C116D0;
	Sat, 28 Feb 2026 18:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302178;
	bh=Hs4w6l+cfUQviG4d0qm8C1PVPbWkF3fTSJF48h19n04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nA48L34mwQfbT9gKWa+W5YQ+ws8PqeOyniraEfdaNlgbSv4ATbB1D9gCCJHm0R+PR
	 rf0q/XNWCFMojetVknPE87qW0lLo4FxqkT2aF8HbzRVSMo89uB3xQeU/q8BDE35NRC
	 GlEXclwvzNnJ6L1AfTiyht/GmhZTOKnY6yBSp1SewAhZw8yXYzQLfEsZBShYH40k9Z
	 sEC8rAWHx0vgHYPfqJaNA6S567u9ewnMesRdnwfPH48v66rdfxqFSDkTEtQxQwF95E
	 /GkLM4NwDgFpv9xyFZKOtFkh76kRBby6gv2L8MYJo8gLJ3H/DtcTG1TL3fbZqO5THT
	 pxj9l+vYkriTA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alexander Koskovich <AKoskovich@pm.me>,
	Alexander Koskovich <akoskovich@pm.me>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 178/283] power: reset: nvmem-reboot-mode: respect cell size for nvmem_cell_write
Date: Sat, 28 Feb 2026 13:05:20 -0500
Message-ID: <20260228180709.1583486-178-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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

