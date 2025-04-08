Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E990C268C72;
	Tue,  8 Apr 2025 11:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110345; cv=none; b=fcWtrlXxS6o09U6/vLc68Mu6yO9WJXlNWIvV8jdVSnFKmnaQn4liNSqkUi8WLUoSMq3rUR7mbee1cjrwi1pVLNYH7iSS7nVksDuC0xdWu0Q4dpNw8v3mDqbBHkxlh2/gDy4QJMHZyl3dQeHO/1jxuMoLLRKOOHH8q3UNZH3wIO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110345; c=relaxed/simple;
	bh=ZslecVM0vlZJ3QeSPMtvBe6lKVseM8Fk5lj340q+dRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSRDF2z8IauS90T6sGeq0BNHeTCj3Q1+qpCkbQT5sAMxxX2PTeuF/ZSzOIJk1bIc+6LZtpegYacOiwkcbg/6STCThZ458w/DttyKMK+zhJ1ZH12wAkNCU40QGtlWKfdLgYKZUdFkSNkjeLea7cdjxue8agN7vMKR0vl+V8O5vgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b9nR8ZTP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b9nR8ZTP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75553C4CEE5;
	Tue,  8 Apr 2025 11:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110344;
	bh=ZslecVM0vlZJ3QeSPMtvBe6lKVseM8Fk5lj340q+dRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b9nR8ZTP9nbE2QTycMq33JSZfjyumbywRIpuX+bdkPevzS0W5ZgbNM4S6ak85/7bx
	 dqsLB8S/QeQ3+Tl4qrpC76Me5RI5vJObi2PESC+GDx/Ju6Jb5ThqmU9AOm11lIlRri
	 Wk4UyVJ8dbWicc2GgTettCoyiQyeIawAwoYR67Ak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 029/731] kunit/stackinit: Use fill byte different from Clang i386 pattern
Date: Tue,  8 Apr 2025 12:38:46 +0200
Message-ID: <20250408104914.945636356@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit d985e4399adffb58e10b38dbb5479ef29d53cde6 ]

The byte initialization values used with -ftrivial-auto-var-init=pattern
(CONFIG_INIT_STACK_ALL_PATTERN=y) depends on the compiler, architecture,
and byte position relative to struct member types. On i386 with Clang,
this includes the 0xFF value, which means it looks like nothing changes
between the leaf byte filling pass and the expected "stack wiping"
pass of the stackinit test.

Use the byte fill value of 0x99 instead, fixing the test for i386 Clang
builds.

Reported-by: ernsteiswuerfel
Closes: https://github.com/ClangBuiltLinux/linux/issues/2071
Fixes: 8c30d32b1a32 ("lib/test_stackinit: Handle Clang auto-initialization pattern")
Tested-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20250304225606.work.030-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/stackinit_kunit.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/lib/stackinit_kunit.c b/lib/stackinit_kunit.c
index 135322592faf8..63aa78e6f5c1a 100644
--- a/lib/stackinit_kunit.c
+++ b/lib/stackinit_kunit.c
@@ -184,6 +184,15 @@ static bool stackinit_range_contains(char *haystack_start, size_t haystack_size,
 #define INIT_UNION_assigned_copy(var_type)		\
 	INIT_STRUCT_assigned_copy(var_type)
 
+/*
+ * The "did we actually fill the stack?" check value needs
+ * to be neither 0 nor any of the "pattern" bytes. The
+ * pattern bytes are compiler, architecture, and type based,
+ * so we have to pick a value that never appears for those
+ * combinations. Use 0x99 which is not 0xFF, 0xFE, nor 0xAA.
+ */
+#define FILL_BYTE	0x99
+
 /*
  * @name: unique string name for the test
  * @var_type: type to be tested for zeroing initialization
@@ -206,12 +215,12 @@ static noinline void test_ ## name (struct kunit *test)		\
 	ZERO_CLONE_ ## which(zero);				\
 	/* Clear entire check buffer for 0xFF overlap test. */	\
 	memset(check_buf, 0x00, sizeof(check_buf));		\
-	/* Fill stack with 0xFF. */				\
+	/* Fill stack with FILL_BYTE. */			\
 	ignored = leaf_ ##name((unsigned long)&ignored, 1,	\
 				FETCH_ARG_ ## which(zero));	\
-	/* Verify all bytes overwritten with 0xFF. */		\
+	/* Verify all bytes overwritten with FILL_BYTE. */	\
 	for (sum = 0, i = 0; i < target_size; i++)		\
-		sum += (check_buf[i] != 0xFF);			\
+		sum += (check_buf[i] != FILL_BYTE);		\
 	/* Clear entire check buffer for later bit tests. */	\
 	memset(check_buf, 0x00, sizeof(check_buf));		\
 	/* Extract stack-defined variable contents. */		\
@@ -222,7 +231,8 @@ static noinline void test_ ## name (struct kunit *test)		\
 	 * possible between the two leaf function calls.	\
 	 */							\
 	KUNIT_ASSERT_EQ_MSG(test, sum, 0,			\
-			    "leaf fill was not 0xFF!?\n");	\
+			    "leaf fill was not 0x%02X!?\n",	\
+			    FILL_BYTE);				\
 								\
 	/* Validate that compiler lined up fill and target. */	\
 	KUNIT_ASSERT_TRUE_MSG(test,				\
@@ -234,9 +244,9 @@ static noinline void test_ ## name (struct kunit *test)		\
 		(int)((ssize_t)(uintptr_t)fill_start -		\
 		      (ssize_t)(uintptr_t)target_start));	\
 								\
-	/* Look for any bytes still 0xFF in check region. */	\
+	/* Validate check region has no FILL_BYTE bytes. */	\
 	for (sum = 0, i = 0; i < target_size; i++)		\
-		sum += (check_buf[i] == 0xFF);			\
+		sum += (check_buf[i] == FILL_BYTE);		\
 								\
 	if (sum != 0 && xfail)					\
 		kunit_skip(test,				\
@@ -271,12 +281,12 @@ static noinline int leaf_ ## name(unsigned long sp, bool fill,	\
 	 * stack frame of SOME kind...				\
 	 */							\
 	memset(buf, (char)(sp & 0xff), sizeof(buf));		\
-	/* Fill variable with 0xFF. */				\
+	/* Fill variable with FILL_BYTE. */			\
 	if (fill) {						\
 		fill_start = &var;				\
 		fill_size = sizeof(var);			\
 		memset(fill_start,				\
-		       (char)((sp & 0xff) | forced_mask),	\
+		       FILL_BYTE & forced_mask,			\
 		       fill_size);				\
 	}							\
 								\
@@ -469,7 +479,7 @@ static int noinline __leaf_switch_none(int path, bool fill)
 			fill_start = &var;
 			fill_size = sizeof(var);
 
-			memset(fill_start, forced_mask | 0x55, fill_size);
+			memset(fill_start, (forced_mask | 0x55) & FILL_BYTE, fill_size);
 		}
 		memcpy(check_buf, target_start, target_size);
 		break;
@@ -480,7 +490,7 @@ static int noinline __leaf_switch_none(int path, bool fill)
 			fill_start = &var;
 			fill_size = sizeof(var);
 
-			memset(fill_start, forced_mask | 0xaa, fill_size);
+			memset(fill_start, (forced_mask | 0xaa) & FILL_BYTE, fill_size);
 		}
 		memcpy(check_buf, target_start, target_size);
 		break;
-- 
2.39.5



