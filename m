Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593C923535A;
	Mon, 12 May 2025 17:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072478; cv=none; b=gcwJd81lIqtzfZyaphj65RLnoKXUjncZsu+fUrCuQZDOhW051FxnXRRMfazBOOn52Oj3qeKwYQ9nWaQNF9eZgTaCS8Sxe0dnfvmzl/VP4MZf5PB6LoCbdVQDlhVlUCflGwdQuImsm4/JRKHCXNuZgovh757N2OGIXbR1a3neX5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072478; c=relaxed/simple;
	bh=PhiWZ/e3wESfqnd0jRugk8u4XP8ZjGsWPtL4+fUtaRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEkH3e3n/fOvxi+2W8w5gtJTdg6p91eZpFxAUyEBSueH2s3ShPc2zJ6W+g0ERpGoZNW4bl2EK7dW1V4vqBhimU7y7KNpdzrs0+A9Rgvi9H9JDC0WFZkoIRGgQ8Xvy+5F9n7fQaj4EyeuZipK1FOfetDGG9Y9BvGPsv362UR+4CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=udMu+DBv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="udMu+DBv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA6FC4CEE7;
	Mon, 12 May 2025 17:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072478;
	bh=PhiWZ/e3wESfqnd0jRugk8u4XP8ZjGsWPtL4+fUtaRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=udMu+DBvQm/EZMQh5QFLkxUOs3tLmGqFOHLGLaqEllTmFeZDJ/S81Y0Ul0XV2coqm
	 QJ5moxGU50c5lCDj3AFefEgIdxuSnEBepnVZrJLOv01NicHeFfqXSHR0GvMQUwuiCc
	 QHQr3STzw08I6g8CCp2cQj+NulZZnx0afVqgNmQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Wayne Chang <waynec@nvidia.com>
Subject: [PATCH 6.1 52/92] usb: gadget: tegra-xudc: ACK ST_RC after clearing CTRL_RUN
Date: Mon, 12 May 2025 19:45:27 +0200
Message-ID: <20250512172025.236239125@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayne Chang <waynec@nvidia.com>

commit 59820fde001500c167342257650541280c622b73 upstream.

We identified a bug where the ST_RC bit in the status register was not
being acknowledged after clearing the CTRL_RUN bit in the control
register. This could lead to unexpected behavior in the USB gadget
drivers.

This patch resolves the issue by adding the necessary code to explicitly
acknowledge ST_RC after clearing CTRL_RUN based on the programming
sequence, ensuring proper state transition.

Fixes: 49db427232fe ("usb: gadget: Add UDC driver for tegra XUSB device mode controller")
Cc: stable <stable@kernel.org>
Signed-off-by: Wayne Chang <waynec@nvidia.com>
Link: https://lore.kernel.org/r/20250418081228.1194779-1-waynec@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/tegra-xudc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/gadget/udc/tegra-xudc.c
+++ b/drivers/usb/gadget/udc/tegra-xudc.c
@@ -1743,6 +1743,10 @@ static int __tegra_xudc_ep_disable(struc
 		val = xudc_readl(xudc, CTRL);
 		val &= ~CTRL_RUN;
 		xudc_writel(xudc, val, CTRL);
+
+		val = xudc_readl(xudc, ST);
+		if (val & ST_RC)
+			xudc_writel(xudc, ST_RC, ST);
 	}
 
 	dev_info(xudc->dev, "ep %u disabled\n", ep->index);


