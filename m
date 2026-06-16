Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7228747ECC1;
	Tue, 16 Jun 2026 17:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629633; cv=none; b=UbflntEWwy499RForhehxfWDbP3I45TDrUMbH82++BY+6d8KpLeDM9v5lOJT/pMgG+5GJ+GlUn6gPu6yjQJiYFkmjqJUC/84GMRDJQtC7klcSyVXoCsFTkTVLylSozZM4xmRRSq2Mbgv7E5aUnGlPgUkXTapGLZ8dkhmpHQaeKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629633; c=relaxed/simple;
	bh=HkDe7huBlBRqEegEkr41GsB6KQI9Eh6crirk/OmN+GM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OLY68s/USyJSai2U7RpHgjrhd2ySOwWKliQR0wimkmAjFVD9HG1Mll3c7dCqgjSIKkNwpLBwtzXgPzMseevJKvMNWWiVW4+jn+2P6w9XIHWB3JpQTi4+mrZTCFSZJsf8OE5fF7CPL0+GoryyyWZhZrhHvxbj2KAXGJD4OkwFKLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MLZIehif; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MLZIehif"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6671F000E9;
	Tue, 16 Jun 2026 17:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629631;
	bh=8UlOwkiMUK8E2uQo26BeFpAadp14zPkIurnAasm3njU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MLZIehifCAvsaXxCq1Yle/vZXPfWEdvXf+ryk+CR5TfdEl2Si0UzdoHj60w25MAW/
	 z1XXgT9vBrLnyeLKg8ltHgWG7VQCGSU0fd5oW50ls9Bg4VW9O2PdbpLeDiq1btGKW6
	 QOLfueGmyGqDyUlYroN27lgfUHZ1cdSHWGCKvTdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Meyer <kyle.meyer@hpe.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 322/452] bnxt_en: Fix NULL pointer dereference
Date: Tue, 16 Jun 2026 20:29:09 +0530
Message-ID: <20260616145134.354921558@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4698,7 +4698,7 @@ static void bnxt_disable_int_sync(struct
 {
 	int i;
 
-	if (!bp->irq_tbl)
+	if (!bp->irq_tbl || !bp->bnapi)
 		return;
 
 	atomic_inc(&bp->intr_sem);


