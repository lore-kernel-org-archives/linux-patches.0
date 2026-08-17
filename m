Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A074A40F8DF;
	Mon, 17 Aug 2026 13:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975166; cv=none; b=YvUaegHl5iC/NMceya3FCvNC7sBymDOd8f0snZT/ebS8v0/C29GqU2tU8pO6bCORTVI+ke1yb+H0bOIVT0oDwnaTqYnf4ENXWRTSSywZZLYD1s5+2i5v4r64CSp7F7c2qKQ7sygYoNIb/ibFtIkWp5TodM1cJWGYRAfQ0xRdA3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975166; c=relaxed/simple;
	bh=BZVTIasP4T0W5ZwgJYjRushougGl0m1bp0nMPcuVOys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=et8Y1PA9kA1a8JU7DsxibJCVsmVgpjC0ykoqBHKS3dZI12Gc4Qh7nrXLemsEbX7DSjLcCauZCJy6t/6wI2n5c964hRVdUqQo0ivC7ot4KHMM8bw2LLR04U4E3M3am8L4MH+KiSZWmUC5bOFPXeP2bLhaAo5HeNa4JIUlX95BqEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F5mYq0re; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F5mYq0re"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FF41F000E9;
	Mon, 17 Aug 2026 13:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975165;
	bh=rQE6BjbVraLUrDcGXsTYWwht01y8SsukWYpTfxq3L9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F5mYq0rezHOIFf1WMGNm8r0PO9gYwZoK9xzAsfF96T7jE86Ffxad6DjecKV+/vK3l
	 Z1NO6TKuLYfQHthWZQTr6i2Hb52sBvxJq4Mf1BVpyPncWlXB3Ug+oz5ZbarPC8p2Fm
	 GSL/tU0ONbQXOWGEH0evZY3qZAD3SfrWV5MEBCMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Federico Kirschbaum <federico.kirschbaum@xbow.com>,
	Baul Lee <baul.lee@xbow.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 184/250] ALSA: usx2y: bound the hwdep mmap fault offset
Date: Mon, 17 Aug 2026 15:32:25 +0200
Message-ID: <20260817132544.103733507@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baul Lee <baul.lee@xbow.com>

commit 2ca1eea3cd17930daffe9e429a7c89232036ec24 upstream.

snd_us428ctls_vm_fault() turns the faulting page offset into a kernel
address with no bound of any kind:

	offset = vmf->pgoff << PAGE_SHIFT;
	vaddr = (char *)(...)->us428ctls_sharedmem + offset;
	page = virt_to_page(vaddr);
	get_page(page);
	vmf->page = page;

	return 0;

snd_us428ctls_mmap() checks only the length of the mapping, never the
offset, and us428ctls_sharedmem is a single page from
alloc_pages_exact().  For a character device file_mmap_size_max()
returns ULONG_MAX, so the mm layer imposes no ceiling either.  Every page
offset above zero resolves to a struct page outside the object, and the
handler installs it into the caller's address space read-write; the vma
is not marked read-only.

The caller picks the page frame with a single mmap() argument and gets
read-write access to a page of kernel memory it does not own; an offset
that lands in an unpopulated vmemmap region oopses instead.

A process that can open the hwdep node of an attached US-X2Y reaches
this after loading the FPGA image through the same node; no capability
check is involved.

On 7.2.0-rc5 (arm64), mmap() with a large offset:

  Unable to handle kernel paging request at virtual address fffffdffc45d5ac8
  pc : snd_us428ctls_vm_fault+0x68/0x140 [snd_usb_usx2y]
  Call trace:
   snd_us428ctls_vm_fault+0x68/0x140 [snd_usb_usx2y]
   __do_fault
   __handle_mm_fault
   handle_mm_fault
   el0_da

Reject any offset outside the shared region.  The pcm hwdep handler in
usx2yhwdeppcm.c computes its address the same way and needs the same
bound.

Discovered by XBOW, triaged by Baul Lee <baul.lee@xbow.com>

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Federico Kirschbaum <federico.kirschbaum@xbow.com>
Reported-by: Baul Lee <baul.lee@xbow.com>
Cc: stable@vger.kernel.org
Signed-off-by: Baul Lee <baul.lee@xbow.com>
Link: https://patch.msgid.link/20260805013445.38283-1-baul.lee@xbow.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/usx2y/usX2Yhwdep.c    |    2 ++
 sound/usb/usx2y/usx2yhwdeppcm.c |    2 ++
 2 files changed, 4 insertions(+)

--- a/sound/usb/usx2y/usX2Yhwdep.c
+++ b/sound/usb/usx2y/usX2Yhwdep.c
@@ -25,6 +25,8 @@ static vm_fault_t snd_us428ctls_vm_fault
 	void *vaddr;
 
 	offset = vmf->pgoff << PAGE_SHIFT;
+	if (offset >= US428_SHAREDMEM_PAGES)
+		return VM_FAULT_SIGBUS;
 	vaddr = (char *)((struct usx2ydev *)vmf->vma->vm_private_data)->us428ctls_sharedmem + offset;
 	page = virt_to_page(vaddr);
 	get_page(page);
--- a/sound/usb/usx2y/usx2yhwdeppcm.c
+++ b/sound/usb/usx2y/usx2yhwdeppcm.c
@@ -672,6 +672,8 @@ static vm_fault_t snd_usx2y_hwdep_pcm_vm
 	void *vaddr;
 
 	offset = vmf->pgoff << PAGE_SHIFT;
+	if (offset >= USX2Y_HWDEP_PCM_PAGES)
+		return VM_FAULT_SIGBUS;
 	vaddr = (char *)((struct usx2ydev *)vmf->vma->vm_private_data)->hwdep_pcm_shm + offset;
 	vmf->page = virt_to_page(vaddr);
 	get_page(vmf->page);


