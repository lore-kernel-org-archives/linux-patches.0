Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9E82566D3;
	Wed, 30 Jul 2025 09:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868728; cv=none; b=EdIv5miECih4Va5snLWIR7LqlHarElsv0tqx7TyPz683pIA/uui3RqAJmc6lupMwAk299Mybosyz3v21XHvnIj+LPTfHpaeS8ulnR8CWHgV0KP/kx1ygFn8/gFp2o4GaIIkWdANwABqqo3e/Jt8gRRRiS/m1LVQEIFTrGqj4ysU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868728; c=relaxed/simple;
	bh=yXB90O9EKcH0cRRKLZSzqQ79t24gGq+6ti5E3jeqeLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=laGd9hjlr8Osb8FD4/06i4QDdrOanyDmz2Wiq9kJseFfNC/aDWKxdgRSgHhdX2ozZqYvxa2WwtxkX7lmmjk5kChin3dWazCHK3Pqk79ZY62iqQ1ZNULYw6ca3f1ecW0uN8NAniU0MMGjd32MfPZlkR5CnobZqHgcR1JTqt05yJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sqNdo0vC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sqNdo0vC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF5BC4CEF5;
	Wed, 30 Jul 2025 09:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868728;
	bh=yXB90O9EKcH0cRRKLZSzqQ79t24gGq+6ti5E3jeqeLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sqNdo0vCFZc3PuI68NjOjkUx5V71hBx6GDZTEh29cFUBG4Jj1+JQdsUrT8/aPBkjT
	 rtwPEYgYRv7FMJszs2T1HRbn8JaWEoZx0a/VIt+ngF0Eugymhx3lp1j0os9RIVpeHe
	 tFzOg/Tt+rAlsufYGbBUWNiQZbTy3S4RKKcbM8CA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Elver <elver@google.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Yunseong Kim <ysk@kzalloc.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 060/117] kasan: use vmalloc_dump_obj() for vmalloc error reports
Date: Wed, 30 Jul 2025 11:35:29 +0200
Message-ID: <20250730093235.888433148@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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

From: Marco Elver <elver@google.com>

commit 6ade153349c6bb990d170cecc3e8bdd8628119ab upstream.

Since 6ee9b3d84775 ("kasan: remove kasan_find_vm_area() to prevent
possible deadlock"), more detailed info about the vmalloc mapping and the
origin was dropped due to potential deadlocks.

While fixing the deadlock is necessary, that patch was too quick in
killing an otherwise useful feature, and did no due-diligence in
understanding if an alternative option is available.

Restore printing more helpful vmalloc allocation info in KASAN reports
with the help of vmalloc_dump_obj().  Example report:

| BUG: KASAN: vmalloc-out-of-bounds in vmalloc_oob+0x4c9/0x610
| Read of size 1 at addr ffffc900002fd7f3 by task kunit_try_catch/493
|
| CPU: [...]
| Call Trace:
|  <TASK>
|  dump_stack_lvl+0xa8/0xf0
|  print_report+0x17e/0x810
|  kasan_report+0x155/0x190
|  vmalloc_oob+0x4c9/0x610
|  [...]
|
| The buggy address belongs to a 1-page vmalloc region starting at 0xffffc900002fd000 allocated at vmalloc_oob+0x36/0x610
| The buggy address belongs to the physical page:
| page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x126364
| flags: 0x200000000000000(node=0|zone=2)
| raw: 0200000000000000 0000000000000000 dead000000000122 0000000000000000
| raw: 0000000000000000 0000000000000000 00000001ffffffff 0000000000000000
| page dumped because: kasan: bad access detected
|
| [..]

Link: https://lkml.kernel.org/r/20250716152448.3877201-1-elver@google.com
Fixes: 6ee9b3d84775 ("kasan: remove kasan_find_vm_area() to prevent possible deadlock")
Signed-off-by: Marco Elver <elver@google.com>
Suggested-by: Uladzislau Rezki <urezki@gmail.com>
Acked-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Yunseong Kim <ysk@kzalloc.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kasan/report.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -398,7 +398,9 @@ static void print_address_description(vo
 	}
 
 	if (is_vmalloc_addr(addr)) {
-		pr_err("The buggy address %px belongs to a vmalloc virtual mapping\n", addr);
+		pr_err("The buggy address belongs to a");
+		if (!vmalloc_dump_obj(addr))
+			pr_cont(" vmalloc virtual mapping\n");
 		page = vmalloc_to_page(addr);
 	}
 


