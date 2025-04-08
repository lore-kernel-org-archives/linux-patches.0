Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1983269AE8;
	Tue,  8 Apr 2025 12:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115752; cv=none; b=O6QkEjtA1V9SRcV/Zh+fE5yivMuQLVWj2SXsPRlbuR8HSCiQGfBWgS0FOTY6nLzUrKpw5HQ4We58M2LhEUNhYisYxb0hANpMdxM/DbFda738IUjqh7tXaskFPLycbIbu3XAPol2VlAyPZ7kisP+9qemViHUoW0pkMcieFJnqgSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115752; c=relaxed/simple;
	bh=exGrcVYIDSMoh7tzty76FvhVkLjC1YTDICGEc4CeSPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cI/5yxMH2jcqEMLtJ75MlsQyEdrjmWx7TBhOhZjNtfHrKRhKY1eFu3Tt2Ma+vrmONjaAwYmqsRXLC3b6wqpYB+gAECECLpsQLHq6X83Ei6D6yf7AjNx/nPl4lNdPagpcRBtww4cm6YIUUiWADmX6uKp258jBGoK5J4/g3WDMbeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ib3wx/TH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ib3wx/TH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5598AC4CEE5;
	Tue,  8 Apr 2025 12:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115752;
	bh=exGrcVYIDSMoh7tzty76FvhVkLjC1YTDICGEc4CeSPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ib3wx/THLf9kkAeckyDeC4/u9SPfdUGwYLtgBeSzxyqgnh/awxpFBXoz9/h4CiYO8
	 Haz04bgJMs/mZu8innqEaVqZUdmSUjaPI1nsA9672R+YabufLSnBXgRF4EBdiHwf2o
	 6aIeSPucNyUPmAtB9kSxnZIP4idQa+EKENR2naHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saket Kumar Bhaskar <skb99@linux.ibm.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 074/204] selftests/bpf: Select NUMA_NO_NODE to create map
Date: Tue,  8 Apr 2025 12:50:04 +0200
Message-ID: <20250408104822.530998735@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saket Kumar Bhaskar <skb99@linux.ibm.com>

[ Upstream commit 4107a1aeb20ed4cdad6a0d49de92ea0f933c71b7 ]

On powerpc, a CPU does not necessarily originate from NUMA node 0.
This contrasts with architectures like x86, where CPU 0 is not
hot-pluggable, making NUMA node 0 a consistently valid node.
This discrepancy can lead to failures when creating a map on NUMA
node 0, which is initialized by default, if no CPUs are allocated
from NUMA node 0.

This patch fixes the issue by setting NUMA_NO_NODE (-1) for map
creation for this selftest.

Fixes: 96eabe7a40aa ("bpf: Allow selecting numa node during map creation")
Signed-off-by: Saket Kumar Bhaskar <skb99@linux.ibm.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/bpf/cf1f61468b47425ecf3728689bc9636ddd1d910e.1738302337.git.skb99@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/bloom_filter_map.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/bloom_filter_map.c b/tools/testing/selftests/bpf/prog_tests/bloom_filter_map.c
index f79815b7e951b..fff16cdc93f20 100644
--- a/tools/testing/selftests/bpf/prog_tests/bloom_filter_map.c
+++ b/tools/testing/selftests/bpf/prog_tests/bloom_filter_map.c
@@ -6,6 +6,10 @@
 #include <test_progs.h>
 #include "bloom_filter_map.skel.h"
 
+#ifndef NUMA_NO_NODE
+#define NUMA_NO_NODE	(-1)
+#endif
+
 static void test_fail_cases(void)
 {
 	LIBBPF_OPTS(bpf_map_create_opts, opts);
@@ -69,6 +73,7 @@ static void test_success_cases(void)
 
 	/* Create a map */
 	opts.map_flags = BPF_F_ZERO_SEED | BPF_F_NUMA_NODE;
+	opts.numa_node = NUMA_NO_NODE;
 	fd = bpf_map_create(BPF_MAP_TYPE_BLOOM_FILTER, NULL, 0, sizeof(value), 100, &opts);
 	if (!ASSERT_GE(fd, 0, "bpf_map_create bloom filter success case"))
 		return;
-- 
2.39.5



