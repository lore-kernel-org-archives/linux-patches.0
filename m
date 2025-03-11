Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D1825C715;
	Tue, 11 Mar 2025 15:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706020; cv=none; b=Y1xfg1ZgDeCyKh/OECwINhDhKIJU/oxVh4YI31kWiRhnVy3/iDvXvGLrkYAghmnrWhrP7o2mMYyjoPyFLkB7KbnwhI50XdH5kt/kBg8FR+K5Q+D4jziHBywhciy3xWvdzQj6TKwQnxnz3s0Pq1+QCE4xPd1nXYG2lxgIyxckszM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706020; c=relaxed/simple;
	bh=Cn/IYKfOTHCNXaAH9CC1KzUtrKYHa4oPesl5HOQPVAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJg2s/T5BbSPsZeecOPPP4bz/9ZiDuavA6Psutw6eT0y5oUmPA/NFH3JREl2oo3X1whuYPNXVtSanzTaEe3Yn11TBPo4CL+ZOlQCaQz28qoVgFOtKZEf0373Z32IoNzL/UquLP9Bm09LN0g1P16/Y+r9WokIz9kgT58U4Hyg7sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iQsEDGsd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iQsEDGsd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C95C4CEE9;
	Tue, 11 Mar 2025 15:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706020;
	bh=Cn/IYKfOTHCNXaAH9CC1KzUtrKYHa4oPesl5HOQPVAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iQsEDGsduEbahPRE7fTt3WhiSqgpT4M7o49/Rof/cVmvu8s41XohYn+EVJmxDd/HU
	 siOtH/s/+kHbPPt5M6ZcJOQHInZLcfjcdeh0iE6saPzWJhAZjWJtc/0z+drw44E0jQ
	 KdLaTknGnRUS7VepSm+E338qtEVUkkCQBJm26Vxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wesley Cheng <quic_wcheng@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 235/328] usb: dwc3: Increase DWC3 controller halt timeout
Date: Tue, 11 Mar 2025 16:00:05 +0100
Message-ID: <20250311145724.255681189@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 6caedef5575d7..f9232c099f494 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1966,7 +1966,7 @@ static void dwc3_stop_active_transfers(struct dwc3 *dwc)
 static int dwc3_gadget_run_stop(struct dwc3 *dwc, int is_on, int suspend)
 {
 	u32			reg;
-	u32			timeout = 500;
+	u32			timeout = 2000;
 
 	if (pm_runtime_suspended(dwc->dev))
 		return 0;
@@ -1998,6 +1998,7 @@ static int dwc3_gadget_run_stop(struct dwc3 *dwc, int is_on, int suspend)
 	dwc3_writel(dwc->regs, DWC3_DCTL, reg);
 
 	do {
+		usleep_range(1000, 2000);
 		reg = dwc3_readl(dwc->regs, DWC3_DSTS);
 		reg &= DWC3_DSTS_DEVCTRLHLT;
 	} while (--timeout && !(!is_on ^ !reg));
-- 
2.39.5



