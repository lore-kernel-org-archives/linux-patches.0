Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4640D4409;
	Mon, 23 Jun 2025 22:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716054; cv=none; b=B65oeCvBEjY/Gb2vILwY1W605YrL5p8eg+4twFsc0mFcFJGjUfgBzgQ5EJL4IoDDyiDXBnkIgtBVeFs83gdo0f26skUVztVKntHSJI0ySvItitXcD1me7KOoyHzSUYfBzd07XoOEgr+FCkyoro5kYTyYu8OslGC2xP8Z2PBMFhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716054; c=relaxed/simple;
	bh=Jdm6XAcQIVE4nQ3lRb8OR5MSeAmX50OOIrGM12yAsGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nv3IbkWqdGh5CLX9xBvMgvm1op/8WuqIo+5X1iiJIYE13HYdkNkYqbRU5Ghvm3+7ShZ4EUHJsw5ZPU/9TgkWaOQnZ1Fxm1LAfu1KgVzS73pznAhnsB+k5+aXBr66AG2LlWOQeTp5TEwTOrlj5Rp2Z595lsbV3ZlyANz0f+onApY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w7X7QBGr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w7X7QBGr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75445C4CEEA;
	Mon, 23 Jun 2025 22:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716053;
	bh=Jdm6XAcQIVE4nQ3lRb8OR5MSeAmX50OOIrGM12yAsGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w7X7QBGrtwi0tuo67R/IZfypVQMTGCTn3oTecoxvxUWldTfN9ehRfAfGPEaiUw8UQ
	 HYYJAdTtqOVEfT8wQA3u8FW3tc5K1ypZE5xIH1oPQ/xwn9r6JLjXtVJ+Fbi4MTmwC1
	 2zm/XkJPK9EfJomO2y7bBvIfkkkhiSYfs1ITHd1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Wupeng Ma <mawupeng1@huawei.com>
Subject: [PATCH 6.1 277/508] VMCI: fix race between vmci_host_setup_notify and vmci_ctx_unset_notify
Date: Mon, 23 Jun 2025 15:05:22 +0200
Message-ID: <20250623130652.063562743@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

From: Wupeng Ma <mawupeng1@huawei.com>

commit 1bd6406fb5f36c2bb1e96e27d4c3e9f4d09edde4 upstream.

During our test, it is found that a warning can be trigger in try_grab_folio
as follow:

  ------------[ cut here ]------------
  WARNING: CPU: 0 PID: 1678 at mm/gup.c:147 try_grab_folio+0x106/0x130
  Modules linked in:
  CPU: 0 UID: 0 PID: 1678 Comm: syz.3.31 Not tainted 6.15.0-rc5 #163 PREEMPT(undef)
  RIP: 0010:try_grab_folio+0x106/0x130
  Call Trace:
   <TASK>
   follow_huge_pmd+0x240/0x8e0
   follow_pmd_mask.constprop.0.isra.0+0x40b/0x5c0
   follow_pud_mask.constprop.0.isra.0+0x14a/0x170
   follow_page_mask+0x1c2/0x1f0
   __get_user_pages+0x176/0x950
   __gup_longterm_locked+0x15b/0x1060
   ? gup_fast+0x120/0x1f0
   gup_fast_fallback+0x17e/0x230
   get_user_pages_fast+0x5f/0x80
   vmci_host_unlocked_ioctl+0x21c/0xf80
  RIP: 0033:0x54d2cd
  ---[ end trace 0000000000000000 ]---

Digging into the source, context->notify_page may init by get_user_pages_fast
and can be seen in vmci_ctx_unset_notify which will try to put_page. However
get_user_pages_fast is not finished here and lead to following
try_grab_folio warning. The race condition is shown as follow:

cpu0			cpu1
vmci_host_do_set_notify
vmci_host_setup_notify
get_user_pages_fast(uva, 1, FOLL_WRITE, &context->notify_page);
lockless_pages_from_mm
gup_pgd_range
gup_huge_pmd  // update &context->notify_page
			vmci_host_do_set_notify
			vmci_ctx_unset_notify
			notify_page = context->notify_page;
			if (notify_page)
			put_page(notify_page);	// page is freed
__gup_longterm_locked
__get_user_pages
follow_trans_huge_pmd
try_grab_folio // warn here

To slove this, use local variable page to make notify_page can be seen
after finish get_user_pages_fast.

Fixes: a1d88436d53a ("VMCI: Fix two UVA mapping bugs")
Cc: stable <stable@kernel.org>
Closes: https://lore.kernel.org/all/e91da589-ad57-3969-d979-879bbd10dddd@huawei.com/
Signed-off-by: Wupeng Ma <mawupeng1@huawei.com>
Link: https://lore.kernel.org/r/20250510033040.901582-1-mawupeng1@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/vmw_vmci/vmci_host.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/misc/vmw_vmci/vmci_host.c
+++ b/drivers/misc/vmw_vmci/vmci_host.c
@@ -227,6 +227,7 @@ static int drv_cp_harray_to_user(void __
 static int vmci_host_setup_notify(struct vmci_ctx *context,
 				  unsigned long uva)
 {
+	struct page *page;
 	int retval;
 
 	if (context->notify_page) {
@@ -243,13 +244,11 @@ static int vmci_host_setup_notify(struct
 	/*
 	 * Lock physical page backing a given user VA.
 	 */
-	retval = get_user_pages_fast(uva, 1, FOLL_WRITE, &context->notify_page);
-	if (retval != 1) {
-		context->notify_page = NULL;
+	retval = get_user_pages_fast(uva, 1, FOLL_WRITE, &page);
+	if (retval != 1)
 		return VMCI_ERROR_GENERIC;
-	}
-	if (context->notify_page == NULL)
-		return VMCI_ERROR_UNAVAILABLE;
+
+	context->notify_page = page;
 
 	/*
 	 * Map the locked page and set up notify pointer.


