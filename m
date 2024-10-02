Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E0A1D04B8;
	Wed,  2 Oct 2024 13:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875958; cv=none; b=HXa4OMtNybrg1JofLTvSi9v6lnKlipetDH3zyyoACaM2oPhek3Tu0VqK2HUUwzW+j3yU2glZIJHXd4qAXJZfespxU4H3TkESKFD1q+rN1100s1taWlZ26HB7pJAhAGbYQrN+olMJ+jNWDs8bEKJlImEku5BZbtfenvqYSGicBPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875958; c=relaxed/simple;
	bh=7m1Nxn+aJzGDk+wibEhTFCACFd2UVjSEkOi1kgFGOR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PbrXafndNW6U8rWXZra/b2bZYoc9H1ZxQbmfSSlgPrlPHMYa27HsjD9gGWkEwOfqgWNayrO+TDrqWXQuu9f8l1l6i7qar1JQMdrhuxD8UFrKOCw52Gh/UajHBv/GwxN6udSR6txvjhi+wNtS8aDBnchEsYzpdNIztTGgyeA/NI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hr0+Tvd7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hr0+Tvd7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E27AC4CECD;
	Wed,  2 Oct 2024 13:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875957;
	bh=7m1Nxn+aJzGDk+wibEhTFCACFd2UVjSEkOi1kgFGOR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hr0+Tvd7Vqxu8OSW4ZBiw6rYeXBPV//qpoymDKDyMH7yyzo7GH5SawjBONOJteM2e
	 yXHRoP3LZJGEPN65On9k+/SHaRD5aP/nyQhqLrpwItrQ5FrXHJg9bLC4BEiKCfKzHA
	 LFVMv4jEWgZ2r6XmjA9je7GY+07S+0TomkiCXfvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 279/695] selftests/bpf: Fix errors compiling crypto_sanity.c with musl libc
Date: Wed,  2 Oct 2024 14:54:37 +0200
Message-ID: <20241002125833.581685526@linuxfoundation.org>
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

[ Upstream commit 9822be702fe6e1c3e0933ef4b68a8c56683d930d ]

Remove a redundant include of '<linux/in6.h>', whose needed definitions are
already provided by 'test_progs.h'. This avoids errors seen compiling for
mips64el/musl-libc:

  In file included from .../arpa/inet.h:9,
                   from ./test_progs.h:17,
                   from prog_tests/crypto_sanity.c:10:
  .../netinet/in.h:23:8: error: redefinition of 'struct in6_addr'
     23 | struct in6_addr {
        |        ^~~~~~~~
  In file included from crypto_sanity.c:7:
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

Fixes: 91541ab192fc ("selftests: bpf: crypto skcipher algo selftests")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://lore.kernel.org/bpf/911293968f424ad7b462d8805aeb3baee8f4985b.1721713597.git.tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/crypto_sanity.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/crypto_sanity.c b/tools/testing/selftests/bpf/prog_tests/crypto_sanity.c
index b1a3a49a822a7..42bd07f7218dc 100644
--- a/tools/testing/selftests/bpf/prog_tests/crypto_sanity.c
+++ b/tools/testing/selftests/bpf/prog_tests/crypto_sanity.c
@@ -4,7 +4,6 @@
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <net/if.h>
-#include <linux/in6.h>
 #include <linux/if_alg.h>
 
 #include "test_progs.h"
-- 
2.43.0



