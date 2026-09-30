Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49EF43149B;
	Wed, 30 Sep 2026 19:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797189; cv=none; b=qJpUHt4I2Mc6F/0CPm/LdxpOMvxfpJ7tkwNbTQQAU1jqmXPjxG6Zi9Fk9soyZxbUXCq5hDvIMmQ+FWbFSOwHOSiKbyfCd3xZGeWff1j8G5KiRbJlXBA4jPm1Y5j2a3UNaoDGTSwRFDzI/rxtiyex/vfC14VcwfSwoDBAZHCk82Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797189; c=relaxed/simple;
	bh=xXv7PkQMHf95Tsu8jK/l7FRKSMhIgAls3mETlWzBW48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XcBIQncYEzjDMaqyvNgyfQ9V2dBNt4kjYo5EiKQ985ss8hfEMAhnnEML3I+WwF5Z5wWwyD0CXfkgBVRK6qaetGQ99kwAHVzzHFIjcVuwQauHImBYmXfVyUIJT/nRBTxx1mzSF/+cMtRzhCobhVKA307Bqj1tF6Zh0QXcOD8Q8gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ym02fcjU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ym02fcjU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A871F000FF;
	Wed, 30 Sep 2026 19:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797187;
	bh=yQqTRWMSAAdoem8177xpHHjD7S93v5+GDpN2n0XxCQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ym02fcjUXJy2+6vykmZaEJcZPUKN1qVDSJsmvzAMGA0TvzQqEAXtIRWAfTjHjI6vc
	 Rj8zIhkJsYcRa1exCYQLl8L8eQl+ytRIBJtKq4VLBrDIf6J9lQnXLnB/7DM2Xq+h0y
	 NP0pgRioyKYpC8oWcZVXteHiENS9O1/HPIQ6qtLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Neronin <niklas.neronin@linux.intel.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1177/1193] usb: xhci: use cached HCSPARAMS1 value
Date: Wed, 30 Sep 2026 17:31:01 +0200
Message-ID: <20260930152500.391268824@linuxfoundation.org>
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

From: Niklas Neronin <niklas.neronin@linux.intel.com>

[ Upstream commit 70651cc3f5a4c7cec529f121e36ea3b45ea84778 ]

The Structural Parameters 1 (HCSPARAMS1) register is read and cached in
'xhci->hcs_params1' during host controller initialization. Since this
register is read-only and its value remains constant for the lifetime of
the controller, re-reading it later is unnecessary.

Replace subsequent register reads with the cached 'xhci->hcs_params1'
value to avoid redundant MMIO access.

Signed-off-by: Niklas Neronin <niklas.neronin@linux.intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20251119142417.2820519-15-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 78203d5b54a4 ("usb: xhci: bail out of setup if the controller is inaccessible")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4057,8 +4057,7 @@ int xhci_alloc_dev(struct usb_hcd *hcd,
 		xhci_err(xhci, "Error while assigning device slot ID: %s\n",
 			 xhci_trb_comp_code_string(command->status));
 		xhci_err(xhci, "Max number of devices this xHCI host supports is %u.\n",
-				HCS_MAX_SLOTS(
-					readl(&xhci->cap_regs->hcs_params1)));
+			 HCS_MAX_SLOTS(xhci->hcs_params1));
 		xhci_free_command(xhci, command);
 		return 0;
 	}


