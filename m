Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5122C223331;
	Thu, 12 Dec 2024 16:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021482; cv=none; b=enM7qTvJ1nXfiJqn1RyfvlNl2wYd6AQXkUlB/1oeIPTyvNDwaKGEBDTzk+E1KP4n2jRN/rdaIeS8GzM6KNWMCqq6nMufN/q6mdFNLpENLN3MBb3dzd2fgNncxJh6nlFGqwm1cv7+jmRVRnHYpddUrmxkiFzJZrly2VjzGrvr97A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021482; c=relaxed/simple;
	bh=EMAjHTDsIfRkbwQwtlCvMPhgNaY78EMnAqVTmrBIyag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XyyrGe7UfftufdlDMcLcpDNPrzPfzqctACg6yxsGRI4ZZDqGZ/rW9MAMYkL9u5g1Pm9BOWem4984iPCM8EKfCJHK0NQ7difn4oz+GdiB+oHfPeNC4BXayt8gjYaxb6hcN4r8S8wkB+/9XbEJXQutfdJx3NL7LFsrrkyW5OEUK9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tq1EXzNC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tq1EXzNC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90775C4CECE;
	Thu, 12 Dec 2024 16:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021482;
	bh=EMAjHTDsIfRkbwQwtlCvMPhgNaY78EMnAqVTmrBIyag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tq1EXzNCxqyvK76TxHh33U7yO8kffVngVLRqhoIZ1smef34JadF//vBn92mb5gGWr
	 5c3NSK9UPUmeyVqy+qnmMenTXNFtPg+VLitay40PsFApnwIwoZLR087U++G3cOZ+bI
	 NAAPeWGuuHl5CIFD+GXfX2kadEjwMSstsUzapDTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chen <peter.chen@kernel.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 720/772] usb: chipidea: udc: handle USB Error Interrupt if IOC not set
Date: Thu, 12 Dec 2024 16:01:05 +0100
Message-ID: <20241212144419.636800130@linuxfoundation.org>
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
index 35dfc05854fb7..3795c70a31555 100644
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -2052,7 +2052,7 @@ static irqreturn_t udc_irq(struct ci_hdrc *ci)
 			}
 		}
 
-		if (USBi_UI  & intr)
+		if ((USBi_UI | USBi_UEI) & intr)
 			isr_tr_complete_handler(ci);
 
 		if ((USBi_SLI & intr) && !(ci->suspended)) {
-- 
2.43.0



