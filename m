Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1832C2517AC;
	Wed, 25 Feb 2026 01:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982830; cv=none; b=Ks669xMD6OUizFRgWAaXHrMhwo8tsCawXqS2j0owNlf6Xp8TpkZB1UU9TPEAeLncerwZsU8f/yMB8OMzLiwd8r+KnF8dHpvcCWbGT7Pd057pUGTOKqJBZsrc3EBmIsiet9zu3IaoZQlqzi0pQENU7Ny6D2Vjwx1ow0d2lf7aZw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982830; c=relaxed/simple;
	bh=zdx8U/PfqhbK6iPo/ecL2ACMUcDdDXH5wMnElrmaOpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pIjd8+czEr1gY85/uDmjcIVBUk0cC5jZPrZMTEE5qjCcQCSjqsOqqopCyApa3fR5hq2Fy/pGVQKsBKMEGKpkfPvwl9nbcptq7gUN1wRK9oG9A4ujLWyy2EPqSZb6H8VJNWQWjAoDdAplht+iYKK+YV1lKn2627wZUgRBSWt8YRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BaOTKiVJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BaOTKiVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFD35C116D0;
	Wed, 25 Feb 2026 01:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982830;
	bh=zdx8U/PfqhbK6iPo/ecL2ACMUcDdDXH5wMnElrmaOpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BaOTKiVJROeBPirrz07h9ATLg3Z6RI/mWa5xXyhLGxivtw0/U4q/EYPYpjYT74ZG/
	 dcaoylhm2VCY1pT6/edFOqNezQl+Zr3eIPdIv/cgI/LhyebcLXpoaeJ7LOkkSjEDxp
	 BYOGWIJ3HkKC15uprPHeqTPZUJPXLg8xhoxsYy9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaochen Shen <shenxiaochen@open-hieco.net>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Fenghua Yu <fenghuay@nvidia.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 008/781] selftests/resctrl: Fix a division by zero error on Hygon
Date: Tue, 24 Feb 2026 17:11:57 -0800
Message-ID: <20260225012359.900895895@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaochen Shen <shenxiaochen@open-hieco.net>

[ Upstream commit 671ef08d9455f5754d1fc96f5a14e357d6b80936 ]

Change to adjust effective L3 cache size with SNC enabled change
introduced the snc_nodes_per_l3_cache() function to detect the Intel
Sub-NUMA Clustering (SNC) feature by comparing #CPUs in node0 with #CPUs
sharing LLC with CPU0. The function was designed to return:
  (1) >1: SNC mode is enabled.
  (2)  1: SNC mode is not enabled or not supported.

However, on certain Hygon CPUs, #CPUs sharing LLC with CPU0 is actually
less than #CPUs in node0. This results in snc_nodes_per_l3_cache()
returning 0 (calculated as cache_cpus / node_cpus).

This leads to a division by zero error in get_cache_size():
  *cache_size /= snc_nodes_per_l3_cache();

Causing the resctrl selftest to fail with:
  "Floating point exception (core dumped)"

Fix the issue by ensuring snc_nodes_per_l3_cache() returns 1 when SNC
mode is not supported on the platform.

Updated commit log to fix commit has issues:
Shuah Khan <skhan@linuxfoundation.org>

Link: https://lore.kernel.org/r/20251217030456.3834956-2-shenxiaochen@open-hieco.net
Fixes: a1cd99e700ec ("selftests/resctrl: Adjust effective L3 cache size with SNC enabled")
Signed-off-by: Xiaochen Shen <shenxiaochen@open-hieco.net>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Fenghua Yu <fenghuay@nvidia.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/resctrl/resctrlfs.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/resctrl/resctrlfs.c b/tools/testing/selftests/resctrl/resctrlfs.c
index 195f04c4d1586..b9c1bfb6cc029 100644
--- a/tools/testing/selftests/resctrl/resctrlfs.c
+++ b/tools/testing/selftests/resctrl/resctrlfs.c
@@ -243,6 +243,16 @@ int snc_nodes_per_l3_cache(void)
 		}
 		snc_mode = cache_cpus / node_cpus;
 
+		/*
+		 * On some platforms (e.g. Hygon),
+		 * cache_cpus < node_cpus, the calculated snc_mode is 0.
+		 *
+		 * Set snc_mode = 1 to indicate that SNC mode is not
+		 * supported on the platform.
+		 */
+		if (!snc_mode)
+			snc_mode = 1;
+
 		if (snc_mode > 1)
 			ksft_print_msg("SNC-%d mode discovered.\n", snc_mode);
 	}
-- 
2.51.0



