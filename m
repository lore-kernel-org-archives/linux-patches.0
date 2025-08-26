Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD552BEC34;
	Tue, 26 Aug 2025 11:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207582; cv=none; b=gj3XN9S8uNQon2hsKaI6O4gaOaea4Ijc8oUealFoYh2gSmvLzok9Yk7BbTjjpzy2+5QvOtTsKTftrk0lFjU0hILOif/klSKKvTReoYjenhgz3I4AoTyv0f4Gm/fwMfJYTyBl3k7n/cBKN8lcUnZn/B35ON4Ftv7vaI+QKkcayJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207582; c=relaxed/simple;
	bh=p6Vl2qw9JchiluDQWoO66G+jgQWucUJmEQHBVEv/2TQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aAofNhZkRCQaIf1NTwKOznmcBomKd4pvfU9rdKjVOE+A97/4fQEn5wngCPv7s1t+KopdsnKCSWBjbna1RYRmvVHlRk7r11MrdLUFa4xAUJSrk4U8f+c6PV+xVc2IlvxTC1ljn4Sra9qCqFnFWhzE4vemo2ybxWaidDZJTe/Tfew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T6r0NbPi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T6r0NbPi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8C7C4CEF1;
	Tue, 26 Aug 2025 11:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207581;
	bh=p6Vl2qw9JchiluDQWoO66G+jgQWucUJmEQHBVEv/2TQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T6r0NbPiz/qVAsxlvRr0YT4rzxbSQDlvOyHa5Rgns+U3EtZf8jw7kkMT2YqjZA63t
	 lUmg/CbKcFD+feavFlVlepFPG+b830Et78soxtFIxaJgfkuPQbDj6OO0WOodUGrNBg
	 qoiIJZztuPsQ+u0OkZIxi920tpSbS9EubFDqfehc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>,
	Coiby Xu <coxu@redhat.com>,
	Dave Vasilevsky <dave@vasilevsky.ca>,
	Eric Biggers <ebiggers@google.com>,
	Kees Cook <kees@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.16 237/457] kho: init new_physxa->phys_bits to fix lockdep
Date: Tue, 26 Aug 2025 13:08:41 +0200
Message-ID: <20250826110943.231792760@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pasha Tatashin <pasha.tatashin@soleen.com>

commit 63b17b653df30e90f95338083cb44c35d64bcae4 upstream.

Patch series "Several KHO Hotfixes".

Three unrelated fixes for Kexec Handover.


This patch (of 3):

Lockdep shows the following warning:

INFO: trying to register non-static key.  The code is fine but needs
lockdep annotation, or maybe you didn't initialize this object before use?
turning off the locking correctness validator.

[<ffffffff810133a6>] dump_stack_lvl+0x66/0xa0
[<ffffffff8136012c>] assign_lock_key+0x10c/0x120
[<ffffffff81358bb4>] register_lock_class+0xf4/0x2f0
[<ffffffff813597ff>] __lock_acquire+0x7f/0x2c40
[<ffffffff81360cb0>] ? __pfx_hlock_conflict+0x10/0x10
[<ffffffff811707be>] ? native_flush_tlb_global+0x8e/0xa0
[<ffffffff8117096e>] ? __flush_tlb_all+0x4e/0xa0
[<ffffffff81172fc2>] ? __kernel_map_pages+0x112/0x140
[<ffffffff813ec327>] ? xa_load_or_alloc+0x67/0xe0
[<ffffffff81359556>] lock_acquire+0xe6/0x280
[<ffffffff813ec327>] ? xa_load_or_alloc+0x67/0xe0
[<ffffffff8100b9e0>] _raw_spin_lock+0x30/0x40
[<ffffffff813ec327>] ? xa_load_or_alloc+0x67/0xe0
[<ffffffff813ec327>] xa_load_or_alloc+0x67/0xe0
[<ffffffff813eb4c0>] kho_preserve_folio+0x90/0x100
[<ffffffff813ebb7f>] __kho_finalize+0xcf/0x400
[<ffffffff813ebef4>] kho_finalize+0x34/0x70

This is becase xa has its own lock, that is not initialized in
xa_load_or_alloc.

Modifiy __kho_preserve_order(), to properly call
xa_init(&new_physxa->phys_bits);

Link: https://lkml.kernel.org/r/20250808201804.772010-2-pasha.tatashin@soleen.com
Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: Dave Vasilevsky <dave@vasilevsky.ca>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kexec_handover.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index e49743ae52c5..65145972d6d6 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -144,14 +144,34 @@ static int __kho_preserve_order(struct kho_mem_track *track, unsigned long pfn,
 				unsigned int order)
 {
 	struct kho_mem_phys_bits *bits;
-	struct kho_mem_phys *physxa;
+	struct kho_mem_phys *physxa, *new_physxa;
 	const unsigned long pfn_high = pfn >> order;
 
 	might_sleep();
 
-	physxa = xa_load_or_alloc(&track->orders, order, sizeof(*physxa));
-	if (IS_ERR(physxa))
-		return PTR_ERR(physxa);
+	physxa = xa_load(&track->orders, order);
+	if (!physxa) {
+		int err;
+
+		new_physxa = kzalloc(sizeof(*physxa), GFP_KERNEL);
+		if (!new_physxa)
+			return -ENOMEM;
+
+		xa_init(&new_physxa->phys_bits);
+		physxa = xa_cmpxchg(&track->orders, order, NULL, new_physxa,
+				    GFP_KERNEL);
+
+		err = xa_err(physxa);
+		if (err || physxa) {
+			xa_destroy(&new_physxa->phys_bits);
+			kfree(new_physxa);
+
+			if (err)
+				return err;
+		} else {
+			physxa = new_physxa;
+		}
+	}
 
 	bits = xa_load_or_alloc(&physxa->phys_bits, pfn_high / PRESERVE_BITS,
 				sizeof(*bits));
-- 
2.50.1



