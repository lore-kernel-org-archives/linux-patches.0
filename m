Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9799629CE7;
	Wed,  2 Oct 2024 13:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875940; cv=none; b=iol6HO2041Z8jiiWm5ewnqdnzWmZnAbVilbz6w0c8NQITEtbyvE6Ok5AI1F80yJ7htNwCH6o7x6FVz1GjeepyyZcdR6qlxxhNAv+rGqkAYD69GxBOke+P8+3yYGt20mUJoEs/18iCQjdwEEu/YDMyDZlmAM3GgVBsXwrqgNMiaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875940; c=relaxed/simple;
	bh=/JtWb4jgtOHyapfiTbHw6r/UG1FbPx+RoyxyLJW8S6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IIgs22QNoN38LlqEbp59KljO4znYBuBNhZmfKs7hgozau09knSdiIXp6q3ewp0egcJolbaJH7qFxERZ+77EloI/QQwLHsZhG9EMern6RWcf5Hpi6WjH2oPKs+NIUjd2tL9bELnXt2nd29vfXlGCQ1eVu7pdzgD/W55OJXn+HAAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uLOhZJHH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uLOhZJHH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ABDFC4CECF;
	Wed,  2 Oct 2024 13:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875940;
	bh=/JtWb4jgtOHyapfiTbHw6r/UG1FbPx+RoyxyLJW8S6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uLOhZJHH9SXA/XDh9PmcNcMw99bcA5fyp8PC/sc1G5ypAg3hJo9Gr0iuBPwGjwzCT
	 Srvo/ZfuRQLC8yPgzcGapWD1xQsunlkIdxuvYIIOXqaSe0k/WsqXWaSathLn+xI4g1
	 E2KuH27JIj+g93sy1JlH7S753Ix3/mDgCV6XmBzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 273/695] selftests/bpf: Fix compiling kfree_skb.c with musl-libc
Date: Wed,  2 Oct 2024 14:54:31 +0200
Message-ID: <20241002125833.342541929@linuxfoundation.org>
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

[ Upstream commit bae9a5ce7d3a9b3a9e07b31ab9e9c58450e3e9fd ]

The GNU version of 'struct tcphdr' with member 'doff' is not exposed by
musl headers unless _GNU_SOURCE is defined. Add this definition to fix
errors seen compiling for mips64el/musl-libc:

  In file included from kfree_skb.c:2:
  kfree_skb.c: In function 'on_sample':
  kfree_skb.c:45:30: error: 'struct tcphdr' has no member named 'doff'
     45 |         if (CHECK(pkt_v6->tcp.doff != 5, "check_tcp",
        |                              ^

Fixes: 580d656d80cf ("selftests/bpf: Add kfree_skb raw_tp test")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/e2d8cedc790959c10d6822a51f01a7a3616bea1b.1721713597.git.tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/kfree_skb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/kfree_skb.c b/tools/testing/selftests/bpf/prog_tests/kfree_skb.c
index c07991544a789..34f8822fd2219 100644
--- a/tools/testing/selftests/bpf/prog_tests/kfree_skb.c
+++ b/tools/testing/selftests/bpf/prog_tests/kfree_skb.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
 #include <test_progs.h>
 #include <network_helpers.h>
 #include "kfree_skb.skel.h"
-- 
2.43.0



