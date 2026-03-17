Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDA2179A3;
	Tue, 17 Mar 2026 16:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766227; cv=none; b=hl7svXYT0iLEgdC25b53xe4AJKZLOb6hD9wpEcgM2GSHtvJT6R/rhZ1PRVYipGnppCGXXShaK7cF6W5yJj9qrkY88Uo+Doz5klxwgtyd3my+dOMsg3xwp85wYBD9nRhDZr3bmd6Hk8fAb0M0FnCrinZI2zJ2VXA2AO8upuh9WSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766227; c=relaxed/simple;
	bh=gbhmR0Ii2CdeIyFxdwdlZ52jkR257u46ueG4+Py8aYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EbmNA6ij6N2eL57lhJl912p1lJXLyjDQ/5hU97dhtUDq68LD8PRESMBc6Q+jmMSX6McZVZUZhlamI2MjcwTsvZznNuJGEY4aQLwz7plqZZasy5AUBeJM20zh7sUHoyq3NtbugqV+bFCQZzx3kQUP0nsxrbcImegsCtia8SqZoco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wbY6XvG8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wbY6XvG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6FCFC4CEF7;
	Tue, 17 Mar 2026 16:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766227;
	bh=gbhmR0Ii2CdeIyFxdwdlZ52jkR257u46ueG4+Py8aYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wbY6XvG8lqO/s775Ly2baE2/zyrwGI/cTanTadJht6OaVv5e5qzD9dW/jWIp6UEXS
	 xiQ//N0F3FiX4bb/B/IqX73FxOP4xFI+qGx+uD6c7gCGdU/OHdQWGXVYn0uimjeyDx
	 LqjI5aIbHIqdbC09HVL5bNFna1ruBOCICEg0Ua+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Ernesto Martinez Garcia <ernesto.martinezgarcia@tugraz.at>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.19 196/378] mm/kfence: disable KFENCE upon KASAN HW tags enablement
Date: Tue, 17 Mar 2026 17:32:33 +0100
Message-ID: <20260317163014.214976588@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

From: Alexander Potapenko <glider@google.com>

commit 09833d99db36d74456a4d13eb29c32d56ff8f2b6 upstream.

KFENCE does not currently support KASAN hardware tags.  As a result, the
two features are incompatible when enabled simultaneously.

Given that MTE provides deterministic protection and KFENCE is a
sampling-based debugging tool, prioritize the stronger hardware
protections.  Disable KFENCE initialization and free the pre-allocated
pool if KASAN hardware tags are detected to ensure the system maintains
the security guarantees provided by MTE.

Link: https://lkml.kernel.org/r/20260213095410.1862978-1-glider@google.com
Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
Signed-off-by: Alexander Potapenko <glider@google.com>
Suggested-by: Marco Elver <elver@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ernesto Martinez Garcia <ernesto.martinezgarcia@tugraz.at>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Kees Cook <kees@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kfence/core.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -13,6 +13,7 @@
 #include <linux/hash.h>
 #include <linux/irq_work.h>
 #include <linux/jhash.h>
+#include <linux/kasan-enabled.h>
 #include <linux/kcsan-checks.h>
 #include <linux/kfence.h>
 #include <linux/kmemleak.h>
@@ -912,6 +913,20 @@ void __init kfence_alloc_pool_and_metada
 		return;
 
 	/*
+	 * If KASAN hardware tags are enabled, disable KFENCE, because it
+	 * does not support MTE yet.
+	 */
+	if (kasan_hw_tags_enabled()) {
+		pr_info("disabled as KASAN HW tags are enabled\n");
+		if (__kfence_pool) {
+			memblock_free(__kfence_pool, KFENCE_POOL_SIZE);
+			__kfence_pool = NULL;
+		}
+		kfence_sample_interval = 0;
+		return;
+	}
+
+	/*
 	 * If the pool has already been initialized by arch, there is no need to
 	 * re-allocate the memory pool.
 	 */


