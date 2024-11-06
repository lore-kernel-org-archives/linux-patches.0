Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D0E1DED6C;
	Wed,  6 Nov 2024 12:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897997; cv=none; b=B77BwoebcbLyzAOh7XhdRlvUJBu011fEP0NvRlPZEUMbXFJULb9U5DN3CJ+oujbPZi0HO7BGSstUZZmkkL0a/aBPfO2eEQ1vijoH04aCUA6dS0rN1Q362m6M/YpTNwwx72oiPDgwGpQGyukRJLcaXIWwmFWjwoTLlRWtg+0cA+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897997; c=relaxed/simple;
	bh=XRxFgwo07paz6uNcL5EMjpEhiue1f6JcoLBg91Fr524=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oOxOBVHMgcyhxRpuJiWgtejuLAmARJ68ajhIZ+4nfPZlq3LHtsqs5D0TRKDmbMAyyWlM6h84tUxUtXL3A3AzZfSuGKIdkk1VyI/ZF1ZnTRkgz+hyIRXW25hs2bqc5WaesXZTIs8dre3Whf5zSCeV1mlfyvdHlW3nLLQeOrilZN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LZ1kSzUz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LZ1kSzUz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D394DC4CECD;
	Wed,  6 Nov 2024 12:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897997;
	bh=XRxFgwo07paz6uNcL5EMjpEhiue1f6JcoLBg91Fr524=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LZ1kSzUzIGSmCNcWCsW7MfonKs/Urbo7ExHGOBFbSTWJHYN7r7m2rPYognnzfc0Qc
	 NCgmTro53pV9ZQmw0je6RYhE3BOAMB6LyVWauVfp4BRYz451AnjJvL1ACAoA5JSG7p
	 CcCUrV0TeTw5bgWFdlz3h3sKAYzLzJbr448v6wkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 089/462] selftests/bpf: Fix compiling flow_dissector.c with musl-libc
Date: Wed,  6 Nov 2024 12:59:42 +0100
Message-ID: <20241106120333.703823299@linuxfoundation.org>
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

[ Upstream commit 5e4c43bcb85973243d7274e0058b6e8f5810e4f7 ]

The GNU version of 'struct tcphdr' has members 'doff', 'source' and 'dest',
which are not exposed by musl libc headers unless _GNU_SOURCE is defined.

Add this definition to fix errors seen compiling for mips64el/musl-libc:

  flow_dissector.c:118:30: error: 'struct tcphdr' has no member named 'doff'
    118 |                         .tcp.doff = 5,
        |                              ^~~~
  flow_dissector.c:119:30: error: 'struct tcphdr' has no member named 'source'
    119 |                         .tcp.source = 80,
        |                              ^~~~~~
  flow_dissector.c:120:30: error: 'struct tcphdr' has no member named 'dest'
    120 |                         .tcp.dest = 8080,
        |                              ^~~~

Fixes: ae173a915785 ("selftests/bpf: support BPF_FLOW_DISSECTOR_F_PARSE_1ST_FRAG")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/8f7ab21a73f678f9cebd32b26c444a686e57414d.1721713597.git.tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/flow_dissector.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
index 9f3634c9971d0..8a921686d304f 100644
--- a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
+++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
 #include <test_progs.h>
 #include <error.h>
 #include <linux/if.h>
-- 
2.43.0



