Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E2C1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:50:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD0EC433EF;
	Wed, 28 Dec 2022 16:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246255;
	bh=eSsy+PB1DmhRyOHmasLjcN3vEdhJt20bN7ipN8qY9Jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tkr+07oJcTwsA+wg+nmgGGwWyPUJMMEsLOm+BPDIcfafEIl6evEkCMzuQGB328htn
	 LCNBGVW8QITuIDs/8Xd5wrx5Yto207kjyRBGsdLK+KfIPH+b69msJqGOBu6Ag08Qwl
	 qpGsUlcRVDEPQXABxdXyXAwwAfdJtVaT5dp1BoWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Ferry Toth <ftoth@exalondelft.nl>
Subject: [PATCH 6.0 1039/1073] usb: dwc3: core: defer probe on ulpi_read_id timeout
Date: Wed, 28 Dec 2022 15:43:47 +0100
Message-Id: <20221228144356.415361178@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ferry Toth <ftoth@exalondelft.nl>

commit 63130462c919ece0ad0d9bb5a1f795ef8d79687e upstream.

Since commit 0f0101719138 ("usb: dwc3: Don't switch OTG -> peripheral
if extcon is present"), Dual Role support on Intel Merrifield platform
broke due to rearranging the call to dwc3_get_extcon().

It appears to be caused by ulpi_read_id() masking the timeout on the first
test write. In the past dwc3 probe continued by calling dwc3_core_soft_reset()
followed by dwc3_get_extcon() which happend to return -EPROBE_DEFER.
On deferred probe ulpi_read_id() finally succeeded. Due to above mentioned
rearranging -EPROBE_DEFER is not returned and probe completes without phy.

On Intel Merrifield the timeout on the first test write issue is reproducible
but it is difficult to find the root cause. Using a mainline kernel and
rootfs with buildroot ulpi_read_id() succeeds. As soon as adding
ftrace / bootconfig to find out why, ulpi_read_id() fails and we can't
analyze the flow. Using another rootfs ulpi_read_id() fails even without
adding ftrace. We suspect the issue is some kind of timing / race, but
merely retrying ulpi_read_id() does not resolve the issue.

As we now changed ulpi_read_id() to return -ETIMEDOUT in this case, we
need to handle the error by calling dwc3_core_soft_reset() and request
-EPROBE_DEFER. On deferred probe ulpi_read_id() is retried and succeeds.

Fixes: ef6a7bcfb01c ("usb: ulpi: Support device discovery via DT")
Cc: stable@vger.kernel.org
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Ferry Toth <ftoth@exalondelft.nl>
Link: https://lore.kernel.org/r/20221205201527.13525-3-ftoth@exalondelft.nl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1100,8 +1100,13 @@ static int dwc3_core_init(struct dwc3 *d
 
 	if (!dwc->ulpi_ready) {
 		ret = dwc3_core_ulpi_init(dwc);
-		if (ret)
+		if (ret) {
+			if (ret == -ETIMEDOUT) {
+				dwc3_core_soft_reset(dwc);
+				ret = -EPROBE_DEFER;
+			}
 			goto err0;
+		}
 		dwc->ulpi_ready = true;
 	}
 


