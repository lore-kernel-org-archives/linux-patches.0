Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A073722A7E0;
	Mon, 18 Aug 2025 13:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523459; cv=none; b=TIPS35iNZP+YGaXFHRr6hyJpisDR56Gi+cRd+Sh0vmFb+U2Vxg3T+0XxoGl+LXHGBq5JzcM2H1SZN9eS0mXuQwfO92FjI+m/WeWqXH1dWzq/1HmTZ8ZK10A7/JAeslb8AW6v+T4HGt/sMPd4l7FIrIij8blttzwK/2dp4Blt0+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523459; c=relaxed/simple;
	bh=YTKzFVmxvix36OVONbphBoT3WOE9LlBtEl3FKXRid4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P6CQe5sEB2h5rCHw5xgbGV+YEOcbuEEPhn1bpkiGPSUTG2zMIqJsWaVYggwGKimsOMJcSs1t7Upkjn6PvquqdgncoYuzlixyHWLe+LBEgZUbNJ1RkBfIGTS+eQXdd9bmSbTnXPELYAWLX1tzXRuaSOdDCp6pOVLUgyWZjK0KmA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kAiRWnrU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kAiRWnrU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F901C4CEEB;
	Mon, 18 Aug 2025 13:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523459;
	bh=YTKzFVmxvix36OVONbphBoT3WOE9LlBtEl3FKXRid4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kAiRWnrUm2suwrl0K1OAHPB2SkCbeA4F1WRN+Hr1INg/7yVjFyBy+miCkWmrx+0tK
	 /5ZEuOJizEFkZMidWoI6KR9t6y9aH2be5w26PXq3vRgWSat1nLcoqVvayVnlH0LZbo
	 hSGK9ve4Gly/VplnNLdt8+qs28PrzO/CGwV5c5Zk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 177/515] usb: dwc3: xilinx: add shutdown callback
Date: Mon, 18 Aug 2025 14:42:43 +0200
Message-ID: <20250818124505.180855093@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>

[ Upstream commit 70627bf82e36e61c40c3315e1206e4ea4c02e668 ]

Adds a shutdown callback to ensure that the XHCI stack is properly
shutdown in reboot/shutdown path.

In kexec flow, kernel_restart_prepare() performs actions necessary
to prepare the system for a restart and invokes device_shutdown. To
ensure proper shutdown attach the dwc3 shutdown implementation which
mirrors the remove method.

$ kexec -e

<snip>
xhci-hcd xhci-hcd.0.auto: remove, state 1
usb usb1: USB disconnect, device number 1
usb 1-1: USB disconnect, device number 6
xhci-hcd xhci-hcd.0.auto: USB bus 1 deregistered
kexec_core: Starting new kernel

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/1748977771-714153-1-git-send-email-radhey.shyam.pandey@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-xilinx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/dwc3/dwc3-xilinx.c b/drivers/usb/dwc3/dwc3-xilinx.c
index 4ca7f6240d07..09c3c5c226ab 100644
--- a/drivers/usb/dwc3/dwc3-xilinx.c
+++ b/drivers/usb/dwc3/dwc3-xilinx.c
@@ -422,6 +422,7 @@ static const struct dev_pm_ops dwc3_xlnx_dev_pm_ops = {
 static struct platform_driver dwc3_xlnx_driver = {
 	.probe		= dwc3_xlnx_probe,
 	.remove		= dwc3_xlnx_remove,
+	.shutdown	= dwc3_xlnx_remove,
 	.driver		= {
 		.name		= "dwc3-xilinx",
 		.of_match_table	= dwc3_xlnx_of_match,
-- 
2.39.5



