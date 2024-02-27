Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A520713A26F;
	Tue, 27 Feb 2024 14:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042953; cv=none; b=o0Iya5Re3FYpwU923os1XavMKoGZUvrapFW5WFVXFoRITT9Ye0IT2SQ2eVDPjCsqtNIArEZyNvek5gIn5H8e0ORVHnA0cfRiYml9k2NlWdcxj/o2EFfNbvE12wZdagjhs2UE8uQozG12caS8p/BGOXjxuyOYgqTYdlgHbXTU9D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042953; c=relaxed/simple;
	bh=z9f8TkcscV/K1WDIm6iO8B05+k7D2SjnfwAzKGiJy0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMkApn3dvsI0QJ94XgUtASyZcVswGK10t4obG21kgWjsg3FEwM7fTopW6EUCL/p1DSIrXY+D4IZBUxG59N9KpeK1mQr2olYJ8uWHoCqq4FbOwb3fWqj58/AQgVlzRQc+qP03RxYs25Yki2JiQvoEO7AB3TOQrKV6VrzU64uo4Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i4Q8p0Nd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i4Q8p0Nd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32634C433F1;
	Tue, 27 Feb 2024 14:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042953;
	bh=z9f8TkcscV/K1WDIm6iO8B05+k7D2SjnfwAzKGiJy0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i4Q8p0NdwdddWz7qUVIrBCiJP+LwmAefQOIeviYKePeTlR44vxLP4Gq3uesENLi/y
	 MmAajT9ZGX9RaOY4fQ22TFV2txAe5g7zPulunIVKZlLApInynFI5KXwKpE4wcO54Zq
	 XFYpy92d1raCT7J32J8H7qhF9TRHMc0DTMf+jUeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Axtens <dja@axtens.net>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 153/245] powerpc/eeh: Small refactor of eeh_handle_normal_event()
Date: Tue, 27 Feb 2024 14:25:41 +0100
Message-ID: <20240227131620.190746245@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Axtens <dja@axtens.net>

[ Upstream commit 10b34ece132ee46dc4e6459c765d180c422a09fa ]

The control flow of eeh_handle_normal_event() is a bit tricky.

Break out one of the error handling paths - rather than be in an else
block, we'll make it part of the regular body of the function and put a
'goto out;' in the true limb of the if.

Signed-off-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211015070628.1331635-1-dja@axtens.net
Stable-dep-of: 9efcdaac36e1 ("powerpc/eeh: Set channel state after notifying the drivers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/eeh_driver.c | 69 ++++++++++++++++----------------
 1 file changed, 35 insertions(+), 34 deletions(-)

diff --git a/arch/powerpc/kernel/eeh_driver.c b/arch/powerpc/kernel/eeh_driver.c
index 3eff6a4888e79..cb3ac555c9446 100644
--- a/arch/powerpc/kernel/eeh_driver.c
+++ b/arch/powerpc/kernel/eeh_driver.c
@@ -1054,45 +1054,46 @@ void eeh_handle_normal_event(struct eeh_pe *pe)
 		}
 
 		pr_info("EEH: Recovery successful.\n");
-	} else  {
-		/*
-		 * About 90% of all real-life EEH failures in the field
-		 * are due to poorly seated PCI cards. Only 10% or so are
-		 * due to actual, failed cards.
-		 */
-		pr_err("EEH: Unable to recover from failure from PHB#%x-PE#%x.\n"
-		       "Please try reseating or replacing it\n",
-			pe->phb->global_number, pe->addr);
+		goto out;
+	}
 
-		eeh_slot_error_detail(pe, EEH_LOG_PERM);
+	/*
+	 * About 90% of all real-life EEH failures in the field
+	 * are due to poorly seated PCI cards. Only 10% or so are
+	 * due to actual, failed cards.
+	 */
+	pr_err("EEH: Unable to recover from failure from PHB#%x-PE#%x.\n"
+		"Please try reseating or replacing it\n",
+		pe->phb->global_number, pe->addr);
 
-		/* Notify all devices that they're about to go down. */
-		eeh_set_channel_state(pe, pci_channel_io_perm_failure);
-		eeh_set_irq_state(pe, false);
-		eeh_pe_report("error_detected(permanent failure)", pe,
-			      eeh_report_failure, NULL);
+	eeh_slot_error_detail(pe, EEH_LOG_PERM);
 
-		/* Mark the PE to be removed permanently */
-		eeh_pe_state_mark(pe, EEH_PE_REMOVED);
+	/* Notify all devices that they're about to go down. */
+	eeh_set_channel_state(pe, pci_channel_io_perm_failure);
+	eeh_set_irq_state(pe, false);
+	eeh_pe_report("error_detected(permanent failure)", pe,
+		      eeh_report_failure, NULL);
 
-		/*
-		 * Shut down the device drivers for good. We mark
-		 * all removed devices correctly to avoid access
-		 * the their PCI config any more.
-		 */
-		if (pe->type & EEH_PE_VF) {
-			eeh_pe_dev_traverse(pe, eeh_rmv_device, NULL);
-			eeh_pe_dev_mode_mark(pe, EEH_DEV_REMOVED);
-		} else {
-			eeh_pe_state_clear(pe, EEH_PE_PRI_BUS, true);
-			eeh_pe_dev_mode_mark(pe, EEH_DEV_REMOVED);
+	/* Mark the PE to be removed permanently */
+	eeh_pe_state_mark(pe, EEH_PE_REMOVED);
 
-			pci_lock_rescan_remove();
-			pci_hp_remove_devices(bus);
-			pci_unlock_rescan_remove();
-			/* The passed PE should no longer be used */
-			return;
-		}
+	/*
+	 * Shut down the device drivers for good. We mark
+	 * all removed devices correctly to avoid access
+	 * the their PCI config any more.
+	 */
+	if (pe->type & EEH_PE_VF) {
+		eeh_pe_dev_traverse(pe, eeh_rmv_device, NULL);
+		eeh_pe_dev_mode_mark(pe, EEH_DEV_REMOVED);
+	} else {
+		eeh_pe_state_clear(pe, EEH_PE_PRI_BUS, true);
+		eeh_pe_dev_mode_mark(pe, EEH_DEV_REMOVED);
+
+		pci_lock_rescan_remove();
+		pci_hp_remove_devices(bus);
+		pci_unlock_rescan_remove();
+		/* The passed PE should no longer be used */
+		return;
 	}
 
 out:
-- 
2.43.0



