Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E06344CAF9;
	Tue, 16 Jun 2026 15:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623980; cv=none; b=iLE7rWzb8F674yNqjMwsR48L225i+WQ0ksqHayz7OL7/kSR48KCiAxeNNbtHeMUe4yZclxuWvVXZENOPSHMoQSKX/WLVVtD6IWJSyv3ts8iwe7A2XkpzNAJJKBMcndYD3GXoGu//IRo7sxLL977vyIgcR1nzZ5xjw+tneDi05JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623980; c=relaxed/simple;
	bh=yqGIdmaV3InF3wbCMy6yg8LXayiEaoexwYLmbLDJyc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+RkqDIBAWAifHXKSS90k3QDRjAk2WMyyFqHID2FOd+5ctWm1jO0BOPWx+I3qB2IyaiXew4oO7soZW0GAXZWqq7yV0KC6bEAjBfCJGQxGiCFrzoM7PtrmPGZ9DXpfa/njNlCj0BR6kEFMMtW1cuTnl1RUoTAp2PxTr8/wxJTGvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=muBWFHDf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="muBWFHDf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6D51F000E9;
	Tue, 16 Jun 2026 15:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623979;
	bh=gfj2IjYPqunEVNp6k3VLj9KPXO9ZCyofky/jd/gWuvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=muBWFHDfUzaKsbfe5dpKUY/jsZC+Tps7abcYnz4HLRB16sXUSmMjeM1aOX26NUTLG
	 eikTgmGkjLWOqTaWRILUVpq+D2+5cgTVNB6cvkvPzoUBg9MZwPIUfTBkNxpABZkaa3
	 1FbHhK8ZtHLEb5Modtmc2QfJgantbytBtsRhJyzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Meyer <kyle.meyer@hpe.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 250/378] bnxt_en: Fix NULL pointer dereference
Date: Tue, 16 Jun 2026 20:28:01 +0530
Message-ID: <20260616145123.324141600@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5656,7 +5656,7 @@ static void bnxt_disable_int_sync(struct
 {
 	int i;
 
-	if (!bp->irq_tbl)
+	if (!bp->irq_tbl || !bp->bnapi)
 		return;
 
 	atomic_inc(&bp->intr_sem);


