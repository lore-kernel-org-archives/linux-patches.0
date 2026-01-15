Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4B73C1997;
	Thu, 15 Jan 2026 17:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498476; cv=none; b=KoDDQ6P5SZxIb4MTpd/5BlIGSvmM6jKyZpR6Q8BeYplG9JbW7XWEBnknkxa4udeFJRx/OCvbuDAL3VyZxKh91yH0UI7CipQg2qFCXRJoHaqFuCeqbzZw0e5IAEiOuH8vMU5X9AI3noNOtnOKMM3UROXFJhve2bYdqiJafsSPxkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498476; c=relaxed/simple;
	bh=wPki+DrT/P380REOJ5zKwGmNjCooDDGVXnp/atL2cVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebZ54SGhjJnnEavVWUiYUq0lw6JqdR7n9fnL+CyEt/cXE1lPznzix96UPdE3ti2KfKw3ks2V2ZdkbmEvSumHqk4YHV8aCbI0kGhr1ns3IxrABjZFK7uBWBBJHSqW45NSa144IHkL5UUtIlcxXtz1MrNo6IyAAtiBOoTjURAkkQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nrKQBcZd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nrKQBcZd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B9EC19422;
	Thu, 15 Jan 2026 17:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498476;
	bh=wPki+DrT/P380REOJ5zKwGmNjCooDDGVXnp/atL2cVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nrKQBcZdb9WVVA8vEifbc6LDc7ljlS/XfzELIquUrk336EhdNyiwQp6E8wz4FQNPu
	 onkUTY0uZZj2dpzf23pXtjGzoP0KPCNYfyZxUMevLx7eNZUmbI6n4bkFv+XuOkmNGG
	 f9H9t4GoY784WP/rUYiDGSkTQDqWAz1fp4ujQXB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Udipto Goswami <udipto.goswami@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 445/554] usb: dwc3: keep susphy enabled during exit to avoid controller faults
Date: Thu, 15 Jan 2026 17:48:31 +0100
Message-ID: <20260115164302.376819251@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Udipto Goswami <udipto.goswami@oss.qualcomm.com>

[ Upstream commit e1003aa7ec9eccdde4c926bd64ef42816ad55f25 ]

On some platforms, switching USB roles from host to device can trigger
controller faults due to premature PHY power-down. This occurs when the
PHY is disabled too early during teardown, causing synchronization
issues between the PHY and controller.

Keep susphy enabled during dwc3_host_exit() and dwc3_gadget_exit()
ensures the PHY remains in a low-power state capable of handling
required commands during role switch.

Cc: stable <stable@kernel.org>
Fixes: 6d735722063a ("usb: dwc3: core: Prevent phy suspend during init")
Suggested-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Udipto Goswami <udipto.goswami@oss.qualcomm.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://patch.msgid.link/20251126054221.120638-1-udipto.goswami@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    2 +-
 drivers/usb/dwc3/host.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -4585,7 +4585,7 @@ void dwc3_gadget_exit(struct dwc3 *dwc)
 	if (!dwc->gadget)
 		return;
 
-	dwc3_enable_susphy(dwc, false);
+	dwc3_enable_susphy(dwc, true);
 	usb_del_gadget(dwc->gadget);
 	dwc3_gadget_free_endpoints(dwc);
 	usb_put_gadget(dwc->gadget);
--- a/drivers/usb/dwc3/host.c
+++ b/drivers/usb/dwc3/host.c
@@ -157,7 +157,7 @@ err:
 
 void dwc3_host_exit(struct dwc3 *dwc)
 {
-	dwc3_enable_susphy(dwc, false);
+	dwc3_enable_susphy(dwc, true);
 	platform_device_unregister(dwc->xhci);
 	dwc->xhci = NULL;
 }


