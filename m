Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A5424EF83;
	Mon, 24 Feb 2025 14:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407962; cv=none; b=LpNvTgvx/dLPPuZcVFL/tdethrNyhWNmYZluCaF2xnL7+oxmcsF9aTLTVkmjzVfGGpe1ki8E7X08W3jHByjSRZRiEpOMjYlMeoryQKkPDIrqxghKOvNPFQ/q0c43rUrIohgcbIJ9JmJlQXNl4qZX5le02C2kE89Tn375wC7RbSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407962; c=relaxed/simple;
	bh=tV9xg/DkNjp7jtjcmEHwxYyQNmCCEYQLLdwFvpslpqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fqBsOgRGgF6ny7jR+/SIinaHrgFn26eVL+vTCKZxffjeZkPWfvWsHGn0NccBBYoyCCzA8NnOjybTc8pe85HgAyUZwrUYbOr15cNrup8UBoHhK7qN/rfNkwHV4ugHroESZvVURieBWKthvhOCLj8aVrVh4ek2c3l1h9hEUyV3BHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a9aGqw7l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a9aGqw7l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C396C4CEE9;
	Mon, 24 Feb 2025 14:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407962;
	bh=tV9xg/DkNjp7jtjcmEHwxYyQNmCCEYQLLdwFvpslpqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a9aGqw7lxG+WgPSc4D9n8CqKDwgrY37Sx8rcVzYp36X4OaTBABAkke+g8MJ2fj6fq
	 tqCX1sFUXGHbHb5rtsPsxtLtE28nee7bCk0BhED0a3qsFwz5xYviqCCSJbsKamPNBr
	 EMWKFd3TUDbyDiJlFTOtSNs2LO8LbqtYBrRr1uJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/140] nvmem: Create a header for internal sharing
Date: Mon, 24 Feb 2025 15:34:17 +0100
Message-ID: <20250224142605.296057610@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit ec9c08a1cb8dc5e8e003f95f5f62de41dde235bb ]

Before adding all the NVMEM layout bus infrastructure to the core, let's
move the main nvmem_device structure in an internal header, only
available to the core. This way all the additional code can be added in
a dedicated file in order to keep the current core file tidy.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20231215111536.316972-4-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 391b06ecb63e ("nvmem: imx-ocotp-ele: fix MAC address byte order")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/core.c      | 24 +-----------------------
 drivers/nvmem/internals.h | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 23 deletions(-)
 create mode 100644 drivers/nvmem/internals.h

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index fd11d3825cf85..ec35886e921a8 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -19,29 +19,7 @@
 #include <linux/of.h>
 #include <linux/slab.h>
 
-struct nvmem_device {
-	struct module		*owner;
-	struct device		dev;
-	int			stride;
-	int			word_size;
-	int			id;
-	struct kref		refcnt;
-	size_t			size;
-	bool			read_only;
-	bool			root_only;
-	int			flags;
-	enum nvmem_type		type;
-	struct bin_attribute	eeprom;
-	struct device		*base_dev;
-	struct list_head	cells;
-	const struct nvmem_keepout *keepout;
-	unsigned int		nkeepout;
-	nvmem_reg_read_t	reg_read;
-	nvmem_reg_write_t	reg_write;
-	struct gpio_desc	*wp_gpio;
-	struct nvmem_layout	*layout;
-	void *priv;
-};
+#include "internals.h"
 
 #define to_nvmem_device(d) container_of(d, struct nvmem_device, dev)
 
diff --git a/drivers/nvmem/internals.h b/drivers/nvmem/internals.h
new file mode 100644
index 0000000000000..ce353831cd655
--- /dev/null
+++ b/drivers/nvmem/internals.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _LINUX_NVMEM_INTERNALS_H
+#define _LINUX_NVMEM_INTERNALS_H
+
+#include <linux/device.h>
+#include <linux/nvmem-consumer.h>
+#include <linux/nvmem-provider.h>
+
+struct nvmem_device {
+	struct module		*owner;
+	struct device		dev;
+	struct list_head	node;
+	int			stride;
+	int			word_size;
+	int			id;
+	struct kref		refcnt;
+	size_t			size;
+	bool			read_only;
+	bool			root_only;
+	int			flags;
+	enum nvmem_type		type;
+	struct bin_attribute	eeprom;
+	struct device		*base_dev;
+	struct list_head	cells;
+	const struct nvmem_keepout *keepout;
+	unsigned int		nkeepout;
+	nvmem_reg_read_t	reg_read;
+	nvmem_reg_write_t	reg_write;
+	struct gpio_desc	*wp_gpio;
+	struct nvmem_layout	*layout;
+	void *priv;
+};
+
+#endif  /* ifndef _LINUX_NVMEM_INTERNALS_H */
-- 
2.39.5



