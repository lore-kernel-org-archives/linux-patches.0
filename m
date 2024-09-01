Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA6117CA1F;
	Sun,  1 Sep 2024 16:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209006; cv=none; b=UEQmYfEkOBTn9EtklCMjypF/H0763XGD8OoWUrB300ib9ZscY7vXdfk2VadTKS0h6MopBuqCkkCIxq0JTuEU5QtgXV5Kw2AfXGno9KPkzA6wriJr18i68esK9ywuz23pfeKB+gqXOSXfGEMF26hrugvAhpbiJ8rGIl1vmKbAi50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209006; c=relaxed/simple;
	bh=k8Vu5GbhatEthMtKawaWANqRRH1FVabqTpQdS3rgJJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mm1UHCRK9Ncs/owNhr7Lf7KoZVsCu4JaOq4kHMSLLzeH1vq7Aqa9jbCdyW46eXx9KueXvmQHegzp3BCes94OJhh4pFoWWsXfZdcJWKcZCsX1PmKqPiXjh9haCEBblrE9l3KwZ5HjClyv4nigoHFw3EjL3MGWp6i5GzpIA20sVsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ls9COscB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ls9COscB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57243C4CEC3;
	Sun,  1 Sep 2024 16:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209005;
	bh=k8Vu5GbhatEthMtKawaWANqRRH1FVabqTpQdS3rgJJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ls9COscBg3iL9cR1Bh3EuzdiMpiS/jcFW8iWwgOlQcGhtOjZTBgjFJOAXFiqYSle/
	 HOHUXkL8yQrEBb8EErisehzRJH7natxznmZt3Ep0zoGzeoMxtAhgok1RoQ3bvnqhRR
	 V7nOj2shmJfVYLkm8GJLdNBMa8v63/oGxofm8b5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yury Norov <yury.norov@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 106/134] tools: move alignment-related macros to new <linux/align.h>
Date: Sun,  1 Sep 2024 18:17:32 +0200
Message-ID: <20240901160814.077821000@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 tools/include/linux/bitmap.h |    1 +
 2 files changed, 13 insertions(+)
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


