Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4533A5E77;
	Sat, 17 Oct 2026 16:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255157; cv=none; b=susvN1h649pRpX0JLbwP2dIVc0CHVNO5e/mChEBU443BpdZBsPXQUI/pya/FDpFmjyq2IbrDKwCzuia8mJf1LBTbQIy7diEmQC9bC4PPi4lvx64zEfGPwtfgWao3SrjohgUnXnpdWxkH9AY5lE+Ht/eyIAqnemTTWwWH9AnGVUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255157; c=relaxed/simple;
	bh=61yURVACdUl2xsxyeG66gAyzW6IpfBhDPFO48bso9JY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jMIQU5kNoWDj+vLAdecrU/7sZnAEj4Tafj13QUvCYGaFn3oOep5w7sdqZduVTW5NrrV1EYfKgSxecw8ggtFpop6XuWArAwhL6zEii2GIgYbzHHp7me2ltQxkF+enTxM/RsoHU/XDaA/WPRcyMRpgW9p0msn0GRKYl5gU7BROs2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0AlPmSSg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0AlPmSSg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C21F1F000C6;
	Sat, 17 Oct 2026 16:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255155;
	bh=AyyO7MYVDu65o8H0EHADW4KIsNtcyIbSMFeRI+trwdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0AlPmSSgCl7K2YCvfAYSwOUwBOlXiHcNCo5Fs12FzfC88JtPmCewmWr9E5wy3A3xX
	 fuatLE+sXPHcX2DnGH0nrSv86yJwOrpohvlYZkSZm1tUBmiq1WGp17Vg/UHNEZEw7a
	 PKDfnRxH+3fK7/34lBfTtMh3fsAb0+IDMrFQIu1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 682/869] overflow: add range_overflows() and range_end_overflows()
Date: Sat, 17 Oct 2026 17:58:43 +0200
Message-ID: <20261017160054.462859969@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit 5f3cec21f6d57336a2cbfa9ee428ac66c77a7211 ]

Move the range_overflows() and range_end_overflows() along with the _t
variants over from drm/i915 and drm/buddy to overflow.h.

Cc: Kees Cook <kees@kernel.org>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-hardening@vger.kernel.org
Reviewed-by: Kees Cook <kees@kernel.org>
Reviewed-by: Jouni Högander <jouni.hogander@intel.com>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://lore.kernel.org/r/20250829174601.2163064-3-jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Stable-dep-of: 985f5e12f3cd ("drm/panthor: Add vm_bind region with kbo range overlap check")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/i915_utils.h | 70 -------------------------------
 include/linux/gpu_buddy.h         |  9 ----
 include/linux/overflow.h          | 70 +++++++++++++++++++++++++++++++
 3 files changed, 70 insertions(+), 79 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_utils.h b/drivers/gpu/drm/i915/i915_utils.h
index a53d8a59ce19a..e9b8ec51f6ab4 100644
--- a/drivers/gpu/drm/i915/i915_utils.h
+++ b/drivers/gpu/drm/i915/i915_utils.h
@@ -69,76 +69,6 @@ bool i915_error_injected(void);
 		drm_err(&(i915)->drm, fmt, ##__VA_ARGS__); \
 })
 
-/**
- * range_overflows() - Check if a range is out of bounds
- * @start: Start of the range.
- * @size:  Size of the range.
- * @max:   Exclusive upper boundary.
- *
- * A strict check to determine if the range [@start, @start + @size) is
- * invalid with respect to the allowable range [0, @max). Any range
- * starting at or beyond @max is considered an overflow, even if @size is 0.
- *
- * Returns: true if the range is out of bounds.
- */
-#define range_overflows(start, size, max) ({ \
-	typeof(start) start__ = (start); \
-	typeof(size) size__ = (size); \
-	typeof(max) max__ = (max); \
-	(void)(&start__ == &size__); \
-	(void)(&start__ == &max__); \
-	start__ >= max__ || size__ > max__ - start__; \
-})
-
-/**
- * range_overflows_t() - Check if a range is out of bounds
- * @type:  Data type to use.
- * @start: Start of the range.
- * @size:  Size of the range.
- * @max:   Exclusive upper boundary.
- *
- * Same as range_overflows() but forcing the parameters to @type.
- *
- * Returns: true if the range is out of bounds.
- */
-#define range_overflows_t(type, start, size, max) \
-	range_overflows((type)(start), (type)(size), (type)(max))
-
-/**
- * range_end_overflows() - Check if a range's endpoint is out of bounds
- * @start: Start of the range.
- * @size:  Size of the range.
- * @max:   Exclusive upper boundary.
- *
- * Checks only if the endpoint of a range (@start + @size) exceeds @max.
- * Unlike range_overflows(), a zero-sized range at the boundary (@start == @max)
- * is not considered an overflow. Useful for iterator-style checks.
- *
- * Returns: true if the endpoint exceeds the boundary.
- */
-#define range_end_overflows(start, size, max) ({ \
-	typeof(start) start__ = (start); \
-	typeof(size) size__ = (size); \
-	typeof(max) max__ = (max); \
-	(void)(&start__ == &size__); \
-	(void)(&start__ == &max__); \
-	start__ > max__ || size__ > max__ - start__; \
-})
-
-/**
- * range_end_overflows_t() - Check if a range's endpoint is out of bounds
- * @type:  Data type to use.
- * @start: Start of the range.
- * @size:  Size of the range.
- * @max:   Exclusive upper boundary.
- *
- * Same as range_end_overflows() but forcing the parameters to @type.
- *
- * Returns: true if the endpoint exceeds the boundary.
- */
-#define range_end_overflows_t(type, start, size, max) \
-	range_end_overflows((type)(start), (type)(size), (type)(max))
-
 #define ptr_mask_bits(ptr, n) ({					\
 	unsigned long __v = (unsigned long)(ptr);			\
 	(typeof(ptr))(__v & -BIT(n));					\
