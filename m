Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AF413792B;
	Thu, 12 Dec 2024 15:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017207; cv=none; b=Z1V9k9Cw8jE/BxHLNKEVeyRJE8Nyk2OIPxOe5Rq8it110bTeZTh8/RnPvnznL5rDrrTTyWdx9B7c8UNrtd4D149WO3nu7vNjW7iEnSFxDMW1c5po7d5j0vfQCpv/5LWrrKn6FF6UpDOkwYmMrL8JXaPhPqQoPCQZexoxeGwa1dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017207; c=relaxed/simple;
	bh=oOHGbAPO6l+2OzNsRKtNM4gscLagA4vxgv9nUsESgVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uuLOThiQK9/6+sm9TiZiea25iBQI7FC4d/t0I75ETYZiDMSAoLM4g3db970/2a1Sb/95vfb5dzFluiOJKdujLOFRQzAis9v9xMQnCfiMRym8OAG4a+3Yol4ZXRLUZsKF3Je0SzKI0GibprdV4PrenAdUWn1vzdCr+p5T0zcsuL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dBgnl+LA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dBgnl+LA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D73C4CECE;
	Thu, 12 Dec 2024 15:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017207;
	bh=oOHGbAPO6l+2OzNsRKtNM4gscLagA4vxgv9nUsESgVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dBgnl+LAnWzQa4eGt4rxH57n77C5aTWG2D1CJeO2N0qY9T2tB3Falc2M7bZHTut4g
	 Hxth0GE4DUFF9oJHLTESjvRX01UlyARTJ9My0+07v7nw4Hh8WIAJLeYJlsrqx3inW6
	 nt+Mb8aettsZtJNJkubVOCW4w7+NeV0v6c/w3oAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chen <peter.chen@kernel.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 412/466] usb: chipidea: udc: handle USB Error Interrupt if IOC not set
Date: Thu, 12 Dec 2024 15:59:41 +0100
Message-ID: <20241212144323.036742807@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

[ Upstream commit 548f48b66c0c5d4b9795a55f304b7298cde2a025 ]

As per USBSTS register description about UEI:

  When completion of a USB transaction results in an error condition, this
  bit is set by the Host/Device Controller. This bit is set along with the
  USBINT bit, if the TD on which the error interrupt occurred also had its
  interrupt on complete (IOC) bit set.

UI is set only when IOC set. Add checking UEI to fix miss call
isr_tr_complete_handler() when IOC have not set and transfer error happen.

Acked-by: Peter Chen <peter.chen@kernel.com>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://lore.kernel.org/r/20240926022906.473319-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/chipidea/udc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
index f0fcaf2b1f334..fd6032874bf33 100644
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -2217,7 +2217,7 @@ static irqreturn_t udc_irq(struct ci_hdrc *ci)
 			}
 		}
 
-		if (USBi_UI  & intr)
+		if ((USBi_UI | USBi_UEI) & intr)
 			isr_tr_complete_handler(ci);
 
 		if ((USBi_SLI & intr) && !(ci->suspended)) {
-- 
2.43.0



