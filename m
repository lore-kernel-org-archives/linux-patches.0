Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCE56FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCDECC433CC;
	Sun, 17 Sep 2023 20:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981695;
	bh=pRxcH3St86ls7slgJwZMWG9wO1n5InhqvB1I81vAeUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uM3CbAkKGzuSZzYfzwTPLN7udqEMW2MRogYIifceXid3xaNlLpHsYgeyUTtLoJyUC
	 9dEL3GR/TgWOtpNTeUCg0QYU4HHiSXBoNYGQhLCuOBC/Cke1TysngAhATuAgkdzWGA
	 kMJPc0fQSlQfZKRB4Ye/li5svx8hRH+mqYQ/sZ1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colm Harrington <colm.harrington@oracle.com>,
	Alan Maguire <alan.maguire@oracle.com>,
	Yipeng Zou <zouyipeng@huawei.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 094/511] selftests/bpf: fix static assert compilation issue for test_cls_*.c
Date: Sun, 17 Sep 2023 21:08:41 +0200
Message-ID: <20230917191116.137864047@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

From: Alan Maguire <alan.maguire@oracle.com>

[ Upstream commit 416c6d01244ecbf0abfdb898fd091b50ef951b48 ]

commit bdeeed3498c7 ("libbpf: fix offsetof() and container_of() to work with CO-RE")

...was backported to stable trees such as 5.15. The problem is that with older
LLVM/clang (14/15) - which is often used for older kernels - we see compilation
failures in BPF selftests now:

In file included from progs/test_cls_redirect_subprogs.c:2:
progs/test_cls_redirect.c:90:2: error: static assertion expression is not an integral constant expression
        sizeof(flow_ports_t) !=
        ^~~~~~~~~~~~~~~~~~~~~~~
progs/test_cls_redirect.c:91:3: note: cast that performs the conversions of a reinterpret_cast is not allowed in a constant expression
                offsetofend(struct bpf_sock_tuple, ipv4.dport) -
                ^
progs/test_cls_redirect.c:32:3: note: expanded from macro 'offsetofend'
        (offsetof(TYPE, MEMBER) + sizeof((((TYPE *)0)->MEMBER)))
         ^
tools/testing/selftests/bpf/tools/include/bpf/bpf_helpers.h:86:33: note: expanded from macro 'offsetof'
                                 ^
In file included from progs/test_cls_redirect_subprogs.c:2:
progs/test_cls_redirect.c:95:2: error: static assertion expression is not an integral constant expression
        sizeof(flow_ports_t) !=
        ^~~~~~~~~~~~~~~~~~~~~~~
progs/test_cls_redirect.c:96:3: note: cast that performs the conversions of a reinterpret_cast is not allowed in a constant expression
                offsetofend(struct bpf_sock_tuple, ipv6.dport) -
                ^
progs/test_cls_redirect.c:32:3: note: expanded from macro 'offsetofend'
        (offsetof(TYPE, MEMBER) + sizeof((((TYPE *)0)->MEMBER)))
         ^
tools/testing/selftests/bpf/tools/include/bpf/bpf_helpers.h:86:33: note: expanded from macro 'offsetof'
                                 ^
2 errors generated.
make: *** [Makefile:594: tools/testing/selftests/bpf/test_cls_redirect_subprogs.bpf.o] Error 1

The problem is the new offsetof() does not play nice with static asserts.
Given that the context is a static assert (and CO-RE relocation is not
needed at compile time), offsetof() usage can be replaced by restoring
the original offsetof() definition as __builtin_offsetof().

Fixes: bdeeed3498c7 ("libbpf: fix offsetof() and container_of() to work with CO-RE")
Reported-by: Colm Harrington <colm.harrington@oracle.com>
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
Tested-by: Yipeng Zou <zouyipeng@huawei.com>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20230802073906.3197480-1-alan.maguire@oracle.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/test_cls_redirect.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/test_cls_redirect.h b/tools/testing/selftests/bpf/progs/test_cls_redirect.h
index 76eab0aacba0c..233b089d1fbac 100644
--- a/tools/testing/selftests/bpf/progs/test_cls_redirect.h
+++ b/tools/testing/selftests/bpf/progs/test_cls_redirect.h
@@ -12,6 +12,15 @@
 #include <linux/ipv6.h>
 #include <linux/udp.h>
 
+/* offsetof() is used in static asserts, and the libbpf-redefined CO-RE
+ * friendly version breaks compilation for older clang versions <= 15
+ * when invoked in a static assert.  Restore original here.
+ */
+#ifdef offsetof
+#undef offsetof
+#define offsetof(type, member) __builtin_offsetof(type, member)
+#endif
+
 struct gre_base_hdr {
 	uint16_t flags;
 	uint16_t protocol;
-- 
2.40.1



