Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F9A537FF;
	Sun,  1 Sep 2024 16:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208675; cv=none; b=j15Dn4ROQy6QgOZ5DioMnq+cxcjzLaaSgKnFizgNQ9O1lhMd8N1ZQbaeKLkGDgqosW0WoyWAPqCCoTm768GIyRkNmkgA3Z0YjhPYpTQWI3YdPUX3g9NN1y/2Y7SvUrBOMyLRmNaoqz7iFiom0iv0kwQ+xM5kEixexvh5+1o81PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208675; c=relaxed/simple;
	bh=hP8B5zaVSxGNuxLteYATXF45YjgtxOeIzVyC20QMuKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/j4ezUqEe4oqfXfC/aGryxbtPMSJTJm0FnFZb49WSWFMdSBORfx3mAW7zSp/Y/NZqnx57adjwoIMTjW8T5oM6Sl3GqtgINv6QWeReIzn/n2O/X5ZHIttXAkGoBzQCjDYkLO9Q/hd0k4agyRF1JiFPfzkE8F9bnRHmDQoA+CwHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gvJscU+0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gvJscU+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C105C4CEC3;
	Sun,  1 Sep 2024 16:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208675;
	bh=hP8B5zaVSxGNuxLteYATXF45YjgtxOeIzVyC20QMuKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gvJscU+0XFsqn3R5NmqoqIGMpM+SYoIKgEXxockCXYZ547dMoBCOilGELynmCQEpU
	 HnkXwFd52iyIZ66AXZ5qUgaLePVLbasFe9NRJX4E158m4FQNU36/ko3KSSCtPhde6z
	 EPxxBTziIOIFFQdc50mLWwuGxBRDd2js/oN0OWOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH 6.10 130/149] usb: dwc3: ep0: Dont reset resource alloc flag (including ep0)
Date: Sun,  1 Sep 2024 18:17:21 +0200
Message-ID: <20240901160822.342902853@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

commit 72fca8371f205d654f95b09cd023a71fd5307041 upstream.

The DWC3_EP_RESOURCE_ALLOCATED flag ensures that the resource of an
endpoint is only assigned once. Unless the endpoint is reset, don't
clear this flag. Otherwise we may set endpoint resource again, which
prevents the driver from initiate transfer after handling a STALL or
endpoint halt to the control endpoint.

Commit f2e0eee47038 ("usb: dwc3: ep0: Don't reset resource alloc flag")
was fixing the initial issue, but did this only for physical ep1. Since
the function dwc3_ep0_stall_and_restart is resetting the flags for both
physical endpoints, this also has to be done for ep0.

Cc: stable@vger.kernel.org
Fixes: b311048c174d ("usb: dwc3: gadget: Rewrite endpoint allocation flow")
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Link: https://lore.kernel.org/r/20240814-dwc3hwep0reset-v2-1-29e1d7d923ea@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/ep0.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/ep0.c b/drivers/usb/dwc3/ep0.c
index d96ffbe52039..c9533a99e47c 100644
--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -232,7 +232,8 @@ void dwc3_ep0_stall_and_restart(struct dwc3 *dwc)
 	/* stall is always issued on EP0 */
 	dep = dwc->eps[0];
 	__dwc3_gadget_ep_set_halt(dep, 1, false);
-	dep->flags = DWC3_EP_ENABLED;
+	dep->flags &= DWC3_EP_RESOURCE_ALLOCATED;
+	dep->flags |= DWC3_EP_ENABLED;
 	dwc->delayed_status = false;
 
 	if (!list_empty(&dep->pending_list)) {
-- 
2.46.0



