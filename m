Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8854C26FD9B;
	Tue, 17 Mar 2026 17:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767647; cv=none; b=to/xj6qs4VKPqe7mF2A+DWLZZQekDpszGeDKBYQxIDJ/aihc84UroNTzJ7qJTZiYE2jXLGxcBhK5Zs91caMxxfZ7ovZSipAcIfYtpVUR7q6b6sOI+j9JhyHdYacnYohDEHAkz0CVIpHqQR8GxsA/Bt2dGfLyjEQUYqXVraP9obI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767647; c=relaxed/simple;
	bh=QFVg//+h6Re0Tc2xoKx+/sSjlSOipII10FbcNnMGk0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u/NKVufvWnn+LlWyFSgD7YWYvWIVbNU90/JKuO2s83PmF8bAfDCyjkChK3Tw6At8tY6VPlrH8L9gChFHEkiD8PfU9wp4Z7P9EvIfn7ZOh5er3dSPqMMDT6FTnXdiU5JJ8Kt5UeyYSqkchiJPjjpUhC+6Zfsek7vs/0IXHUzNNGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TzaUSgnU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TzaUSgnU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88AD6C4CEF7;
	Tue, 17 Mar 2026 17:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767647;
	bh=QFVg//+h6Re0Tc2xoKx+/sSjlSOipII10FbcNnMGk0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TzaUSgnUHecK963fpidDjy+D8PsGvC829dO02juRYQ1wTX6Fw4Di8rokkSt8N0c5/
	 WAGGf62Z5bLuD/Mfi/iJVctCUazTMlZvV9PhERcSlJpjrK8yG0J5o7Z5mODAOKBvE6
	 nAGxG7HEC6hk+XEjzyO3e9BPK0khEAhyywzC7o+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dayu Jiang <jiangdayu@xiaomi.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.18 130/333] usb: xhci: Prevent interrupt storm on host controller error (HCE)
Date: Tue, 17 Mar 2026 17:32:39 +0100
Message-ID: <20260317163004.184352266@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dayu Jiang <jiangdayu@xiaomi.com>

commit d6d5febd12452b7fd951fdd15c3ec262f01901a4 upstream.

The xHCI controller reports a Host Controller Error (HCE) in UAS Storage
Device plug/unplug scenarios on Android devices. HCE is checked in
xhci_irq() function and causes an interrupt storm (since the interrupt
isn’t cleared), leading to severe system-level faults.

When the xHC controller reports HCE in the interrupt handler, the driver
only logs a warning and assumes xHC activity will stop as stated in xHCI
specification. An interrupt storm does however continue on some hosts
even after HCE, and only ceases after manually disabling xHC interrupt
and stopping the controller by calling xhci_halt().

Add xhci_halt() to xhci_irq() function where STS_HCE status is checked,
mirroring the existing error handling pattern used for STS_FATAL errors.

This only fixes the interrupt storm. Proper HCE recovery requires resetting
and re-initializing the xHC.

CC: stable@vger.kernel.org
Signed-off-by: Dayu Jiang <jiangdayu@xiaomi.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20260304223639.3882398-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -3224,6 +3224,7 @@ irqreturn_t xhci_irq(struct usb_hcd *hcd
 
 	if (status & STS_HCE) {
 		xhci_warn(xhci, "WARNING: Host Controller Error\n");
+		xhci_halt(xhci);
 		goto out;
 	}
 


