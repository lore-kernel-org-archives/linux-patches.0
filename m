Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B4722FF4E;
	Mon, 10 Mar 2025 18:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630655; cv=none; b=fmu1MjRoTWK4LpmYBqXzab1xJyK6NnXC9rpiJp8LoiGSTHw6KC5k4o5Jbk6emAXgKctdpDc76oSlbXs/DgI8H66SzTl/IZfXgR8sJmUsB+IHtDc1l4/fq4CRU/G9JYJ3rPzf43cd2XcrZxtp0XkMh5vHxOzwo3PXzOfrXu22Jxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630655; c=relaxed/simple;
	bh=RqUOdaiCU3wc9xS5pShQG7P+XGWp4CaMT3kd4govzHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CTndR/TGmsrgwhHPPyfZj1QJM/7kA+ObR7ukTROltzqt9ea8PF7NyByYezjAC++Wx+l2UqKPrz8eug9RFMfKkyuz6lcRJrxAd37NWOmrtuH4yM2sl6C4XY8J+KRkPNhoAfNr12Cd8MgPnTsma8IUt8DC0GJu/aYcPb6u13Q3yIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ybfekd4a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ybfekd4a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADDCAC4CEE5;
	Mon, 10 Mar 2025 18:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630655;
	bh=RqUOdaiCU3wc9xS5pShQG7P+XGWp4CaMT3kd4govzHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ybfekd4an7qe2dkxasbEsGV7xcc3Lx2Go65ZDdECkx03atzt3+G43vFDEwWYkdTjn
	 UAnMreLqjaKc+8jgg5G1AWxQkqmQNVxrINSL3ytdeuT99T3K8w5GTUQ0+S7105iD1g
	 lrkGhMQutDEr6E/rfHnnDiAi0YSRIqFVjueD99ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wesley Cheng <quic_wcheng@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 458/620] usb: dwc3: Increase DWC3 controller halt timeout
Date: Mon, 10 Mar 2025 18:05:04 +0100
Message-ID: <20250310170603.660385847@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wesley Cheng <quic_wcheng@quicinc.com>

[ Upstream commit 461ee467507cb98a348fa91ff8460908bb0ea423 ]

Since EP0 transactions need to be completed before the controller halt
sequence is finished, this may take some time depending on the host and the
enabled functions.  Increase the controller halt timeout, so that we give
the controller sufficient time to handle EP0 transfers.

Signed-off-by: Wesley Cheng <quic_wcheng@quicinc.com>
Link: https://lore.kernel.org/r/20220901193625.8727-4-quic_wcheng@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: d3a8c28426fc ("usb: dwc3: Fix timeout issue during controller enter/exit from halt state")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index d39906248850a..e9daeaa5b68e9 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2457,7 +2457,7 @@ static void __dwc3_gadget_set_speed(struct dwc3 *dwc)
 static int dwc3_gadget_run_stop(struct dwc3 *dwc, int is_on)
 {
 	u32			reg;
-	u32			timeout = 500;
+	u32			timeout = 2000;
 
 	if (pm_runtime_suspended(dwc->dev))
 		return 0;
@@ -2484,6 +2484,7 @@ static int dwc3_gadget_run_stop(struct dwc3 *dwc, int is_on)
 	dwc3_gadget_dctl_write_safe(dwc, reg);
 
 	do {
+		usleep_range(1000, 2000);
 		reg = dwc3_readl(dwc->regs, DWC3_DSTS);
 		reg &= DWC3_DSTS_DEVCTRLHLT;
 	} while (--timeout && !(!is_on ^ !reg));
-- 
2.39.5



