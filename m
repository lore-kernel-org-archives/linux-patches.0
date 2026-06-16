Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239AF283FE5;
	Tue, 16 Jun 2026 16:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627412; cv=none; b=qp85IlfOFGeQk0YE0/MPtBTeiva7QNg5t7UlumhE64fSO+5W396N1h7wXpNUfkYY95K9vjaTVQirsLSVbtRZ7e6Ejo7RcBv+vloeSK1ZawV3Mrni1awpFYp3hiwQMS43nFFxPj7dTFDDpllclWVkXq6V92hXTD8BBH1xoolzZiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627412; c=relaxed/simple;
	bh=EINVZfGJs9nBvFe7I6phhxrp9GxqSdE6FyEkgi/67lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p1Xa8koHGMPFePoQdjGMTxkCGsUkzt6qz0QkPmTFFdCDFUwyGrE8US5wd9BpObhP25CV4Tl3aV64HaSUD8xaoxWAX45NaHFGsEN7Aa5QAAK6CBCR01yiqmJ7IbjAGstPwyHNpLtbivPfenpJGuBkWlnbAHP81Uwnoff26kgAY9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZPRpkhuB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZPRpkhuB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC9C1F000E9;
	Tue, 16 Jun 2026 16:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627411;
	bh=PE0yt3kpl24rrRgL/fGPqiRu+DI+RfWvRXeZl/xplQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZPRpkhuBXAofzSkrbJzXyZQ8E2rj/FSiHngul+YL4vg5ca8nyTN+LjPl3pwFWZaIC
	 8S6Z0l8O9RprSwBpSefzJMn92Xos0OnWHFR1NUJnUNLuahiRgGh4ipBQKteAG7uT4q
	 jSB6m85BZJCr64phLVaklokUvIcxbyNuSbj/XAi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Meyer <kyle.meyer@hpe.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 166/261] bnxt_en: Fix NULL pointer dereference
Date: Tue, 16 Jun 2026 20:30:04 +0530
Message-ID: <20260616145052.764755634@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

From: Kyle Meyer <kyle.meyer@hpe.com>

commit d930276f2cddd0b7294cac7a8fe7b877f6d9e08d upstream.

PCIe errors detected by a Root Port or Downstream Port cause error
recovery services to run on all subordinate devices regardless of
administrative state.

The .error_detected() callback, bnxt_io_error_detected(), disables
and synchronizes IRQs via bnxt_disable_int_sync(), which calls
bnxt_cp_num_to_irq_num() to map completion rings to IRQs using
bp->bnapi.

Since bp->bnapi is allocated on NIC open and freed on NIC close, PCIe
error recovery on a closed NIC can dereference a NULL pointer.

Check if bp->bnapi is NULL before disabling and synchronizing IRQs.

Fixes: e5811b8c09df ("bnxt_en: Add IRQ remapping logic.")
Cc: stable@vger.kernel.org
Signed-off-by: Kyle Meyer <kyle.meyer@hpe.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Link: https://patch.msgid.link/aiNM1CY2-StPilxW@hpe.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -5419,7 +5419,7 @@ static void bnxt_disable_int_sync(struct
 {
 	int i;
 
-	if (!bp->irq_tbl)
+	if (!bp->irq_tbl || !bp->bnapi)
 		return;
 
 	atomic_inc(&bp->intr_sem);


