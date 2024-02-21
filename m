Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F28D55E5E;
	Wed, 21 Feb 2024 13:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523562; cv=none; b=CO+TFi3nbOopbNWeZzp/ZkLV1dtPDXyYE+BCPtAjnBGss+t10znt+Me9gT5MVCEzZKitAMjrfcHKD9cpwoCvw5d45buFjqQJ1F6Ro3aTi1VwQMAZrXLBhPtIkbNPvyXJ6GM+Bu5ridKMM6crsDvA03f+y/Hf5CdjSUO2pCvXlA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523562; c=relaxed/simple;
	bh=oq262k9KVw41qURcLRm2bh+muuixBB6gpJzeb0/zadk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nGaQgOtwiGw/8eSNRmHYgvY3fiAHZVpju1lA6VLnlwgsKC5Ztw5YyuTXjK6BEsIRYB+URqEUcVRuj/g0yobD54U27MjZVN5H8v93/WqfClyx7cbGGnIU3O6BKk4hJYcS/J/kENi1uQYfxv3+cJjoEWAQt5qg6ukYHQjzZxtV4Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bgwrO4M8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bgwrO4M8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D06BC433C7;
	Wed, 21 Feb 2024 13:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523562;
	bh=oq262k9KVw41qURcLRm2bh+muuixBB6gpJzeb0/zadk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bgwrO4M8NkFoUvQyGyWaIFbf8Yh7MQsOkvv1FzdtLrfPUznLlGRr2yeeuJFcBXH/Z
	 vrrpUtGD70eCEXtXDION74Yb7sSjhn9D3nZkNr6YvHEIRee8EcLZd2Hi50XM+Nc5C3
	 lS0OHCAYS63Qp7EXa8zGpqVhdNzp4SnzIk2t/nuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.15 473/476] usb: dwc3: gadget: Dont delay End Transfer on delayed_status
Date: Wed, 21 Feb 2024 14:08:44 +0100
Message-ID: <20240221130025.478306505@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 4db0fbb601361767144e712beb96704b966339f5 upstream.

The gadget driver may wait on the request completion when it sets the
USB_GADGET_DELAYED_STATUS. Make sure that the End Transfer command can
go through if the dwc->delayed_status is set so that the request can
complete. When the delayed_status is set, the Setup packet is already
processed, and the next phase should be either Data or Status. It's
unlikely that the host would cancel the control transfer and send a new
Setup packet during End Transfer command. But if that's the case, we can
try again when ep0state returns to EP0_SETUP_PHASE.

Fixes: e1ee843488d5 ("usb: dwc3: gadget: Force sending delayed status during soft disconnect")
Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/3f9f59e5d74efcbaee444cf4b30ef639cc7b124e.1666146954.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1680,6 +1680,16 @@ static int __dwc3_stop_active_transfer(s
 	cmd |= DWC3_DEPCMD_PARAM(dep->resource_index);
 	memset(&params, 0, sizeof(params));
 	ret = dwc3_send_gadget_ep_cmd(dep, cmd, &params);
+	/*
+	 * If the End Transfer command was timed out while the device is
+	 * not in SETUP phase, it's possible that an incoming Setup packet
+	 * may prevent the command's completion. Let's retry when the
+	 * ep0state returns to EP0_SETUP_PHASE.
+	 */
+	if (ret == -ETIMEDOUT && dep->dwc->ep0state != EP0_SETUP_PHASE) {
+		dep->flags |= DWC3_EP_DELAY_STOP;
+		return 0;
+	}
 	WARN_ON_ONCE(ret);
 	dep->resource_index = 0;
 
@@ -3701,7 +3711,7 @@ void dwc3_stop_active_transfer(struct dw
 	 * timeout. Delay issuing the End Transfer command until the Setup TRB is
 	 * prepared.
 	 */
-	if (dwc->ep0state != EP0_SETUP_PHASE) {
+	if (dwc->ep0state != EP0_SETUP_PHASE && !dwc->delayed_status) {
 		dep->flags |= DWC3_EP_DELAY_STOP;
 		return;
 	}


