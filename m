Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22571A680D;
	Mon, 23 Mar 2026 14:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275568; cv=none; b=kdYcjqa3EDZcNOTURAzp1jRb+o92LWAKWW3aswZiXh9M4hyPdMnwDYW++O29KUZifAHwEMo0/UeMsJfN3zEhNj4ykELUxA+KJps7NgEqLFFzWdFxniMAfk+7mg237i+xu8KaCy1Hy8vROPmsQvYccxXwHU2aMwfVB/2GeH9D03M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275568; c=relaxed/simple;
	bh=GodLHv44Cdrgkq6f4f89NMq1rY6+sEkoKzDGYUxseyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MGrl1ASDHsBMlFWY1l3mJkym+028FM/nRIbkL5Hc7YRSbNUdxq0FMtZXxGohWZZNnJxF/k9oxzcB5wpPHpudhyKpRx6mFdhE9dy1ywWs7CHyagdfh0YWHHv7ZOdOmBUALkSaOzCyq/DUVpC7E5ixfc1W9+JCcOvwaCTSG4ALYR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HnuEtNs+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HnuEtNs+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2B5C2BCB1;
	Mon, 23 Mar 2026 14:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275568;
	bh=GodLHv44Cdrgkq6f4f89NMq1rY6+sEkoKzDGYUxseyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HnuEtNs+F59ngaYmkfd51qVKIwLIFXZBIZmZH87TW+LLdecM6CB66dImhn8jwlIdO
	 rcrSypboEgAiprlWDbOc1M3WfBOrWUW+ot8Yam1zwtxcou/kKfCqiyE6NlYzpJdciZ
	 08p3do/NRPG3kUCQCVaHuQLqoqfb22t1gCiLTZhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dayu Jiang <jiangdayu@xiaomi.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.12 102/460] usb: xhci: Prevent interrupt storm on host controller error (HCE)
Date: Mon, 23 Mar 2026 14:41:38 +0100
Message-ID: <20260323134529.156356608@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3200,6 +3200,7 @@ irqreturn_t xhci_irq(struct usb_hcd *hcd
 
 	if (status & STS_HCE) {
 		xhci_warn(xhci, "WARNING: Host Controller Error\n");
+		xhci_halt(xhci);
 		goto out;
 	}
 


