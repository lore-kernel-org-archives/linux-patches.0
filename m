Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592311D5AA5;
	Tue, 15 Oct 2024 11:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992709; cv=none; b=JYTLiziDiRdLiF/OX0W8521Mh5ChWw/2BIUp20KT2Rc6jwOG/qlNcZ+AhUSe3j/7oTl9ExBzYH4GeMfM9kwnG3o4HUwPVc1ewMwqjePonrgdyBv8r4DU5jpItYKIXKhko4RUwcizINDp2TJoUq0lYd51VQjqkfu5LEYUjCh4VTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992709; c=relaxed/simple;
	bh=4rfJVyjR5rQLx/K4G0c0o88fgsUUKTZJY+zlabY6IjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VnlDlnY+ay0xP8D3iJDQsxuG89a03s5O7Z05bnr9aXoS8MbL+dEnD5GEeR6Uzj0SPJbj7RC8r6Hq+E+60clAOUIJUQg7qXuw9sDgmlfWypJDEO5X+N9CdReUN7LYhy3/An2mdIw9I+gc/QA5hwHGegfW5Xc0gY6iF55MAvv5XT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bijzlkbd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bijzlkbd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA96C4CEC6;
	Tue, 15 Oct 2024 11:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992709;
	bh=4rfJVyjR5rQLx/K4G0c0o88fgsUUKTZJY+zlabY6IjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bijzlkbd9JIVKhF4u4QUez3QrjX/e437z8THESLSjDoZ0bT8lC3ifTjFOb8xGw33x
	 0ijesh89Z83GqRvUkqx2+8nAx1S/v8GbZaFjJCL0M5Z03SYHjv9L29cWc/cmzuKY/5
	 JJBgVoPr9II4WYBk9nOr1f64IqctzZoAX08JFYqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 196/691] selftests/bpf: Fix compiling tcp_rtt.c with musl-libc
Date: Tue, 15 Oct 2024 13:22:24 +0200
Message-ID: <20241015112448.136622371@linuxfoundation.org>
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
index d207e968e6b1b..dee68ef976ae9 100644
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



