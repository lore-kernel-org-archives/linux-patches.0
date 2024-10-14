Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F38B1AB517;
	Mon, 14 Oct 2024 14:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917854; cv=none; b=L0pBug272gk4jIH6v2NADsiDfqkSksMT3S6SZkYXsKHl+w57gZzY6qmOBULErKTa4im3qZnjtBZJujPy3+IhxybdQyqVX3oNYyaJrZUNv1r9vsCHPXhfLQXUomzP2UajzFwejcpqPOg1O5VSvnOxWnM1jG6bnvh75bnu5Zl7bQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917854; c=relaxed/simple;
	bh=G4wP7ac7IKxISlJaMv9BdKDbVBMy9kYmjWMXI1WW9CM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZL19+BaYMKOY+27y/FuICvVsYffWOcXRtKv+rN5NdnLxHARPyiWaHCzpVCUTKBptmYw8pU1J60IiwWUslU5ThZYcacYRh68zSZ73Rl6cdNc7XhiEuSSfmbPibZS59eX/Qayf91tWyqTTD6QXW2IxAYFNA5sxu6O5FA7OeJwGgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JEFVeSbQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JEFVeSbQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A97AC4CED2;
	Mon, 14 Oct 2024 14:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917854;
	bh=G4wP7ac7IKxISlJaMv9BdKDbVBMy9kYmjWMXI1WW9CM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JEFVeSbQ/eVWjXrgVwIl45ctMCdZS2QCcDxD9mVBJmlODsUqHl/4ewCTLqnr32U2O
	 UeQPFON1xv7IzwSoH7HED54JpquW5Jdlprjm9zSOKAZD1g+pT79/fb/AL0IqGPOkeX
	 Wj2Dx1FB7sEItl7Y93v79dtauUZMnPQveKbAJ2Xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 153/798] selftests/bpf: Fix compiling tcp_rtt.c with musl-libc
Date: Mon, 14 Oct 2024 16:11:47 +0200
Message-ID: <20241014141223.927240320@linuxfoundation.org>
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
index 8fe84da1b9b49..6a2da7a64419a 100644
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



