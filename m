Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D5513D8A4;
	Thu, 13 Feb 2025 15:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460541; cv=none; b=sNT+v9qiuHvuu0d+F68seRjNj6j+1dZQA7rPeR8AgcjH0uZmc1Grs8cPxiBD6YWoXrCIztzdBdEv4tR8S+odQd0acVXf+uWEnEDDTqTf3Fsv5N1z1EwF4KnXyE/GF04olu5QSEvD3M3UuhjVhqcUvrXP6C2OXyqvpgM2TDDKrx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460541; c=relaxed/simple;
	bh=qCe+MTS1gghHjvqhojKFW/E38ULxigfRF3eTml+EgWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZfC+fiYEUWPdG6YRtnR9t1jqdMmlAOq08+2tDS4KVDSdjXFx0H3seOCiYjqX2OZHDh2dfuTEWuLeFhlyhp+hcdaygv/8aw7CpqupPY+HiwyJg7LbPNOr6tvZ7ekjI5R13H5x4/svPTvr7hc+JNkyQvz8vlzE5hhmRQnEPSDccVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XreCZV6H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XreCZV6H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307A4C4CED1;
	Thu, 13 Feb 2025 15:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460541;
	bh=qCe+MTS1gghHjvqhojKFW/E38ULxigfRF3eTml+EgWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XreCZV6HbYraIParhriJYfomEx+AnanSTw3PEZY4fs4yRJfRt9cfSpKuQvHYpEwfE
	 txu4i9tTxUzH1mAsiPVa86/8+x51ev+UqDDQyvfxUJ1wSBFCMgeJ/GwUC+1KvQA/B6
	 Ifunhpz6M/2z+BhYF6OPy0hxNtCWtkhi/1ZkLF3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.6 134/273] usb: gadget: f_tcm: ep_autoconfig with fullspeed endpoint
Date: Thu, 13 Feb 2025 15:28:26 +0100
Message-ID: <20250213142412.632953954@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 25224c1f07d31c261d04dfbc705a7a0f314a825d upstream.

Match usb endpoint using fullspeed endpoint descriptor to make sure the
wMaxPacketSize for fullspeed descriptors is automatically configured.

Fixes: c52661d60f63 ("usb-gadget: Initial merge of target module for UASP + BOT")
Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/e4507bc824aed6e7c7f5a718392ab6a7c1480a7f.1733876548.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_tcm.c |   30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1967,43 +1967,39 @@ static int tcm_bind(struct usb_configura
 	bot_intf_desc.bInterfaceNumber = iface;
 	uasp_intf_desc.bInterfaceNumber = iface;
 	fu->iface = iface;
-	ep = usb_ep_autoconfig_ss(gadget, &uasp_ss_bi_desc,
-			&uasp_bi_ep_comp_desc);
+	ep = usb_ep_autoconfig(gadget, &uasp_fs_bi_desc);
 	if (!ep)
 		goto ep_fail;
 
 	fu->ep_in = ep;
 
-	ep = usb_ep_autoconfig_ss(gadget, &uasp_ss_bo_desc,
-			&uasp_bo_ep_comp_desc);
+	ep = usb_ep_autoconfig(gadget, &uasp_fs_bo_desc);
 	if (!ep)
 		goto ep_fail;
 	fu->ep_out = ep;
 
-	ep = usb_ep_autoconfig_ss(gadget, &uasp_ss_status_desc,
-			&uasp_status_in_ep_comp_desc);
+	ep = usb_ep_autoconfig(gadget, &uasp_fs_status_desc);
 	if (!ep)
 		goto ep_fail;
 	fu->ep_status = ep;
 
-	ep = usb_ep_autoconfig_ss(gadget, &uasp_ss_cmd_desc,
-			&uasp_cmd_comp_desc);
+	ep = usb_ep_autoconfig(gadget, &uasp_fs_cmd_desc);
 	if (!ep)
 		goto ep_fail;
 	fu->ep_cmd = ep;
 
 	/* Assume endpoint addresses are the same for both speeds */
-	uasp_bi_desc.bEndpointAddress =	uasp_ss_bi_desc.bEndpointAddress;
-	uasp_bo_desc.bEndpointAddress = uasp_ss_bo_desc.bEndpointAddress;
+	uasp_bi_desc.bEndpointAddress =	uasp_fs_bi_desc.bEndpointAddress;
+	uasp_bo_desc.bEndpointAddress = uasp_fs_bo_desc.bEndpointAddress;
 	uasp_status_desc.bEndpointAddress =
-		uasp_ss_status_desc.bEndpointAddress;
-	uasp_cmd_desc.bEndpointAddress = uasp_ss_cmd_desc.bEndpointAddress;
+		uasp_fs_status_desc.bEndpointAddress;
+	uasp_cmd_desc.bEndpointAddress = uasp_fs_cmd_desc.bEndpointAddress;
 
-	uasp_fs_bi_desc.bEndpointAddress = uasp_ss_bi_desc.bEndpointAddress;
-	uasp_fs_bo_desc.bEndpointAddress = uasp_ss_bo_desc.bEndpointAddress;
-	uasp_fs_status_desc.bEndpointAddress =
-		uasp_ss_status_desc.bEndpointAddress;
-	uasp_fs_cmd_desc.bEndpointAddress = uasp_ss_cmd_desc.bEndpointAddress;
+	uasp_ss_bi_desc.bEndpointAddress = uasp_fs_bi_desc.bEndpointAddress;
+	uasp_ss_bo_desc.bEndpointAddress = uasp_fs_bo_desc.bEndpointAddress;
+	uasp_ss_status_desc.bEndpointAddress =
+		uasp_fs_status_desc.bEndpointAddress;
+	uasp_ss_cmd_desc.bEndpointAddress = uasp_fs_cmd_desc.bEndpointAddress;
 
 	ret = usb_assign_descriptors(f, uasp_fs_function_desc,
 			uasp_hs_function_desc, uasp_ss_function_desc,