diff --git a/include/linux/gpu_buddy.h b/include/linux/gpu_buddy.h
index 2d45ce054f263..db0a23405ec9d 100644
--- a/include/linux/gpu_buddy.h
+++ b/include/linux/gpu_buddy.h
@@ -14,15 +14,6 @@
 
 #include <drm/drm_print.h>
 
-#define range_overflows(start, size, max) ({ \
-	typeof(start) start__ = (start); \
-	typeof(size) size__ = (size); \
-	typeof(max) max__ = (max); \
-	(void)(&start__ == &size__); \
-	(void)(&start__ == &max__); \
-	start__ >= max__ || size__ > max__ - start__; \
-})
-
 #define GPU_BUDDY_RANGE_ALLOCATION		BIT(0)
 #define GPU_BUDDY_TOPDOWN_ALLOCATION		BIT(1)
 #define GPU_BUDDY_CONTIGUOUS_ALLOCATION		BIT(2)
diff --git a/include/linux/overflow.h b/include/linux/overflow.h
index 89e9d60498835..456b3b09e3e9c 100644
--- a/include/linux/overflow.h
+++ b/include/linux/overflow.h
@@ -238,6 +238,76 @@ static inline bool __must_check __must_check_overflow(bool overflow)
 			      __overflows_type_constexpr(n, T),	\
 			      __overflows_type(n, T))
 
+/**
+ * range_overflows() - Check if a range is out of bounds
+ * @start: Start of the range.
+ * @size:  Size of the range.
+ * @max:   Exclusive upper boundary.
+ *
+ * A strict check to determine if the range [@start, @start + @size) is
+ * invalid with respect to the allowable range [0, @max). Any range
+ * starting at or beyond @max is considered an overflow, even if @size is 0.
+ *
+ * Returns: true if the range is out of bounds.
+ */
+#define range_overflows(start, size, max) ({ \
+	typeof(start) start__ = (start); \
+	typeof(size) size__ = (size); \
+	typeof(max) max__ = (max); \
+	(void)(&start__ == &size__); \
+	(void)(&start__ == &max__); \
+	start__ >= max__ || size__ > max__ - start__; \
+})
+
+/**
+ * range_overflows_t() - Check if a range is out of bounds
+ * @type:  Data type to use.
+ * @start: Start of the range.
+ * @size:  Size of the range.
+ * @max:   Exclusive upper boundary.
+ *
+ * Same as range_overflows() but forcing the parameters to @type.
+ *
+ * Returns: true if the range is out of bounds.
+ */
+#define range_overflows_t(type, start, size, max) \
+	range_overflows((type)(start), (type)(size), (type)(max))
+
+/**
+ * range_end_overflows() - Check if a range's endpoint is out of bounds
+ * @start: Start of the range.
+ * @size:  Size of the range.
+ * @max:   Exclusive upper boundary.
+ *
+ * Checks only if the endpoint of a range (@start + @size) exceeds @max.
+ * Unlike range_overflows(), a zero-sized range at the boundary (@start == @max)
+ * is not considered an overflow. Useful for iterator-style checks.
+ *
+ * Returns: true if the endpoint exceeds the boundary.
+ */
+#define range_end_overflows(start, size, max) ({ \
+	typeof(start) start__ = (start); \
+	typeof(size) size__ = (size); \
+	typeof(max) max__ = (max); \
+	(void)(&start__ == &size__); \
+	(void)(&start__ == &max__); \
+	start__ > max__ || size__ > max__ - start__; \
+})
+
+/**
+ * range_end_overflows_t() - Check if a range's endpoint is out of bounds
+ * @type:  Data type to use.
+ * @start: Start of the range.
+ * @size:  Size of the range.
+ * @max:   Exclusive upper boundary.
+ *
+ * Same as range_end_overflows() but forcing the parameters to @type.
+ *
+ * Returns: true if the endpoint exceeds the boundary.
+ */
+#define range_end_overflows_t(type, start, size, max) \
+	range_end_overflows((type)(start), (type)(size), (type)(max))
+
 /**
  * castable_to_type - like __same_type(), but also allows for casted literals
  *
-- 
2.53.0



