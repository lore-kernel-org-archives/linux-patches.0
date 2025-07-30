Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5BEE267F61;
	Wed, 30 Jul 2025 09:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868349; cv=none; b=VwW9V8+mbnkQD5u+s/A/YpRPJh5a0CFbzwvE3ICH713qGInRFULl33OvBIIvm7m0fZZU5rfl9zLpZrtTzwAzdhRR/04D3uwZkBqnLir5cuhTn64hQ/vmMuuHm1W1VDmxQVbDXhVS2EZglaj448IEUsk6NLClTW+5OUp3fiTI+3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868349; c=relaxed/simple;
	bh=a+1KE/EGg/XihqO4tVP0ywmebwa6i/1CLya+CuI9Y9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Stc07vOyVEui7UQNYmAyRmvCTswGwBZ7f+Eud46ZJXhTaWdjPioL+EJN+QJ+wGuWXmqd2WySsVXHQTUa6G67gpoebP6n5vPWHa1L034NcSNaFcLXGcbTULwQxCk7Yib7yu5ygxuaD4LkIMURpiNxQP6bShhr/5ZWC4dZxmjBnog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nvjg7KOO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nvjg7KOO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 527EAC4CEE7;
	Wed, 30 Jul 2025 09:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868348;
	bh=a+1KE/EGg/XihqO4tVP0ywmebwa6i/1CLya+CuI9Y9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nvjg7KOOQeJeek//gHhR4D3maX4SaQ/GAapuvb8kh3w8u8DImzTjiSItubitcIZF4
	 gJfwddGP2C4t46L1wYyngPDzlm5mvws4kxpOA0Ohk+PiiatfxsPTrBi81DrHhvnxij
	 qy67BRPRyq6vafmYA//O62J2bMcXwMCvdBSEjDhE=
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
Subject: [PATCH 6.6 42/76] kasan: use vmalloc_dump_obj() for vmalloc error reports
Date: Wed, 30 Jul 2025 11:35:35 +0200
Message-ID: <20250730093228.467013162@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -385,7 +385,9 @@ static void print_address_description(vo
 	}
 
 	if (is_vmalloc_addr(addr)) {
-		pr_err("The buggy address %px belongs to a vmalloc virtual mapping\n", addr);
+		pr_err("The buggy address belongs to a");
+		if (!vmalloc_dump_obj(addr))
+			pr_cont(" vmalloc virtual mapping\n");
 		page = vmalloc_to_page(addr);
 	}
 


