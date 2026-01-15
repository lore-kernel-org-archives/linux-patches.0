Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBA13BF2E7;
	Thu, 15 Jan 2026 17:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497775; cv=none; b=R1q8a7RdXZJdPbEQHqpRjrSRWhUeKZvgJa+EUthVEgiA51b3Q9lsVpAzzAO3hXgp/P7uvg74HsBEZM+EqcalF+J+Dtu05j1pHv66boeGNuVVRq8RNi6VlWyopRU4j6mFLaYbWHEEo4zu0vxBbVHyLwKYGGKyzAyIgtrRboArwcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497775; c=relaxed/simple;
	bh=EQo+azW+sWfFB3cQ/MkhD7I1yfbN77ipxXzwWE2yvCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zpy48sDGzPHfeQPZqC7PMDsTBiEnCd+DV017OXqMjwt6ivWE784nq33LJjuZkOOMvNXaDw8MWZ5oqqvr4LRaIF6Nk/Raq3OoCmkSz/c9nTyRIu5xlHQ3gY/htxkdDk/vmtz1bJBy8qnQwmB97lWW2kfzXBM5qHFz4SYx93Aw4OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1IKU5xO8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1IKU5xO8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C2CBC19423;
	Thu, 15 Jan 2026 17:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497775;
	bh=EQo+azW+sWfFB3cQ/MkhD7I1yfbN77ipxXzwWE2yvCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1IKU5xO8oHsN/74CCCls/vqvNxGVMsLqA4F4/241zonUhuokWFdSYKNDyPO/cJHVR
	 0qRA1N3fy92bbgGQmVAvVB6acrW50CbpxCeTYCIg/NTZig2klgQauuYTDN2RwlXdHj
	 93JmhVzIgpskAh4xKgoXirAzXx3OIE1isMErKtPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Haotien Hsu <haotienh@nvidia.com>,
	Wayne Chang <waynec@nvidia.com>
Subject: [PATCH 5.15 198/554] usb: gadget: tegra-xudc: Always reinitialize data toggle when clear halt
Date: Thu, 15 Jan 2026 17:44:24 +0100
Message-ID: <20260115164253.423672745@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1542,12 +1542,6 @@ static int __tegra_xudc_ep_set_halt(stru
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


