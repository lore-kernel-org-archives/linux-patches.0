Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3035A2FA624;
	Tue, 17 Jun 2025 16:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179465; cv=none; b=Hj2AoJzjK+vcr0h5UxeX+1RzotnBNaPcrCLZ7XLKAQqrQRszYLhey+mGPlOBUjRvRCNNLLl9zWguxD/H5AF3xmgq/RnJt1Zpleab3marYDVNyXcTTSpcRq78muvbX6kmHlnnCeRZ1SY06t5Pd2a5V6pBtG2BDWmF0FFNMofUX6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179465; c=relaxed/simple;
	bh=pxtTVTkDbG76SjiJMbbLlmKg2Z/+h7gUFYFrJH8w3ZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=un3inrRMgCo/n9YyVj/Fv7bycOm6j22d5yOVJQJ4WA1xVF0RdflOYjpWhB42L/bSSXC9wVCADzBbb38XpTbFc37Izx2wYVMOBbTbAIVL6YR7ViEvH32xXVBefVv2CMoPBzQLWQZYuGRBqRvhl7Yz650vEQNPBinVM4wfwxe64gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hfoQ3X7q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hfoQ3X7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91CF7C4CEE7;
	Tue, 17 Jun 2025 16:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179465;
	bh=pxtTVTkDbG76SjiJMbbLlmKg2Z/+h7gUFYFrJH8w3ZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hfoQ3X7qu54N2D7WOfJzf1Tfxyzez3pcjh1e9ZD4/LSQ5Oiu2WslXVPDLrX8HVQZo
	 R5js8EQqFHvJAJyKbPW6rdBYr7sUXXTjDeV+zBoCzmdFN5v1fP8H2NRqBC/pCojje3
	 s4rD8FtqcvxjC1X/3MAox0MMss6zhptPS5VW/nZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Wupeng Ma <mawupeng1@huawei.com>
Subject: [PATCH 6.15 754/780] VMCI: fix race between vmci_host_setup_notify and vmci_ctx_unset_notify
Date: Tue, 17 Jun 2025 17:27:42 +0200
Message-ID: <20250617152522.217645735@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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


