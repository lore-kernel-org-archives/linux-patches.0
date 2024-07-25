Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E92219D087;
	Thu, 25 Jul 2024 14:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919293; cv=none; b=RpYjQ9YRAkSvlwI+O1gdh8yuY+P9XTzvltdOFwc7fu0fA2sSj0q/Buz55KLp2hX8J/rvHFgGC9b/ameQ5wZU7/gEl/TxBaxcqB6N0C3yXx6pI3gMc1TtFs7Ql1BSLQpGnkuUOqggfL8GqKgYeHGk0YVaqJcTi9kqdGsxc6Z/ZR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919293; c=relaxed/simple;
	bh=D3CXDTRBkATPesCa7miPke8psUuqE3eW6Fj3kmUs9/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lC+H3UIPVk83OdzFgHt/KFtp5LoU3oRvFLtgaCoPmi3gJbpD4VRbRjiJUAw/TpMSumbypMactU7kymdnfcDmZu/3CUqTRD8+bMAQaN4N5LIP0nxsSgSRr4Kb1lpsNwRglAEKFhXNIxnW/M4AADkW3OwkeU6k2/k5F02cuUmFe2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vzvbd+zF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vzvbd+zF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4833EC116B1;
	Thu, 25 Jul 2024 14:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919292;
	bh=D3CXDTRBkATPesCa7miPke8psUuqE3eW6Fj3kmUs9/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vzvbd+zFgkbERXg3Mica+crHioOL/bLHHVcplxcmQESMn4MSRngPA4lXU4r+TJe3d
	 22xQ//4A+YgNdWkJJbTKUy3/zR+Cql3eO6w1qfl0AQS5lAM1iMYgPngZhd35JC/9tv
	 a8eiVHV/fo8dy5uI/wCWOWDt7ZIW0WZAhihG7R10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Kees Cook <keescook@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	SeongJae Park <sj@kernel.org>
Subject: [PATCH 5.15 65/87] minmax: sanity check constant bounds when clamping
Date: Thu, 25 Jul 2024 16:37:38 +0200
Message-ID: <20240725142740.885143328@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
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

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 5efcecd9a3b18078d3398b359a84c83f549e22cf upstream.

The clamp family of functions only makes sense if hi>=lo.  If hi and lo
are compile-time constants, then raise a build error.  Doing so has
already caught buggy code.  This also introduces the infrastructure to
improve the clamping function in subsequent commits.

[akpm@linux-foundation.org: coding-style cleanups]
[akpm@linux-foundation.org: s@&&\@&& \@]
Link: https://lkml.kernel.org/r/20220926133435.1333846-1-Jason@zx2c4.com
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit 5efcecd9a3b18078d3398b359a84c83f549e22cf)
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |   26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -37,6 +37,28 @@
 		__cmp(x, y, op), \
 		__cmp_once(x, y, __UNIQUE_ID(__x), __UNIQUE_ID(__y), op))
 
+#define __clamp(val, lo, hi)	\
+	__cmp(__cmp(val, lo, >), hi, <)
+
+#define __clamp_once(val, lo, hi, unique_val, unique_lo, unique_hi) ({	\
+		typeof(val) unique_val = (val);				\
+		typeof(lo) unique_lo = (lo);				\
+		typeof(hi) unique_hi = (hi);				\
+		__clamp(unique_val, unique_lo, unique_hi); })
+
+#define __clamp_input_check(lo, hi)					\
+        (BUILD_BUG_ON_ZERO(__builtin_choose_expr(			\
+                __is_constexpr((lo) > (hi)), (lo) > (hi), false)))
+
+#define __careful_clamp(val, lo, hi) ({					\
+	__clamp_input_check(lo, hi) +					\
+	__builtin_choose_expr(__typecheck(val, lo) && __typecheck(val, hi) && \
+			      __typecheck(hi, lo) && __is_constexpr(val) && \
+			      __is_constexpr(lo) && __is_constexpr(hi),	\
+		__clamp(val, lo, hi),					\
+		__clamp_once(val, lo, hi, __UNIQUE_ID(__val),		\
+			     __UNIQUE_ID(__lo), __UNIQUE_ID(__hi))); })
+
 /**
  * min - return minimum of two values of the same or compatible types
  * @x: first value
@@ -103,7 +125,7 @@
  * This macro does strict typechecking of @lo/@hi to make sure they are of the
  * same type as @val.  See the unnecessary pointer comparisons.
  */
-#define clamp(val, lo, hi) min((typeof(val))max(val, lo), hi)
+#define clamp(val, lo, hi) __careful_clamp(val, lo, hi)
 
 /*
  * ..and if you can't take the strict
@@ -138,7 +160,7 @@
  * This macro does no typechecking and uses temporary variables of type
  * @type to make all the comparisons.
  */
-#define clamp_t(type, val, lo, hi) min_t(type, max_t(type, val, lo), hi)
+#define clamp_t(type, val, lo, hi) __careful_clamp((type)(val), (type)(lo), (type)(hi))
 
 /**
  * clamp_val - return a value clamped to a given range using val's type


