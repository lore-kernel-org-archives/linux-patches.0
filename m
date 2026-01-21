Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEAD43570D5;
	Wed, 21 Jan 2026 18:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020296; cv=none; b=obVe7GgZPA2Bka4qor+gYnVBhPZXnJUneCnSbRJGPZKDhbisZMxKw0ND3gJ6hMhtqsYl08kLRa+xsl46KnVvNvuak0m2/qefQYfmSIx3AuFbuTcr7WCw5W4FcNRHVq9YQPwg9UXReCcuqNuddAhMSnbEtWKWgxdEVvWFQEwQ/gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020296; c=relaxed/simple;
	bh=i1GhFdqGR8poxV26TsaaWUy3bU0waqau9JL34M0GrLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qpV0owx3bDprOoRcguAug04GtGSVWVoo7YMEJSQXDCl6FHxmZcNtAT4b8jIEM8Pckm4hOkq2RTXsM3l+Je+pFNOq+LHPuVgaeY2QhdW9V9BQnXvAZJguLfngfaU7aC7Kt5UNA5y2FV2EizX+t+DphDg/qwYvC6qrALbGsbkfvYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BGpVZJ6o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BGpVZJ6o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A42C4CEF1;
	Wed, 21 Jan 2026 18:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020296;
	bh=i1GhFdqGR8poxV26TsaaWUy3bU0waqau9JL34M0GrLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BGpVZJ6o/e01cavnlfXIVUHG8iDFN7jIA4YmgdMHtuUItmmoDQ9KWD2VPoOHJ15fA
	 wLzLYngrfuuD1KGZioV/UcgQGYwHSAHsdSKMxxTk9HZXXvqGRKpFVfEf23yaIXxWD0
	 DzZBtjVmzdD1Nzsu5va5WKhwreOidpmIom6ZDju0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Wayne Chang <waynec@nvidia.com>,
	Wei-Cheng Chen <weichengc@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>
Subject: [PATCH 6.18 117/198] usb: host: xhci-tegra: Use platform_get_irq_optional() for wake IRQs
Date: Wed, 21 Jan 2026 19:15:45 +0100
Message-ID: <20260121181422.763727413@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: Wayne Chang <waynec@nvidia.com>

commit d13b6a128a12e528bb18f971f2969feb286f45c7 upstream.

When some wake IRQs are disabled in the device tree, the corresponding
interrupt entries are removed from DT. In such cases, the driver
currently calls platform_get_irq(), which returns -ENXIO and logs
an error like:

  tegra-xusb 3610000.usb: error -ENXIO: IRQ index 2 not found

However, not all wake IRQs are mandatory. The hardware can operate
normally even if some wake sources are not defined in DT. To avoid this
false alarm and allow missing wake IRQs gracefully, use
platform_get_irq_optional() instead of platform_get_irq().

Fixes: 5df186e2ef11 ("usb: xhci: tegra: Support USB wakeup function for Tegra234")
Cc: stable <stable@kernel.org>
Signed-off-by: Wayne Chang <waynec@nvidia.com>
Signed-off-by: Wei-Cheng Chen <weichengc@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://patch.msgid.link/20260112145653.95691-1-weichengc@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-tegra.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-tegra.c
+++ b/drivers/usb/host/xhci-tegra.c
@@ -1564,7 +1564,7 @@ static int tegra_xusb_setup_wakeup(struc
 	for (i = 0; i < tegra->soc->max_num_wakes; i++) {
 		struct irq_data *data;
 
-		tegra->wake_irqs[i] = platform_get_irq(pdev, i + WAKE_IRQ_START_INDEX);
+		tegra->wake_irqs[i] = platform_get_irq_optional(pdev, i + WAKE_IRQ_START_INDEX);
 		if (tegra->wake_irqs[i] < 0)
 			break;
 


