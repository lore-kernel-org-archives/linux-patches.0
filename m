Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A281D0B86;
	Wed,  2 Oct 2024 14:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877948; cv=none; b=PIDZ6ZZetrepaFnMI4rBvyur+0cKG9ul/0YrIkfqJ0lt+zWgF8eMoqHed++/M0npaHWO2oE7vXQ8zQMfVCsB7P6ipjXlUZesNoatGaBwTwonilPTiPKv4ghHTmMA86IvyBx4BekjvwP2hZ/UUui6DPDApaojol6+1f/qiH6wOhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877948; c=relaxed/simple;
	bh=eoMsS4+rcl6+y5wODGM7kuRrsgRpFegyRx5SWqu6qpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I5fi0T0fDef12zEqVtkoZ7z6DgC8VkDZpCZYmcZrxssQJvB26USNdMBbrPUTHYBPvAiWVpgLWR7yIN3nmy+xDG2oa8tMz0YgdgyvOpRWu4OvOVZ0+je0DrmBAz/AZHRosNIeeaM/6sA3W5gA+8lVYV80I/8t5E0mQF1STGHq61s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aQx2OhU8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aQx2OhU8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4CD2C4CEC2;
	Wed,  2 Oct 2024 14:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877948;
	bh=eoMsS4+rcl6+y5wODGM7kuRrsgRpFegyRx5SWqu6qpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aQx2OhU8+sTlE3RL2O/SrfXNY+3d5P1EP+5ED82mIeXMZ/OZIWhmL73VJcm4Hx0k2
	 87apz7ey4VfKt3YtpsL2jYcpO0ZKk9KdAMDcwlpBIvFgpPYTWMnj+qKe89hadzyRpR
	 4TNDml7HE0gyxvLKhI2EH9SSSqPiixBkFw7kOArY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 250/634] selftests/bpf: Fix errors compiling lwt_redirect.c with musl libc
Date: Wed,  2 Oct 2024 14:55:50 +0200
Message-ID: <20241002125820.966193650@linuxfoundation.org>
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

[ Upstream commit 27c4797ce51c8dd51e35e68e9024a892f62d78b2 ]

Remove a redundant include of '<linux/icmp.h>' which is already provided in
'lwt_helpers.h'. This avoids errors seen compiling for mips64el/musl-libc:

  In file included from .../arpa/inet.h:9,
                   from lwt_redirect.c:51:
  .../netinet/in.h:23:8: error: redefinition of 'struct in6_addr'
     23 | struct in6_addr {
        |        ^~~~~~~~
  In file included from .../linux/icmp.h:24,
                   from lwt_redirect.c:50:
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

Fixes: 43a7c3ef8a15 ("selftests/bpf: Add lwt_xmit tests for BPF_REDIRECT")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/3869dda876d5206d2f8d4dd67331c739ceb0c7f8.1721713597.git.tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/lwt_redirect.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/lwt_redirect.c b/tools/testing/selftests/bpf/prog_tests/lwt_redirect.c
index 835a1d756c166..b6e8d822e8e95 100644
--- a/tools/testing/selftests/bpf/prog_tests/lwt_redirect.c
+++ b/tools/testing/selftests/bpf/prog_tests/lwt_redirect.c
@@ -47,7 +47,6 @@
 #include <linux/if_ether.h>
 #include <linux/if_packet.h>
 #include <linux/if_tun.h>
-#include <linux/icmp.h>
 #include <arpa/inet.h>
 #include <unistd.h>
 #include <errno.h>
-- 
2.43.0



