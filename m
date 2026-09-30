Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F07050C2A4;
	Wed, 30 Sep 2026 17:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788819; cv=none; b=PzLvHHp2l7dixq9f4D1aS5Fch9fyb32+21lq5UDarDdFX0bVKHRwQuEH9D126TyCaWi3qnmQI62F2QieYY/GbJRwDn5vHwyo+DSTeStafYJo7QJc80G3HA9YVQOCUIxryYlC2zWt7BGyPkqLiGXkIv194OvSFtYLTthimVVixDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788819; c=relaxed/simple;
	bh=wt92NRG4uB3gdhSjylwisSaCI4jr7zWx6DcTOKBp62s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WOq/tV78nM5mWjv1bG+WEzaWx7naWtnPCV0+LjZzm0DoTkoGcHdvrjj6+5XQs08LlsjCxstP1Q8ZJscOVuGOC4uO+bKsh+vn9Dsv824NpulX8PSbpOX9CTkOVq8ku1rtteujDfcaH4SLHdveNs9lmJbBRAj4VnG1/gagvqWkeqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MINXFoNC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MINXFoNC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC8E1F000FF;
	Wed, 30 Sep 2026 17:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788818;
	bh=l6GvzDIr3o5sVjPH4G6ck2bqXAsD97L6hY7+w9AFxag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MINXFoNCLHhWGs58eYouRDqXlYOyz2054ONcwGbKNENwv7FMAw7b0xWqr1u7STpAd
	 9o2rJFHqPkgwkGPHQ11XLYD0HZeVq9ziZUrU+LkNQwOxiqBlXMcokjUOKd2oQWf9Zc
	 guFgN1oW/562kI16ncUdT3vB2KMtJAJrggMDTu2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuhei Takeshita <jyohuku.alterego@gmail.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 6.12 213/877] IB/hfi1: Resolve the credit-return buffer through the send contexts node
Date: Wed, 30 Sep 2026 17:18:44 +0200
Message-ID: <20260930152419.325153992@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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


