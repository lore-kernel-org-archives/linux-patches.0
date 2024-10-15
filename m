Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6A11D8DE0;
	Tue, 15 Oct 2024 11:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992702; cv=none; b=dz8FUJDlJbFWd86L5gu3H6YKPFxNQN1u8jGBm2AALgn+bFI/RS2naLsizjsGaeDqZrm7/l7Bde6YA92hJc/6n2Hyfkvjr9HApJ8+9JltK6MeBFNBoOlfztZdobtrZlZK7V4vUS2q4z+uOf8zbYGqvkLL3EMyFdq/bwPk3yO9paM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992702; c=relaxed/simple;
	bh=fopFq1iIct3+SYul7QE6oph2LtYj8TfyNtqnBVSUk9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rtznmsKR9RIITQfbAE2JyrB8oRKjf7Ky7S2zmYRe8rP4whnPuPAXs5E/Zcyn+UMBgCOacXwFu8Tvu2QCqVLtAcu7SIIYXc5qtloQIvZGfxsvBqAjBNL6zk2QToL3qEr+oyodco3sKmZ4C92U5NvPp4famDB9yc4PHwvgz5RlkfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qNBvzOuo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qNBvzOuo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF3AC4CECF;
	Tue, 15 Oct 2024 11:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992702;
	bh=fopFq1iIct3+SYul7QE6oph2LtYj8TfyNtqnBVSUk9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qNBvzOuouhqfBxH1vyHFdF1CG+NKRudCBDmSP6ukXXEOPniFh5GGlj+XNt/m3s9L5
	 lFLg+h245edE2ykA9h7e1ck8Q3oo5KeSDBpkHlrg4peRD2vvZzVkrzP2dUdLkbNmWK
	 QrRU9Ec3UMhhynZOJ13NaijbaixdZ4iTrbuXDdTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 194/691] selftests/bpf: Fix compiling kfree_skb.c with musl-libc
Date: Tue, 15 Oct 2024 13:22:22 +0200
Message-ID: <20241015112448.059427204@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ddfb6bf971524..f1a7d1fa0ee91 100644
--- a/tools/testing/selftests/bpf/prog_tests/kfree_skb.c
+++ b/tools/testing/selftests/bpf/prog_tests/kfree_skb.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
 #include <test_progs.h>
 #include <network_helpers.h>
 
-- 
2.43.0



