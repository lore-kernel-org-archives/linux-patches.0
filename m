Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55C26FB1;
	Tue,  5 Dec 2023 03:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cZElqKYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 638F5C433C8;
	Tue,  5 Dec 2023 03:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747409;
	bh=PL2+vVjEmu4hcQI/wxwuOhxZBv6Im0v9WPqn3IFOmIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cZElqKYc1sMGpMko7Sr2BBoDlVF4OL1zoA6s8jLDo3oLEoRmuXd2cDWxrHFsYoUvg
	 VcdE+7CEyWuLhx2Vxry6j42MP+CprSJbYGKc5fI46CJsWER+eWAekpa1s28wefcNqR
	 e6Qlk62CGNqyysveO4/gPowxAagDmIAW/a8Vg9FI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.10 066/135] usb: dwc3: Fix default mode initialization
Date: Tue,  5 Dec 2023 12:16:27 +0900
Message-ID: <20231205031534.578706297@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031530.557782248@linuxfoundation.org>
References: <20231205031530.557782248@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

commit 10d510abd096d620b9fda2dd3e0047c5efc4ad2b upstream.

The default mode, configurable by DT, shall be set before usb role switch
driver is registered. Otherwise there is a race between default mode
and mode set by usb role switch driver.

Fixes: 98ed256a4dbad ("usb: dwc3: Add support for role-switch-default-mode binding")
Cc: stable <stable@kernel.org>
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20231025095110.2405281-1-alexander.stein@ew.tq-group.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/drd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/dwc3/drd.c
+++ b/drivers/usb/dwc3/drd.c
@@ -547,6 +547,7 @@ static int dwc3_setup_role_switch(struct
 		dwc->role_switch_default_mode = USB_DR_MODE_PERIPHERAL;
 		mode = DWC3_GCTL_PRTCAP_DEVICE;
 	}
+	dwc3_set_mode(dwc, mode);
 
 	dwc3_role_switch.fwnode = dev_fwnode(dwc->dev);
 	dwc3_role_switch.set = dwc3_usb_role_switch_set;
@@ -556,7 +557,6 @@ static int dwc3_setup_role_switch(struct
 	if (IS_ERR(dwc->role_sw))
 		return PTR_ERR(dwc->role_sw);
 
-	dwc3_set_mode(dwc, mode);
 	return 0;
 }
 #else


