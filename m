Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E560921E0BC;
	Thu, 12 Dec 2024 16:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020876; cv=none; b=Vs3kdGfG+OZiZD93M8Di+KeBzgjgLyxGnFspKbBRnhDwEvZU/IpOgITaS7zFMxxiR12hOhEVKeraaa0BpCYPDgPFDl2Ruc8J0y7mIJ9N486RH0XMy05++af60Gy0/TLhpJG/pfKyO3glqMSsNAaYGht3cVOJKKS+EesR6WygRF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020876; c=relaxed/simple;
	bh=DNw/OJrnt8J9VEMzCPhu6RD2wjzs0ibT33aK7S/fQkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WuEw2iugmKuGB/DtONrPHrTLzpf1QoFrh+HEF5A76xK86d4GdUvtEfwIZqrCeG8yzO6G3MhIF98UxhR3D9PJ9nSgiLXIS13pP2fE+j+JUp1J8BQNlpMH/e+7WVp/uh28zFXjJHrLphLfXzokGzdEnd5bCk/QjZZpBmqmqaJopL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AjOJ/H36; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AjOJ/H36"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3EEC4CED0;
	Thu, 12 Dec 2024 16:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020875;
	bh=DNw/OJrnt8J9VEMzCPhu6RD2wjzs0ibT33aK7S/fQkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AjOJ/H36+F5DD32wZOSy/RI89upPMGGXAvPPX7g2HfOmOHTf97YP940Fnll4hmDkl
	 JrSk9YZHWi8Sfbepx9q62bgmqc+mEyonvKuFhqlPnvMw0zAIgjwFRGgCJ9jloNfKlW
	 XDiIRRq59L6nLZz2+pwEynlGkhL08FWWbMRy6la8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 554/772] usb: dwc3: ep0: Dont reset resource alloc flag (including ep0)
Date: Thu, 12 Dec 2024 15:58:19 +0100
Message-ID: <20241212144412.853592705@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

[ Upstream commit 72fca8371f205d654f95b09cd023a71fd5307041 ]

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
Stable-dep-of: 5d2fb074dea2 ("usb: dwc3: ep0: Don't clear ep0 DWC3_EP_TRANSFER_STARTED")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/ep0.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/ep0.c b/drivers/usb/dwc3/ep0.c
index afaaff33862bb..2da36f02a10e8 100644
--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -229,7 +229,8 @@ void dwc3_ep0_stall_and_restart(struct dwc3 *dwc)
 	/* stall is always issued on EP0 */
 	dep = dwc->eps[0];
 	__dwc3_gadget_ep_set_halt(dep, 1, false);
-	dep->flags = DWC3_EP_ENABLED;
+	dep->flags &= DWC3_EP_RESOURCE_ALLOCATED;
+	dep->flags |= DWC3_EP_ENABLED;
 	dwc->delayed_status = false;
 
 	if (!list_empty(&dep->pending_list)) {
-- 
2.43.0



