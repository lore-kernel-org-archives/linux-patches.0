Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296C6269AE4;
	Tue,  8 Apr 2025 12:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114211; cv=none; b=UnexpC+eRMscbUJkiwr3WPp2AtxNAfwyfE6PQTC0K20XfyWW/eMEoE6n5WR3cG+wVbWo00se7sBK12AkDXn/k6Xy/7SR56GDJWLnX2lbwvZj++KcV/1/bjxIUmWGfmVza+Z/KxCzRMc4P/5ysWTlIubkaraXQBstNYbo6SpcyGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114211; c=relaxed/simple;
	bh=b9QE5VfHMF7taXXffimyhPOcu8j27Mmo+JQFXyEdpTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l9LGPf2UUg/jadv5eIesDGFfZiWeG1tZXHXg3T9gjHgbaHrK7GXOMb29bU+L1HEv8FsMoxDSXo5nIJWk0w7s0LNqXVTItRzbzZvoVH64zce+Rllm+kQyjqy9tPQhTRSDWcqQRUg1MXDGHTS1eCideMzk8Qv1stqN8T6FUDM2CPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NUO/hwlj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NUO/hwlj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539C2C4CEE5;
	Tue,  8 Apr 2025 12:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114210;
	bh=b9QE5VfHMF7taXXffimyhPOcu8j27Mmo+JQFXyEdpTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NUO/hwljGrgD57gDWTsiJNkK125dYEJZxaNMYr7WIyeNKEbiihc2/89VShRCI9nWC
	 W74E+Z02slhD81+QZr83wsc9MPIE2yXSfFC3TWSSnM5TkToH72c8A6/3NVwfJtdfha
	 Y7G43FAVcRa4T28yoIgq7hYwtaau82ddtjqNnnmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 022/499] kunit/stackinit: Use fill byte different from Clang i386 pattern
Date: Tue,  8 Apr 2025 12:43:54 +0200
Message-ID: <20250408104851.802544800@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index c40818ec9c180..49d32e43d06ef 100644
--- a/lib/stackinit_kunit.c
+++ b/lib/stackinit_kunit.c
@@ -146,6 +146,15 @@ static bool stackinit_range_contains(char *haystack_start, size_t haystack_size,
 #define INIT_STRUCT_assigned_copy(var_type)				\
 					; var = *(arg)
 
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
@@ -168,12 +177,12 @@ static noinline void test_ ## name (struct kunit *test)		\
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
@@ -184,7 +193,8 @@ static noinline void test_ ## name (struct kunit *test)		\
 	 * possible between the two leaf function calls.	\
 	 */							\
 	KUNIT_ASSERT_EQ_MSG(test, sum, 0,			\
-			    "leaf fill was not 0xFF!?\n");	\
+			    "leaf fill was not 0x%02X!?\n",	\
+			    FILL_BYTE);				\
 								\
 	/* Validate that compiler lined up fill and target. */	\
 	KUNIT_ASSERT_TRUE_MSG(test,				\
@@ -196,9 +206,9 @@ static noinline void test_ ## name (struct kunit *test)		\
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
@@ -233,12 +243,12 @@ static noinline int leaf_ ## name(unsigned long sp, bool fill,	\
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
@@ -380,7 +390,7 @@ static int noinline __leaf_switch_none(int path, bool fill)
 			fill_start = &var;
 			fill_size = sizeof(var);
 
-			memset(fill_start, forced_mask | 0x55, fill_size);
+			memset(fill_start, (forced_mask | 0x55) & FILL_BYTE, fill_size);
 		}
 		memcpy(check_buf, target_start, target_size);
 		break;
@@ -391,7 +401,7 @@ static int noinline __leaf_switch_none(int path, bool fill)
 			fill_start = &var;
 			fill_size = sizeof(var);
 
-			memset(fill_start, forced_mask | 0xaa, fill_size);
+			memset(fill_start, (forced_mask | 0xaa) & FILL_BYTE, fill_size);
 		}
 		memcpy(check_buf, target_start, target_size);
 		break;
-- 
2.39.5



