Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752561D094A;
	Wed,  2 Oct 2024 14:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877939; cv=none; b=UuLhl4k72ErbA08/SlU5qcK4U3TRAcHH3zn4VL7e0dEFtjrBun4qodi5wTp69CyDWBc0QKKU6ao5gF5jrpWkJzeS4VqzPQpH5eQZPLaf4Vqz1bRSd84Gj5pjSW2sq67wzrq60yAUszy42KRiBtuhyyyjZg5LzxuEJ7RBC2002PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877939; c=relaxed/simple;
	bh=8qixo2+qUwneiD+04CEWDsYFCg19hxw6O95JJTD0lgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M2iBGXS5ViSABTCmJdVwo6acgus7DspiivBdBhzMXq1LdVj/zdhLXyrCwuujuN0YObjWAmNRhh9eQ4XYMbUfb0vLowMi09Y4UIzCOX42Mr4dSGbRrKfIdBIGS0bXNJ1R01kSJA1g02LVa4x5BUVZhWFlC+xZKI9tjh3vkvTF4vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r0Ym14FI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r0Ym14FI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC67C4CEC2;
	Wed,  2 Oct 2024 14:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877939;
	bh=8qixo2+qUwneiD+04CEWDsYFCg19hxw6O95JJTD0lgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r0Ym14FIR4Fb0Ja4aQUrFW/WFrHBJ3bUK34X/k0HXN+oK/E0EGZ+woQZodUanGQaj
	 ZfKMZmX+5mkVLT6DlNK2s+4I5Wa7xyLaIjx3NIVC5/qI0h+ZG1FGZQU8EVddlul3uH
	 zWVKCOULu28hcBLKhe3OGzwr5b7ue4s39s88bnDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 247/634] selftests/bpf: Fix compiling flow_dissector.c with musl-libc
Date: Wed,  2 Oct 2024 14:55:47 +0200
Message-ID: <20241002125820.847951727@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9625e6d217913..3171047414a7d 100644
--- a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
+++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
 #include <test_progs.h>
 #include <network_helpers.h>
 #include <linux/if_tun.h>
-- 
2.43.0



