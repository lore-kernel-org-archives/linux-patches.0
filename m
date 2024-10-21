Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D961E47A5;
	Mon, 21 Oct 2024 10:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506843; cv=none; b=BuAeqx0osHVrsWJyRQYL3ITCTEYKFo1l6/S0aG/7xRppdj4xJ+8QGQW78YtkgIlErmeaU9V5TmM9AWdM7eujR4o75O0DJWwACyBtz2fZMUgEnXGIq27wksEmHoccxErNEZw8aQ3Oqg8r/NKLAbrthCfv/WxrsuvJWUKNArq+3bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506843; c=relaxed/simple;
	bh=3VFUYkuodr/OIaMZfLm/2mouPOtSN13HUbXbg2utzJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TQtmfjKhHpTjLZXyaYfhgA4AYZdnaj+nTKAiQ8bnHdJmCOpsfm9h5RHlOPJQ+vtaz+TvYFmkQftjC/uhMRYv4Gk3ufvDDNrzF42ziR29bP/cU1Sxs9QKdYKFC3GIEVo8Lkq2IkYbKp0IYepwnYQ4qv04kCO+78lLqMYQKv/nnL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m2WjfEXW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m2WjfEXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F5BC4CEC3;
	Mon, 21 Oct 2024 10:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506843;
	bh=3VFUYkuodr/OIaMZfLm/2mouPOtSN13HUbXbg2utzJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m2WjfEXWPdtJ9RkK+8mnhCPBzZWdqN/NVXYcMEJsNwsyMYwAmODrs33bnbN1owgBk
	 JPbojdJK09E+H5wCTQaJx919RtxWraldKuiXha20EeG395RkBLpeiQlD40AaMll8rr
	 HkgSFljGHfYzkZSIWCyYe8JxgJuOyHsWBQB8fjlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashanth K <quic_prashk@quicinc.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.11 108/135] usb: dwc3: Wait for EndXfer completion before restoring GUSB2PHYCFG
Date: Mon, 21 Oct 2024 12:24:24 +0200
Message-ID: <20241021102303.551912504@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1715,12 +1719,10 @@ static int __dwc3_stop_active_transfer(s
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


