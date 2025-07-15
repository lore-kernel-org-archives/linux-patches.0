Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9426F2E11D3;
	Tue, 15 Jul 2025 13:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585758; cv=none; b=V67LFocCKTygwyL420xSr7IW5Tw9Wl1o2btzhN0U9UkQPHdvWqZz0+Ffu6eKvu+tNZF/t8K0g+/LKiB2RRJPHAgwB874zPbZR75ZZscioAlp2UuWZNu/as/CimHT1ddgv+JmoKElj+Hqysdh/xFJZQLZ05AosMslTGf2ixPkmI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585758; c=relaxed/simple;
	bh=3o6zsYO8YwOkO86mzylxKNa2LumRF1DprVaCjIWpH7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ag/NVcZc0c2gtQ1YMA010O4GsEfWrLWExrQtcoHyFyhgXUPcWwMZcpAWhmDoX2hju+LJC9kbYVvTWsjh2GUOo1e4JEkqmaqDsfaIRqIJsMGhgp4GtpLxZNtWG6vsnqUFCda7gCE0t2N8o91A9N/YVTOkbj3ZTlV3KBqPoV+SISg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZCyR9l9o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZCyR9l9o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E330DC4CEE3;
	Tue, 15 Jul 2025 13:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585758;
	bh=3o6zsYO8YwOkO86mzylxKNa2LumRF1DprVaCjIWpH7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZCyR9l9oD5GXMl7s+wsq35cGyJ7ZP2XBmcmAI0e5537JrQHtWF1JKmpEm2Me3j3kP
	 A6fccVaMjIolyCKbaxKb8BCnuWZ8a8Nja/eShx02uYYDN4WapXPELZz+YBwZMSAJf7
	 Qlls3/LDVzEQgu0VgFZLlgwYXPaz/gbjT6kDnBFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Yunseong Kim <ysk@kzalloc.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Dmitriy Vyukov <dvyukov@google.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 161/163] kasan: remove kasan_find_vm_area() to prevent possible deadlock
Date: Tue, 15 Jul 2025 15:13:49 +0200
Message-ID: <20250715130815.292422276@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yeoreum Yun <yeoreum.yun@arm.com>

commit 6ee9b3d84775944fb8c8a447961cd01274ac671c upstream.

find_vm_area() couldn't be called in atomic_context.  If find_vm_area() is
called to reports vm area information, kasan can trigger deadlock like:

CPU0                                CPU1
vmalloc();
 alloc_vmap_area();
  spin_lock(&vn->busy.lock)
                                    spin_lock_bh(&some_lock);
   <interrupt occurs>
   <in softirq>
   spin_lock(&some_lock);
                                    <access invalid address>
                                    kasan_report();
                                     print_report();
                                      print_address_description();
                                       kasan_find_vm_area();
                                        find_vm_area();
                                         spin_lock(&vn->busy.lock) // deadlock!

To prevent possible deadlock while kasan reports, remove kasan_find_vm_area().

Link: https://lkml.kernel.org/r/20250703181018.580833-1-yeoreum.yun@arm.com
Fixes: c056a364e954 ("kasan: print virtual mapping info in reports")
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reported-by: Yunseong Kim <ysk@kzalloc.com>
Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kasan/report.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -398,17 +398,8 @@ static void print_address_description(vo
 	}
 
 	if (is_vmalloc_addr(addr)) {
-		struct vm_struct *va = find_vm_area(addr);
-
-		if (va) {
-			pr_err("The buggy address belongs to the virtual mapping at\n"
-			       " [%px, %px) created by:\n"
-			       " %pS\n",
-			       va->addr, va->addr + va->size, va->caller);
-			pr_err("\n");
-
-			page = vmalloc_to_page(addr);
-		}
+		pr_err("The buggy address %px belongs to a vmalloc virtual mapping\n", addr);
+		page = vmalloc_to_page(addr);
 	}
 
 	if (page) {


