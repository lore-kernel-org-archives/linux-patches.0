Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ADDF6AB9
	for <patches@lists.linux.dev>; Wed, 23 Mar 2022 23:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B64C36AE3;
	Wed, 23 Mar 2022 23:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648076818;
	bh=hxk7kBSl4cgSFefnme3Gtf3lrT03mqYn2+Ec8eARHKY=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=T4wnPit94vmyT15PfOHt60dbyJMW9Jkn5UOgRtamRRFQmbiQS3BOINPERn7H7EB0O
	 +Epp6qaHGGSk7V+guNJMSxesUOIbshbGXmOSqxmbacOUCVCjRzqay4bcTl762j48pv
	 AJrWXXLdiTXchJgP9c/6FyC5ETPsJGvF5Y2AKGFo=
Date: Wed, 23 Mar 2022 16:06:57 -0700
To: ryabinin.a.a@gmail.com,lixuefeng@loongson.cn,elver@google.com,corbet@lwn.net,bhe@redhat.com,yangtiezhu@loongson.cn,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
Subject: [patch 33/41] kasan: no need to unset panic_on_warn in end_report()
Message-Id: <20220323230658.17B64C36AE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: kasan: no need to unset panic_on_warn in end_report()

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
---

 mm/kasan/report.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/mm/kasan/report.c~kasan-no-need-to-unset-panic_on_warn-in-end_report
+++ a/mm/kasan/report.c
@@ -117,16 +117,8 @@ static void end_report(unsigned long *fl
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
 	if (kasan_arg_fault == KASAN_ARG_FAULT_PANIC)
 		panic("kasan.fault=panic set ...\n");
 	kasan_enable_current();
_
