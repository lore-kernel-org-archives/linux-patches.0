Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4A2397E81;
	Thu,  2 Jul 2026 16:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009605; cv=none; b=bzOn0zCPV3xggDUbkksaLHJ7zGYoBJAo4yej1hAia+KZlmB9y6qtv8hfc1D59wuelL4SbOVFVsIX+Xqg/fSKwK2gbRgZENTNCVGJ3tsiFAKXKJ7OObxSZfsOm+lQe5kgTIJKS1CAYhW9ROvi2EWoY4GU/N5oPDEgDfssFdMaLoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009605; c=relaxed/simple;
	bh=yTSTeNk3K1sCqQlHLX0A0aiEgm/byLi6VO5dLGNFG5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lh9ba/pAgDSo/OTHTmm/BsI8d45UPOggegGP0Y/vbHKTQ9QqCWokqVKSCCXASJ8T2y8T6sKjIgw27oMn6eRKpl1tuoQ2hYHCNhWqSUhMg6D+zTMHpstdUabR+RVC5yuKxUD+dx2pChKwM5US/+xTOfbEnuUjw8AKN2WNxWOqnV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z/X7w/t5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z/X7w/t5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E081F00A3A;
	Thu,  2 Jul 2026 16:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009602;
	bh=JEHJAVBVMkDrmbsAvMsHd6M6+BKqT5dlBwaCdX0W+hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z/X7w/t5QVReSBu4zlDSaOsnVmGB6ZnH09jBYLnOBx6EbIu2G/4korWG8OlnD71fk
	 YUn6cQUgu7jd0bjx6Mtj61RIRNlKJE7uWPnVxXxYcfen2lN0pgAho9syHiD5H8abHz
	 nj9JSaf7w3eLDoM8TlOz/LXj8sWmNh9vKGp6Z2+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wang <00107082@163.com>,
	Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Justin Chen <justin.chen@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 18/95] xhci: fix memory leak regression when freeing xhci vdev devices depth first
Date: Thu,  2 Jul 2026 18:19:21 +0200
Message-ID: <20260702155109.589842234@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
References: <20260702155109.196223802@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit edcbe06453ddfde21f6aa763f7cab655f26133cc upstream

Suspend-resume cycle test revealed a memory leak in 6.17-rc3

Turns out the slot_id race fix changes accidentally ends up calling
xhci_free_virt_device() with an incorrect vdev parameter.
The vdev variable was reused for temporary purposes right before calling
xhci_free_virt_device().

Fix this by passing the correct vdev parameter.

The slot_id race fix that caused this regression was targeted for stable,
so this needs to be applied there as well.

Fixes: 2eb03376151b ("usb: xhci: Fix slot_id resource race conflict")
Reported-by: David Wang <00107082@163.com>
Closes: https://lore.kernel.org/linux-usb/20250829181354.4450-1-00107082@163.com
Suggested-by: Michal Pecio <michal.pecio@gmail.com>
Suggested-by: David Wang <00107082@163.com>
Cc: stable@vger.kernel.org
Tested-by: David Wang <00107082@163.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20250902105306.877476-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-mem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index fb81e61a599d75..7f75298a09d6fc 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -961,7 +961,7 @@ static void xhci_free_virt_devices_depth_first(struct xhci_hcd *xhci, int slot_i
 out:
 	/* we are now at a leaf device */
 	xhci_debugfs_remove_slot(xhci, slot_id);
-	xhci_free_virt_device(xhci, vdev, slot_id);
+	xhci_free_virt_device(xhci, xhci->devs[slot_id], slot_id);
 }
 
 int xhci_alloc_virt_device(struct xhci_hcd *xhci, int slot_id,
-- 
2.53.0



