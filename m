Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0170128851F;
	Wed, 25 Feb 2026 01:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983753; cv=none; b=snOFHFaIcsSc5pI3cP4AQzJKa05iByH6anbhadFEAD/4shWdssx2W0ED3LVNRYnTzX+Bq/rduO/u+jtk658TRhVowAZX5Qn5IajuTRm300fWGsO94Eb1QklAEhhO9nJEt0FCUTd3ZnwzCfS6U0E71YeYxLhlq1KQcWrTu9z6z4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983753; c=relaxed/simple;
	bh=88dZP/FQuW/wvsCe+aIuzgrjWmoR1rgac8IKIWWHBVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QVG/ZeE6h6E6dsLJ7+2fdeJIvTpB43Op7C+EFbtVFBCbE1Xqx6YYJ7tD3FaVc57845VqEdc3250Q5RWVuPmPClv64SHddcRHLdtj6Wa3nAoNOomcbzxNegugyziDqvnHMf2eN+cnX5gbjtn4DVGuFZLjPoTD+j63Tm9SlPOenGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JlEJQiHv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JlEJQiHv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B05D7C19423;
	Wed, 25 Feb 2026 01:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983752;
	bh=88dZP/FQuW/wvsCe+aIuzgrjWmoR1rgac8IKIWWHBVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JlEJQiHvEP1P/yXoNwtYTdWT7bYhDVsI73rIfiPnEEApVFVKwDf6EZ6TeZ9dcJU0L
	 Zz2OZYgkmW0FAHiFMrjhcb/8gHtwVUYyiQZfHogCpozje/RLpzfb3OUthFcvkEtn8z
	 7/W/NGCzzdQcsRD7/Uz+aC/5wCnZ2cfswLg772Fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaochen Shen <shenxiaochen@open-hieco.net>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Fenghua Yu <fenghuay@nvidia.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 007/641] selftests/resctrl: Fix a division by zero error on Hygon
Date: Tue, 24 Feb 2026 17:15:33 -0800
Message-ID: <20260225012349.117826556@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



