Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1E53CAA41;
	Wed, 30 Sep 2026 19:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795544; cv=none; b=uLtSGPWA+ryqJomkiLQxAMWFSAmc2Qtt9uqK9kRBPlfhXtKHtOsnEx/4B0PGnwsVWvntDpewgT/0AtdHbY5x+0XY+UrIrSytK0d1gyqr16y7xbD+sM64cGCjMDSWh06+OuSdSgSekJ3K+i3AkJ83+6YVo3gjK9d0TkQ5P9/g1+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795544; c=relaxed/simple;
	bh=c7MiIu0Z+7IJjm/XEIN+b0O9+tpkrtzeYBc7AYlpR9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ilCkdE8pHznKOZl4+orgI4Hs8+eA+pKDP+ztJVDtmw5hIWgcUGAAmbNXcZ3b2swV+ge3w3AWnbb+ju98s2ctaWMKCCnLO+6NvQu8TzYKWrczW/MWGFFozbic//V8ita6UGicodl+TeauBoJFIvURMsE3IEoAU6Sg2BqeAR7OPRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uKCCd3Ou; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uKCCd3Ou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4C51F000FF;
	Wed, 30 Sep 2026 19:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795543;
	bh=nrfHlbjfT/GxWpeKDG0u015gwJBeOvoPy1LkafOMVVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uKCCd3OuWKZjfC2TgYOf1wobiDT7NrjStecdL7As8WtbgAhumezL4YfLmfVZSHgwl
	 iZrARhCF+GLEvVSuo+WzMbN3NO2OgQS/FjON8QE9E9kDqATESLx9SuHcvg/0CQ4w0g
	 SrQ9u6D3hGgsdzad5DQEko6rJ/pcDnlJd+Tsig4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shivaprasad G Bhat <sbhat@linux.ibm.com>,
	Amit Machhiwal <amachhiw@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.6 0597/1193] powerpc/eeh: Fix recursive locking on devices without EEH sensitive driver
Date: Wed, 30 Sep 2026 17:21:21 +0200
Message-ID: <20260930152447.506669343@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Shivaprasad G Bhat <sbhat@linux.ibm.com>

commit c5e68706527968282e49de205cc2b935823cb88a upstream.

The commit 1010b4c012b0 ("powerpc/eeh: Make EEH driver device hotplug
safe") refactored the EEH code such that the pci_rescan_remove_lock is
held at the beginning of eeh_handle_normal_event() and the
eeh_reset_device() is called with that lock being held. Looks like the
commit missed to remove the existing lock/unlock inside eeh_rmv_device()
which is no longer necessary. This is causing the eehd to hang on the
lock which it actually holds when that code path is taken.

[<0>] 0xc00000011c78f870
[<0>] __switch_to+0xfc/0x1a0
[<0>] pci_lock_rescan_remove+0x30/0x44
[<0>] eeh_rmv_device+0x290/0x2e0
[<0>] eeh_pe_dev_traverse+0x80/0x130
[<0>] eeh_reset_device+0xcc/0x23c
[<0>] eeh_handle_normal_event+0x830/0xa80
[<0>] eeh_event_handler+0xf8/0x190
[<0>] kthread+0x194/0x1b0
[<0>] start_kernel_thread+0x14/0x18

The issue is seen for cases where the errors are detected on the PHB
directly AND|OR for devices where the driver error_detected() returns
PCI_ERS_RESULT_NEED_RESET, and driver being not EEH sensitive(i.e no
error handlers like slot_reset(), resume() etc defined).

Fixes: 1010b4c012b0 ("powerpc/eeh: Make EEH driver device hotplug safe")
Cc: stable <stable@kernel.org>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Reviewed-by: Amit Machhiwal <amachhiw@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/178404937381.913.2759874335293830160.stgit@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/eeh_driver.c |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/powerpc/kernel/eeh_driver.c
+++ b/arch/powerpc/kernel/eeh_driver.c
@@ -533,9 +533,7 @@ static void eeh_rmv_device(struct eeh_de
 		if (rmv_data)
 			list_add(&edev->rmv_entry, &rmv_data->removed_vf_list);
 	} else {
-		pci_lock_rescan_remove();
 		pci_stop_and_remove_bus_device(dev);
-		pci_unlock_rescan_remove();
 	}
 }
 


