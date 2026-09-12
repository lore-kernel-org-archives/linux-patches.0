Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E33E4921BC;
	Sat, 12 Sep 2026 19:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239672; cv=none; b=u6IK5BWnCfBE0PuW4VlTbQU+xPnTor90fZHTJLlWjd1hsyNonUkDOpezTBENM4YfG5VnGXgJ3WWVnPHGrI6nmFpCzY8/ZsqGZiq9uqn5+Kcgzp7qK00pWec/9MzMCK7KsIB1juZDZZI14Oo3+9gH1Ib77dkQ1RK0BARIoC1Scno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239672; c=relaxed/simple;
	bh=3a4ilUGN5IDxOIIOP/Z02Gjvt8jcyqbHqXAWHeQ3a9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P0CBPwyq4UVNtVs9f/lEHUft1hSLa/J1uMtkbDIvIasHe8Z/JvpF15r6FPNZVHu0ejaXKGCz2rcxBFHeKBTdu0x0lhdeeg6DYlgzIAEnN30DQGoYS94QhNgRKTEdTYGE5pbUhc3sbgIG0SzHG/5wuMyvj2tT/KIwqoT8zy2KJjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JRRjIVW7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JRRjIVW7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3AE21F00898;
	Sat, 12 Sep 2026 19:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239668;
	bh=glICxlEhjm8ZBYOySntgT+pzSMHqYWH9i6VDAGZv4lI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JRRjIVW7r3ce7AF2D6F51NXZFivENl+bEhuMYaEwbeDfqULK4/MbRW5gECWjeoKx7
	 ZdBDH0kfShx4snsDkVDzBCFdMXWugHThtPgXte2JoEuqXm3OhLf885k6j0V9tB85RS
	 agd/poXPxuxBdQrbsT4eChvlaVzlBX0eOdmNj6iA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	"Yury Norov (NVIDIA)" <yury.norov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 710/935] bitfield: Add less-checking __FIELD_{GET,PREP}()
Date: Sat, 12 Sep 2026 09:02:20 +0200
Message-ID: <20260912065543.120216453@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 2a6c045640c38a407a39cd40c3c4d8dd2fd89aa8 ]

The BUILD_BUG_ON_MSG() check against "~0ull" works only with "unsigned
(long) long" _mask types.  For constant masks, that condition is usually
met, as GENMASK() yields an UL value.  The few places where the
constant mask is stored in an intermediate variable were fixed by
changing the variable type to u64 (see e.g. [1] and [2]).

However, for non-constant masks, smaller unsigned types should be valid,
too, but currently lead to "result of comparison of constant
18446744073709551615 with expression of type ... is always
false"-warnings with clang and W=1.

Hence refactor the __BF_FIELD_CHECK() helper, and factor out
__FIELD_{GET,PREP}().  The later lack the single problematic check, but
are otherwise identical to FIELD_{GET,PREP}(), and are intended to be
used in the fully non-const variants later.

[1] commit 5c667d5a5a3ec166 ("clk: sp7021: Adjust width of _m in
    HWM_FIELD_PREP()")
[2] commit cfd6fb45cfaf46fa ("crypto: ccree - avoid out-of-range
    warnings from clang")

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://git.kernel.org/torvalds/c/5c667d5a5a3ec166 [1]
Signed-off-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Stable-dep-of: 62bac3202042 ("drm/sun4i: tcon-top: Keep mixer routes distinct")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bitfield.h | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/include/linux/bitfield.h b/include/linux/bitfield.h
index 6093fa6db2600..359916a958f35 100644
--- a/include/linux/bitfield.h
+++ b/include/linux/bitfield.h
@@ -57,7 +57,7 @@
 
 #define __bf_cast_unsigned(type, x)	((__unsigned_scalar_typeof(type))(x))
 
-#define __BF_FIELD_CHECK(_mask, _reg, _val, _pfx)			\
+#define __BF_FIELD_CHECK_MASK(_mask, _val, _pfx)			\
 	({								\
 		BUILD_BUG_ON_MSG(!__builtin_constant_p(_mask),		\
 				 _pfx "mask is not constant");		\
@@ -65,13 +65,33 @@
 		BUILD_BUG_ON_MSG(__builtin_constant_p(_val) ?		\
 				 ~((_mask) >> __bf_shf(_mask)) & (_val) : 0, \
 				 _pfx "value too large for the field"); \
-		BUILD_BUG_ON_MSG(__bf_cast_unsigned(_mask, _mask) >	\
-				 __bf_cast_unsigned(_reg, ~0ull),	\
-				 _pfx "type of reg too small for mask"); \
 		__BUILD_BUG_ON_NOT_POWER_OF_2((_mask) +			\
 					      (1ULL << __bf_shf(_mask))); \
 	})
 
+#define __BF_FIELD_CHECK_REG(mask, reg, pfx)				\
+	BUILD_BUG_ON_MSG(__bf_cast_unsigned(mask, mask) >		\
+			 __bf_cast_unsigned(reg, ~0ull),		\
+			 pfx "type of reg too small for mask")
+
+#define __BF_FIELD_CHECK(mask, reg, val, pfx)				\
+	({								\
+		__BF_FIELD_CHECK_MASK(mask, val, pfx);			\
+		__BF_FIELD_CHECK_REG(mask, reg, pfx);			\
+	})
+
+#define __FIELD_PREP(mask, val, pfx)					\
+	({								\
+		__BF_FIELD_CHECK_MASK(mask, val, pfx);			\
+		((typeof(mask))(val) << __bf_shf(mask)) & (mask);	\
+	})
+
+#define __FIELD_GET(mask, reg, pfx)					\
+	({								\
+		__BF_FIELD_CHECK_MASK(mask, 0U, pfx);			\
+		(typeof(mask))(((reg) & (mask)) >> __bf_shf(mask));	\
+	})
+
 /**
  * FIELD_MAX() - produce the maximum value representable by a field
  * @_mask: shifted mask defining the field's length and position
@@ -108,8 +128,8 @@
  */
 #define FIELD_PREP(_mask, _val)						\
 	({								\
-		__BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_PREP: ");	\
-		((typeof(_mask))(_val) << __bf_shf(_mask)) & (_mask);	\
+		__BF_FIELD_CHECK_REG(_mask, 0ULL, "FIELD_PREP: ");	\
+		__FIELD_PREP(_mask, _val, "FIELD_PREP: ");		\
 	})
 
 /**
@@ -122,8 +142,8 @@
  */
 #define FIELD_GET(_mask, _reg)						\
 	({								\
-		__BF_FIELD_CHECK(_mask, _reg, 0U, "FIELD_GET: ");	\
-		(typeof(_mask))(((_reg) & (_mask)) >> __bf_shf(_mask));	\
+		__BF_FIELD_CHECK_REG(_mask, _reg, "FIELD_GET: ");	\
+		__FIELD_GET(_mask, _reg, "FIELD_GET: ");		\
 	})
 
 extern void __compiletime_error("value doesn't fit into mask")
-- 
2.53.0



