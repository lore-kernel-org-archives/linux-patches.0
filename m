Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D5529CE7;
	Wed,  2 Oct 2024 13:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875955; cv=none; b=RBCAieUyukI5FCgIRTIOaDpyCvWrRfSkYWTls+V80CRU/PODD9zvxuNrmwuFYV/mYcMoFG+vFlNva3lVNxWGfyfuJXskSOZB4+FRQaCmShrJGI+tZDgVh/kMvEDTQvMepwUDQ80XUD+dQYhIgegHKeOiugKNjYIm7E+ZfNN2oNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875955; c=relaxed/simple;
	bh=41fko6mg6N9uoi9QINF9zSqyMaGoENONnORrKOqgNdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TsIJj8C1ksGjFYDEZh13H2oXmroJm/ySH3oRDrBMHTMVXKdlWqUiRpZqaaThKpykqviRKfYGZVuXHWIfP5wZ8RmiDQXmmJ/vK9oKnshNZKVdeg6fn922yfAfgUbWeit6oMdZwd/ztlpvh8V7iMa0W1eo4cbkS2Q9dCGoYk8JDl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m5Ohr09O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m5Ohr09O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824F4C4CEC5;
	Wed,  2 Oct 2024 13:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875954;
	bh=41fko6mg6N9uoi9QINF9zSqyMaGoENONnORrKOqgNdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m5Ohr09OGTsnfI5opp9NdBlCIPuB4r7aEvXhJ4LWrHazg5F6W3CIecH56DISwqn/t
	 1gho88J9j7JGh8CMGQ3c0f0Yl1iwUs6wfo00SFavpkQroQiJf3Zwcy9CZeQAGcm8Sr
	 NAue3U5RYDyacs1QamCHM4qkRHRNdKNRtbxHFgnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 278/695] selftests/bpf: Fix errors compiling decap_sanity.c with musl libc
Date: Wed,  2 Oct 2024 14:54:36 +0200
Message-ID: <20241002125833.542547757@linuxfoundation.org>
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



