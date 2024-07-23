Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2928113D521;
	Tue, 23 Jul 2024 18:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759119; cv=none; b=LQTH/7aacsLDjDYt7eMXcdbu7d786ItE2Bs3ImBKGZRMIW8NN2C9GDtEDFRgQkEWroDacMawm8G1+OVFdkMym03a1T7FguwbIbDrwjcyVVdCmSC7sg69KbiLom4yRM078bft+vqSJY5ejLClYbIBAi/wJ650xBWbVAfyQId7pzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759119; c=relaxed/simple;
	bh=QMgz94ViZzpbmAiqSp/nkeL+MJs8yKJZ5mwSYC4jZF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xc2TGGe0yOClDA8PG0PViSgidEHs9DzNRS+6k1+GvI29WrB++9tyXBX9I+cExE9M2Jkjbb5iXkbq63eGnWvswrr2cmz2k5fQUB9WmiChxvED77upEfVKSXMz0IpqXaq0fW71I1cK7/6Zk6b5yTTAvo/aNDc6yVMzFoR8z920ZSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rc6IeMSe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rc6IeMSe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F69DC4AF0B;
	Tue, 23 Jul 2024 18:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759118;
	bh=QMgz94ViZzpbmAiqSp/nkeL+MJs8yKJZ5mwSYC4jZF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rc6IeMSe+1IeCOcMchF0pQ+U3oLLP8S8de4HnCGcOu57BdPSPMCit4+2djx1rsOVw
	 zrluLmVsXmFm3VoDffZ9/4AYHzWBb1LBSwIQMtjn0fikucB9r6fXVW/poiGIdwnjwd
	 fMlUb/seYOVZEZsQ6gsEdM7RNsA/m/cHq4igpq7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Kees Cook <keescook@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	SeongJae Park <sj@kernel.org>
Subject: [PATCH 6.1 001/105] minmax: sanity check constant bounds when clamping
Date: Tue, 23 Jul 2024 20:22:38 +0200
Message-ID: <20240723180402.575573856@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


