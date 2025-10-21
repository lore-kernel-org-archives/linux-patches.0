Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E44926E6F5;
	Tue, 21 Oct 2025 20:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077377; cv=none; b=RgJE2oS0mMaW2uTe/bPMtH9FB4OZFVOSVXBKsWM1lNttBvytSV3AiuqKHjtfzP4ah1UnG9ZnCkUoVzZUi9Y0Zp/2UyoIXzZqjLA69vafpPLX+BIsd4+FzraB5vCT0SdwuPH0CfjtPA8Ln/3tL8vxCvzY4+OQs8tlkXxG+y3yl/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077377; c=relaxed/simple;
	bh=kK1uVQ5pOzmNxeVeW+RgT7U+TxIlqF46ILy66UHJvC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MKZVUxGI+5nbbq7MTSV3rrPJeHeJRINfg1C/kVdCIoXWasf5aV7OG2FT3jo7jrAYWtKjOCse+k2u631D5Zda50GpEbt3luuQqK/bXx6JajojHwh3CZuSfu+Fhkaado4fVPcQPDS1oTySX3izU7DIfYl2cZ4uX+J73J5TxbFd6jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ik4WPRvU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ik4WPRvU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D76C4CEF1;
	Tue, 21 Oct 2025 20:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077377;
	bh=kK1uVQ5pOzmNxeVeW+RgT7U+TxIlqF46ILy66UHJvC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ik4WPRvUcJDyPEdA6F5cWirGAdH7/8Kpn7YCmlfZF7VndND9+1c269y93aHwULVFZ
	 vg9y1XlxFWAHWs8nrxe7aUo+W8n/ferQxbVFuvp6VvG0e12Ey22OW1IoNlEEYA/vVH
	 8x7oxBE0JoSoJ8lOfHCsG0+X5mjbM7KRUmYDpaZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandr Sapozhnikov <alsp705@gmail.com>,
	Alexey Simakov <bigalex934@gmail.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 084/159] tg3: prevent use of uninitialized remote_adv and local_adv variables
Date: Tue, 21 Oct 2025 21:51:01 +0200
Message-ID: <20251021195045.214048723@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Simakov <bigalex934@gmail.com>

[ Upstream commit 0c3f2e62815a43628e748b1e4ad97a1c46cce703 ]

Some execution paths that jump to the fiber_setup_done label
could leave the remote_adv and local_adv variables uninitialized
and then use it.

Initialize this variables at the point of definition to avoid this.

Fixes: 85730a631f0c ("tg3: Add SGMII phy support for 5719/5718 serdes")
Co-developed-by: Alexandr Sapozhnikov <alsp705@gmail.com>
Signed-off-by: Alexandr Sapozhnikov <alsp705@gmail.com>
Signed-off-by: Alexey Simakov <bigalex934@gmail.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Link: https://patch.msgid.link/20251014164736.5890-1-bigalex934@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/tg3.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index b4dc93a487184..8b64e4667c21c 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -5803,7 +5803,7 @@ static int tg3_setup_fiber_mii_phy(struct tg3 *tp, bool force_reset)
 	u32 current_speed = SPEED_UNKNOWN;
 	u8 current_duplex = DUPLEX_UNKNOWN;
 	bool current_link_up = false;
-	u32 local_adv, remote_adv, sgsr;
+	u32 local_adv = 0, remote_adv = 0, sgsr;
 
 	if ((tg3_asic_rev(tp) == ASIC_REV_5719 ||
 	     tg3_asic_rev(tp) == ASIC_REV_5720) &&
@@ -5944,9 +5944,6 @@ static int tg3_setup_fiber_mii_phy(struct tg3 *tp, bool force_reset)
 		else
 			current_duplex = DUPLEX_HALF;
 
-		local_adv = 0;
-		remote_adv = 0;
-
 		if (bmcr & BMCR_ANENABLE) {
 			u32 common;
 
-- 
2.51.0



