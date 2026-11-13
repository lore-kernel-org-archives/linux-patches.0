Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590791;
	b=TtHKVzBZ89gGpJSVim67WqPa2CwdEHEWcT+hS3ys2zRrlTW7axr9ymcDfyNMg/4Qh1hz
	 jsFcbVRlOc2w9Wlx4YRwly0uCsNa3P8lR1fGJaawQsbLNtuW7+ik34ov15A3sqZqh1wFz
	 QdXAUFc9LurKNI5xE8eApf/p4OjXOMVWf8DF+znizndrPIrDMSbl/ghWTzUK24iZh9N7M
	 hnndMQDiRkjhKJCSbP4F62w3oDAKw12oaQn+J6n2LN3N8R94UZO2vwcxaheS1nUiY61zp
	 n5xeHCf+EuYP8+dL3gzuxI1BNzjGsTcLKdlNlF9/mPbWWKhP1AdpBLerP53CmylDeRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590791;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+upQntqMznWHByVq29+LQeHPr48nBur3fjD4zlsdxVc=;
	b=ic4987mDXz9fo9YmZKctGvo7SeZ3TAjDvu6T/XfYe98HNhXBUVQGUzsAbrJ3NApsdo2h
	 d5QHqQgHLe2zR3pxIoDwiseptjlv/msPoW53FwchkaRa4vm8SWtDSe/sOlkxYvmSfIUu5
	 170gqY/F9++xQ7sLMFgxpyUg3FGf5/AOLfvmkvAISj1ql+ZTz25LL9WX+x7XFPXICTTOa
	 +ZN1Gq8Y29NikxJI6fgX0IJbWesZbIj7JgE7gTykJt/7Wazh5ZPdQ3bQ8+SQqJ96raY81
	 NeDbBPZuu2eyYw9jcFGVmE+VqjCCeG+uGibflMhO6A4MNTt7pJIFxZXQtS9gUWndlhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hRW62cF8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E6D607D2CD;
	Fri, 13 Nov 2026 17:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hRW62cF8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0511F1F000C5;
	Fri, 13 Nov 2026 17:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590791;
	bh=+upQntqMznWHByVq29+LQeHPr48nBur3fjD4zlsdxVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hRW62cF8fzAduc/RKcET33w5E3RzsoX8XDaQRz5DAk8XoofmUuHKlDrZeZ3GGA6tK
	 +7omzQRUvD7ob5WajS3orH8OFeq7W7m2b4grKUxlggAYdB0EdgbFMRsw4a6Pn/wWk2
	 nIvnOcdcbky82CaLuJxLTLrQ6YIh4uOm41j/+5nE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armaan Sandhu <armaan.sandhu0504@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Leizhen Zhang <lzsx618@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 683/686] lib/cmdline: fix get_options() count and overflow with large ranges
Date: Fri, 13 Nov 2026 10:53:36 -0500
Message-ID: <20261113153844.775663072@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armaan Sandhu <armaan.sandhu0504@gmail.com>

[ Upstream commit 5d72266218b1c4dd2917f1df2b86f3b0e0a605c9 ]

get_range() stops writing once the array is full, but get_options() still
advances its index by the whole range.  So "1-100" parsed into four ints
reports 99 numbers, and a range like "0-2147483647" wraps the index
negative and writes outside the array.

Stop once a range fills the array, bail out in validation mode before the
count overflows, and saturate the range length in get_range().  Add KUnit
cases; without the fix "0-2147483647" panics the test kernel.

Only root can supply this input, so this is a robustness fix.

[akpm@linux-foundation.org: add additional test case from Leizhen]
Link: https://lore.kernel.org/20261005213945.359905-1-armaan.sandhu0504@gmail.com
Fixes: 22f2e2801799 ("[PATCH] get_options to allow a hypenated range for isolcpus")
Signed-off-by: Armaan Sandhu <armaan.sandhu0504@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Leizhen Zhang <lzsx618@gmail.com>
Reviewed-by: Leizhen Zhang <lzsx618@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/cmdline.c             | 13 ++++++++++++-
 lib/tests/cmdline_kunit.c | 39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/lib/cmdline.c b/lib/cmdline.c
index 90ed997d95701..f5dc59b3548e9 100644
--- a/lib/cmdline.c
+++ b/lib/cmdline.c
@@ -11,6 +11,7 @@
 
 #include <linux/export.h>
 #include <linux/kernel.h>
