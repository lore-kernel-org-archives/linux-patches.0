Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E612D35A281;
	Tue, 26 Aug 2025 14:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218323; cv=none; b=VD27vwGFr8k2alBWELsvGf3dej1AhGZmuCNbBhmbt7NW8/CCVA/+Sl1kcypS8+qsMvZbindET6ah1tREgeB+qOcXpHBnJt7BCLapl3adms5oFCoCfTmd1XAUKDiZMx9H5cigXFuIlgfDlod3I2q7+xevuMhNKrUIK4q8cbo0IhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218323; c=relaxed/simple;
	bh=TQbOCuB4338I/a72sbfPNWAxUtH3PhfaOnN36mUfCds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGqI0kTsFW6w7rX9AJqDYewv6UX/B0Vxbf1MXQ0+3tdN6eGv2IWTlrGyvs4Mtuc3QcnXnvphdz51/qIcDmJ0cxkrhSAQ9qBnVtEeSWIijypmZ/ETggRJL193z5ce0cVVSbGfCrt74Q/7KWBx/g2MlbGVlyuFQHPILgbiQcoQmaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WitZCS6f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WitZCS6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7908BC113D0;
	Tue, 26 Aug 2025 14:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218322;
	bh=TQbOCuB4338I/a72sbfPNWAxUtH3PhfaOnN36mUfCds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WitZCS6fOaqhjCZGu69QLnzirG34nDXqRhOmDDe9V9lwktnoifGWED45PlMiDGXbB
	 we/BPA7MbHOuw4WAUr7Y+Kz1oz8AZaXwv5n/D0tvP7P3YUxtL9XcqNifBtoukD+nCp
	 bZO8p9fuIy7CuE9Ya2/tDjq1hMJO2VD+eIrrnuh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Elver <elver@google.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 479/523] locking/barriers, kcsan: Support generic instrumentation
Date: Tue, 26 Aug 2025 13:11:29 +0200
Message-ID: <20250826110936.260418982@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Elver <elver@google.com>

[ Upstream commit 2505a51ac6f249956735e0a369e2404f96eebef0 ]

Thus far only smp_*() barriers had been defined by asm-generic/barrier.h
based on __smp_*() barriers, because the !SMP case is usually generic.

With the introduction of instrumentation, it also makes sense to have
asm-generic/barrier.h assist in the definition of instrumented versions
of mb(), rmb(), wmb(), dma_rmb(), and dma_wmb().

Because there is no requirement to distinguish the !SMP case, the
definition can be simpler: we can avoid also providing fallbacks for the
__ prefixed cases, and only check if `defined(__<barrier>)`, to finally
define the KCSAN-instrumented versions.

This also allows for the compiler to complain if an architecture
accidentally defines both the normal and __ prefixed variant.

Signed-off-by: Marco Elver <elver@google.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Stable-dep-of: aa6956150f82 ("wifi: ath11k: fix dest ring-buffer corruption when ring is full")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/asm-generic/barrier.h |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/include/asm-generic/barrier.h
+++ b/include/asm-generic/barrier.h
@@ -21,6 +21,31 @@
 #endif
 
 /*
+ * Architectures that want generic instrumentation can define __ prefixed
+ * variants of all barriers.
+ */
+
+#ifdef __mb
+#define mb()	do { kcsan_mb(); __mb(); } while (0)
+#endif
+
+#ifdef __rmb
+#define rmb()	do { kcsan_rmb(); __rmb(); } while (0)
+#endif
+
+#ifdef __wmb
+#define wmb()	do { kcsan_wmb(); __wmb(); } while (0)
+#endif
+
+#ifdef __dma_rmb
+#define dma_rmb()	do { kcsan_rmb(); __dma_rmb(); } while (0)
+#endif
+
+#ifdef __dma_wmb
+#define dma_wmb()	do { kcsan_wmb(); __dma_wmb(); } while (0)
+#endif
+
+/*
  * Force strict CPU ordering. And yes, this is required on UP too when we're
  * talking to devices.
  *


