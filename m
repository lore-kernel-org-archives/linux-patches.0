Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CF41519A0;
	Mon,  4 Aug 2025 00:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267188; cv=none; b=Jy2nZxJzy7aDsshLs16EzfhFdPINfCatSZ328Q2mgNn0PaLM5p7qfGsptZv0A1YWLba8iKqjYSsdJYu6lwymeqwRztTgiMF1m0NIRe0HY+8ue7LIa78J6sH2zNvgy7CblYd7334er663nOcJ708qIY4v9I2lME5J9P9/2veKKaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267188; c=relaxed/simple;
	bh=dd0SJyHo3DZqL7wtm3TCfNZYchbIagfGqxfYDLtBqgU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UwXcfSSDlV+0YE4uYMymhRdjF3lFpJuzZnB+oatYmAwOZTf8Lr7N5Iu6oadDhV14S0MVX5I3NyOYS018D5GiNGOi4EE+zAB2XYgx9tSAqEt4yT0tD6k2nAzVTLkK1w1VaVZdyelkohi68bfBPv06llU81T2n1qDFj7nPWw03Wr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ow3KSsva; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ow3KSsva"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD0FC4CEEB;
	Mon,  4 Aug 2025 00:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267188;
	bh=dd0SJyHo3DZqL7wtm3TCfNZYchbIagfGqxfYDLtBqgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ow3KSsvaSq8p4SmB2ZVxxyntya6j1OVkoY9izUueA5eyFY73Wk0Tm/lUddmeh7+jF
	 mGD0OjU87XCpaN4FYaIW0SgIntc2xyWtl1PfTXmB7dHHApkO9U0+6fs31oQZkhbk+M
	 n0NfY9hEG9iOS7uxdDGPYj02o7+Q+MFlmuIxJh4P3f+QoKWEB7UqOb9gj5/0qzJzYy
	 5X+r1ZGfOWxPu7mF2hLaMk4XksYvRNYeYOS+iEeAlPOAWrHrapHqg/cBHQF1ecFopP
	 PjegKH1JQdBjHWacOQoso3Kfd9zq1+63XoHZriMyHSDg1GmIgihLEjXJSTShAKoIUV
	 XSEgAFW7hxyUQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.16 55/85] char: misc: Fix improper and inaccurate error code returned by misc_init()
Date: Sun,  3 Aug 2025 20:23:04 -0400
Message-Id: <20250804002335.3613254-55-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804002335.3613254-1-sashal@kernel.org>
References: <20250804002335.3613254-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Zijun Hu <zijun.hu@oss.qualcomm.com>

[ Upstream commit 0ef1fe4bc38673db72e39b700b29c50dfcc5a415 ]

misc_init() returns -EIO for __register_chrdev() invocation failure, but:

- -EIO is for I/O error normally, but __register_chrdev() does not do I/O.
- -EIO can not cover various error codes returned by __register_chrdev().

Fix by returning error code of __register_chrdev().

Signed-off-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250620-fix_mischar-v1-3-6c2716bbf1fa@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Bug Fix Nature**: This is a clear bug fix that corrects improper
   error handling in `misc_init()`. The original code hardcoded `-EIO`
   regardless of the actual error returned by `__register_chrdev()`,
   which could mask the real failure reason.

2. **Small and Contained Change**: The fix is minimal - just 4 lines
   changed:
   - Removed the hardcoded `err = -EIO;` assignment
   - Changed `__register_chrdev()` from being used in an if condition to
     storing its return value
   - Updated the error check to properly test for negative error codes
     (`err < 0`)

3. **Improves Diagnostic Accuracy**: By returning the actual error code
   from `__register_chrdev()`, system administrators and developers can
   get accurate information about why the misc device initialization
   failed. Looking at the `__register_chrdev()` implementation, it can
   return various error codes like `-ENOMEM`, `-EBUSY`, or error codes
   from `__register_chrdev_region()`.

4. **No Architectural Changes**: This commit doesn't introduce any new
   features or change the architecture. It simply fixes error
   propagation in the initialization path.

5. **Low Risk of Regression**: The change is straightforward error
   handling correction. The behavior remains the same for successful
   cases, and only the error code changes for failure cases. This cannot
   break any working systems.

6. **Affects Core Subsystem**: The misc device subsystem is fundamental
   to many kernel drivers and userspace applications. Having accurate
   error codes during initialization failures is important for debugging
   boot issues.

7. **Follows Stable Rules**: This meets the stable kernel criteria -
   it's a real bug fix (incorrect error codes), it's small (4 lines),
   and it has minimal risk while providing clear benefit.

The commit properly preserves the error path behavior while ensuring the
actual error from `__register_chrdev()` is propagated up, making it an
ideal candidate for stable backporting.

 drivers/char/misc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index d5accc10a110..5247d0ec0f4c 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -296,8 +296,8 @@ static int __init misc_init(void)
 	if (err)
 		goto fail_remove;
 
-	err = -EIO;
-	if (__register_chrdev(MISC_MAJOR, 0, MINORMASK + 1, "misc", &misc_fops))
+	err = __register_chrdev(MISC_MAJOR, 0, MINORMASK + 1, "misc", &misc_fops);
+	if (err < 0)
 		goto fail_printk;
 	return 0;
 
-- 
2.39.5

