Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB0458FD26;
	Wed,  9 Sep 2026 14:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964457; cv=none; b=llWa0yF19vGpTl4SjUA28OVrEDRVhqISmNIQb6M3eHCKuRJ/jlS+d10Jd1vcn2oEx8hBC0OT5ARaFcartfeCM2WnsH+sHxLX8K9KDHVuua0irFpOF34JM7UYqW4iH9utctYwoD6nzuR3HTj242BZOgByyXdvvMvzB7+TrCVCCtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964457; c=relaxed/simple;
	bh=qO8osLg3/qGZdkNlEsEgjZuxVd7kNikH49auNbjbSGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8ngld1dwlLydojeDlUMdlA6hG10caqd0YjV4F+v4SEiQj2ECgLweGIY+oKe4qKbaR3Tq/qrHWlqwAVg6zHswfqjrz9tIJGopFOnLXzKVIxo9V1KnzIeKqonYC/7BXnt3O52VLn2FH9Xv5p87tWCVVC9NQnOP1th/WpnUVv01/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ETHetn45; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ETHetn45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B9F1F00A3D;
	Wed,  9 Sep 2026 14:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964456;
	bh=I4HWcPBq2mgZhac0BlzVo+Q/bBpe5O+TtlOdD2O3ZZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ETHetn45Z55bfggL3DiL/CalZbNtqZOwofpsuwX8Rc7hqm5NO0yAkvbyzw9FEhfvJ
	 JkxfEU20CsPZ0uSiAs+8xSoi09GyWqzhi9jiCUCck6F8OTqkZVCRPytGId77cfIW/T
	 UTbUKJvDsk9zi5/YOLUIdq38A+E0Mcu2DbaqA44c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Neronin <niklas.neronin@linux.intel.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 428/583] usb: xhci: use cached HCSPARAMS1 value
Date: Wed,  9 Sep 2026 15:41:53 +0200
Message-ID: <20260909134252.817876406@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4253,8 +4253,7 @@ int xhci_alloc_dev(struct usb_hcd *hcd,
 		xhci_err(xhci, "Error while assigning device slot ID: %s\n",
 			 xhci_trb_comp_code_string(command->status));
 		xhci_err(xhci, "Max number of devices this xHCI host supports is %u.\n",
-				HCS_MAX_SLOTS(
-					readl(&xhci->cap_regs->hcs_params1)));
+			 HCS_MAX_SLOTS(xhci->hcs_params1));
 		xhci_free_command(xhci, command);
 		return 0;
 	}


