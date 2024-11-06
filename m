Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503CE1DFE3B;
	Wed,  6 Nov 2024 13:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898000; cv=none; b=kSpPwp0T5O2METIzPu10JSGxHKDqG57lXj6OVRq2jgE/yUQ+VCF6mrF6n9bUeIOuas6wMzz8SuLbbukTqhWA5AAlZXpm8lLcLxDu3bQDzHbozQ/MIhI9tu/rFa4ALLb5iv7qdw6Pg7b+fND4KaJMuo3PLhjz65ew7USLxJ74hw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898000; c=relaxed/simple;
	bh=J5BqvNC/5vbytBy9G51P1Bh2Kjt6iAgzzx5aH4cng94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JM+GZZhKyOGpErGtYkx46+jbMK8q6PA03ihEHmwFb0FkNKmB/tsSCG7bJ2i/PVE3PvSW6p3uvBs/TWpbtNeirRpdZXT11Db33jWKv8Gpe0JP8DEk3krtg4Rt3YyeO5UbKejaH0IlfOxtdAvB1n/7ndMlvSjIVV3eDpJAk7IwoHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iCJgc+Am; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iCJgc+Am"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7199C4CECD;
	Wed,  6 Nov 2024 12:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898000;
	bh=J5BqvNC/5vbytBy9G51P1Bh2Kjt6iAgzzx5aH4cng94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iCJgc+AmndYfA+tPyKVcqcbql+Mfhkj+IbOmJVs50HhOiZb12PpAgOEXTiNvwviCk
	 dt3+Q+EWnMOlTT1liZ2hR9rKkMcyyeA3DoXOkXdy+AsXdnx74nWlKKJ3Sw7To5i681
	 KmjxA8AFugvDkEtr8why1pKYVtvPhjx6WUkA+SeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 090/462] selftests/bpf: Fix compiling tcp_rtt.c with musl-libc
Date: Wed,  6 Nov 2024 12:59:43 +0100
Message-ID: <20241106120333.728864682@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Ambardar <tony.ambardar@gmail.com>

[ Upstream commit 18826fb0b79c3c3cd1fe765d85f9c6f1a902c722 ]

The GNU version of 'struct tcp_info' in 'netinet/tcp.h' is not exposed by
musl headers unless _GNU_SOURCE is defined.

Add this definition to fix errors seen compiling for mips64el/musl-libc:

  tcp_rtt.c: In function 'wait_for_ack':
  tcp_rtt.c:24:25: error: storage size of 'info' isn't known
     24 |         struct tcp_info info;
        |                         ^~~~
  tcp_rtt.c:24:25: error: unused variable 'info' [-Werror=unused-variable]
  cc1: all warnings being treated as errors

Fixes: 1f4f80fed217 ("selftests/bpf: test_progs: convert test_tcp_rtt")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/f2329767b15df206f08a5776d35a47c37da855ae.1721713597.git.tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/tcp_rtt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c b/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
index f4cd60d6fba2e..ef052f7845b67 100644
--- a/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
+++ b/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
 #include <test_progs.h>
 #include "cgroup_helpers.h"
 
-- 
2.43.0



