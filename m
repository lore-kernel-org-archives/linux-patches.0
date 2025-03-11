Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558991CAA8F;
	Tue, 11 Mar 2025 15:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707254; cv=none; b=Gm4duK+cqpEpADB8+8CcpAnudxf3ocU9oxvY4+2CtvEIGJ8ka5bujw9bbfke2PMyatBQsO+7z6DIlpifHJaEpwuX8F3Bxe/OTU1vVTYifFbSdA9oN0aKY5QfPDfNWoq1qRc4y+F0vE/BDoJMRP3w6/HAMngEgnO6ahgWsj+KAjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707254; c=relaxed/simple;
	bh=xDb4wR4wbbtyCMT8/3jo259uY/nbFfEcKdQvnpNQyg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kdV4O2sjBacdwQJ0QDx0t+WlE2VF+0oNyYJMocPHF+QC7Z9b8oHSs4O0Tk1+QxXtyayBoCnPdKIT/47MspL0YlBusaNVSCJWwz/bY0gXlfZaQdsH3gqL9CrX2mHPTP/Sev+9f1s5GIf7kWHTlLtdBleSk1KVpW9z8JAKUtw1eOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E0IkIHlD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E0IkIHlD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3BB8C4CEE9;
	Tue, 11 Mar 2025 15:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707254;
	bh=xDb4wR4wbbtyCMT8/3jo259uY/nbFfEcKdQvnpNQyg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E0IkIHlD7adtZ7xuFe1o3DJBAFM5EkHKyqbc4RQgh7q7kkkoPNK/V3LO4b6EYfOne
	 PECLRLCTzVhxlGsyQmqbvibLk5WOj7DPE3HZFxZCZnTY16JXDf2bU4GN9uIEcvmicX
	 FhflZXuLUQlgwFvqeiQ8GhRvK/wN95tB+AYzBVGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wesley Cheng <quic_wcheng@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 327/462] usb: dwc3: Increase DWC3 controller halt timeout
Date: Tue, 11 Mar 2025 15:59:53 +0100
Message-ID: <20250311145811.281278645@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e1e18a4f0d071..a13d1e2c5bde0 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2104,7 +2104,7 @@ static void dwc3_stop_active_transfers(struct dwc3 *dwc)
 static int dwc3_gadget_run_stop(struct dwc3 *dwc, int is_on, int suspend)
 {
 	u32			reg;
-	u32			timeout = 500;
+	u32			timeout = 2000;
 
 	if (pm_runtime_suspended(dwc->dev))
 		return 0;
@@ -2136,6 +2136,7 @@ static int dwc3_gadget_run_stop(struct dwc3 *dwc, int is_on, int suspend)
 	dwc3_gadget_dctl_write_safe(dwc, reg);
 
 	do {
+		usleep_range(1000, 2000);
 		reg = dwc3_readl(dwc->regs, DWC3_DSTS);
 		reg &= DWC3_DSTS_DEVCTRLHLT;
 	} while (--timeout && !(!is_on ^ !reg));
-- 
2.39.5



