Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6009B343D92;
	Tue, 16 Dec 2025 12:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888729; cv=none; b=VOUmOoH7SNlALgs4kXhW+FzmTu+iEubQRZ9NRxw8YZEsLM9Oma1e6blep36pXCF+GVIDI9B2msj7g47QoZdVQpcQKHCv2AgbJKZkcNSmFxmH4HSldX8q7K9RulQDSOabptoshOwRao6sfbAtjkMSLGFmYuPDtui6xAqxiVo9/kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888729; c=relaxed/simple;
	bh=9mtMaHycE5zqvcvULg7Winhym/3clsQyLDatkFhBRVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OJFgOSLdc4RxHldTGdLVaibtoUCgO7RChgmh1nfr37Rn2U8CslxXTHABS/+mgW8MmpMipScu/Urc9/y8LRyz3kEt92NBqH4Do0B1cGe/wYMvvHlx/Ft/E0wsCUkunnyZ4eUTYG1Hi4xairTPzy8WjjjnEB3rh+oUx1gs7k6zK7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cdvf1N+n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cdvf1N+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2DA8C4CEF1;
	Tue, 16 Dec 2025 12:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888729;
	bh=9mtMaHycE5zqvcvULg7Winhym/3clsQyLDatkFhBRVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cdvf1N+na5WvAvMbI4AbzVO7ELex9rPxl1+97B5gTqgheDlq/jPzePN3sWrlaT6P0
	 ktlcgqKnANaFrJ1VCmlngoD146QvPyux4jf7cMlIJDDZmk7Wl0L3BV+2a7qJbSdOhi
	 hN9aYTKppVOuWWsFpt7yJSlbM+4lYNPsDX2kn2F0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Haotien Hsu <haotienh@nvidia.com>,
	Wayne Chang <waynec@nvidia.com>
Subject: [PATCH 6.18 604/614] usb: gadget: tegra-xudc: Always reinitialize data toggle when clear halt
Date: Tue, 16 Dec 2025 12:16:11 +0100
Message-ID: <20251216111423.278659488@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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
@@ -1558,12 +1558,6 @@ static int __tegra_xudc_ep_set_halt(stru
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


