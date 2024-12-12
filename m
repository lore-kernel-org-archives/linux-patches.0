Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B62B215764;
	Thu, 12 Dec 2024 15:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018472; cv=none; b=RdAp3Jdnd87t/vq/NxYlJK8ZKx7nVazpvYRyK1PN1Ig54FajSKNWwnJTXtXpjSbZiSyRiJoBWiCJfgXVqamvj/SgNFD357l7UwCK7fcIQwQ0hg8i1HRnFrrpox9Xr7E/2nXyqnA+P9darP2PSRpNZaJ9QTkE+2jkOchLDcBoigM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018472; c=relaxed/simple;
	bh=XXI9I/hZBFiLrbc/vbPHcEk0N4gmwrTvYcML459GsM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+j9Qyt+FfotVcU53EdSjj/ldNsJIISiU7Kt8n3we5WI5gk5bHvHpEjPu0kkAwT6FJJdobTOpa9lOfecpQt/td9GhA61u0zb1k52ZSbmUOwxmaWH9HZ0H8iq8U6Szq0aG03JphNhYqi6fVBFaB+jYpf/4hbIXnoG68befdduwKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pF84pqEQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pF84pqEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95850C4CECE;
	Thu, 12 Dec 2024 15:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018472;
	bh=XXI9I/hZBFiLrbc/vbPHcEk0N4gmwrTvYcML459GsM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pF84pqEQxto5yBlUGA2C+DV3b2mRFYjRimMVCtrLdXL5VEqfEq8H4shgzs+xDE2dL
	 v/WWdTFxpr8H6hw+xnRl2cSIcnYZk2rVlMWcy7pDYD6DKPF4Hcv2pAVYaA3E+rCqRV
	 8mpiGvzMWw4PV/HSljdtPYjrBy2WJizKoeMafu6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chen <peter.chen@kernel.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 303/356] usb: chipidea: udc: handle USB Error Interrupt if IOC not set
Date: Thu, 12 Dec 2024 16:00:22 +0100
Message-ID: <20241212144256.535164495@linuxfoundation.org>
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
index f70ceedfb468f..9f7d003e467b5 100644
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -2062,7 +2062,7 @@ static irqreturn_t udc_irq(struct ci_hdrc *ci)
 			}
 		}
 
-		if (USBi_UI  & intr)
+		if ((USBi_UI | USBi_UEI) & intr)
 			isr_tr_complete_handler(ci);
 
 		if ((USBi_SLI & intr) && !(ci->suspended)) {
-- 
2.43.0



