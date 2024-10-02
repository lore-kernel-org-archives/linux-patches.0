Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE70B1D27AD;
	Wed,  2 Oct 2024 14:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879772; cv=none; b=bE9+2wpzaTex97Nru03qb5wDBGmGvoRNj8EaeLtVIXBg1sl7Au9azo/9LICNUCdf8Ony1vLVp8MU8q4M3QelXhnDpqDY4Rz00XS+2BoyJsbU3HS/80dmRNy+kVSy0Q9XADZD6veTzUywkGiPDQq/CjZDBBTny6iwtQWewUNPWVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879772; c=relaxed/simple;
	bh=brpNF6536GR6Q2+n4uMvHSr9HvnA7YR6oT0P++BUg4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pnWQGwcNDW4gPCHXtYrPsLOF36aAGfzUbRQ7o4/2kpJyfbvAA3zYbnfr4VulQVXjNabVWCI5v+8wHKX/F22wHBqfZH2CKk/aHEInwNvlwK9KtBcbhBbe3Qp6kQ3RJbjfS/SRboZnNNowYXFMFAlQ5JZ5aTDuietOky+PRKC0NbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oZaIzx6j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oZaIzx6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35EADC4CED9;
	Wed,  2 Oct 2024 14:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879772;
	bh=brpNF6536GR6Q2+n4uMvHSr9HvnA7YR6oT0P++BUg4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oZaIzx6j3iCHtdYp7Ulun39S91I374oLXVswE3ufI41BrbW17viVvPTKPod2XpT0P
	 NuBc/PUBLc3ueAEuI7JZSWMVZU/S8uI+bypK8gAOBvmkh1OW27ygqZtjclxPRa9Kal
	 6Z/QGhkKh6DaP3rowWz+d+O+zVzgWtiDbG94OqVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 202/538] selftests/bpf: Fix compiling flow_dissector.c with musl-libc
Date: Wed,  2 Oct 2024 14:57:21 +0200
Message-ID: <20241002125800.227650513@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



