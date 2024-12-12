Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF51522331E;
	Thu, 12 Dec 2024 17:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023411; cv=none; b=Yb8zj57tfPB5lo+Wo9QsgJIfbKCfSt9opTS2lF4H5lu4pgb4laSu40XMFNc9y4NOMMXWC0KEjqTgSocFYov0cF+IiW1w2RpebZQSLx/TNibxNNkyP+qzygeWvxrIbxCToFR6R1Vc7eMikLKMksOw4O/DkjAEh47u7Q0nloLbVUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023411; c=relaxed/simple;
	bh=5OXQhV7lFOdDPwGbGKtK0YjDkn3tumAM1jMIVTLbv0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OBddLmxl+KxJBOzyCZJugmHaKmcJW78B4r8O6xXQiujpaRX/yZaSUxK6pvS8qRvRxJng19H1K2AfjXBRWimT16T1HZWnBJOqKV5xGYLnDwEV0mGyrqf/IeIJSQv6Q5wwJET53nxxM2kb/g4nsuLVwQM2dheU8vKIgUU2xWTf+q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZLaWjZz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZLaWjZz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7F8C4CECE;
	Thu, 12 Dec 2024 17:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023411;
	bh=5OXQhV7lFOdDPwGbGKtK0YjDkn3tumAM1jMIVTLbv0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZLaWjZzK2KIjOut7178qaV1cqp3dA2B4C+QOFRJ4/4E0tQowO9H2QxKNd52+Xe45
	 lpYrr27R32OeT/peNtfOlrTCwkh3YFFClEYoBZO1APkdawfgGU0vUmpMTWQjig4Lqj
	 7u624Zar+zWbad0utMirHCPVWZRG60DzFtVFn9+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chen <peter.chen@kernel.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 526/565] usb: chipidea: udc: handle USB Error Interrupt if IOC not set
Date: Thu, 12 Dec 2024 16:02:01 +0100
Message-ID: <20241212144332.595636043@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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
index 8b6745b7588c7..187c13af4b352 100644
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -2030,7 +2030,7 @@ static irqreturn_t udc_irq(struct ci_hdrc *ci)
 			}
 		}
 
-		if (USBi_UI  & intr)
+		if ((USBi_UI | USBi_UEI) & intr)
 			isr_tr_complete_handler(ci);
 
 		if ((USBi_SLI & intr) && !(ci->suspended)) {
-- 
2.43.0



