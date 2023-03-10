Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D487846C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:34:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB63C4339B;
	Fri, 10 Mar 2023 14:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458847;
	bh=mxTeQGmIFFUDS6wM4oUvN7vB3/pjqRWDhUqFxPJ9n2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1gl3cS9H4f/e6gmV7sls5FgZKi2PIOI7jXgFiUyBv5CU9fE0pCORItyqSM3NMF3c8
	 /8qy2P8wQXdK6ZBJTw5VJ+KDk53oJViFB4uJlx+Gj4O8YL6UWe9GLMgQ8kysjG/Qcm
	 6+wClr0E77ZhrkQ5ooKyOQIhTC+5vhNkERJJ9eFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahesh Salgaonkar <mahesh@linux.ibm.com>,
	Ganesh Goudar <ganeshgr@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 164/357] powerpc/eeh: Set channel state after notifying the drivers
Date: Fri, 10 Mar 2023 14:37:33 +0100
Message-Id: <20230310133741.953279881@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
index ee12e335fed8f..68decc2bf42bc 100644
--- a/arch/powerpc/kernel/eeh_driver.c
+++ b/arch/powerpc/kernel/eeh_driver.c
@@ -1087,10 +1087,10 @@ void eeh_handle_normal_event(struct eeh_pe *pe)
 	eeh_slot_error_detail(pe, EEH_LOG_PERM);
 
 	/* Notify all devices that they're about to go down. */
-	eeh_set_channel_state(pe, pci_channel_io_perm_failure);
 	eeh_set_irq_state(pe, false);
 	eeh_pe_report("error_detected(permanent failure)", pe,
 		      eeh_report_failure, NULL);
+	eeh_set_channel_state(pe, pci_channel_io_perm_failure);
 
 	/* Mark the PE to be removed permanently */
 	eeh_pe_state_mark(pe, EEH_PE_REMOVED);
@@ -1207,10 +1207,10 @@ void eeh_handle_special_event(void)
 
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
2.39.2



