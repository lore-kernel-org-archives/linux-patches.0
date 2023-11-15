Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F7E3BB42
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i8NRY7dk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B0AC433C8;
	Wed, 15 Nov 2023 19:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077473;
	bh=c34dXg2xMoEloNJ9iCXkCcpeAIKRgJ+HQv2qzG/FP/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i8NRY7dkfBXnXNmDatZBA6qoujqfh7y+9SL14zCx6IbhSgl29prG9lcQyxE8izHZK
	 38grLfNCATlbCePA7ACsrh/nbm8qXXm9NUdEubqPCa8vJQNbQwErG9X+O7NBgUYfba
	 D1u4YjnpCn5yOfo7s/TqZniT9EXXg+l0GhEhXUmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Rae Moar <rmoar@google.com>,
	David Gow <davidgow@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 299/603] kunit: Fix missed memory release in kunit_free_suite_set()
Date: Wed, 15 Nov 2023 14:14:04 -0500
Message-ID: <20231115191634.080921441@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit a6074cf0126b0bee51ab77a15930dc24a4d5db90 ]

modprobe cpumask_kunit and rmmod cpumask_kunit, kmemleak detect
a suspected memory leak as below.

If kunit_filter_suites() in kunit_module_init() succeeds, the
suite_set.start will not be NULL and the kunit_free_suite_set() in
kunit_module_exit() should free all the memory which has not
been freed. However the test_cases in suites is left out.

unreferenced object 0xffff54ac47e83200 (size 512):
  comm "modprobe", pid 592, jiffies 4294913238 (age 1367.612s)
  hex dump (first 32 bytes):
    84 13 1a f0 d3 b6 ff ff 30 68 1a f0 d3 b6 ff ff  ........0h......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000008dec63a2>] slab_post_alloc_hook+0xb8/0x368
    [<00000000ec280d8e>] __kmem_cache_alloc_node+0x174/0x290
    [<00000000896c7740>] __kmalloc+0x60/0x2c0
    [<000000007a50fa06>] kunit_filter_suites+0x254/0x5b8
    [<0000000078cc98e2>] kunit_module_notify+0xf4/0x240
    [<0000000033cea952>] notifier_call_chain+0x98/0x17c
    [<00000000973d05cc>] notifier_call_chain_robust+0x4c/0xa4
    [<000000005f95895f>] blocking_notifier_call_chain_robust+0x4c/0x74
    [<0000000048e36fa7>] load_module+0x1a2c/0x1c40
    [<0000000004eb8a91>] init_module_from_file+0x94/0xcc
    [<0000000037dbba28>] idempotent_init_module+0x184/0x278
    [<00000000161b75cb>] __arm64_sys_finit_module+0x68/0xa8
    [<000000006dc1669b>] invoke_syscall+0x44/0x100
    [<00000000fa87e304>] el0_svc_common.constprop.1+0x68/0xe0
    [<000000009d8ad866>] do_el0_svc+0x1c/0x28
    [<000000005b83c607>] el0_svc+0x3c/0xc4

Fixes: a127b154a8f2 ("kunit: tool: allow filtering test cases via glob")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Rae Moar <rmoar@google.com>
Reviewed-by: David Gow <davidgow@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kunit/executor.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/kunit/executor.c b/lib/kunit/executor.c
index a6348489d45fe..a037a46fae5ea 100644
--- a/lib/kunit/executor.c
+++ b/lib/kunit/executor.c
@@ -137,8 +137,10 @@ void kunit_free_suite_set(struct kunit_suite_set suite_set)
 {
 	struct kunit_suite * const *suites;
 
-	for (suites = suite_set.start; suites < suite_set.end; suites++)
+	for (suites = suite_set.start; suites < suite_set.end; suites++) {
+		kfree((*suites)->test_cases);
 		kfree(*suites);
+	}
 	kfree(suite_set.start);
 }
 
-- 
2.42.0



