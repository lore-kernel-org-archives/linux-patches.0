Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2CA1E2618;
	Mon, 21 Oct 2024 10:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507124; cv=none; b=nP6DLXWW+NQtXiBCW4RGAplWDaOjdgL6ETuh8XHC7tpG6AeY/oPNwACWp7qLz6rm55Uc0KeSUwFmjP7Wltm91RtuEG6TEVr17w4SnHHV6QfTok1xvK4qQPS09oOdczqX+38bfVmZFyMMsIAoPwf3bFx2vvdN6ucWB9g7dDmlk1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507124; c=relaxed/simple;
	bh=xS7udohdo2YG8O7WP+r3xXq365WyM2d+I5BfOCsOuuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lqzaaErswmeAyrlWlbJwXreuC3wyiVBJjT/32rZIadjx3mXMWuaC/Xu2zCZIxyT+kfnmSnvPOozhZ4g7EFlexyKY3V0krP0wf/MrpHNsGrgUdDFrKsAUIetZWiYY3RZ0zYTSWURSul+cW0S7eQO6TyTEkj58floVPENq01iGUdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jzb77/3l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jzb77/3l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 808E9C4CEC3;
	Mon, 21 Oct 2024 10:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507123;
	bh=xS7udohdo2YG8O7WP+r3xXq365WyM2d+I5BfOCsOuuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jzb77/3lrux76jtqbkFYmrfoASuDnEPPxi854z4xu9h0G+aMjCJ4u+Cg8nLMqKAdv
	 pFs6sK0msctHBw7LxoK4LCwhoPNvR68lkPMrR3yLiohR6q3fdgBH6rKhuzk3cFruP1
	 2K6cTYMoNQ7Dc2ijfi+/mGKirSPlgsqazB/1klwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashanth K <quic_prashk@quicinc.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.6 098/124] usb: dwc3: Wait for EndXfer completion before restoring GUSB2PHYCFG
Date: Mon, 21 Oct 2024 12:25:02 +0200
Message-ID: <20241021102300.514195275@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prashanth K <quic_prashk@quicinc.com>

commit c96e31252110a84dcc44412e8a7b456b33c3e298 upstream.

DWC3 programming guide mentions that when operating in USB2.0 speeds,
if GUSB2PHYCFG[6] or GUSB2PHYCFG[8] is set, it must be cleared prior
to issuing commands and may be set again  after the command completes.
But currently while issuing EndXfer command without CmdIOC set, we
wait for 1ms after GUSB2PHYCFG is restored. This results in cases
where EndXfer command doesn't get completed and causes SMMU faults
since requests are unmapped afterwards. Hence restore GUSB2PHYCFG
after waiting for EndXfer command completion.

Cc: stable@vger.kernel.org
Fixes: 1d26ba0944d3 ("usb: dwc3: Wait unconditionally after issuing EndXfer command")
Signed-off-by: Prashanth K <quic_prashk@quicinc.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20240924093208.2524531-1-quic_prashk@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -438,6 +438,10 @@ skip_status:
 			dwc3_gadget_ep_get_transfer_index(dep);
 	}
 
+	if (DWC3_DEPCMD_CMD(cmd) == DWC3_DEPCMD_ENDTRANSFER &&
+	    !(cmd & DWC3_DEPCMD_CMDIOC))
+		mdelay(1);
+
 	if (saved_config) {
 		reg = dwc3_readl(dwc->regs, DWC3_GUSB2PHYCFG(0));
 		reg |= saved_config;
@@ -1734,12 +1738,10 @@ static int __dwc3_stop_active_transfer(s
 	WARN_ON_ONCE(ret);
 	dep->resource_index = 0;
 
-	if (!interrupt) {
-		mdelay(1);
+	if (!interrupt)
 		dep->flags &= ~DWC3_EP_TRANSFER_STARTED;
-	} else if (!ret) {
+	else if (!ret)
 		dep->flags |= DWC3_EP_END_TRANSFER_PENDING;
-	}
 
 	dep->flags &= ~DWC3_EP_DELAY_STOP;
 	return ret;


