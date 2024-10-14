Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A56A81749;
	Mon, 14 Oct 2024 14:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917847; cv=none; b=ikS+ljbLEwQQhuG194apVJ3H3Y86HqA5bS/wRdBOwo/s84+zWNZW12ecDb0X7c5cRQpjtC5+vmrPPxtJCTnUTBVx69JvzPr5qSg7pSbRKd6RqxRMzB2O4Kcq8yN1UAmSipsvNQPb+RpeHXRP2z40eftgzKJ4MWghzxsTHru6rLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917847; c=relaxed/simple;
	bh=SlGXN8+4/alAilf3CHOIMZZb5DF21/UYmDmiuswVrJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HwAnRqGnA7p/tELLwZsJHSe6xMuBjLdy+Tq6pTkDTvDEmmNkk3Xkvko7nwl/rBPJmiQLX63XcP6jQXUIGnThMRRSuZ3fbl4eUx70SsS+UnXtzcFgd4KZDQVAHUQaXdRWPnZo0QnzeNslApwDnVnK3GQcyzu4/P/q5P6TA0nJlAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vlhlg01s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vlhlg01s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2426BC4CEC3;
	Mon, 14 Oct 2024 14:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917847;
	bh=SlGXN8+4/alAilf3CHOIMZZb5DF21/UYmDmiuswVrJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vlhlg01stVT1zcjv84lM7RQOCDyIYTfE5WPJRtd+i5IgLeI7yUYITwTcKTDgZNmKT
	 /PRdJaQKLNcJ0W0MBRfZZ70+pJ0A1NoNiYsVaTz594gsXB6tQ4FMEzLfTn1H7NaIMS
	 XPVZMCTcb9y+1dN4HIpBF9UcQ0HCgxdkneMkhSWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 151/798] selftests/bpf: Fix compiling kfree_skb.c with musl-libc
Date: Mon, 14 Oct 2024 16:11:45 +0200
Message-ID: <20241014141223.849364024@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Ambardar <tony.ambardar@gmail.com>

[ Upstream commit bae9a5ce7d3a9b3a9e07b31ab9e9c58450e3e9fd ]

The GNU version of 'struct tcphdr' with member 'doff' is not exposed by
musl headers unless _GNU_SOURCE is defined. Add this definition to fix
errors seen compiling for mips64el/musl-libc:

  In file included from kfree_skb.c:2:
  kfree_skb.c: In function 'on_sample':
  kfree_skb.c:45:30: error: 'struct tcphdr' has no member named 'doff'
     45 |         if (CHECK(pkt_v6->tcp.doff != 5, "check_tcp",
        |                              ^

Fixes: 580d656d80cf ("selftests/bpf: Add kfree_skb raw_tp test")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/e2d8cedc790959c10d6822a51f01a7a3616bea1b.1721713597.git.tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/kfree_skb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/kfree_skb.c b/tools/testing/selftests/bpf/prog_tests/kfree_skb.c
index 73579370bfbd6..353499cfb1e41 100644
--- a/tools/testing/selftests/bpf/prog_tests/kfree_skb.c
+++ b/tools/testing/selftests/bpf/prog_tests/kfree_skb.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
 #include <test_progs.h>
 #include <network_helpers.h>
 #include "kfree_skb.skel.h"
-- 
2.43.0



