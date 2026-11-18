Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054214;
	b=QfigtOCrkLSaa/FUJbzAgVg1nHOhrnb6OiJMFQxtQfuF8alcd5mu3kdMrPJV4LkUPtEy
	 EuItdcSNfivcfAWHc/nYq2Ey6BFCvj+9jfa5Ytzhf6v1pd/pwDvdOQAcUyv5N/EVOuMFp
	 KQ/oaokS0lbkmjIV3g66ytwS5H1b0PmhHn41NHi42B4tNE0n6jnZFtQ6kGgQ4/fiOl1/f
	 tRiNerRmkQ3LvCfHemH5DGxfuvOdrHfcFG8CdLlgZpHYm/xYG8seCVXXL0AyN/GThsteY
	 sQ5BhMlvQT6puPLK3bctjbEAKB9uCFx+QREOq6WjSfAhNhc5EjNucpGYlK6e3f4RiWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054214;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XlL/0j6CZ4RdzTW2lCowh4jbsOEIQXIxu9sK2cKen58=;
	b=YYIm4jxTLy+IbeoOnNkVt1S2lATYLn1+Z4cKALeJXSnwLMpMFxusrb3nDWBWDH0lTYfy
	 GJSL0J8Z7U5m1UdttTBAhItNkeMHlQ5P0YX00Y9PstNUHxd/MR1D2uVs7NnfSeg6vMsTo
	 TcYH6hIFX/lfjIzGP/OdDPa2AS5gWePebqEkCDyUnHsiy7eA/vsQpyY2+9XdwRfv4jFFq
	 WgQA6MjifS5Z0WNljWV2ysLf9fBqGGNe3xL5zpYDt52sgx3HRS/TtmAk3jqSnfEUsrovM
	 4I4hS2qKmJ7PLHtcMRCVCLFcQ8a/UR0W9Mz5FoTri8hcKL3nwYsyg9KHZc8LMxdLhLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0aXS3enw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10DB4606A331;
	Thu, 19 Nov 2026 02:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0aXS3enw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624A41F000C8;
	Thu, 19 Nov 2026 02:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054213;
	bh=XlL/0j6CZ4RdzTW2lCowh4jbsOEIQXIxu9sK2cKen58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0aXS3enw/D+ZfpHJLHhQCEnkTmcEOJeVyJ3zC2VpG/Es9YEk+s6Ms/v8ThCL35cx7
	 kcziUplOowXGF1T/tyA+AgtSGg51Nmokq1EMiZ9u50HRA0cDuMtjmTGa5isx8UCeUa
	 ojqrgW3r/WKDcNZ9msgdYxdrRYAjXvbV/Fz73XPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armaan Sandhu <armaan.sandhu0504@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Leizhen Zhang <lzsx618@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1194/2214] lib/cmdline: fix get_options() count and overflow with large ranges
Date: Wed, 18 Nov 2026 15:47:50 +0100
Message-ID: <20261118150059.657724343@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted KUnit test placement to the existing layout lacking next_arg() and memparse() tests ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/cmdline.c       | 13 ++++++++++++-
 lib/cmdline_kunit.c | 39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/lib/cmdline.c b/lib/cmdline.c
index 5546bf5887806..04661bd4f40d7 100644
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
diff --git a/lib/cmdline_kunit.c b/lib/cmdline_kunit.c
index de7fb7476cb9a..205a2cb542436 100644
--- a/lib/cmdline_kunit.c
+++ b/lib/cmdline_kunit.c
@@ -139,11 +139,50 @@ static void cmdline_test_range(struct kunit *test)
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
 static struct kunit_case cmdline_test_cases[] = {
 	KUNIT_CASE(cmdline_test_noint),
 	KUNIT_CASE(cmdline_test_lead_int),
 	KUNIT_CASE(cmdline_test_tail_int),
 	KUNIT_CASE(cmdline_test_range),
+	KUNIT_CASE(cmdline_test_range_overflow),
 	{}
 };
 
-- 
2.53.0



