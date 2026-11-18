Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059883;
	b=mC5rFnl9zJHSeoG9yI5ydxQopy3qdyVYOUvs1BCJiczsQnvrm/hAwZoxBE/W+RUVfJ1m
	 Fx3KjOIfdDZIC+kPja05NtcV6vEqsQEMXuRlr4iC6Fx5eYKWjJGsOFHxmGqvT6bG07GxE
	 JcpEBMmqLuhh63Qe9bYu8tgKhwoLd8YAX9LTJfjXjVW5LsQ+p/RMuFJ/LQFOfz8Yey+0s
	 RhU7uDfS6Vk2de/TKD0FVyM9m74TPh28ZLWJtfsdak2w04JF4/Xp4HvZtQ345OJFSFthu
	 OIF9s3vwQCnNq5SeO59DD3BWvjt6YjN+Y3IqOpK2Vpu7DqvmKrcV0wITUKI/1WYpuBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059883;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bIQOI9hS7T+z37FH+7bRDhR2YpkRd6jbFJeAaIJxBmk=;
	b=oH4zjKcpH26IE+HmCeUj7CCMRnDrT0NUNf+KhqyboJx2nKZJXfBuIIaSHCEmJjwSml5y
	 VNtKNVvnLEGGgL5givpKrmk9KiTOIrhf/SxLKGolKMmf3jfEBJEN9Q1/J/UNf23EDBChl
	 YP7S3JIBxEeziQazKacRo2MuvEqN12BJOXUvb5rPL2LyTKDM5iMGYYtufh7ARun0HMY3s
	 Xgzc8/mcvyTe5xSUAsUQFJ5XeL8h13rZOTZjs6duy+Pb7uOOOLKTvq7T+/uu0qZlRlB71
	 eevIAlUk8dwFp4do1sqcFdjo3IxwPfIk+K0fLEwVF1pfKUcAeyzsWAEEnZ0FQQA/anQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EkcAm30T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E40606A320;
	Thu, 19 Nov 2026 03:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EkcAm30T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC971F000C4;
	Thu, 19 Nov 2026 03:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059882;
	bh=bIQOI9hS7T+z37FH+7bRDhR2YpkRd6jbFJeAaIJxBmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EkcAm30Tybhm2bR8JPkyjxnLOvqZ/ROGx9LZ8S/vpu3vBhu+zOS1h4L6Dxa+NqHr3
	 tlKESCrr5HFvUnNLCiBefNfRnP5+vAIo6w3jRYC9MXgUQtu5Me1isZL5MVdS+wDdFD
	 wLOcH1r3W7P6Mrbq7BqXglhd9aNeArxNqMvEVJPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armaan Sandhu <armaan.sandhu0504@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Leizhen Zhang <lzsx618@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1000/1848] lib/cmdline: fix get_options() count and overflow with large ranges
Date: Wed, 18 Nov 2026 15:50:38 +0100
Message-ID: <20261118145958.679032037@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted the capacity check to use nints - i without the unavailable validation mode. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/cmdline.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/lib/cmdline.c b/lib/cmdline.c
index fbb9981a04a41..aa90d0f8e1f21 100644
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
@@ -97,6 +100,14 @@ char *get_options(const char *str, int nints, int *ints)
 			range_nums = get_range((char **)&str, ints + i, nints - i);
 			if (range_nums < 0)
 				break;
+			/* The range didn't fit, so the array is full */
+			if (range_nums > nints - i) {
+				i = nints;
+				break;
+			}
+			/* Leave room for the upper number of the range */
+			if (range_nums >= INT_MAX - i)
+				break;
 			/*
 			 * Decrement the result by one to leave out the
 			 * last number in the range.  The next iteration
-- 
2.53.0



