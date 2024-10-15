Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A42E1E6DCD;
	Tue, 15 Oct 2024 13:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997391; cv=none; b=CJJdcUM9RRAsO+BVQ/jVaQ9GuHU5yB18FntwzFqSZaE95GBZGItvq9+NzENkhBR7Meto+SmZxxsfLnspdWYkzgzw16lLl6docPBrvDQ7gzdtfhVLCPOntdB9WsqExrIjc2gRMrRDWUJQqejLa+wNS6Zehdcr+hoXzeE1RXJ2MDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997391; c=relaxed/simple;
	bh=+RgMXeCF7/wu2QcdvXMhL/xVbY1rwZPYpWKcBkHvH0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxKEYNb+x/WKUnYL/qamwpl9cntYacA0luYCN9fNV91Yh5w8u+eDtGkGVNPsB0+cH41ANSYUwoHptKF3+A9iXLUD/TyT2RyAwDkf+Ak2wGuoyznKs7hpJwDPQB74bluoHZc2ibTlmEA9ZAIysRO5UlFd8qd4jOoWRnkfWNaIcAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UiIOWj6K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UiIOWj6K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1F5C4CED2;
	Tue, 15 Oct 2024 13:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997391;
	bh=+RgMXeCF7/wu2QcdvXMhL/xVbY1rwZPYpWKcBkHvH0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UiIOWj6KcrdKjHjAVNZuqpXppe8X1iJRDT8E0bBLrAP6T1HZUbVa/BL5Bk+DKcQ0J
	 qCdHDi0XlfhajHdmY5GJAtLMtLq6IGHxTXJhGyxpKvgtpjH72kulI4iOfREnzisp/Z
	 6AifcA/EE31QoV7njBAxm2moJO5N6wmFi2bZLexM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 138/518] selftests/bpf: Fix compiling kfree_skb.c with musl-libc
Date: Tue, 15 Oct 2024 14:40:42 +0200
Message-ID: <20241015123922.323272735@linuxfoundation.org>
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
index 42c3a3103c262..a37b1d663f964 100644
--- a/tools/testing/selftests/bpf/prog_tests/kfree_skb.c
+++ b/tools/testing/selftests/bpf/prog_tests/kfree_skb.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
 #include <test_progs.h>
 #include <network_helpers.h>
 
-- 
2.43.0



