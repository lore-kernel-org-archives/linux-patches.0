Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEA52054F8;
	Thu, 12 Dec 2024 15:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017683; cv=none; b=tLgyzXWqXoCY9xWfeSyCUjEXVji/LtYuWLdqDAmdHzsh3irOEFjVJg23lOFrCccurTiPeHnJs6a9VQcZ/KCr2cJbA0GMTHnomFH8ucPJAqqjK7Zogp+axElnyC//ozNjMmC5qXGOzSJMU0VXaCZnWUPdRUcW6KSVW4yhGWxJ38Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017683; c=relaxed/simple;
	bh=qziqEWd4DDUhzTEuaHrV9ouD55iG7H3DVuS9VSEO/ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=njA2yqvojDWK4PMi+hPN7Zf5BS4tTAZ6IHnt4NASydRVSJPZEGosplhwRIGsabAAvMmib7T9p1rMkdrQzPy3ktrT/rho/G5UYmDmt9pzYRv68C+OKrSucZiJ27nqJIok4QxRogzukT92xwHvj6X1Ys0hyDXZsxrBjVzupgIx1Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cTaOZp+8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cTaOZp+8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152B4C4CECE;
	Thu, 12 Dec 2024 15:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017682;
	bh=qziqEWd4DDUhzTEuaHrV9ouD55iG7H3DVuS9VSEO/ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cTaOZp+8pjL4W/I1npZ9+MBF+YHyagWGvKonFegSdxmEX2SqURe0Azi34dOGWeNed
	 79nEJC0ujLmb6yCHbNotaK5Oef5SX/eMl09MViDooXfOyeLjUUd3RnzBXcUvKo7zP4
	 9Z8Bsdv2pYPQTAwLlZc4P/EUxTr13NmbWN2kq31A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 081/356] usb: dwc3: ep0: Dont reset resource alloc flag (including ep0)
Date: Thu, 12 Dec 2024 15:56:40 +0100
Message-ID: <20241212144247.822312408@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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
index 72bb722da2f25..371662a552538 100644
--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -231,7 +231,8 @@ void dwc3_ep0_stall_and_restart(struct dwc3 *dwc)
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



