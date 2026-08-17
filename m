Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12D44B0481;
	Mon, 17 Aug 2026 14:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977749; cv=none; b=eg1cOAI8ikOxxqN3MxDXRkAZJowX5cS5FZ3w6vQZ2EY1ySLcb8geLOlcb8algpM5eYrs7RoD9bDydob3LyawKiOEZ/5/p9fK1cq/tpWNDNKSfYO5CeZ1bfQ6HZVRx6LiNHmUpY5zIm9RBk7qsruXqCrMzO4Tp/8sBAQbqUdL5MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977749; c=relaxed/simple;
	bh=jFac3WgB7sYmL6cQPacgJEeSz7nuLEgyvUjLJ9lViJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rWRdoe/BhBhyTihXrW/ZIcchhZkX24eR13C/qo+1tpacqZfZAOwG0VbmYeqGdJxLuqvzO+fl5X8G3fTNEca6RXgHMXpiUsrKc7Kz62U6nfnZxzu8gNZVfPGLDR6A2PeTqZFOcdoFLe7YEJDyp7ZSSVbaqe1JmZgB1GktRaHAkmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RvrQuo69; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RvrQuo69"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228BE1F000E9;
	Mon, 17 Aug 2026 14:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977747;
	bh=h8jLtssjKC0TDcA5OeYePWiZwjWNp9PInrVRmhg7GU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RvrQuo69iWkjUhgFbNlMhTjqcw2WMyKRVgKfQdOaU8E8ZK2ocZx5WapcqPj0hm9n/
	 wPNpuvCOK0UjnC4sbfWPvlL3Os/nWX75VlNqVt4jIecpYDevMkuuqGYmgs65hQmhtc
	 fAr3R5xcEDx4ewQX2yyidXuk9jHyF/PSbdZHX2oU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Federico Kirschbaum <federico.kirschbaum@xbow.com>,
	Baul Lee <baul.lee@xbow.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 434/456] ALSA: usx2y: bound the hwdep mmap fault offset
Date: Mon, 17 Aug 2026 15:33:44 +0200
Message-ID: <20260817132556.101596921@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -29,6 +29,8 @@ static vm_fault_t snd_us428ctls_vm_fault
 		   vmf->pgoff);
 
 	offset = vmf->pgoff << PAGE_SHIFT;
+	if (offset >= US428_SHAREDMEM_PAGES)
+		return VM_FAULT_SIGBUS;
 	vaddr = (char *)((struct usx2ydev *)vmf->vma->vm_private_data)->us428ctls_sharedmem + offset;
 	page = virt_to_page(vaddr);
 	get_page(page);
--- a/sound/usb/usx2y/usx2yhwdeppcm.c
+++ b/sound/usb/usx2y/usx2yhwdeppcm.c
@@ -677,6 +677,8 @@ static vm_fault_t snd_usx2y_hwdep_pcm_vm
 	void *vaddr;
 
 	offset = vmf->pgoff << PAGE_SHIFT;
+	if (offset >= USX2Y_HWDEP_PCM_PAGES)
+		return VM_FAULT_SIGBUS;
 	vaddr = (char *)((struct usx2ydev *)vmf->vma->vm_private_data)->hwdep_pcm_shm + offset;
 	vmf->page = virt_to_page(vaddr);
 	get_page(vmf->page);


