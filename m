Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083BF30CB24;
	Wed, 17 Sep 2025 12:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113124; cv=none; b=RqwFlvw6PCJeXbwA4rTQF7i9PHFOb4dIVvlLKwtGQMsSfqGlBdPlLf+via6f88sb8rYK9XZFLTCDpF6PlCpxwQvXS2Yjsjcqul6YMXN3OETFXaQUD/8WQyUNNx+xX9keV4Afn46HHFbk8rbS0T60E1OFuCoUONCmOC9Xua8C0H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113124; c=relaxed/simple;
	bh=AXNU05eRhL4DXLxT/ID5GSfD785TxE9Sxi3w9odhz8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b7uVQChRhLKsO1mdv3JNef5XZY201ScwdzhSzEB6mXDCPnBscJA6MoIRuar6x4UmRRDquGoRCFw0cx0QhYL5oa++fkIJ3pJzgXtYNjQjhnNipy0A+nlx0pXX9LG3CvaAdHdeQarWI2ZhVPSFyXE+lO4gWOqKr4xJJ/DfNmWJDMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cL3tvuUm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cL3tvuUm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78FB3C4CEF0;
	Wed, 17 Sep 2025 12:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113123;
	bh=AXNU05eRhL4DXLxT/ID5GSfD785TxE9Sxi3w9odhz8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cL3tvuUmEB2EMKCLciCItyY3AT12Wp1dG3wlYVIMvz19Q/c6zGiWh8MfmvB2A8nre
	 cLSbqEe9M4AmMWqOh+Ki2z2yaypmzbEzVL0i6nJROpr81zyHz7+pu99d2AWqwou7E6
	 g2OFbZlQb2Q49C+Z7sBi0+ZicQFc04B09IU2etEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wang <00107082@163.com>,
	Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.16 179/189] xhci: fix memory leak regression when freeing xhci vdev devices depth first
Date: Wed, 17 Sep 2025 14:34:49 +0200
Message-ID: <20250917123356.258651275@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit edcbe06453ddfde21f6aa763f7cab655f26133cc upstream.

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
---
 drivers/usb/host/xhci-mem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -962,7 +962,7 @@ static void xhci_free_virt_devices_depth
 out:
 	/* we are now at a leaf device */
 	xhci_debugfs_remove_slot(xhci, slot_id);
-	xhci_free_virt_device(xhci, vdev, slot_id);
+	xhci_free_virt_device(xhci, xhci->devs[slot_id], slot_id);
 }
 
 int xhci_alloc_virt_device(struct xhci_hcd *xhci, int slot_id,


