Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFBB1AB517;
	Mon, 14 Oct 2024 14:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917851; cv=none; b=J9qM1AWqbU/1UMwbx+g0eLftnPuA7sj3CZdcF2LV/Zn3s/IrAGXqSIjpBaeYPe2rX6h/vLpCbcc6jksAMPzEvQFvPRZvofIBzaKUgVm6LsQ0NPW7hzCDnrRVOpvrTrLHu+nLxoexn6WeYvNuOyDXUUI/+mLh/YKz3ro/QmIx/rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917851; c=relaxed/simple;
	bh=lHC+z9EmHwjimZkwxN4x7Y0khJXtQQVCM/T48WfBVOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TMZ5SeMUpzjUEg/HL8w/Yhq0gtzeeqNw8GY+lPak4jWCZDGWz7RJnF6/M0l988seAO/DTk48HcVqDvhBs4c7iTYxxcBmQDNfj/gVRa1hWVn8GXfj9W9/DwI6vn9vqbWE/o40hxYrSdk5bfO53oIThirJ/n2+akRt41wLT743nbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q0TzhtnO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q0TzhtnO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F1DCC4CEC3;
	Mon, 14 Oct 2024 14:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917850;
	bh=lHC+z9EmHwjimZkwxN4x7Y0khJXtQQVCM/T48WfBVOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q0TzhtnOYuZBclnpjFpVBfZ5pB68xnQKEUSZiUhJyHiR68gXJ+SFMWFTtZAtBb1At
	 xLW0lENGAiwCmVFReAqtnBTUY9WjqISAbrE08MBRAa1c8AlLPUkaKSEC7f1BFy19rq
	 Vu3pv/6UYGSJxxlPpKmZ9xzqvYab0KFg5a/rkQSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 152/798] selftests/bpf: Fix compiling flow_dissector.c with musl-libc
Date: Mon, 14 Oct 2024 16:11:46 +0200
Message-ID: <20241014141223.887742620@linuxfoundation.org>
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
index 7acca37a3d2b5..657b5dbdafaf6 100644
--- a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
+++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
 #include <test_progs.h>
 #include <network_helpers.h>
 #include <error.h>
-- 
2.43.0



