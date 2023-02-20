Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1CD63B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:50:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22FCBC433EF;
	Mon, 20 Feb 2023 13:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901051;
	bh=r64yiBzGaKtlU8G8fUZFgAEgg9lGCT6yggEySf6vAzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S4pf7jLgwv5fxmoMjZ4rCxCmEspyeO2aWuOz5pR4TaU4i/Yoz7tlPh6tOKnCNYRs0
	 wKt58UQm17IdH/flwRNo12Ev/rpHz+8nwOzhlLHakqloJh6sM4m7HQ5eK6lYtAs4NV
	 bY+pS5/kPh+OeejpuR52G13UO9ZU9Vt48TYStfK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shunsuke Mie <mie@igel.co.jp>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 11/83] tools/virtio: fix the vringh test for virtio ring changes
Date: Mon, 20 Feb 2023 14:35:44 +0100
Message-Id: <20230220133554.095147411@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shunsuke Mie <mie@igel.co.jp>

[ Upstream commit 3f7b75abf41cc4143aa295f62acbb060a012868d ]

Fix the build caused by missing kmsan_handle_dma() and is_power_of_2() that
are used in drivers/virtio/virtio_ring.c.

Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
Message-Id: <20230110034310.779744-1-mie@igel.co.jp>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/virtio/linux/bug.h         |  8 +++-----
 tools/virtio/linux/build_bug.h   |  7 +++++++
 tools/virtio/linux/cpumask.h     |  7 +++++++
 tools/virtio/linux/gfp.h         |  7 +++++++
 tools/virtio/linux/kernel.h      |  1 +
 tools/virtio/linux/kmsan.h       | 12 ++++++++++++
 tools/virtio/linux/scatterlist.h |  1 +
 tools/virtio/linux/topology.h    |  7 +++++++
 8 files changed, 45 insertions(+), 5 deletions(-)
 create mode 100644 tools/virtio/linux/build_bug.h
 create mode 100644 tools/virtio/linux/cpumask.h
 create mode 100644 tools/virtio/linux/gfp.h
 create mode 100644 tools/virtio/linux/kmsan.h
 create mode 100644 tools/virtio/linux/topology.h

diff --git a/tools/virtio/linux/bug.h b/tools/virtio/linux/bug.h
index 813baf13f62a2..51a919083d9b8 100644
--- a/tools/virtio/linux/bug.h
+++ b/tools/virtio/linux/bug.h
@@ -1,13 +1,11 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#ifndef BUG_H
-#define BUG_H
+#ifndef _LINUX_BUG_H
+#define _LINUX_BUG_H
 
 #include <asm/bug.h>
 
 #define BUG_ON(__BUG_ON_cond) assert(!(__BUG_ON_cond))
 
-#define BUILD_BUG_ON(x)
-
 #define BUG() abort()
 
-#endif /* BUG_H */
+#endif /* _LINUX_BUG_H */
diff --git a/tools/virtio/linux/build_bug.h b/tools/virtio/linux/build_bug.h
new file mode 100644
index 0000000000000..cdbb75e28a604
--- /dev/null
+++ b/tools/virtio/linux/build_bug.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_BUILD_BUG_H
+#define _LINUX_BUILD_BUG_H
+
+#define BUILD_BUG_ON(x)
+
+#endif	/* _LINUX_BUILD_BUG_H */
diff --git a/tools/virtio/linux/cpumask.h b/tools/virtio/linux/cpumask.h
new file mode 100644
index 0000000000000..307da69d6b26c
--- /dev/null
+++ b/tools/virtio/linux/cpumask.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_CPUMASK_H
+#define _LINUX_CPUMASK_H
+
+#include <linux/kernel.h>
+
+#endif /* _LINUX_CPUMASK_H */
diff --git a/tools/virtio/linux/gfp.h b/tools/virtio/linux/gfp.h
new file mode 100644
index 0000000000000..43d146f236f14
--- /dev/null
+++ b/tools/virtio/linux/gfp.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __LINUX_GFP_H
+#define __LINUX_GFP_H
+
+#include <linux/topology.h>
+
+#endif
diff --git a/tools/virtio/linux/kernel.h b/tools/virtio/linux/kernel.h
index 0b493542e61a6..a4beb719d2174 100644
--- a/tools/virtio/linux/kernel.h
+++ b/tools/virtio/linux/kernel.h
@@ -10,6 +10,7 @@
 #include <stdarg.h>
 
 #include <linux/compiler.h>
+#include <linux/log2.h>
 #include <linux/types.h>
 #include <linux/overflow.h>
 #include <linux/list.h>
diff --git a/tools/virtio/linux/kmsan.h b/tools/virtio/linux/kmsan.h
new file mode 100644
index 0000000000000..272b5aa285d5a
--- /dev/null
+++ b/tools/virtio/linux/kmsan.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_KMSAN_H
+#define _LINUX_KMSAN_H
+
+#include <linux/gfp.h>
+
+inline void kmsan_handle_dma(struct page *page, size_t offset, size_t size,
+			     enum dma_data_direction dir)
+{
+}
+
+#endif /* _LINUX_KMSAN_H */
diff --git a/tools/virtio/linux/scatterlist.h b/tools/virtio/linux/scatterlist.h
index 369ee308b6686..74d9e1825748e 100644
--- a/tools/virtio/linux/scatterlist.h
+++ b/tools/virtio/linux/scatterlist.h
@@ -2,6 +2,7 @@
 #ifndef SCATTERLIST_H
 #define SCATTERLIST_H
 #include <linux/kernel.h>
+#include <linux/bug.h>
 
 struct scatterlist {
 	unsigned long	page_link;
diff --git a/tools/virtio/linux/topology.h b/tools/virtio/linux/topology.h
new file mode 100644
index 0000000000000..910794afb993a
--- /dev/null
+++ b/tools/virtio/linux/topology.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_TOPOLOGY_H
+#define _LINUX_TOPOLOGY_H
+
+#include <linux/cpumask.h>
+
+#endif /* _LINUX_TOPOLOGY_H */
-- 
2.39.0



