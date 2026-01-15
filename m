Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4AB3BFE27;
	Thu, 15 Jan 2026 17:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499215; cv=none; b=LxO/iXEjlPXQQavtsfOFE/fHW64ZCnnzKBe49aK1UwrfwCPevswapFcxEHWtsdyBk/GWunhM6bw2all4u1Ryd3Girhe6VzfBTGYA2/Nbtw9xRyZW0Hf4iOGgEnx9Czujmyzgx+3FJ13VLChI0Okw4+hQ7VeffM4VPDFNkkcu17Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499215; c=relaxed/simple;
	bh=NK+BV+uHj67FmFBKIZtTUNhGcsXjY7p6S/3a+a91N3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Awk5yXng5SIdbXiP7gaeS1vK1+iBWRNyeB/MTsTvNbccInKsGk935iXYNKFTLq7GEOBnc9z2ldPc6meyziFUPYZKPJDzhX7/coxiAu6leN92lLuIBRqgxFfjFVVFZL3/evJsj7+igh0gREw93p3vwBBWK9MJH6GK2ABc9XNYwv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HYgNsAdD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HYgNsAdD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 916D6C116D0;
	Thu, 15 Jan 2026 17:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499214;
	bh=NK+BV+uHj67FmFBKIZtTUNhGcsXjY7p6S/3a+a91N3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HYgNsAdDjyFsoTynyUmLYGLXv7vW2K3bIdPiuiowjj9stXWVeQG1Qasac2rNLn4WI
	 rfIlI46mFLReF/52EQcz/w01eh8TfuHIn4FP8QhMRU83lS5AlGeDkG6MmWK4jxlr2f
	 G1STfmAuoXnGUQW+tLSRpRnTmN/ox4AAbiVw4Ik0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Haotien Hsu <haotienh@nvidia.com>,
	Wayne Chang <waynec@nvidia.com>
Subject: [PATCH 5.10 148/451] usb: gadget: tegra-xudc: Always reinitialize data toggle when clear halt
Date: Thu, 15 Jan 2026 17:45:49 +0100
Message-ID: <20260115164236.269934856@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


