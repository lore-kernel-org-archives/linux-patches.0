Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C362C190;
	Sun,  1 Sep 2024 17:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210491; cv=none; b=KOBDRLr8TlRguBKEoBReDdqbpXNq6BINFft/Z/GGoZBzcm14FtChyTT/3m8QkOT9JbcL8j8QuQhb8DxcdqHmR+7X71DOlHzJzSvycWtmB7ixIeZ7UoAWRnPtwtYG/0gOh8Xl+HQUH9gmHAkirF0GP94amRlfcuvE3/XXfyInh64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210491; c=relaxed/simple;
	bh=AJFxwj+bB2NuZXJQqGvB75OAciIhHUg3cLvlhsE/MqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o81I/l9prt7p0gYQIU0sjvwAUHmcHkOb71cPRnHm2BEtTx1jAoEFFNG4kjVSfCmTzoGGb5XY01txxq4+Qam2HCj0K+jxxqBIJBi0hnZUf17ghWAeb2fFhcbPY5+qsFwJIZI1pbqdnujxUz/+xYBLrdKm6dqWpNt1j9/LdaWS2JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bhm0UPuu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bhm0UPuu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B21C4CEC3;
	Sun,  1 Sep 2024 17:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210491;
	bh=AJFxwj+bB2NuZXJQqGvB75OAciIhHUg3cLvlhsE/MqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bhm0UPuu5ESLBPOH7FzuOCs6z3SxRdxPhDPMV0p3z8vXGI1xNvaRS3+zDR0N0Wbgo
	 xcc44ysWGg5olckErZ0O6TVAd9v8MPEYmBlMO0CYgkjfVthbLBbRnyvDnzlCosjAwu
	 HZYNTDC5oZk/5kF95eRMqxUlmwqlPVuiji+MTKGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yury Norov <yury.norov@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 174/215] tools: move alignment-related macros to new <linux/align.h>
Date: Sun,  1 Sep 2024 18:18:06 +0200
Message-ID: <20240901160829.940325600@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Lobakin <aleksander.lobakin@intel.com>

commit 10a04ff09bcc39e0044190ffe9f00f998f13647c upstream.

Currently, tools have *ALIGN*() macros scattered across the unrelated
headers, as there are only 3 of them and they were added separately
each time on an as-needed basis.
Anyway, let's make it more consistent with the kernel headers and allow
using those macros outside of the mentioned headers. Create
<linux/align.h> inside the tools/ folder and include it where needed.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/include/linux/align.h  |   12 ++++++++++++
 tools/include/linux/bitmap.h |    2 +-
 2 files changed, 13 insertions(+), 1 deletion(-)
 create mode 100644 tools/include/linux/align.h

--- /dev/null
+++ b/tools/include/linux/align.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef _TOOLS_LINUX_ALIGN_H
+#define _TOOLS_LINUX_ALIGN_H
+
+#include <uapi/linux/const.h>
+
+#define ALIGN(x, a)		__ALIGN_KERNEL((x), (a))
+#define ALIGN_DOWN(x, a)	__ALIGN_KERNEL((x) - ((a) - 1), (a))
+#define IS_ALIGNED(x, a)	(((x) & ((typeof(x))(a) - 1)) == 0)
+
+#endif /* _TOOLS_LINUX_ALIGN_H */
--- a/tools/include/linux/bitmap.h
+++ b/tools/include/linux/bitmap.h
@@ -3,6 +3,7 @@
 #define _PERF_BITOPS_H
 
 #include <string.h>
+#include <linux/align.h>
 #include <linux/bitops.h>
 #include <stdlib.h>
 #include <linux/kernel.h>
@@ -160,7 +161,6 @@ static inline int bitmap_and(unsigned lo
 #define BITMAP_MEM_ALIGNMENT (8 * sizeof(unsigned long))
 #endif
 #define BITMAP_MEM_MASK (BITMAP_MEM_ALIGNMENT - 1)
-#define IS_ALIGNED(x, a) (((x) & ((typeof(x))(a) - 1)) == 0)
 
 static inline int bitmap_equal(const unsigned long *src1,
 			const unsigned long *src2, unsigned int nbits)


