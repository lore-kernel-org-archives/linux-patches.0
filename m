Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78641E412E;
	Tue, 15 Oct 2024 11:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992705; cv=none; b=L4oaydA/9dgBi4g6exkuuMVkEppsE19GD05VQ74XZ/7/q0orVgNivq+NDRRnQsr5eR1bEtZ71o65/O+/gL5EJBnTY+4Ai6Lhsdjvcik5FFHf/PtiWwAxpc/j4XgoDhjJCNhfqWZqq5U9/PT5wHsj9DFxf2b6YJ2Y00ibcBsok5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992705; c=relaxed/simple;
	bh=0giygngFf5i5XYl0cB5tS850IuxrXxzz+XHZDySRJIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ybqy+FSk3y89NQWDYvSxmS67JltSPH110URpVFEwOO1h+ZdYQ3st21hrvkBKP0tHiJzhezGBEZZDjLBlYT7akwYpI/yDdzP3KooeAEzyEPfWe2qJFsR2j62flr8YwN9xFgOqj9vDFNREKvGI5VK7otkJXl3Sudc2t4SY9dDxI/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G2vc+xr4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G2vc+xr4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4282AC4CEC6;
	Tue, 15 Oct 2024 11:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992705;
	bh=0giygngFf5i5XYl0cB5tS850IuxrXxzz+XHZDySRJIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G2vc+xr4+7sskj4A3Ka4LlXdh6lIDd7Gx3ZyMI60mwKaXvsEq4vhnjoQ+amuKVh+X
	 NBuYF4B8gSpDZ36EawuP9066tb6dgq9JoE0/VrTE5WkpBhxF/455wqqFvTktH/5yDy
	 4l/qSdGi8Z11xEwzqX3f65A55nSvFSiJoQA2Wpfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 195/691] selftests/bpf: Fix compiling flow_dissector.c with musl-libc
Date: Tue, 15 Oct 2024 13:22:23 +0200
Message-ID: <20241015112448.097962112@linuxfoundation.org>
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
index 225714f71ac6e..334449262beff 100644
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



