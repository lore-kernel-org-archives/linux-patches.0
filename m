Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD221CFEA9;
	Wed,  2 Oct 2024 14:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877951; cv=none; b=Omb52Ws6jKyB81XdkWDG9INeSSIu+rytQm58WQfkrdKeLumlr5+zjsm2XB62Kd7s+JoQ45KDgEiIfdSz7LNfuHe2RQ1ZfjEI+dpUAKo+iOgEveaPUhyD8P171gBLa4OnuTaYJ6KZJa6/3xfpDZXaz7xnNIsjr18p3+k6pK9bAnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877951; c=relaxed/simple;
	bh=YXwPDGLxx5/S9QV2cLHXVuny536eiScaN4SLLBK1iuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AN9r8K2f1gAc8QnWo7iDdHSCU0f6VlaOHygNThgDxvXd7P6XdkrbbH7+y9oEX4WJrt2t3bk7yVXoQpmf+LVohoCVjvpJvJqmowrvmLXWYkKY338IxbyLa5D1Pc1dIcJ7arbHCuBCjyxnPD3wkPdj3UAOke5jOv1MZhVSDVKft+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jhPqmOzu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jhPqmOzu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F7BC4CEC2;
	Wed,  2 Oct 2024 14:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877950;
	bh=YXwPDGLxx5/S9QV2cLHXVuny536eiScaN4SLLBK1iuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jhPqmOzuSVILWEhgsGy9lz7+/ApMwJSIhObJcTntvgAGUEKSQ0hexZkmK4W4MJQc5
	 C3hU3t3xntXO2mELcCAmAzAOcTBTP7Fs2YHe6rg8L3oFF55GO1NhMjFE6TMZmfuMVJ
	 PnP8hEHI1AlC3PnyqjKjrrf2kPX1RyH2w5Fd1a/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 251/634] selftests/bpf: Fix errors compiling decap_sanity.c with musl libc
Date: Wed,  2 Oct 2024 14:55:51 +0200
Message-ID: <20241002125821.005395929@linuxfoundation.org>
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

[ Upstream commit 1b00f355130a5dfc38a01ad02458ae2cb2ebe609 ]

Remove a redundant include of '<linux/in6.h>', whose needed definitions are
already provided by 'test_progs.h'. This avoids errors seen compiling for
mips64el/musl-libc:

  In file included from .../arpa/inet.h:9,
                   from ./test_progs.h:17,
                   from prog_tests/decap_sanity.c:9:
  .../netinet/in.h:23:8: error: redefinition of 'struct in6_addr'
     23 | struct in6_addr {
        |        ^~~~~~~~
  In file included from decap_sanity.c:7:
  .../linux/in6.h:33:8: note: originally defined here
     33 | struct in6_addr {
        |        ^~~~~~~~
  .../netinet/in.h:34:8: error: redefinition of 'struct sockaddr_in6'
     34 | struct sockaddr_in6 {
        |        ^~~~~~~~~~~~
  .../linux/in6.h:50:8: note: originally defined here
     50 | struct sockaddr_in6 {
        |        ^~~~~~~~~~~~
  .../netinet/in.h:42:8: error: redefinition of 'struct ipv6_mreq'
     42 | struct ipv6_mreq {
        |        ^~~~~~~~~
  .../linux/in6.h:60:8: note: originally defined here
     60 | struct ipv6_mreq {
        |        ^~~~~~~~~

Fixes: 70a00e2f1dba ("selftests/bpf: Test bpf_skb_adjust_room on CHECKSUM_PARTIAL")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/e986ba2d7edccd254b54f7cd049b98f10bafa8c3.1721713597.git.tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/decap_sanity.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/decap_sanity.c b/tools/testing/selftests/bpf/prog_tests/decap_sanity.c
index dcb9e5070cc3d..d79f398ec6b7c 100644
--- a/tools/testing/selftests/bpf/prog_tests/decap_sanity.c
+++ b/tools/testing/selftests/bpf/prog_tests/decap_sanity.c
@@ -4,7 +4,6 @@
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <net/if.h>
-#include <linux/in6.h>
 
 #include "test_progs.h"
 #include "network_helpers.h"
-- 
2.43.0



