Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10D110E9;
	Wed,  2 Oct 2024 14:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879766; cv=none; b=QPzCO6f7E8dWLbf89NYgTK49Z5RqA83hsUpUZ1mRWuBBSFDfkDjnU3bJ2GEMcNSXw1e2w+Gi3QoWYSJxfKUcy+zCRyrjywGuiLToEBL/xcviuWycCfrM2LvlmZr8f2D67o+dotQPKCs/gwT/HR1bN5DD8bBFe8O3oMRTq9lM0Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879766; c=relaxed/simple;
	bh=1LYcyDbDU7FC+mLmrYd3JWQqZXw3QUnaZcC9jL324r4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FyUZE2jJ6Epd0y+akWHJzq5l8jI2LmlUteTIwe22lLGxofCarEfBBWheP6+CVN7WolZwfqZihd9GQsRlvnQ6BgkI9x4R5RMZSDDvQcmIlGjtaaEctnXILjOKnr1dldRiXoOBZYuSrMuSWjRsyD/SYTg6vprTBmKz8BVOJvdLebk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mv7AyDtQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mv7AyDtQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57FAFC4CEC5;
	Wed,  2 Oct 2024 14:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879766;
	bh=1LYcyDbDU7FC+mLmrYd3JWQqZXw3QUnaZcC9jL324r4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mv7AyDtQ4wksN+4e5XXzjrrXE+LIheKRT16PVSJoxuuKEgRDkrJlF1zyuc8vIfPpy
	 mlcnsCIvo0GghPu7Lf5d+sAtjKxuFfiyhirazJyQGOiFiX3TKKC8cMSuQ2U41O1VNx
	 Qbtdh+27RAwGEbSktZX+hrzOo30yS0dX/7YrQdyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 200/538] selftests/bpf: Fix compiling parse_tcp_hdr_opt.c with musl-libc
Date: Wed,  2 Oct 2024 14:57:19 +0200
Message-ID: <20241002125800.149314185@linuxfoundation.org>
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



