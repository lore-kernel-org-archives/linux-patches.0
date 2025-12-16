Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B703446A3;
	Tue, 16 Dec 2025 11:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884998; cv=none; b=CqZ3my1HUSlGjfHBNKcT5FasS/08gtkmmQ9XasK2X7u9ENRbIWkK1ePXEkMmJUFdCdJKsA0zNm+NrBr6lQtJ4hTaOmLue02vY0RZkvEbEVG2f5lfzeraF2r/yGig/AAZS5z6bfh2zbpv+2YymMJ7sWEKP1W8Js74Oug5T98ygug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884998; c=relaxed/simple;
	bh=QjKhx6c+jUU1iVIJMkVEfTs45JZ7dj1tkzCY2u+JBIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KbViBhnaeP4sXCYhHQZH0yMGJg4zgMmsIvf1CviIEGfFWw98ZcLI1pG9C1KUNOJHyk5WW4zGs0WP0l5XPxIHY3xaB41Sh5KSoxyBpfh+wcRbCYCALAslRGG06t2OhDBLbKp9QTbWemKiLMmcOtCud1bXXv8lXUyxpL1sgNo1GnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YNjxgOw5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YNjxgOw5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D6BC4CEF5;
	Tue, 16 Dec 2025 11:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884998;
	bh=QjKhx6c+jUU1iVIJMkVEfTs45JZ7dj1tkzCY2u+JBIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YNjxgOw5z9fioh1NzdYGiq7vmNamdC4OaUbCFqQ4PSuVuz1Odb0MyNtvDKaolexGe
	 rtrKCM8Lp6HAMkTT5twWe/NbAEm+ZS5GBI/xrDIcKNhmtkijt5GOxadiWPn3QsGMeJ
	 KyL9bfxHRX5420iAFinyupgnXm+MjSg7SthQG3TY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Haotien Hsu <haotienh@nvidia.com>,
	Wayne Chang <waynec@nvidia.com>
Subject: [PATCH 6.12 350/354] usb: gadget: tegra-xudc: Always reinitialize data toggle when clear halt
Date: Tue, 16 Dec 2025 12:15:17 +0100
Message-ID: <20251216111333.589688153@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotien Hsu <haotienh@nvidia.com>

commit 2585973c7f9ee31d21e5848c996fab2521fd383d upstream.

The driver previously skipped handling ClearFeature(ENDPOINT_HALT)
when the endpoint was already not halted. This prevented the
controller from resetting the data sequence number and reinitializing
the endpoint state.

According to USB 3.2 specification Rev. 1.1, section 9.4.5,
ClearFeature(ENDPOINT_HALT) must always reset the data sequence and
set the stream state machine to Disabled, regardless of whether the
endpoint was halted.

Remove the early return so that ClearFeature(ENDPOINT_HALT) always
resets the endpoint sequence state as required by the specification.

Fixes: 49db427232fe ("usb: gadget: Add UDC driver for tegra XUSB device mode controller")
Cc: stable <stable@kernel.org>
Signed-off-by: Haotien Hsu <haotienh@nvidia.com>
Signed-off-by: Wayne Chang <waynec@nvidia.com>
Link: https://patch.msgid.link/20251127033540.2287517-1-waynec@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/tegra-xudc.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/usb/gadget/udc/tegra-xudc.c
+++ b/drivers/usb/gadget/udc/tegra-xudc.c
@@ -1554,12 +1554,6 @@ static int __tegra_xudc_ep_set_halt(stru
 		return -ENOTSUPP;
 	}
 
-	if (!!(xudc_readl(xudc, EP_HALT) & BIT(ep->index)) == halt) {
-		dev_dbg(xudc->dev, "EP %u already %s\n", ep->index,
-			halt ? "halted" : "not halted");
-		return 0;
-	}
-
 	if (halt) {
 		ep_halt(xudc, ep->index);
 	} else {