+#include <linux/overflow.h>
 #include <linux/string.h>
 #include <linux/ctype.h>
 
@@ -26,7 +27,9 @@ static int get_range(char **str, int *pint, int n)
 
 	(*str)++;
 	upper_range = simple_strtol((*str), NULL, 0);
-	inc_counter = upper_range - *pint;
+	/* Keep the sign of the result when the difference doesn't fit */
+	if (check_sub_overflow(upper_range, *pint, &inc_counter))
+		inc_counter = upper_range < *pint ? -1 : INT_MAX;
 	for (x = *pint; n && x < upper_range; x++, n--)
 		*pint++ = x;
 	return inc_counter;
@@ -122,6 +125,14 @@ char *get_options(const char *str, int nints, int *ints)
 			range_nums = get_range((char **)&str, pint, n);
 			if (range_nums < 0)
 				break;
+			/* The range didn't fit, so the array is full */
+			if (!validate && range_nums > n) {
+				i = nints;
+				break;
+			}
+			/* Leave room for the upper number of the range */
+			if (range_nums >= INT_MAX - i)
+				break;
 			/*
 			 * Decrement the result by one to leave out the
 			 * last number in the range.  The next iteration
diff --git a/lib/tests/cmdline_kunit.c b/lib/tests/cmdline_kunit.c
index af44ae9e92c3e..74c4b5ea32250 100644
--- a/lib/tests/cmdline_kunit.c
+++ b/lib/tests/cmdline_kunit.c
@@ -139,6 +139,44 @@ static void cmdline_test_range(struct kunit *test)
 	} while (++i < ARRAY_SIZE(cmdline_test_range_strings));
 }
 
+static const struct {
+	const char *in;
+	int parsed[4];
+	int validated;
+} cmdline_test_range_overflow_cases[] = {
+	{ "1-100",         { 3, 1, 2, 3, },    100,        },
+	{ "1,5-100,7",     { 3, 1, 5, 6, },    98,         },
+	{ "1-2147483646",  { 3, 1, 2, 3, },    2147483646, },
+	{ "0-2147483647",  { 3, 0, 1, 2, },    0,          },
+	{ "-5-2147483647", { 3, -5, -4, -3, }, 0,          },
+	{ "2147483647--5", { 0, 2147483647, }, 0,          },
+	{ "1,0-2147483647", { 3, 1, 0, 1, },   1, },
+};
+
+static void cmdline_test_range_overflow(struct kunit *test)
+{
+	unsigned int i, j;
+
+	for (i = 0; i < ARRAY_SIZE(cmdline_test_range_overflow_cases); i++) {
+		const char *in = cmdline_test_range_overflow_cases[i].in;
+		const int *e = cmdline_test_range_overflow_cases[i].parsed;
+		/* Two guard elements past the array handed to get_options() */
+		int r[ARRAY_SIZE(cmdline_test_range_overflow_cases[0].parsed) + 2];
+		int n;
+
+		memset(r, 0, sizeof(r));
+		get_options(in, ARRAY_SIZE(r) - 2, r);
+		for (j = 0; j < ARRAY_SIZE(r) - 2; j++)
+			KUNIT_EXPECT_EQ_MSG(test, r[j], e[j], "Pattern: %s at %u", in, j);
+		for (; j < ARRAY_SIZE(r); j++)
+			KUNIT_EXPECT_EQ_MSG(test, r[j], 0, "Pattern: %s out of bound at %u", in, j);
+
+		get_options(in, 0, &n);
+		KUNIT_EXPECT_EQ_MSG(test, n, cmdline_test_range_overflow_cases[i].validated,
+				    "Pattern: %s (validated)", in);
+	}
+}
+
 static void cmdline_test_next_arg_quoted_value(struct kunit *test)
 {
 	char in[] = "foo=\"bar baz\" qux=1";
@@ -203,6 +241,7 @@ static struct kunit_case cmdline_test_cases[] = {
 	KUNIT_CASE(cmdline_test_lead_int),
 	KUNIT_CASE(cmdline_test_tail_int),
 	KUNIT_CASE(cmdline_test_range),
+	KUNIT_CASE(cmdline_test_range_overflow),
 	KUNIT_CASE(cmdline_test_next_arg_quoted_value),
 	KUNIT_CASE(cmdline_test_next_arg_bare_quote_regression),
 	KUNIT_CASE(cmdline_test_next_arg_mixed_tokens),
-- 
2.53.0



