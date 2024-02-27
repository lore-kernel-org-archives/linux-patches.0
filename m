Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0B713A26F;
	Tue, 27 Feb 2024 14:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042959; cv=none; b=jirSNtO2DkxMjG6KfZN7fu69BixhyoHb0xafLrtY09cWzuWHWeJNwlPSWm81CwR7JMp00lHaVX0oiR/8itmEPtilsgKmEFRF+v2IKA9aPWd/NIdXiizX8vnvYBpdoXM8tIyo5mVuM+LPwcZVpD6W/IGz2JDtze7olHIVouIrtw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042959; c=relaxed/simple;
	bh=yqEX0taDLPUCYTMeHwvd/MiFtqFs4Oym672OyR/d1vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/Kx3BpcW2zCXurjztK5XZ7NJmWzdMGVC0QowZOUi4xlQOjEHKsGWB/doS7rkG47H4jnU86GNZJANd5LwbyHCHXIEgg5xUKnEDd5f12AImqSHVZSd6K3E8K1/OGm620vumZGrAkuqfBC3g8dOPiGB1w+T/REg9MZIhaSmbwpJh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZLZ/A1e9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZLZ/A1e9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2EFAC433C7;
	Tue, 27 Feb 2024 14:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042959;
	bh=yqEX0taDLPUCYTMeHwvd/MiFtqFs4Oym672OyR/d1vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZLZ/A1e9EE/2fvPox1BfewUds2D+DzH9ZdaKCZasewSrV94mpKulwybztdJuNZX3A
	 OHrj53RmvgE9anagTmA3GIvfkk8aNAdiqPKoKg9N7QJ68mzc24JoIRuf1Ez4hgtUo/
	 0OqZ4OPJUMtqtUwxh1QDl1gP3aBMcVqE0lk5+CX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahesh Salgaonkar <mahesh@linux.ibm.com>,
	Ganesh Goudar <ganeshgr@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 154/245] powerpc/eeh: Set channel state after notifying the drivers
Date: Tue, 27 Feb 2024 14:25:42 +0100
Message-ID: <20240227131620.222271732@linuxfoundation.org>
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

From: Ganesh Goudar <ganeshgr@linux.ibm.com>

[ Upstream commit 9efcdaac36e1643a1b7f5337e6143ce142d381b1 ]

When a PCI error is encountered 6th time in an hour we
set the channel state to perm_failure and notify the
driver about the permanent failure.

However, after upstream commit 38ddc011478e ("powerpc/eeh:
Make permanently failed devices non-actionable"), EEH handler
stops calling any routine once the device is marked as
permanent failure. This issue can lead to fatal consequences
like kernel hang with certain PCI devices.

Following log is observed with lpfc driver, with and without
this change, Without this change kernel hangs, If PCI error
is encountered 6 times for a device in an hour.

Without the change

 EEH: Beginning: 'error_detected(permanent failure)'
 PCI 0132:60:00.0#600000: EEH: not actionable (1,1,1)
 PCI 0132:60:00.1#600000: EEH: not actionable (1,1,1)
 EEH: Finished:'error_detected(permanent failure)'

With the change

 EEH: Beginning: 'error_detected(permanent failure)'
 EEH: Invoking lpfc->error_detected(permanent failure)
 EEH: lpfc driver reports: 'disconnect'
 EEH: Invoking lpfc->error_detected(permanent failure)
 EEH: lpfc driver reports: 'disconnect'
 EEH: Finished:'error_detected(permanent failure)'

To fix the issue, set channel state to permanent failure after
notifying the drivers.

Fixes: 38ddc011478e ("powerpc/eeh: Make permanently failed devices non-actionable")
Suggested-by: Mahesh Salgaonkar <mahesh@linux.ibm.com>
Signed-off-by: Ganesh Goudar <ganeshgr@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230209105649.127707-1-ganeshgr@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/eeh_driver.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/eeh_driver.c b/arch/powerpc/kernel/eeh_driver.c
index cb3ac555c9446..665d847ef9b5a 100644
--- a/arch/powerpc/kernel/eeh_driver.c
+++ b/arch/powerpc/kernel/eeh_driver.c
@@ -1069,10 +1069,10 @@ void eeh_handle_normal_event(struct eeh_pe *pe)
 	eeh_slot_error_detail(pe, EEH_LOG_PERM);
 
 	/* Notify all devices that they're about to go down. */
-	eeh_set_channel_state(pe, pci_channel_io_perm_failure);
 	eeh_set_irq_state(pe, false);
 	eeh_pe_report("error_detected(permanent failure)", pe,
 		      eeh_report_failure, NULL);
+	eeh_set_channel_state(pe, pci_channel_io_perm_failure);
 
 	/* Mark the PE to be removed permanently */
 	eeh_pe_state_mark(pe, EEH_PE_REMOVED);
@@ -1189,10 +1189,10 @@ void eeh_handle_special_event(void)
 
 			/* Notify all devices to be down */
 			eeh_pe_state_clear(pe, EEH_PE_PRI_BUS, true);
-			eeh_set_channel_state(pe, pci_channel_io_perm_failure);
 			eeh_pe_report(
 				"error_detected(permanent failure)", pe,
 				eeh_report_failure, NULL);
+			eeh_set_channel_state(pe, pci_channel_io_perm_failure);
 
 			pci_lock_rescan_remove();
 			list_for_each_entry(hose, &hose_list, list_node) {
-- 
2.43.0



