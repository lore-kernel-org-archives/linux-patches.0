Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FB51E8836;
	Fri,  9 Jan 2026 12:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962026; cv=none; b=AqizWoqNgFUEk1gkHgtxoUfxwz9BODqywDnFoIplckxi6aK+zCmfEuSC3iR6QSZ//1JF1epwfuX9bAn+DTTIcmS4HWFtVzrcaX+1CRvCbisGQwF+RfWGIyELWgND9PsVTK5QyjSk+Lfx7rh01kyAghWn7+MP4kPfHNUI5HT+zQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962026; c=relaxed/simple;
	bh=wYtUR2tx2pzlJzyhcr2743xr5ANOtdXKa00lNULsHFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HeCrZWPb3Rmd/SdSjsImpVs+qDwtjiqCUM3drsERPpjPdwgFc7AOeXtd2Ai0Idxj4fj8DZKpH8ip0t1ItkE5IFsgpqUqNSM/WRM66argrpAeXFEqDsc5iU+a+MfjAtmnMJDigwrP28DHRLpnCsE7e0grVl3/IDsROmEUCiAAG3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SnEoxwc5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SnEoxwc5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01572C4CEF1;
	Fri,  9 Jan 2026 12:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962026;
	bh=wYtUR2tx2pzlJzyhcr2743xr5ANOtdXKa00lNULsHFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SnEoxwc5auT4ZleJhN3wqTFCT/u0wpaccZJ4vd0/5zC5SOkCLU0JwQAk9eGEoouuO
	 QQ/ERjN0oaxI6YeEL7H/7FF04NGzUAuVh6IEcvL+TXVvkwgOPROJ8p9NCtJllzzx5o
	 zfT+CEAAYoPQVX9+67TRbgDcAmJ5OGZSElRzbjf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Haotien Hsu <haotienh@nvidia.com>,
	Wayne Chang <waynec@nvidia.com>
Subject: [PATCH 6.1 221/634] usb: gadget: tegra-xudc: Always reinitialize data toggle when clear halt
Date: Fri,  9 Jan 2026 12:38:19 +0100
Message-ID: <20260109112125.749460182@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1548,12 +1548,6 @@ static int __tegra_xudc_ep_set_halt(stru
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


