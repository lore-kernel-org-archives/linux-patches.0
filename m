Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298693229
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:24:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E5CC4339B;
	Mon, 30 Jan 2023 14:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088653;
	bh=P4qBDWLH1+Tmczh0ksP3dyuPskEZJD13t3mC/AeXmt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=COGNtrxt4pAT61a54z/95SBXyeBwneOXmb2MiQymex1K0VGsBbtCkUKJHajDJE5wt
	 NQ3E9IweglMByK4F88umwZ67eXxFai40djXbhud3sZgxG8qvgNj84Scer7VjiBIL0U
	 BYgE5M4jMKW0Vx2ApE7GBDHz1U1smHZc50xBJ9T4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Marco Elver <elver@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Xuefeng Li <lixuefeng@loongson.cn>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Eric Biggers <ebiggers@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 083/143] kasan: no need to unset panic_on_warn in end_report()
Date: Mon, 30 Jan 2023 14:52:20 +0100
Message-Id: <20230130134310.321277262@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit e7ce7500375a63348e1d3a703c8d5003cbe3fea6 upstream.

panic_on_warn is unset inside panic(), so no need to unset it before
calling panic() in end_report().

Link: https://lkml.kernel.org/r/1644324666-15947-6-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Xuefeng Li <lixuefeng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/kasan/report.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/mm/kasan/report.c b/mm/kasan/report.c
index 00a53f1355ae..91714acea0d6 100644
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -95,16 +95,8 @@ static void end_report(unsigned long *flags)
 	pr_err("==================================================================\n");
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 	spin_unlock_irqrestore(&report_lock, *flags);
-	if (panic_on_warn && !test_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags)) {
-		/*
-		 * This thread may hit another WARN() in the panic path.
-		 * Resetting this prevents additional WARN() from panicking the
-		 * system on this thread.  Other threads are blocked by the
-		 * panic_mutex in panic().
-		 */
-		panic_on_warn = 0;
+	if (panic_on_warn && !test_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags))
 		panic("panic_on_warn set ...\n");
-	}
 	kasan_enable_current();
 }
 
-- 
2.39.0



