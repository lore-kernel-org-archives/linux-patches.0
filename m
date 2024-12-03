Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32591FECA2;
	Tue,  3 Dec 2024 15:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240536; cv=none; b=ApAi65xnCMj5uBkTjtAqv/4CghrSJ/jYtij35iTY4oAkB9EgjTRpPUJdmpKWRqGuT0mV26joE3Si86cSqKsfiqS6SBQoYQdOFI70E2m5+bdQ4p6n01jl3GDKxO3xuy8wJu9VDldwAvDTiPi+hgVS/NH3YFZ4OjXc8lxlNtfHc7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240536; c=relaxed/simple;
	bh=5j0lCSInyajRBKoXzGy0iKkSzTA84NW3X99UPb+9ht4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eu6MBK1qlFAUjSpbHciidS4QntPM+COHLHGRYACF65hD06piHUkatQQDsaNKzmkgPmpBUDUnFueEHKaA/Fhbwdval+gwKCGDyc7xoZga+Vy/ZyE3KlGU8yW4KVR5REdxMRbcmILCds98huSnR4NLqSlnc4igIXncTtGPUqA2Jok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kEzeL/2S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kEzeL/2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62497C4CECF;
	Tue,  3 Dec 2024 15:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240535;
	bh=5j0lCSInyajRBKoXzGy0iKkSzTA84NW3X99UPb+9ht4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kEzeL/2SsEMiUjVXYAJJVMcgKY4o5ZaPcrWk2stG3cvMvTLVIy2qwjF7WKnUtFQQX
	 7yxo4vz9ZcmI/7kGCdKF5Ad6jMuNWfZ+8yfN1eA0UBd/XeWfEksWdFTipDfciJQF7I
	 vtshJMzYlcqiGS1oL5jjvi9emxpR7mwXZmyj9OqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reinette Chatre <reinette.chatre@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 164/826] selftests/resctrl: Print accurate buffer size as part of MBM results
Date: Tue,  3 Dec 2024 15:38:11 +0100
Message-ID: <20241203144750.134351181@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Reinette Chatre <reinette.chatre@intel.com>

[ Upstream commit 1b4840395f08e9723a15fea42c2d31090e8375f3 ]

By default the MBM test uses the "fill_buf" benchmark to keep reading
from a buffer with size DEFAULT_SPAN while measuring memory bandwidth.
User space can provide an alternate benchmark or amend the size of
the buffer "fill_buf" should use.

Analysis of the MBM measurements do not require that a buffer be used
and thus do not require knowing the size of the buffer if it was used
during testing. Even so, the buffer size is printed as informational
as part of the MBM test results. What is printed as buffer size is
hardcoded as DEFAULT_SPAN, even if the test relied on another benchmark
(that may or may not use a buffer) or if user space amended the buffer
size.

Ensure that accurate buffer size is printed when using "fill_buf"
benchmark and omit the buffer size information if another benchmark
is used.

Fixes: ecdbb911f22d ("selftests/resctrl: Add MBM test")
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/resctrl/mbm_test.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/resctrl/mbm_test.c b/tools/testing/selftests/resctrl/mbm_test.c
index 6b5a3b52d861b..cf08ba5e314e2 100644
--- a/tools/testing/selftests/resctrl/mbm_test.c
+++ b/tools/testing/selftests/resctrl/mbm_test.c
@@ -40,7 +40,8 @@ show_bw_info(unsigned long *bw_imc, unsigned long *bw_resc, size_t span)
 	ksft_print_msg("%s Check MBM diff within %d%%\n",
 		       ret ? "Fail:" : "Pass:", MAX_DIFF_PERCENT);
 	ksft_print_msg("avg_diff_per: %d%%\n", avg_diff_per);
-	ksft_print_msg("Span (MB): %zu\n", span / MB);
+	if (span)
+		ksft_print_msg("Span (MB): %zu\n", span / MB);
 	ksft_print_msg("avg_bw_imc: %lu\n", avg_bw_imc);
 	ksft_print_msg("avg_bw_resc: %lu\n", avg_bw_resc);
 
@@ -138,15 +139,26 @@ static int mbm_run_test(const struct resctrl_test *test, const struct user_param
 		.setup		= mbm_setup,
 		.measure	= mbm_measure,
 	};
+	char *endptr = NULL;
+	size_t span = 0;
 	int ret;
 
 	remove(RESULT_FILE_NAME);
 
+	if (uparams->benchmark_cmd[0] && strcmp(uparams->benchmark_cmd[0], "fill_buf") == 0) {
+		if (uparams->benchmark_cmd[1] && *uparams->benchmark_cmd[1] != '\0') {
+			errno = 0;
+			span = strtoul(uparams->benchmark_cmd[1], &endptr, 10);
+			if (errno || *endptr != '\0')
+				return -EINVAL;
+		}
+	}
+
 	ret = resctrl_val(test, uparams, uparams->benchmark_cmd, &param);
 	if (ret)
 		return ret;
 
-	ret = check_results(DEFAULT_SPAN);
+	ret = check_results(span);
 	if (ret && (get_vendor() == ARCH_INTEL))
 		ksft_print_msg("Intel MBM may be inaccurate when Sub-NUMA Clustering is enabled. Check BIOS configuration.\n");
 
-- 
2.43.0



