Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7DA3431FE;
	Tue, 26 Aug 2025 14:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216948; cv=none; b=pe1v3ARNVq7V/3t8xmobXGEkUdMhOTptRpC+L+VgJcWhZRwXBiaC/mnK20kUdvZl/JcPgSKR54qah6BTs+kgPWE5J/QEmAunP5Ezlr/2vL11eC/E4LqnzPVtgbMTFkGAiAzloeaZrOkIYtxmTfVD7spPnr1srJdYtovDhiCK6Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216948; c=relaxed/simple;
	bh=RZLz2mrP3p86QbVfhizRfC1J4VAUAPXeslmz6Ajkv20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7PMmwI53yCJoq6Q81DvqE7GSCNR6b8uJV6WFAqCFJIdYFPYUqkQoQCmG4t9zQibxm0bsjjLAP+g+qhPWi0eq85PRhnXjaJApNIa//jzBZl9EOp2I9rIZfQLJDeGP9i/WtlwxMMVzaxjFu6gss1JYvxETt9mtuKbfYQq8TZqhhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QjtKxsyO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QjtKxsyO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BD2C4CEF1;
	Tue, 26 Aug 2025 14:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216948;
	bh=RZLz2mrP3p86QbVfhizRfC1J4VAUAPXeslmz6Ajkv20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QjtKxsyOpgWLJ1f+b/QAFmlfu396u+TexKPqwfjtMqvHYSRnrZ7D58ioJtJjOR8ZX
	 E/791WGq+hD156dMtX4gTcD7MvFOj4sPrBPBc26dc+zHRvVu9yNnmC26V6R6r1WWJr
	 yTGD5kMRNZFqLjPzy9lRbRxfb2XhNJHR9XardGXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Elver <elver@google.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 600/644] locking/barriers, kcsan: Support generic instrumentation
Date: Tue, 26 Aug 2025 13:11:31 +0200
Message-ID: <20250826111001.414779644@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


