Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3032F5A0F;
	Fri, 10 Oct 2025 13:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102510; cv=none; b=QMSIDHNeNmxfY42Kcq+SNX+PcGTtpMytb9De4PLSRXZVlYpJNx+mVvYyGP4x139X4OTDZx3dDdPY+64kZEmHXYuwBCFkTL8lWM5TmH/ZlKSP9emRLELMfS1PU788L9htcLfedIT4mHipxRWhiVedzyJFTnujhiL3OgHnCEnqGts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102510; c=relaxed/simple;
	bh=uvesKUbSL58CxhjC8/Ic9//TUfF3eURI/9UMGP8hjgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kKklj2IzE/3kKgEXi1sxoTB3kcogQZri35Rhlaoy1IzNwvvRzTBlkSMyEOyO6n/7UOhKKpPeRE7Z+5vg3tEMLzFdCs7xYA173vccaaYJ+QcHTyHrPoF82afoCwJIrzhdPGD7LYOcE2u7XnG4hiMnK/KkCxHxyMNE2uglCcOCCrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KTE60nUL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KTE60nUL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE03FC4CEF1;
	Fri, 10 Oct 2025 13:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102510;
	bh=uvesKUbSL58CxhjC8/Ic9//TUfF3eURI/9UMGP8hjgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KTE60nULUL/O0PLFa8TWdTtS8SxKhI7HSx9uHdLPu//b2DyrORLohrYQRNxIm4JGS
	 pJ8H/7u2d2vGT8LUirUqNbDj1gNuiFRJR5X2jjjRqCxrbThCKkD7pHhMbe+4Yj//OE
	 RrvK6Aoxh8mWDPFZIFE36nH/WlXaoKX+uYauU/8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Llamas <cmllamas@google.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Tiffany Yang <ynaffit@google.com>
Subject: [PATCH 6.12 27/35] binder: fix double-free in dbitmap
Date: Fri, 10 Oct 2025 15:16:29 +0200
Message-ID: <20251010131332.771838738@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131331.785281312@linuxfoundation.org>
References: <20251010131331.785281312@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Llamas <cmllamas@google.com>

commit 3ebcd3460cad351f198c39c6edb4af519a0ed934 upstream.

A process might fail to allocate a new bitmap when trying to expand its
proc->dmap. In that case, dbitmap_grow() fails and frees the old bitmap
via dbitmap_free(). However, the driver calls dbitmap_free() again when
the same process terminates, leading to a double-free error:

  ==================================================================
  BUG: KASAN: double-free in binder_proc_dec_tmpref+0x2e0/0x55c
  Free of addr ffff00000b7c1420 by task kworker/9:1/209

  CPU: 9 UID: 0 PID: 209 Comm: kworker/9:1 Not tainted 6.17.0-rc6-dirty #5 PREEMPT
  Hardware name: linux,dummy-virt (DT)
  Workqueue: events binder_deferred_func
  Call trace:
   kfree+0x164/0x31c
   binder_proc_dec_tmpref+0x2e0/0x55c
   binder_deferred_func+0xc24/0x1120
   process_one_work+0x520/0xba4
  [...]

  Allocated by task 448:
   __kmalloc_noprof+0x178/0x3c0
   bitmap_zalloc+0x24/0x30
   binder_open+0x14c/0xc10
  [...]

  Freed by task 449:
   kfree+0x184/0x31c
   binder_inc_ref_for_node+0xb44/0xe44
   binder_transaction+0x29b4/0x7fbc
   binder_thread_write+0x1708/0x442c
   binder_ioctl+0x1b50/0x2900
  [...]
  ==================================================================

Fix this issue by marking proc->map NULL in dbitmap_free().

Cc: stable@vger.kernel.org
Fixes: 15d9da3f818c ("binder: use bitmap for faster descriptor lookup")
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Tiffany Yang <ynaffit@google.com>
Link: https://lore.kernel.org/r/20250915221248.3470154-1-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/dbitmap.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/android/dbitmap.h b/drivers/android/dbitmap.h
index 956f1bd087d1..c7299ce8b374 100644
--- a/drivers/android/dbitmap.h
+++ b/drivers/android/dbitmap.h
@@ -37,6 +37,7 @@ static inline void dbitmap_free(struct dbitmap *dmap)
 {
 	dmap->nbits = 0;
 	kfree(dmap->map);
+	dmap->map = NULL;
 }
 
 /* Returns the nbits that a dbitmap can shrink to, 0 if not possible. */
-- 
2.51.0



