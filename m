Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD44A3B9D9D;
	Mon, 23 Mar 2026 16:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282917; cv=none; b=jsEY/jjB4CRBDRCbiMAy/DEDH5SM5W3keZqNaAxTQ+I/CwcrdHzEb1eV8lqReqwpe++xSdOy74rHAodZn3wB6u7uZUTkEw3gvC7PYXSdlOKCp8G/6+G6e0Vk/s9krtQznQE7sGutfMzWYRJdVB3/5PuLTzCaZIGqX5/PDmrJ6KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282917; c=relaxed/simple;
	bh=rBaU7MS0a+GE3xIXRJFpaRm7qEviipYtfRjEiE7M0+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ElPFKbrgjoqVY279+WCLVDSkbz9gDj3UvyiG+52xQ42GQx5lXKWks683ILX1j8UV3HraBBOkG/RHNh5v1FFHKfaUv7KAiXPc7c2e3nSPpE+mWcUYV5/VbWItK16tL9PbSWH650Jbjy6gY6cYosKNClndhO5UsjpbKzQsfIz89J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N3shejrk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N3shejrk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C069C4CEF7;
	Mon, 23 Mar 2026 16:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282917;
	bh=rBaU7MS0a+GE3xIXRJFpaRm7qEviipYtfRjEiE7M0+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N3shejrk0ed3rKXV/J78i+xjIYsyiMY9HGi/h7YQEq36UH74RypfaSpml+o6YgN7a
	 iSoSnVOaVdNgVdRAnUSJPDTp2ToxLkB8PsKgpsjvvsoS/E4SJyZS6fL3sf6ovaW0hw
	 HxFSPKu8XEmxFJSMos8u3flro7yPW1GjZq7C5Oak=
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
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 335/481] mm/kfence: disable KFENCE upon KASAN HW tags enablement
Date: Mon, 23 Mar 2026 14:45:17 +0100
Message-ID: <20260323134533.260402015@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Potapenko <glider@google.com>

[ Upstream commit 09833d99db36d74456a4d13eb29c32d56ff8f2b6 ]

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
[ Context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
@@ -844,6 +845,20 @@ void __init kfence_alloc_pool(void)
 	if (!kfence_sample_interval)
 		return;
 
+	/*
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
 	/* if the pool has already been initialized by arch, skip the below. */
 	if (__kfence_pool)
 		return;


