Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035391FB7
	for <patches@lists.linux.dev>; Fri, 25 Mar 2022 01:12:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2BAAC340EC;
	Fri, 25 Mar 2022 01:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648170769;
	bh=Nat5VhE6ziYLM5744IzlQUedh3QSwQxGNrwwuNLYEEw=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=RRFoM3yRfXQo5mWu0cKEYElV1Ftw1zJvU4/JBy9gcG/ORHKDK92wzdWAEfFVv/r4w
	 PlxhmggxT9Ia/SwZntMpjqIp1XzkeVUwZdIoV/7A120jtNuiqmg7UMxzvt5m7rYsn/
	 9XhoFZ4biOpWxj61c2qHMrdFWRdrElf6MpOFi9a4=
Date: Thu, 24 Mar 2022 18:12:49 -0700
To: ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 085/114] kasan: restructure kasan_report
Message-Id: <20220325011249.C2BAAC340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: restructure kasan_report

Restructure kasan_report() to make reviewing the subsequent patches
easier.

Link: https://lkml.kernel.org/r/ca28042889858b8cc4724d3d4378387f90d7a59d.1646237226.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/mm/kasan/report.c~kasan-restructure-kasan_report
+++ a/mm/kasan/report.c
@@ -457,15 +457,18 @@ static void __kasan_report(void *addr, s
 bool kasan_report(unsigned long addr, size_t size, bool is_write,
 			unsigned long ip)
 {
-	unsigned long flags = user_access_save();
-	bool ret = false;
+	unsigned long ua_flags = user_access_save();
+	bool ret = true;
 
-	if (likely(report_enabled())) {
-		__kasan_report((void *)addr, size, is_write, ip);
-		ret = true;
+	if (unlikely(!report_enabled())) {
+		ret = false;
+		goto out;
 	}
 
-	user_access_restore(flags);
+	__kasan_report((void *)addr, size, is_write, ip);
+
+out:
+	user_access_restore(ua_flags);
 
 	return ret;
 }
_
