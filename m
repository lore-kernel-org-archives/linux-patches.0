Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145541C331A;
	Mon, 14 Oct 2024 15:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919801; cv=none; b=El2LpkYPYFmMFVG2rma8W20uchvtN0miThVv49KzFTNMo+tj4+6NwCQaCoNbCsjoiGMNw/qgZOqTwAMujcX+BYfU4DlsIl/p7Ld3yKv/jOkn3WGTTyOYZ03t0XIuksx4QgPcujIqRz/5TXDd3UZs/c/3nR0TP0PQkwAqNgrA2mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919801; c=relaxed/simple;
	bh=xFhJHpJWYC9/OlD+Q7nFlBKf3ELFtiHbvSCvIXZ5ggU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rbhISF7c9pt6uwN/ieY5yKv3MjNTbbxOm/IQ5bZyqBzg2YJ0FoQ1cpmYec5X54Ag7ivMGshH5O4f9OTxW0cid1PWEZ4/4fXEeHzIzNW4uWI286sFKePnvTHdBAxB+sx9cIGAEKM12MZOsu0BJtP7YmCZ68TLPrOt/C8gEL3WESU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UPkU9ygh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UPkU9ygh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E685C4CEC3;
	Mon, 14 Oct 2024 15:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919800;
	bh=xFhJHpJWYC9/OlD+Q7nFlBKf3ELFtiHbvSCvIXZ5ggU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UPkU9yghz342KGaVy2LqNPwl7ygZoXcw8ga7UUxZyd6weHaZpYk7n1fS6otOfg+Sc
	 MdMy0/9y7m09xVpJpk1yy87dtvvZQ5KXT/l/8slPZbZdEJNd1ZRvNJbRXfo0xk49Dg
	 lFi4cHDPBUIDsBWvplupmBC/nawGV3TFYbzuFOtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Peter Chen <peter.chen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 711/798] usb: chipidea: udc: enable suspend interrupt after usb reset
Date: Mon, 14 Oct 2024 16:21:05 +0200
Message-ID: <20241014141246.000893044@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Xu Yang <xu.yang_2@nxp.com>

[ Upstream commit e4fdcc10092fb244218013bfe8ff01c55d54e8e4 ]

Currently, suspend interrupt is enabled before pullup enable operation.
This will cause a suspend interrupt assert right after pullup DP. This
suspend interrupt is meaningless, so this will ignore such interrupt
by enable it after usb reset completed.

Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/20240823073832.1702135-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/chipidea/udc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
index 8c3e3a635ac2d..35dfc05854fb7 100644
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -86,7 +86,7 @@ static int hw_device_state(struct ci_hdrc *ci, u32 dma)
 		hw_write(ci, OP_ENDPTLISTADDR, ~0, dma);
 		/* interrupt, error, port change, reset, sleep/suspend */
 		hw_write(ci, OP_USBINTR, ~0,
-			     USBi_UI|USBi_UEI|USBi_PCI|USBi_URI|USBi_SLI);
+			     USBi_UI|USBi_UEI|USBi_PCI|USBi_URI);
 	} else {
 		hw_write(ci, OP_USBINTR, ~0, 0);
 	}
@@ -876,6 +876,7 @@ __releases(ci->lock)
 __acquires(ci->lock)
 {
 	int retval;
+	u32 intr;
 
 	spin_unlock(&ci->lock);
 	if (ci->gadget.speed != USB_SPEED_UNKNOWN)
@@ -889,6 +890,11 @@ __acquires(ci->lock)
 	if (retval)
 		goto done;
 
+	/* clear SLI */
+	hw_write(ci, OP_USBSTS, USBi_SLI, USBi_SLI);
+	intr = hw_read(ci, OP_USBINTR, ~0);
+	hw_write(ci, OP_USBINTR, ~0, intr | USBi_SLI);
+
 	ci->status = usb_ep_alloc_request(&ci->ep0in->ep, GFP_ATOMIC);
 	if (ci->status == NULL)
 		retval = -ENOMEM;
-- 
2.43.0



