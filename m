Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F56B153812;
	Tue,  9 Jul 2024 11:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523909; cv=none; b=dGrRG9Hrw6h9L3l4CKSrIuUluSam6XYxxe5WYDbAfIIyHBDx1dDUWSJ9fVE4q2z5Ezen8sGqK6gLvqAUMjMtowN+GYismQkSXw3BBqPfQVVFHML2+TzL0ZPJxO6n6a5Exf02DzPhUG3wwPWTi9YgL1jHukiWdB9elRA3lPpOeQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523909; c=relaxed/simple;
	bh=GBciLlRC+Hl9z2NMJPyojgbi4+7z/dKS2UxxumBj4ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T8wOK4C4fdzVrpM3TMw0ocMq0LwJKjSKxYVazyEmd7iGc9odknYmvhH6TRF5Ri/aA0iKDwIPEsqJDiQBFiM2X4T6eDnKcYKVf9DbB07P0xVmII0iqFVU4tbDJY9A1wj1lLHai5XEOEdtVS0QoZMsgKUQ8FtXSKfc37N+GdVWwpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jxKwLKZD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jxKwLKZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA04EC3277B;
	Tue,  9 Jul 2024 11:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523909;
	bh=GBciLlRC+Hl9z2NMJPyojgbi4+7z/dKS2UxxumBj4ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jxKwLKZDEe5Kf0r/sQk1wLI1u0EnQxOuFH8Rs6/FWrh/37onha9vPFA942xPPSWuq
	 qAsQkRyrpdoGzFfMlWcpYMUJoGMp+YqEg0Hp/JslWll3iiomOBy2r2oCmbIUrgTuWX
	 Pv2gzE81rtR4gyVNmWnDW0yyEDiLjgh3nTYC4L+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Babu Moger <babu.moger@amd.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 001/197] selftests/resctrl: Fix non-contiguous CBM for AMD
Date: Tue,  9 Jul 2024 13:07:35 +0200
Message-ID: <20240709110708.962223037@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Babu Moger <babu.moger@amd.com>

[ Upstream commit 48236960c06d32370bfa6f2cc408e786873262c8 ]

The non-contiguous CBM test fails on AMD with:
Starting L3_NONCONT_CAT test ...
Mounting resctrl to "/sys/fs/resctrl"
CPUID output doesn't match 'sparse_masks' file content!
not ok 5 L3_NONCONT_CAT: test

AMD always supports non-contiguous CBM but does not report it via CPUID.

Fix the non-contiguous CBM test to use CPUID to discover non-contiguous
CBM support only on Intel.

Fixes: ae638551ab64 ("selftests/resctrl: Add non-contiguous CBMs CAT test")
Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/resctrl/cat_test.c | 32 +++++++++++++++-------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/resctrl/cat_test.c b/tools/testing/selftests/resctrl/cat_test.c
index 4cb991be8e31b..178a41d4bb1be 100644
--- a/tools/testing/selftests/resctrl/cat_test.c
+++ b/tools/testing/selftests/resctrl/cat_test.c
@@ -294,11 +294,30 @@ static int cat_run_test(const struct resctrl_test *test, const struct user_param
 	return ret;
 }
 
+static bool arch_supports_noncont_cat(const struct resctrl_test *test)
+{
+	unsigned int eax, ebx, ecx, edx;
+
+	/* AMD always supports non-contiguous CBM. */
+	if (get_vendor() == ARCH_AMD)
+		return true;
+
+	/* Intel support for non-contiguous CBM needs to be discovered. */
+	if (!strcmp(test->resource, "L3"))
+		__cpuid_count(0x10, 1, eax, ebx, ecx, edx);
+	else if (!strcmp(test->resource, "L2"))
+		__cpuid_count(0x10, 2, eax, ebx, ecx, edx);
+	else
+		return false;
+
+	return ((ecx >> 3) & 1);
+}
+
 static int noncont_cat_run_test(const struct resctrl_test *test,
 				const struct user_params *uparams)
 {
 	unsigned long full_cache_mask, cont_mask, noncont_mask;
-	unsigned int eax, ebx, ecx, edx, sparse_masks;
+	unsigned int sparse_masks;
 	int bit_center, ret;
 	char schemata[64];
 
@@ -307,15 +326,8 @@ static int noncont_cat_run_test(const struct resctrl_test *test,
 	if (ret)
 		return ret;
 
-	if (!strcmp(test->resource, "L3"))
-		__cpuid_count(0x10, 1, eax, ebx, ecx, edx);
-	else if (!strcmp(test->resource, "L2"))
-		__cpuid_count(0x10, 2, eax, ebx, ecx, edx);
-	else
-		return -EINVAL;
-
-	if (sparse_masks != ((ecx >> 3) & 1)) {
-		ksft_print_msg("CPUID output doesn't match 'sparse_masks' file content!\n");
+	if (arch_supports_noncont_cat(test) != sparse_masks) {
+		ksft_print_msg("Hardware and kernel differ on non-contiguous CBM support!\n");
 		return 1;
 	}
 
-- 
2.43.0



