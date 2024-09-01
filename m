Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87CA16EB4B;
	Sun,  1 Sep 2024 16:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207865; cv=none; b=oM/Ppwk/MyLktojt4RSQfxqIZJVoFSDiXNk4phhGgTzuq2i8AZzg5ippf11s0A4MQayTK1EMtHe1LXSbqQq6dHAoQuR2Gfk8ww+9PU1po/Xo73DgBF5FVUmfBJm1HYq6a1JWgRtThFcFeIS5SZQ5mkqLItnCbbQQQdz2ZF+zR/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207865; c=relaxed/simple;
	bh=57hPJ4kSLy6NUUBsJfkq+o7RMvsGv5qTlXi2eUkUGXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQ0rWXU39L6FSE6X5XsNgUWJjCCr0EIT1eLCIsyU/UVm8dg+K0J3bnWb1GeKBydPYRBPmGX6UCCv0DlR5EVwdMAWwKG82M+VboPB/yd3r2dK5re95fk26VWgfSAwbXYzR9vHJ8rP8sMui72LtucS7b6CbvhmB1n+KHlPDRAiksE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lrRm29E0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lrRm29E0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A5B6C4CEC3;
	Sun,  1 Sep 2024 16:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207865;
	bh=57hPJ4kSLy6NUUBsJfkq+o7RMvsGv5qTlXi2eUkUGXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lrRm29E0hiiW/jsX9Ot0y9JZiKp8K0KrP8KGZ/iHRSsnnJ+t6WRmdLWOeZNaPe8pz
	 cA8vBnfhrYffFvotgirNdXhyxJjr+9mbgC5iFsakP5MBAY4IecPO/dSQVE+Tb4TcLT
	 Vsla6GgiCsx2rFy21bUHdpGbC91ZL7jPoDELFTi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Selvarasu Ganesan <selvarasu.g@samsung.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 4.19 93/98] usb: dwc3: core: Prevent USB core invalid event buffer address access
Date: Sun,  1 Sep 2024 18:17:03 +0200
Message-ID: <20240901160807.203981096@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvarasu Ganesan <selvarasu.g@samsung.com>

commit 14e497183df28c006603cc67fd3797a537eef7b9 upstream.

This commit addresses an issue where the USB core could access an
invalid event buffer address during runtime suspend, potentially causing
SMMU faults and other memory issues in Exynos platforms. The problem
arises from the following sequence.
        1. In dwc3_gadget_suspend, there is a chance of a timeout when
        moving the USB core to the halt state after clearing the
        run/stop bit by software.
        2. In dwc3_core_exit, the event buffer is cleared regardless of
        the USB core's status, which may lead to an SMMU faults and
        other memory issues. if the USB core tries to access the event
        buffer address.

To prevent this hardware quirk on Exynos platforms, this commit ensures
that the event buffer address is not cleared by software  when the USB
core is active during runtime suspend by checking its status before
clearing the buffer address.

Cc: stable <stable@kernel.org>
Signed-off-by: Selvarasu Ganesan <selvarasu.g@samsung.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20240815064836.1491-1-selvarasu.g@samsung.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -419,9 +419,17 @@ int dwc3_event_buffers_setup(struct dwc3
 void dwc3_event_buffers_cleanup(struct dwc3 *dwc)
 {
 	struct dwc3_event_buffer	*evt;
+	u32				reg;
 
 	if (!dwc->ev_buf)
 		return;
+	/*
+	 * Exynos platforms may not be able to access event buffer if the
+	 * controller failed to halt on dwc3_core_exit().
+	 */
+	reg = dwc3_readl(dwc->regs, DWC3_DSTS);
+	if (!(reg & DWC3_DSTS_DEVCTRLHLT))
+		return;
 
 	evt = dwc->ev_buf;
 


