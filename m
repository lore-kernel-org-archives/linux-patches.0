Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD531D078D;
	Wed,  2 Oct 2024 13:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875978; cv=none; b=IEcpQfDnZoqt9L/FNj5jGlEdJHk7CqFp9oYv41MW7keyXitIHaGEJRlSZtftgoLOkE1/WCdRXmFX+xQOjnmFCPWb0YrIDHY8XIC/Zg04Ny4bZKrVxCUqdnLT2ADUTTajjAUuDCuFjiCnAKeJl9icny1aaa3mHmG/Hz2Wu50m0w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875978; c=relaxed/simple;
	bh=tQmcOJ8jtt36lmlaZm7Ao1d4E4KWsMSddl7Tyxcc8aQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HYmjXlJtyMUZqd9PtU8LkQGBiHV2kUZB6svreJi+U9iGJ2nIR5mNxm/8O4VU5H3BobHSZG2s0QMEOxdtKUHx/MPAbWoTslIm6LjlSN3AgBFZ7JIfoWMWyqfHTXIatewxmH8n5e4zWN8mHu3lVZlLv2wt6m5UIQH45SWz16szFYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xg1wCBvM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xg1wCBvM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E330C4CEC5;
	Wed,  2 Oct 2024 13:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875978;
	bh=tQmcOJ8jtt36lmlaZm7Ao1d4E4KWsMSddl7Tyxcc8aQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xg1wCBvMatKrb/8klinvrhSAmBXvkfkDIPAWPd0EI3o5hfsaolzr2KaHZeSR70mFr
	 /6F2oDHx1CKcvW4pIqdBqpViOo0JRRaQdb786ZZ0yysrF6PEEaNVYXIIzz/PXXEy4d
	 vN88BHPOMTb2OBoiVUA3p/ztu4NabIwZ9BiMEGs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 285/695] selftests/bpf: Fix redefinition errors compiling lwt_reroute.c
Date: Wed,  2 Oct 2024 14:54:43 +0200
Message-ID: <20241002125833.820429766@linuxfoundation.org>
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

[ Upstream commit 16b795cc59528cf280abc79af3c70bda42f715b9 ]

Compiling lwt_reroute.c with GCC 12.3 for mips64el/musl-libc yields errors:

In file included from .../include/arpa/inet.h:9,
                 from ./test_progs.h:18,
                 from tools/testing/selftests/bpf/prog_tests/lwt_helpers.h:11,
                 from tools/testing/selftests/bpf/prog_tests/lwt_reroute.c:52:
.../include/netinet/in.h:23:8: error: redefinition of 'struct in6_addr'
   23 | struct in6_addr {
      |        ^~~~~~~~
In file included from .../include/linux/icmp.h:24,
                 from tools/testing/selftests/bpf/prog_tests/lwt_helpers.h:9:
.../include/linux/in6.h:33:8: note: originally defined here
   33 | struct in6_addr {
      |        ^~~~~~~~
.../include/netinet/in.h:34:8: error: redefinition of 'struct sockaddr_in6'
   34 | struct sockaddr_in6 {
      |        ^~~~~~~~~~~~
.../include/linux/in6.h:50:8: note: originally defined here
   50 | struct sockaddr_in6 {
      |        ^~~~~~~~~~~~
.../include/netinet/in.h:42:8: error: redefinition of 'struct ipv6_mreq'
   42 | struct ipv6_mreq {
      |        ^~~~~~~~~
.../include/linux/in6.h:60:8: note: originally defined here
   60 | struct ipv6_mreq {
      |        ^~~~~~~~~

These errors occur because <linux/in6.h> is included before <netinet/in.h>,
bypassing the Linux uapi/libc compat mechanism's partial musl support. As
described in [1] and [2], fix these errors by including <netinet/in.h> in
lwt_reroute.c before any uapi headers.

[1]: commit c0bace798436 ("uapi libc compat: add fallback for unsupported libcs")
[2]: https://git.musl-libc.org/cgit/musl/commit/?id=04983f227238

Fixes: 6c77997bc639 ("selftests/bpf: Add lwt_xmit tests for BPF_REROUTE")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/bd2908aec0755ba8b75f5dc41848b00585f5c73e.1722244708.git.tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/lwt_reroute.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/lwt_reroute.c b/tools/testing/selftests/bpf/prog_tests/lwt_reroute.c
index 03825d2b45a8b..6c50c0f63f436 100644
--- a/tools/testing/selftests/bpf/prog_tests/lwt_reroute.c
+++ b/tools/testing/selftests/bpf/prog_tests/lwt_reroute.c
@@ -49,6 +49,7 @@
  *  is not crashed, it is considered successful.
  */
 #define NETNS "ns_lwt_reroute"
+#include <netinet/in.h>
 #include "lwt_helpers.h"
 #include "network_helpers.h"
 #include <linux/net_tstamp.h>
-- 
2.43.0



