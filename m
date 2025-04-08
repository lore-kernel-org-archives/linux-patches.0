Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB19267393;
	Tue,  8 Apr 2025 12:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114522; cv=none; b=Bv9Asv8yGglUX4QTMkIHMZ/0Fybtvhj0XncnVVZnKTdxELznxTgWePBynr381Elo03TXlP8x4LcUXpQvQ0/IzNY3FHqMprPuS1w54fIrXl3gDvXvh7v+VA16hILth5EWs2CxUyCckcVrSZElUa3FrnVXyyEyvBPeMWviaF9vhRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114522; c=relaxed/simple;
	bh=+2Zj+fAnmuhhvYmGfIA92bNvdKyrN64hPKNTj3GwDAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eI0GMWlA0PgiQX8iiOgw+wS1JSZSdvMxk3X6MpnxSau7rg8rvsWWu+Bs/lund2bifyibZFbUQHsn9jwelLSDNBx202whaTgDsTihF5fywGdCWYR4AhOe5YpTjd4yy/qiDVw+5y7RYquYf40gpqX84NCbUO3tsdaK7jcFj2HzDBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q68tqYkv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q68tqYkv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487A5C4CEE5;
	Tue,  8 Apr 2025 12:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114522;
	bh=+2Zj+fAnmuhhvYmGfIA92bNvdKyrN64hPKNTj3GwDAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q68tqYkvHzuDIfEw08hpSxwg/pYtkLbJ4ahJxfV/2AlNhsQP51BZcnRlgIm+unj5C
	 EaJefLurpSDOI2YmfDLLEl0kfhmywdEw68QFuga5sluMIui4EK3aNVXgV0IPlKcv2E
	 dltU3vSojVQNGaPX+etD9iMcgTk6/Z4lL83U//BQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Viktor Malik <vmalik@redhat.com>,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 139/499] selftests/bpf: Fix string read in strncmp benchmark
Date: Tue,  8 Apr 2025 12:45:51 +0200
Message-ID: <20250408104854.658255580@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viktor Malik <vmalik@redhat.com>

[ Upstream commit de07b182899227d5fd1ca7a1a7d495ecd453d49c ]

The strncmp benchmark uses the bpf_strncmp helper and a hand-written
loop to compare two strings. The values of the strings are filled from
userspace. One of the strings is non-const (in .bss) while the other is
const (in .rodata) since that is the requirement of bpf_strncmp.

The problem is that in the hand-written loop, Clang optimizes the reads
from the const string to always return 0 which breaks the benchmark.

Use barrier_var to prevent the optimization.

The effect can be seen on the strncmp-no-helper variant.

Before this change:

    # ./bench strncmp-no-helper
    Setting up benchmark 'strncmp-no-helper'...
    Benchmark 'strncmp-no-helper' started.
    Iter   0 (112.309us): hits    0.000M/s (  0.000M/prod), drops    0.000M/s, total operations    0.000M/s
    Iter   1 (-23.238us): hits    0.000M/s (  0.000M/prod), drops    0.000M/s, total operations    0.000M/s
    Iter   2 ( 58.994us): hits    0.000M/s (  0.000M/prod), drops    0.000M/s, total operations    0.000M/s
    Iter   3 (-30.466us): hits    0.000M/s (  0.000M/prod), drops    0.000M/s, total operations    0.000M/s
    Iter   4 ( 29.996us): hits    0.000M/s (  0.000M/prod), drops    0.000M/s, total operations    0.000M/s
    Iter   5 ( 16.949us): hits    0.000M/s (  0.000M/prod), drops    0.000M/s, total operations    0.000M/s
    Iter   6 (-60.035us): hits    0.000M/s (  0.000M/prod), drops    0.000M/s, total operations    0.000M/s
    Summary: hits    0.000 ± 0.000M/s (  0.000M/prod), drops    0.000 ± 0.000M/s, total operations    0.000 ± 0.000M/s

After this change:

    # ./bench strncmp-no-helper
    Setting up benchmark 'strncmp-no-helper'...
    Benchmark 'strncmp-no-helper' started.
    Iter   0 ( 77.711us): hits    5.534M/s (  5.534M/prod), drops    0.000M/s, total operations    5.534M/s
    Iter   1 ( 11.215us): hits    6.006M/s (  6.006M/prod), drops    0.000M/s, total operations    6.006M/s
    Iter   2 (-14.253us): hits    5.931M/s (  5.931M/prod), drops    0.000M/s, total operations    5.931M/s
    Iter   3 ( 59.087us): hits    6.005M/s (  6.005M/prod), drops    0.000M/s, total operations    6.005M/s
    Iter   4 (-21.379us): hits    6.010M/s (  6.010M/prod), drops    0.000M/s, total operations    6.010M/s
    Iter   5 (-20.310us): hits    5.861M/s (  5.861M/prod), drops    0.000M/s, total operations    5.861M/s
    Iter   6 ( 53.937us): hits    6.004M/s (  6.004M/prod), drops    0.000M/s, total operations    6.004M/s
    Summary: hits    5.969 ± 0.061M/s (  5.969M/prod), drops    0.000 ± 0.000M/s, total operations    5.969 ± 0.061M/s

Fixes: 9c42652f8be3 ("selftests/bpf: Add benchmark for bpf_strncmp() helper")
Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Viktor Malik <vmalik@redhat.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Hou Tao <houtao1@huawei.com>
Link: https://lore.kernel.org/bpf/20250313122852.1365202-1-vmalik@redhat.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/strncmp_bench.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/strncmp_bench.c b/tools/testing/selftests/bpf/progs/strncmp_bench.c
index 18373a7df76e6..f47bf88f8d2a7 100644
--- a/tools/testing/selftests/bpf/progs/strncmp_bench.c
+++ b/tools/testing/selftests/bpf/progs/strncmp_bench.c
@@ -35,7 +35,10 @@ static __always_inline int local_strncmp(const char *s1, unsigned int sz,
 SEC("tp/syscalls/sys_enter_getpgid")
 int strncmp_no_helper(void *ctx)
 {
-	if (local_strncmp(str, cmp_str_len + 1, target) < 0)
+	const char *target_str = target;
+
+	barrier_var(target_str);
+	if (local_strncmp(str, cmp_str_len + 1, target_str) < 0)
 		__sync_add_and_fetch(&hits, 1);
 	return 0;
 }
-- 
2.39.5



