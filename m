Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6721FBC
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D6DC433D2;
	Fri,  3 Feb 2023 10:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675420210;
	bh=kqGRXnEMrWJ0HAljQwIowisBctvphsQPY24cGx5mihE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m4PiuRyWekzC9yhXQd4ZslI3wz+FRYgGFaewDB+taQ1poR/H1zSSf+MWvdNW1CH5y
	 CLGoVEf/dAg2KVcQmxi4Qcl7Bmu6UV27XVDByS1u5pyFARxBBCT/5Yql8fd5THXsOE
	 756npjp1EqQOM+czen4yBQYi8P0UBGe8k5LivrVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <davidgow@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrey Konovalov <andreyknvl@google.com>,
	Brendan Higgins <brendanhiggins@google.com>,
	Andrey Ryabinin <aryabinin@virtuozzo.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Patricia Alfonso <trishalfonso@google.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Shuah Khan <shuah@kernel.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Eric Biggers <ebiggers@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 116/134] mm: kasan: do not panic if both panic_on_warn and kasan_multishot set
Date: Fri,  3 Feb 2023 11:13:41 +0100
Message-Id: <20230203101029.044317449@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Gow <davidgow@google.com>

commit be4f1ae978ffe98cc95ec49ceb95386fb4474974 upstream.

KASAN errors will currently trigger a panic when panic_on_warn is set.
This renders kasan_multishot useless, as further KASAN errors won't be
reported if the kernel has already paniced.  By making kasan_multishot
disable this behaviour for KASAN errors, we can still have the benefits of
panic_on_warn for non-KASAN warnings, yet be able to use kasan_multishot.

This is particularly important when running KASAN tests, which need to
trigger multiple KASAN errors: previously these would panic the system if
panic_on_warn was set, now they can run (and will panic the system should
non-KASAN warnings show up).

Signed-off-by: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Patricia Alfonso <trishalfonso@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lkml.kernel.org/r/20200915035828.570483-6-davidgow@google.com
Link: https://lkml.kernel.org/r/20200910070331.3358048-6-davidgow@google.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/kasan/report.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/kasan/report.c b/mm/kasan/report.c
index 621782100eaa..a05ff1922d49 100644
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -92,7 +92,7 @@ static void end_report(unsigned long *flags)
 	pr_err("==================================================================\n");
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 	spin_unlock_irqrestore(&report_lock, *flags);
-	if (panic_on_warn)
+	if (panic_on_warn && !test_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags))
 		panic("panic_on_warn set ...\n");
 	kasan_enable_current();
 }
-- 
2.39.0



