Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CC779C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:48:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528B7C433C1;
	Wed, 30 Nov 2022 18:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834112;
	bh=i0x02n2/XvUm6x0pXNdeboL9K1Bjk5zIPYRHwpW+QUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CwW1QQlGVIVtrAA4re0zI5SljyMxzApzOolV4IzYXlZUYK8pMozNC0Gcfywt1YaOS
	 qrUZ38wZ5LbtURyF2lXOyLHnlSSjXecZg0Jujzl8ax/GFWmFrmwFCUCpuvxDs8Hk7X
	 HPr7tikDHyYawyolQzF6RsExL9j1osZhDia/ft8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Hua <hucool.lihua@huawei.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 133/289] test_kprobes: fix implicit declaration error of test_kprobes
Date: Wed, 30 Nov 2022 19:21:58 +0100
Message-Id: <20221130180547.153409055@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

[ Upstream commit de3db3f883a82c4800f4af0ae2cc3b96a408ee9b ]

If KPROBES_SANITY_TEST and ARCH_CORRECT_STACKTRACE_ON_KRETPROBE is enabled, but
STACKTRACE is not set. Build failed as below:

lib/test_kprobes.c: In function `stacktrace_return_handler':
lib/test_kprobes.c:228:8: error: implicit declaration of function `stack_trace_save'; did you mean `stacktrace_driver'? [-Werror=implicit-function-declaration]
  ret = stack_trace_save(stack_buf, STACK_BUF_SIZE, 0);
        ^~~~~~~~~~~~~~~~
        stacktrace_driver
cc1: all warnings being treated as errors
scripts/Makefile.build:250: recipe for target 'lib/test_kprobes.o' failed
make[2]: *** [lib/test_kprobes.o] Error 1

To fix this error, Select STACKTRACE if ARCH_CORRECT_STACKTRACE_ON_KRETPROBE is enabled.

Link: https://lkml.kernel.org/r/20221121030620.63181-1-hucool.lihua@huawei.com
Fixes: 1f6d3a8f5e39 ("kprobes: Add a test case for stacktrace from kretprobe handler")
Signed-off-by: Li Hua <hucool.lihua@huawei.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Kconfig.debug | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index cb131fad117c..997d23641448 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2095,6 +2095,7 @@ config KPROBES_SANITY_TEST
 	depends on DEBUG_KERNEL
 	depends on KPROBES
 	depends on KUNIT
+	select STACKTRACE if ARCH_CORRECT_STACKTRACE_ON_KRETPROBE
 	default KUNIT_ALL_TESTS
 	help
 	  This option provides for testing basic kprobes functionality on
-- 
2.35.1



