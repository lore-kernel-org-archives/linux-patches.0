Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973E71D2F46;
	Wed,  2 Oct 2024 14:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879775; cv=none; b=Ub2EstHdSSL/lJab8pSN+7fdipdw8Pgh4qnkY40B6jlx9yGYrMJNxmuZEi1xL2qmUweCqcoL6AKyxqZoi04em4mxrh4rNJEuodRk4GM3q8t2jP4MgxZMZPlzia10cdbtlsjL4AgHFl/axjcNIib90coC9XvcGfa9Feh1B9GCd14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879775; c=relaxed/simple;
	bh=h/uJX0WXnzVhidEQBArBUbu01slYCev4f13nAoJKP7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iViDwrMfOSzCDPTOc0nOO/wV3KiFgntM3K5P7aG/dVWsDz3Ck0yk5OQsUcGFrYOKeafyyqkuAWEPI7FwYS72OmWESfZYQMqlEaJElpfU0Qw2lSvVM9CUimHo+/DnlKSe2Q5sOpOH2lHvY/sqeLjbNGcFc0PC18yZkQNLfqzAa/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l5g5lDFs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l5g5lDFs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23711C4CEC2;
	Wed,  2 Oct 2024 14:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879775;
	bh=h/uJX0WXnzVhidEQBArBUbu01slYCev4f13nAoJKP7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l5g5lDFsnNPf8AEXuj9i97ZN71FAPYPhwJgdvgb7qYqS8ycuXwoBsXNxppn78KQWx
	 /uOjrEBInhpgv/OAHXUnDFuglY84uQkDy48Zkkp1sMZ0wO5Az54481p7c/jMZ/9Voy
	 erR2jgjjqccD64Iup60mKFqmdYwPlSciGpqPHPEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 203/538] selftests/bpf: Fix compiling tcp_rtt.c with musl-libc
Date: Wed,  2 Oct 2024 14:57:22 +0200
Message-ID: <20241002125800.266583544@linuxfoundation.org>
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



