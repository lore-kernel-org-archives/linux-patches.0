Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625864;
	b=LXxQ4lO5CL0WS6fvCdXA3NlPJ1e0qut0vzlCrF6YE+uDWSjuHDpCo/7ZMPkwO7kofhBV
	 XJURLsSzSEJj+7eu4IsxeNCDKutwbshr4xKsdKWWAHuc9m2rXBdcmEZAuiFSfQXr2fD60
	 wu+B/ykwqF/XljqkyzxC005ecBerESPenYYWUfAIkXiRU2jQu3l1uz/IzylK3BdmJOPdy
	 GUCf9ubatHZYmCu2QcsCNPkpUCH03OiFrp6P8mB5O9y6BVKUwI855YBoT0iN2tRV6xIWL
	 GUnIazGY+l8zHcnpZls1xv2IHyX/k/31Sk53/9aShWMu9e39mESJJpDUSTKaYCgZfyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625864;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xYkIFTKgGwAuHjiw2xD5CTFFaLP4vq8loFA208Api3w=;
	b=bT22+iiGcQJWxpdGprWgsrEzAswOHiwNjNT+tu6JY6AMRpubQkARPYmOubD3u8sEcYqc
	 w6OuTfrpZGRdjP1ZmAX8SGT/icG6u74/qEqPyLRTnTLSUxSCoZGDVP4MVVo1ExuLJfH4A
	 yEu5Ubln0JwFzjqq2H6VHEUHSieSmuHO+xemHEU54c0s23MY4oNGsv3LAl4s9cIYbDiM4
	 +x/3AedVAJa7loupmYJgiK+8W123KQcbJOf0utlxR5N6mvmP93gHOiA5uWZnKkrwaMnd3
	 VpHTAHN1eswpePQ8GnaJj+KQwCms6fY4ZGu9AL9SpcKWTKpaD9c5qE3d5cGn947n7nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l+jEggpv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A979606A327;
	Wed, 25 Nov 2026 16:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l+jEggpv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0CC1F000C0;
	Wed, 25 Nov 2026 16:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625863;
	bh=xYkIFTKgGwAuHjiw2xD5CTFFaLP4vq8loFA208Api3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l+jEggpvgM+Reikgyos1um2ltYCg4cODomTwBr02b8Pgfz58dRcy3mJVBXlq+Of6r
	 WLXpPcQyvwLsONMGD8NrZRwDJa/8DO1NE+LsTMD5j9TtVl3+ctL5AhODe52e1wnDoj
	 NmDeRiAE1pat4ZBmWr0hPc7GmW+kN4wIY4IWLkJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 653/816] LoongArch: Restore KFENCE pages through DMW on resume
Date: Wed, 25 Nov 2026 15:36:41 +0100
Message-ID: <20261125143904.297039119@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

commit 40d7a3e63c3d88b43e9115d23d9937dd506bbd02 upstream.

With KFENCE enabled, resume from hibernation triggers KFENCE reports
while swsusp_asm_resume() copies the image pages, for example:

  BUG: KFENCE: use-after-free write in swsusp_asm_resume+0x20/0x94

  Use-after-free write at 0x00000000a57ee925 (in kfence-#254):
   swsusp_asm_resume+0x20/0x94
   hibernation_restore+0x128/0x1a0
   load_image_and_restore+0x6c/0xc8
   software_resume+0x240/0x260
   do_one_initcall+0x68/0x200
   kernel_init_freeable+0x26c/0x304
   kernel_init+0x20/0x134
   ret_from_kernel_thread+0x24/0x1d0
   ret_from_kernel_thread_asm+0xc/0x98

During resume from hibernation, the image pages that occupy physical
pages used by the restore kernel are first loaded into free pages and
then, as the very last step, swsusp_asm_resume() copies them to their
final location pointed to by pbe->orig_address, which the hibernation
core sets to page_address() of the page in the restore kernel.

The early KFENCE pool is allocated from memblock and normally occupies
the same physical pages in the restore kernel and in the image kernel,
so these pages are usually copied by swsusp_asm_resume().

The KFENCE pool is remapped into the KFENCE area above vm_map_base and
set_page_address() adjusts page->virtual so that page_address() returns
the page-table mapped alias rather than the DMW virtual address of the
pool pages.

Hence, pbe->orig_address of KFENCE pages points to that alias and
swsusp_asm_resume() writes them through the page tables. But:

* the copy loop overwrites the kernel page tables, so a TLB refill for
  the KFENCE alias may use a partially restored page table
* the KFENCE pool pages that are protected in the restore kernel fault
  in the middle of the copy

Convert pbe->orig_address to DMW addresses before starting the copy.

Cc: stable@vger.kernel.org
Fixes: 0ca84aeaee15 ("LoongArch: Make {virt, phys, page, pfn} translation work with KFENCE")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/power/hibernate.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/loongarch/power/hibernate.c
+++ b/arch/loongarch/power/hibernate.c
@@ -59,6 +59,12 @@ extern int swsusp_asm_resume(void);
 
 int swsusp_arch_resume(void)
 {
+#ifdef CONFIG_KFENCE
+	struct pbe *pbe;
+
+	for (pbe = restore_pblist; pbe; pbe = pbe->next)
+		pbe->orig_address = __va(virt_to_phys(pbe->orig_address));
+#endif
 	/* Avoid TLB mismatch during and after kernel resume */
 	local_flush_tlb_all();
 	return swsusp_asm_resume();


