Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2560A1D0488;
	Wed,  2 Oct 2024 14:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879726; cv=none; b=Pg7Byj7rvbQB1QOj+OfN+jxyluP1NAXT8ZA/s2I4R1Z83km7tiaKqYQtW9x7l2htJkzLjtZ3ikyNxhudeBxbuoBfoXO1Pnv6uQtcD8D2klaSqP5twMhmKo8V9ZpaMBnUVpkkczxl/q1wlLzBbY38F6M8ypz3/QnBeUMyLowq7TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879726; c=relaxed/simple;
	bh=yfZcLkzCvEy7xp/G+R1dWjkjb7Kzk9mYqXDz908yXUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c0kWm865qbwUTCOY+5sj/XkBs0zv1dIKdyrkSRGK9iuquUxWcGS8o7dx9Sf7dOE5zgyIqwp1uailrjZjhyQYTEB/lOcYGjBNHXAK5NrERo1jyILvgpfqvxxRUsMtP6aH4qa7cSAgRdwz2u5e3br4HtVWMHCtizADpT3PNad02bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B/nonMkB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B/nonMkB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E702C4CEC2;
	Wed,  2 Oct 2024 14:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879726;
	bh=yfZcLkzCvEy7xp/G+R1dWjkjb7Kzk9mYqXDz908yXUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B/nonMkBHZinYTYxpevRDiEmbNRXB4ZMIhgPEXpmyIpKFsUuP+B2FFjpQCssWnMw1
	 jPYfJaA8hWLcUdpHWu+ZRCjmHLI/6ehIvWLpz2QHA5CQbFVkLI2vXlC1DfSm/hbvNC
	 2Nm6HeuZUaSgxSQy6gOYzl7un+lzx/TW9S3q1JWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 217/538] selftests/bpf: Fix redefinition errors compiling lwt_reroute.c
Date: Wed,  2 Oct 2024 14:57:36 +0200
Message-ID: <20241002125800.821619625@linuxfoundation.org>
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
index c104f07f1b0bc..920ee3042d093 100644
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



