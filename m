Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CD621257F;
	Fri, 10 Oct 2025 13:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102235; cv=none; b=hP56jcECaHYsoTDu+1OA2MTvWz0/W35hitm4m19HKKtgDnJnZCU0oCh1EgbmwG5dhNQqG8slo2K9khd4aTVs/21UrVTKzROBIJzUVY8MRc8lHMxRWY6fhVQR1n6pncBRttoVahlTWL4po/Z2DGLRG6rWwkdesAjAZxEt7ELKu28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102235; c=relaxed/simple;
	bh=rP0HuVb0U6/f1beQaropGOTV1etLDBqxCLhmg0BJ3TA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GNOETU1IcRQOlpIwf6IjG2tdxngneK4hegl0W965Iq9/1AQihIr6hqti5XcjdiqrwL6+I2veUbgPyzIrj5dYDcdyukjPsTRAI6RTbAMScjSqcFgG05eapG5/c9XXh+h9vgJ8lgqfIRIA7TYcORjKRtcQaM0QnMyqFrZQjSZHC0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mYWfFYvs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mYWfFYvs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074A1C4CEF1;
	Fri, 10 Oct 2025 13:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102235;
	bh=rP0HuVb0U6/f1beQaropGOTV1etLDBqxCLhmg0BJ3TA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mYWfFYvsTR/g/hhwTXsFCxXnFsgHN7jkPzFjkuD1XWKkxvYaB5sR4T4Ff9nHdVjMY
	 ufpVQtTQYISGrem6eSS3VEnCLiMwnwBFWZ2FkX/8c5kmS/JMJd3Vjdb6X/VsDWMy2X
	 zTpdGD7/hiqUEo2kq6VWmGYFy15F4YrqXugDSiX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Llamas <cmllamas@google.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Tiffany Yang <ynaffit@google.com>
Subject: [PATCH 6.17 13/26] binder: fix double-free in dbitmap
Date: Fri, 10 Oct 2025 15:16:08 +0200
Message-ID: <20251010131331.693737314@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131331.204964167@linuxfoundation.org>
References: <20251010131331.204964167@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/android/dbitmap.h |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/android/dbitmap.h
+++ b/drivers/android/dbitmap.h
@@ -37,6 +37,7 @@ static inline void dbitmap_free(struct d
 {
 	dmap->nbits = 0;
 	kfree(dmap->map);
+	dmap->map = NULL;
 }
 
 /* Returns the nbits that a dbitmap can shrink to, 0 if not possible. */


