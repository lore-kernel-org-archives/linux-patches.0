Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37ADD244691;
	Tue, 15 Jul 2025 13:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587400; cv=none; b=n1obS1d2hCNT8hFoatGjSXn0cw6vxDeh/q4moa2mJzzUAHJWZ/yYJHQKK3or/TNHIPZT1RLvsiWfro5Ky3I+BW00N7yz48MIsQr4hBX23Y+TBSB5oPaEjSg5CNDtRLPTVKHd4yB9WxTdp8Bz43nNRvXk/f5POKCx6xb6KVeP7bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587400; c=relaxed/simple;
	bh=4I4t2dpEWVA0KKgIKLBws4NKnH7aSN/ZZPb8MpTRtyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BdEpAryJKTQ5om6R+g0AJtXtTM9kNY6H5pTcBRzDFjRHkfJp57PE1WV4eYLVz7bd0uITFwRTqBkKvoE+IeNpN2HxOk7gWwjbsP9o7mAYNrdGLvjq73pHDnoUb9dmrMB7hVfVWHyvIpylxkui2Gb30GSCeuYyK8UGukAFE+mQ7eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PDfvRYe5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PDfvRYe5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D07C4CEE3;
	Tue, 15 Jul 2025 13:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587400;
	bh=4I4t2dpEWVA0KKgIKLBws4NKnH7aSN/ZZPb8MpTRtyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PDfvRYe58yoLLIgLa0GqcoNwPmcJkX00acRaUkdOJIizHqhPuYfQeb3xDsrA1v8xF
	 5NUufM4vP3W8+w4S4OzeRtsAm8hfw8Pd5pl9mCjNW3g1D82QkKSrRY2QUBRBtTolB9
	 wcORdVAYjKWFSnt54XbhuXGVgsHKNe2gVp48vYk4=
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
Subject: [PATCH 6.1 87/88] kasan: remove kasan_find_vm_area() to prevent possible deadlock
Date: Tue, 15 Jul 2025 15:15:03 +0200
Message-ID: <20250715130758.060379814@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130754.497128560@linuxfoundation.org>
References: <20250715130754.497128560@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -337,17 +337,8 @@ static void print_address_description(vo
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


