Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13CE529CE7;
	Wed,  2 Oct 2024 13:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875935; cv=none; b=rSPmpqTdKO4x/iqRBPw3USvm/evZjync94wiIKxfjsnP4oVamFXjLO48WdrNjaUs6PuGHelVkrFOPh74kaQfzqGjMCI5JTUicbg4KqQ7uO8nLb6e6cpL1b3dPE9Mql6ZfXzcgTrubq/9kYHF69r8qNhBEYf5lIX9cT0RHkXHAGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875935; c=relaxed/simple;
	bh=qTmMZ1szAQ6nrn//a8QorbnFMeNpRJOiAqOxuh4Xq2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXn7jq8Sb3G3zFqtY9rlqPcmsLdKwh21IebLF3345Gr28Kej5v5/slcdZxD9XVOXDtG270eJ9BYNQjdNr2DZVjWo2ShBc+wycSIq2VCoqOXV+P/0fzwMBBAgjxLaMvo8kUWC0EJze94Hruz81SoBbQgNqiM/RmCKBZg14AdlVPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OeXfIe8J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OeXfIe8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E204C4CEC5;
	Wed,  2 Oct 2024 13:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875934;
	bh=qTmMZ1szAQ6nrn//a8QorbnFMeNpRJOiAqOxuh4Xq2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OeXfIe8JA4S05d4mBjAf1x/mA9CxQ3vHjYuXdUnDgjnooh8+g5gshgeRonQHqdsVE
	 2zS/mX1TXhRFk+y3/5iG/65D/ruK57BSwGBBOgizer4TcAmWkM2vt1AiJskrLWmRqM
	 1BEPoHxrfNALaE31AkBDWgVEY+rEByckhaS6jCRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 272/695] selftests/bpf: Fix compiling parse_tcp_hdr_opt.c with musl-libc
Date: Wed,  2 Oct 2024 14:54:30 +0200
Message-ID: <20241002125833.303814447@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Ambardar <tony.ambardar@gmail.com>

[ Upstream commit 4c329b99ef9c118343379bde9f97e8ce5cac9fc9 ]

The GNU version of 'struct tcphdr', with members 'doff' and 'urg_ptr', is
not exposed by musl headers unless _GNU_SOURCE is defined.

Add this definition to fix errors seen compiling for mips64el/musl-libc:

  parse_tcp_hdr_opt.c:18:21: error: 'struct tcphdr' has no member named 'urg_ptr'
     18 |         .pk6_v6.tcp.urg_ptr = 123,
        |                     ^~~~~~~
  parse_tcp_hdr_opt.c:19:21: error: 'struct tcphdr' has no member named 'doff'
     19 |         .pk6_v6.tcp.doff = 9, /* 16 bytes of options */
        |                     ^~~~

Fixes: cfa7b011894d ("selftests/bpf: tests for using dynptrs to parse skb and xdp buffers")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/ac5440213c242c62cb4e0d9e0a9cd5058b6a31f6.1721713597.git.tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/parse_tcp_hdr_opt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/parse_tcp_hdr_opt.c b/tools/testing/selftests/bpf/prog_tests/parse_tcp_hdr_opt.c
index daa952711d8fd..e9c07d561ded6 100644
--- a/tools/testing/selftests/bpf/prog_tests/parse_tcp_hdr_opt.c
+++ b/tools/testing/selftests/bpf/prog_tests/parse_tcp_hdr_opt.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 
+#define _GNU_SOURCE
 #include <test_progs.h>
 #include <network_helpers.h>
 #include "test_parse_tcp_hdr_opt.skel.h"
-- 
2.43.0



