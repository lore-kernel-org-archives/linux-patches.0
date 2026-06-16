Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C910647B435;
	Tue, 16 Jun 2026 17:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631808; cv=none; b=Vg5qS3YXXc4ztIC9S4o8wDhzLE1AHYJMKDdiT3kT8tiqsSH3o98q9H8tvgllB4r9BjZ8tZCKNrWixIsJ1DVirayrsDejZO26Z7KWIN/T3hIYrHSXuMEDLlHT6fMQYNwhmf0eXOfpzJ6ZwG4rUTidUKtpinszotKr1Mx2iiE+qOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631808; c=relaxed/simple;
	bh=9dc5G6seCq12tpje0xJE9BsPHrwRC8N0Hz+YANXNrsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iMeqnkdJhhS30YgRRIHbIQy/0ycdQtyprRIH7bP8Jrkz9y4otmP3VeJZA7a1nNNWLLEbr6ePVzu++nNVdSBWo7vUmVrJaH8AbFx2PJdzf1jz6JL/9QMZEqxx86m/m9wXhAqOkPZ5QD33lON3H5uwDtjBAYDvuLku9yEpcegE3CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1xJvkX++; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1xJvkX++"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891C61F000E9;
	Tue, 16 Jun 2026 17:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631805;
	bh=jg5UGbmLmDfe48D3KBR0XGUfqC8JV/vexl0xKQ5Guuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1xJvkX++EEHQRkMSTAl4F6uC3v4cgh+EwackNFdAVBigPJUSg7JNAHarvTvvTQ1H9
	 d3DwOh5bCRVq63hoJbE3L1VDPj6Pc51HDvVLVcXi3qcgr1fRgqB+zYkjbr9sKQfnPv
	 o3qLwQGnpR4u8IWa7ZW6wQScTQcSIkmycw2TfqyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Meyer <kyle.meyer@hpe.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 291/522] bnxt_en: Fix NULL pointer dereference
Date: Tue, 16 Jun 2026 20:27:18 +0530
Message-ID: <20260616145139.542083753@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4747,7 +4747,7 @@ static void bnxt_disable_int_sync(struct
 {
 	int i;
 
-	if (!bp->irq_tbl)
+	if (!bp->irq_tbl || !bp->bnapi)
 		return;
 
 	atomic_inc(&bp->intr_sem);


