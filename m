Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1092518CBE8;
	Tue, 10 Sep 2024 09:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961418; cv=none; b=BqQzmRRzGjy4F4ohU3wieGYdf3To35Ftzt92ZyxeR/zfhYoL8BqmJez/v1baX/mBvYcc7vWwvOf5G2f6XKfOtXkd26EY0MEZl07WCtqz1ay8Iw+Rnz+8wMk0uzWnRNEBddvRLwDEQtVak+Rc4FcZCzHkyJVs1lTshvdFBunNT+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961418; c=relaxed/simple;
	bh=DoHC+vPt73EE3Z5a0j7BWSfpj107f68UKM6mdgWlhHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OuNroRAPV1LyWbkAxc11Pm4q14BR6Fikcx3hrO2CGoho7LQ2+jLSsqe2byQwW6jgRJT6wISxzrMtp7RmO0ye+aQX8sjoD42HNFIfZWdmc/4IHShzgDZRlwVb4shWDE9xlDP3qk5ZbAL5+CQI5EPDFh/StfYHeWSFeuWV2vOOppQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GpRXMn4b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GpRXMn4b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6D5C4CEC3;
	Tue, 10 Sep 2024 09:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961417;
	bh=DoHC+vPt73EE3Z5a0j7BWSfpj107f68UKM6mdgWlhHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GpRXMn4bVXMSTCHsvk+Yk4pC5xdDnHJxjGgRBwByntoS6wfG+7ShIidqX8GF23kRC
	 EwyJYjNZB9YjDIv31pEgFRum/TwHevyznoxRzTLSkpbZrN9dtWIcPHYaJiAyr5zsAo
	 h2kEneGnsEhJLr5H+Kqy2bF3xOTAAbmAOitQCIn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	matoro <matoro_mailinglist_kernel@matoro.tk>,
	Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Subject: [PATCH 6.10 045/375] parisc: Delay write-protection until mark_rodata_ro() call
Date: Tue, 10 Sep 2024 11:27:22 +0200
Message-ID: <20240910092623.756313629@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 213aa670153ed675a007c1f35c5db544b0fefc94 upstream.

Do not write-protect the kernel read-only and __ro_after_init sections
earlier than before mark_rodata_ro() is called.  This fixes a boot issue on
parisc which is triggered by commit 91a1d97ef482 ("jump_label,module: Don't
alloc static_key_mod for __ro_after_init keys"). That commit may modify
static key contents in the __ro_after_init section at bootup, so this
section needs to be writable at least until mark_rodata_ro() is called.

Signed-off-by: Helge Deller <deller@gmx.de>
Reported-by: matoro <matoro_mailinglist_kernel@matoro.tk>
Reported-by: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Tested-by: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Link: https://lore.kernel.org/linux-parisc/096cad5aada514255cd7b0b9dbafc768@matoro.tk/#r
Fixes: 91a1d97ef482 ("jump_label,module: Don't alloc static_key_mod for __ro_after_init keys")
Cc: stable@vger.kernel.org # v6.10+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/mm/init.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
index 34d91cb8b259..96970fa75e4a 100644
--- a/arch/parisc/mm/init.c
+++ b/arch/parisc/mm/init.c
@@ -459,7 +459,6 @@ void free_initmem(void)
 	unsigned long kernel_end  = (unsigned long)&_end;
 
 	/* Remap kernel text and data, but do not touch init section yet. */
-	kernel_set_to_readonly = true;
 	map_pages(init_end, __pa(init_end), kernel_end - init_end,
 		  PAGE_KERNEL, 0);
 
@@ -493,11 +492,18 @@ void free_initmem(void)
 #ifdef CONFIG_STRICT_KERNEL_RWX
 void mark_rodata_ro(void)
 {
-	/* rodata memory was already mapped with KERNEL_RO access rights by
-           pagetable_init() and map_pages(). No need to do additional stuff here */
-	unsigned long roai_size = __end_ro_after_init - __start_ro_after_init;
+	unsigned long start = (unsigned long) &__start_rodata;
+	unsigned long end = (unsigned long) &__end_rodata;
 
-	pr_info("Write protected read-only-after-init data: %luk\n", roai_size >> 10);
+	pr_info("Write protecting the kernel read-only data: %luk\n",
+	       (end - start) >> 10);
+
+	kernel_set_to_readonly = true;
+	map_pages(start, __pa(start), end - start, PAGE_KERNEL, 0);
+
+	/* force the kernel to see the new page table entries */
+	flush_cache_all();
+	flush_tlb_all();
 }
 #endif
 
-- 
2.46.0



