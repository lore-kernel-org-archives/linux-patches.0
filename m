Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0182AD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:23:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18410C433EF;
	Wed,  4 Jan 2023 16:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849410;
	bh=micRtym3x5TtlFIQ+/X4E1LzJPUSH0P+PkAWPlxQOPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qYjfaPOQZPLyaqOTy1VQxlVZHz9oT/WQbcA2ba+l8dZ1Id580B46x+QCU+5rbWgxQ
	 D6a7oYP7MrDAQ9GdGVdSZYdyiinahHibzkJ1Wl/lMVwz7iTVWs6WirtOhPJfbPZRSq
	 JnYms+5sXwbfhsBcHrxZVlOgj9AcBcKTE38dSERY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Hua <hucool.lihua@huawei.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.0 116/177] test_kprobes: Fix implicit declaration error of test_kprobes
Date: Wed,  4 Jan 2023 17:06:47 +0100
Message-Id: <20230104160511.155173495@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Li Hua <hucool.lihua@huawei.com>

commit 63a4dc0a0bb0e9bfeb2c88ccda81abdde4cdd6b8 upstream.

If KPROBES_SANITY_TEST and ARCH_CORRECT_STACKTRACE_ON_KRETPROBE is enabled, but
STACKTRACE is not set. Build failed as below:

lib/test_kprobes.c: In function ‘stacktrace_return_handler’:
lib/test_kprobes.c:228:8: error: implicit declaration of function ‘stack_trace_save’; did you mean ‘stacktrace_driver’? [-Werror=implicit-function-declaration]
  ret = stack_trace_save(stack_buf, STACK_BUF_SIZE, 0);
        ^~~~~~~~~~~~~~~~
        stacktrace_driver
cc1: all warnings being treated as errors
scripts/Makefile.build:250: recipe for target 'lib/test_kprobes.o' failed
make[2]: *** [lib/test_kprobes.o] Error 1

To fix this error, Select STACKTRACE if ARCH_CORRECT_STACKTRACE_ON_KRETPROBE is enabled.

Link: https://lore.kernel.org/all/20221121030620.63181-1-hucool.lihua@huawei.com/

Fixes: 1f6d3a8f5e39 ("kprobes: Add a test case for stacktrace from kretprobe handler")
Cc: stable@vger.kernel.org
Signed-off-by: Li Hua <hucool.lihua@huawei.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/Kconfig.debug |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2080,6 +2080,7 @@ config TEST_MIN_HEAP
 config TEST_SORT
 	tristate "Array-based sort test" if !KUNIT_ALL_TESTS
 	depends on KUNIT
+	select STACKTRACE if ARCH_CORRECT_STACKTRACE_ON_KRETPROBE
 	default KUNIT_ALL_TESTS
 	help
 	  This option enables the self-test function of 'sort()' at boot,


