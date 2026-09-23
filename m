Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1AD3A255A;
	Wed, 23 Sep 2026 14:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173803; cv=none; b=RoCxcipeFsuymQUWdJC1kQwCxMwALMvePdYpxiX02epG4ThRZ9e9kfg91H1b1cnmbE0Od97eL2EOluAAN348hkJUOKpofRkWSre6v+DCsABx5UreddjYDTxQgyewGcSS9PqGb6MC6yh8TztbQPG7A/Z9abz4spo8yNIkPR9GKpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173803; c=relaxed/simple;
	bh=NbGNRLc1VFfFtcpst2mWEOL7r25roeTSzm1nfUfCYBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/S9qRWhfa8xYnwHAWYEDbroYkiLIqRlDVt9cF9wijbnEK6boaP8LoYfNLJUwnBPsrXPxEJGtDtSv5Ik+za3wvWYp8x0j7qRGT1fjH1oRKyFowpUE9aqu+xaw8KkHGKCWwmSUHEjLcbh7ALOjvAsv/Bqvls5VNXmylJOANuz3Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F5Jr9C87; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F5Jr9C87"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7976A1F000FF;
	Wed, 23 Sep 2026 14:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173802;
	bh=pSNJqW6k+zya0opnTjMh8OFC7ILoPpo/s+yXjrMKcpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F5Jr9C876Ofdo2lWmzg3oZFlCEnXcau8HkyG9SzBGik+IhxvFcrY2PhfYTndEMe/L
	 iMlVir/Iw5xNR+rkbXOGXZ3aw6bXsDJWbk6bt2Np0QiY5HikKXIGYFI8nyBVh/+fje
	 pnBztIIsbaW75yHVmNcKCFNzs2kdsS2jaQ1P8hMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuhei Takeshita <jyohuku.alterego@gmail.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 7.2 331/438] IB/hfi1: Resolve the credit-return buffer through the send contexts node
Date: Wed, 23 Sep 2026 16:05:52 +0200
Message-ID: <20260923140653.390088948@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuhei Takeshita <jyohuku.alterego@gmail.com>

commit 975396b9e5a4028e649f4b9a6a5ca5dfb76a824b upstream.

hfi1_file_mmap()'s PIO_CRED case derives this context's credit-return
page offset, and the DMA handle for it, from dd->cr_base[uctxt->numa_id].
uctxt->numa_id is the node of whichever CPU the process happened to be
running on, but the entry itself lives in the credit-return allocation of
the send context's own node:

	sc->hw_free = &sc->dd->cr_base[sc->node].va[gc].cr[index];

and user send contexts are allocated with sc_alloc(dd, SC_USER, ...,
dd->node), the HFI-local node.  On a multi-socket host with the process
running off that node the two allocations differ, so the subtraction
produces an offset into an unrelated buffer and the DMA handle belongs to
the wrong allocation.

Use the send context's own node for all three references.  The
continuation lines are reindented at the same time; they mixed spaces and
tabs.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Cc: stable@vger.kernel.org
Signed-off-by: Shuhei Takeshita <jyohuku.alterego@gmail.com>
Link: https://patch.msgid.link/20260809032743.2671579-2-jyohuku.alterego@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -382,10 +382,10 @@ static int hfi1_file_mmap(struct file *f
 		 * of enabled contexts > 64 and 128 respectively).
 		 */
 		cr_page_offset = ((u64)uctxt->sc->hw_free -
-			  	     (u64)dd->cr_base[uctxt->numa_id].va) &
-				   PAGE_MASK;
-		memvirt = dd->cr_base[uctxt->numa_id].va + cr_page_offset;
-		memdma = dd->cr_base[uctxt->numa_id].dma + cr_page_offset;
+				  (u64)dd->cr_base[uctxt->sc->node].va) &
+				 PAGE_MASK;
+		memvirt = dd->cr_base[uctxt->sc->node].va + cr_page_offset;
+		memdma = dd->cr_base[uctxt->sc->node].dma + cr_page_offset;
 		memlen = PAGE_SIZE;
 		flags &= ~VM_MAYWRITE;
 		flags |= VM_DONTCOPY | VM_DONTEXPAND;


