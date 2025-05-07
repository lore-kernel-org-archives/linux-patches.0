Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30444211278;
	Wed,  7 May 2025 19:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645208; cv=none; b=Z5tkDQvdnOAavMs1uTCUnpEHRmfopOdZtFwIO8FrJmkmQlzecNr7D4eHYUBLCQUIEkQXQhqcj6dqEJGzuHE2UtADTMZAJy3KZ1vbClBldmKtuVwTUZ0RCaCOJHF2zBHAGOvm8ybwyWutW7MvQoo6RESa0tKxSnT/VfrHdvfWCJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645208; c=relaxed/simple;
	bh=XwZw1500AiPYYCDl1dSIqiG4BMz+XwV9aO3wQW3Mt9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kKQ9vAQ4zhsOIyqzT7zmfXakXVjtOjNew/5rZAmeZKaU1HO3dxv/wtgAr+Q4e1Zh+t9C1faIffP7jGKgmRJAQRi+Ly8LKzgMT0sLsZckEk9w+E+bkSODYPIXlpgZEvL/Yq1dDRVR5l2p224BF8tCWlMovkYL8RhR7YVNmEsu+do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TWlegcjs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TWlegcjs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9980C4CEE2;
	Wed,  7 May 2025 19:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645208;
	bh=XwZw1500AiPYYCDl1dSIqiG4BMz+XwV9aO3wQW3Mt9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TWlegcjsHiPHB28/gssL6Njc6t9iMa7osSTtEqyEFfxKnsu8e+kZ/jVFRyyXyVPN5
	 Rhau17iOmBf2AHNxHRcpk2mesv9glgdvAJ96BBAo6k0UMmX4/pPGUwJFHZcnzQeaPO
	 ETcq4HtdXEVV660SSUgpmhkqDcuMZpYPRt6pwDEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.6 129/129] xhci: fix possible null pointer dereference at secondary interrupter removal
Date: Wed,  7 May 2025 20:41:05 +0200
Message-ID: <20250507183818.822076502@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit a54a594d72f25b08f39d743880a76721fba9ae77 upstream.

Don't try to remove a secondary interrupter that is known to be invalid.
Also check if the interrupter is valid inside the spinlock that protects
the array of interrupters.

Found by smatch static checker

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/linux-usb/ffaa0a1b-5984-4a1f-bfd3-9184630a97b9@moroto.mountain/
Fixes: c99b38c41234 ("xhci: add support to allocate several interrupters")
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20240125152737.2983959-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-mem.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1855,14 +1855,14 @@ void xhci_remove_secondary_interrupter(s
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
 	unsigned int intr_num;
 
+	spin_lock_irq(&xhci->lock);
+
 	/* interrupter 0 is primary interrupter, don't touch it */
-	if (!ir || !ir->intr_num || ir->intr_num >= xhci->max_interrupters)
+	if (!ir || !ir->intr_num || ir->intr_num >= xhci->max_interrupters) {
 		xhci_dbg(xhci, "Invalid secondary interrupter, can't remove\n");
-
-	/* fixme, should we check xhci->interrupter[intr_num] == ir */
-	/* fixme locking */
-
-	spin_lock_irq(&xhci->lock);
+		spin_unlock_irq(&xhci->lock);
+		return;
+	}
 
 	intr_num = ir->intr_num;
 


