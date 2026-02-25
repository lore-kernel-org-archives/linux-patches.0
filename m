Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB92A18B0A;
	Wed, 25 Feb 2026 01:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983326; cv=none; b=IeL/xCrD1zHmgg3/+dNhUfYS5ihbRgHhleD13yXnOJEfMyxZo2r4O8GpsV9PoKHKx3Y9VXV0MB6xllIFPTYop3rDR9ZoEDuPHYtOOMcnOKSUuuV+rECbPVzis7x6YQE8J0jUXRKUU6uBFDQoHGpoEnzsrYckgQkphK2AXuZ2qeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983326; c=relaxed/simple;
	bh=o8tmQcY/ZeVTp4brsooNE5esFGtQntu/v26Kl355wWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qky0RGFYZOpuV2/r06+3Dtp802LsFAd98P08DoXozGkK59GxPCQ0i/f+RbBcBck9f9Oq0iNO6p19umITXrJGsg3kq8WFcJiTW5krFINL+HFs/FfnfDSn8z2Cw2xWKd5nEfYUpBGvcV3DCTS/9GMDXB+T8jh30vCLezMlLAxs5W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=18z+61n6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="18z+61n6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8208CC116D0;
	Wed, 25 Feb 2026 01:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983326;
	bh=o8tmQcY/ZeVTp4brsooNE5esFGtQntu/v26Kl355wWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=18z+61n6+QFxF3WmEZvyHqrEPNYclH3UY+xbRLO6V+RNlKgStHL0SedtupW/AkSdX
	 9t+kGW9HmiZ7zz83ot0jNCk6qy98jEmyAf8VWTDifqWnmV25FAYasaZPIUYNlbxd1z
	 6CuzVzgYeFzR4+t1Yv2wPcJJy2GKsotnZzcKnUVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Koskovich <akoskovich@pm.me>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 458/781] power: reset: nvmem-reboot-mode: respect cell size for nvmem_cell_write
Date: Tue, 24 Feb 2026 17:19:27 -0800
Message-ID: <20260225012410.953966160@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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



