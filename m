Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35D11946C8;
	Fri,  9 Jan 2026 12:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960124; cv=none; b=WPoFoSFqqHsrd/oNufdVATBGkXV8yRbGL4OiZP9YXUwWzgGeD6eKBGrJZWbiYq2L8NJU7bnhsB1aznDqJeH8TiMp3MvvGvehTnAYWGio4uvIGIXkCb5zFXqAlGKa7WJbiPPmPqT9E8ipDt9zIJmN59gVc24F1w7xGUv8iXGx/xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960124; c=relaxed/simple;
	bh=dWjsvSBF4V6PkMhYYBOHe9XiAMXGU/+gqCCwxcZWruA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kMOmlYhHZHTvA+bI8DkDb5+HS6SlvWgAKB3iyfoj1wunJlcgbgNo2v222U1LLiSLNGQub4foORRekc8ekCDedDmExegGCgY5BNFc+kNxxFO0agnPKHi05SEMTeBTjDE5aqFkQGQH+EYCnohNcUWmYdgq8jp770Y0btZvDfluf7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EY42gJAc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EY42gJAc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BEB1C4CEF1;
	Fri,  9 Jan 2026 12:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960123;
	bh=dWjsvSBF4V6PkMhYYBOHe9XiAMXGU/+gqCCwxcZWruA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EY42gJAcDp9VEwovJjZHYW1qWxLUPNGhixb5ykHXrK3NR402aKE2KyIOdQv7o0Yp4
	 Wi9fXkWoyORIpI8eP4gkp7hiQ3hymMSC0hmyrYuWLA++Aw7M+1JfSyPY0+Hp52Di5K
	 PrKFQvUums/Hl3Lzqb/p6mAmH1QJW6wgmJeG2UEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Haotien Hsu <haotienh@nvidia.com>,
	Wayne Chang <waynec@nvidia.com>
Subject: [PATCH 6.6 294/737] usb: gadget: tegra-xudc: Always reinitialize data toggle when clear halt
Date: Fri,  9 Jan 2026 12:37:13 +0100
Message-ID: <20260109112145.070701861@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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


