Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26D781ADA;
	Tue,  3 Dec 2024 16:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242329; cv=none; b=SvtpsZPI/RToptSV/KtGkAE4OZGnVnRsePXgWbqP6WAhv3sSHkvVueElkydzLOLLLvzs6h8yasbswu1ZCpL4KYrRaJxZ87LA2rZ05u2u0nUMk7dZraHR0n1FiOqNhObkVfr77HROnUnK/aMEvmbju+QlmGcYqskL7oe3T7XnT9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242329; c=relaxed/simple;
	bh=Dq9Erp+CEqs9qTN5RDmQqLFzUZ7OaafHvQhLnOZvW7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LfWWT6tb01z1jj5f+QKNOmW7YFEq0YIW8lYnYjVdL5EZ9nVOGnBmgAHsJkx37DHvdKU0lGFnLj76EOm1wFTMv4uZSXqUBifntOy05S3mcETmiYGkWMpJsjowBtuWsu+pG2wOQxoqoMYUqCKkQPXgqCBV4F9BKr21NRRnS4gtmyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fXXfWBwR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fXXfWBwR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ACE5C4CECF;
	Tue,  3 Dec 2024 16:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242329;
	bh=Dq9Erp+CEqs9qTN5RDmQqLFzUZ7OaafHvQhLnOZvW7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fXXfWBwRp6Jx9JVFk79ZHKYGhUrokli4F/nPjyNF8bEq4x/W4hpHUNLygKkuEvWZ3
	 17Dxln60LtqPjWrf+IY7AVVEFNyEVZEIfOTACmsLkHV0bH9oPpLUNK0Y8FWSDKu8Fn
	 4wx//0DzXC0SdFZZih6oLSTGv7YK70LcLriJybTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuangyi Chiang <ki.chiang65@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.12 674/826] xhci: Dont perform Soft Retry for Etron xHCI host
Date: Tue,  3 Dec 2024 15:46:41 +0100
Message-ID: <20241203144810.045924381@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuangyi Chiang <ki.chiang65@gmail.com>

commit e735e957f2b9cfe4be486e0304732ec36928591f upstream.

Since commit f8f80be501aa ("xhci: Use soft retry to recover faster from
transaction errors"), unplugging USB device while enumeration results in
errors like this:

[ 364.855321] xhci_hcd 0000:0b:00.0: ERROR Transfer event for disabled endpoint slot 5 ep 2
[ 364.864622] xhci_hcd 0000:0b:00.0: @0000002167656d70 67f03000 00000021 0c000000 05038001
[ 374.934793] xhci_hcd 0000:0b:00.0: Abort failed to stop command ring: -110
[ 374.958793] xhci_hcd 0000:0b:00.0: xHCI host controller not responding, assume dead
[ 374.967590] xhci_hcd 0000:0b:00.0: HC died; cleaning up
[ 374.973984] xhci_hcd 0000:0b:00.0: Timeout while waiting for configure endpoint command

Seems that Etorn xHCI host can not perform Soft Retry correctly, apply
XHCI_NO_SOFT_RETRY quirk to disable Soft Retry and then issue is gone.

This patch depends on commit a4a251f8c235 ("usb: xhci: do not perform
Soft Retry for some xHCI hosts").

Fixes: f8f80be501aa ("xhci: Use soft retry to recover faster from transaction errors")
Cc: stable@vger.kernel.org
Signed-off-by: Kuangyi Chiang <ki.chiang65@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20241106101459.775897-21-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -399,6 +399,7 @@ static void xhci_pci_quirks(struct devic
 	     pdev->device == PCI_DEVICE_ID_EJ188)) {
 		xhci->quirks |= XHCI_RESET_ON_RESUME;
 		xhci->quirks |= XHCI_BROKEN_STREAMS;
+		xhci->quirks |= XHCI_NO_SOFT_RETRY;
 	}
 
 	if (pdev->vendor == PCI_VENDOR_ID_RENESAS &&


