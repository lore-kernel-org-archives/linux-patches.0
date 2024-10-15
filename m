Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9C51C07F2;
	Tue, 15 Oct 2024 13:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997398; cv=none; b=PO5/1cZT3kN5MXeXp6YeMuDz0P30huZ1YFuotDMjrhbVrqnGfTpFis7egXZ9DoPxvNUfUchl7hSXGNilYYAkTX596sd6dBJc3TAn85ujHRvtbWJ3tDCulXsbSiBJwA93bdYl7C90CimgMnl5lJC96mGMxPJvxlG9o4oynYvCcv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997398; c=relaxed/simple;
	bh=dFn1OUH4tfdKz5hCWAVxWd38tsX5PUeXsA11rJPXsG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=duu1IJteSMq34XHvo5Okkr4pPyKsFbB+dbyknqu6EUrG7Q8jpjlQNqfG0LtCbKUy54R22n/fZlv/r/UsLzbAPg+Nj5GEZTTQjKifdaSo+a+2Fjw+KrOu6CZqc53LwKoWAO3t5oDsnejivSA6Y7snDBh9xwpOwf0fsjeQ6ThYGDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k8Yt3uKx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k8Yt3uKx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F227C4CEC6;
	Tue, 15 Oct 2024 13:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997398;
	bh=dFn1OUH4tfdKz5hCWAVxWd38tsX5PUeXsA11rJPXsG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k8Yt3uKxWKU5Kj4BitFh6JgWZPBA2dGMEeEk3Vre5qzkOlsh+MVVvItDnO+2JmtYu
	 RCgZaOeIDCasVJlFIuMZ98JQv4Kdqhmo1zLQZ9vCGUhTZjUPJVTej9hzY2Q+srFl5a
	 iPc0nmZuIIpV40emAzQiWH18NZEXAyttzJ6XMI4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 140/518] selftests/bpf: Fix compiling tcp_rtt.c with musl-libc
Date: Tue, 15 Oct 2024 14:40:44 +0200
Message-ID: <20241015123922.399256178@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d207e968e6b1b..dee68ef976ae9 100644
--- a/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
+++ b/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
 #include <test_progs.h>
 #include "cgroup_helpers.h"
 #include "network_helpers.h"
-- 
2.43.0



