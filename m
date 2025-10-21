Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6DE1FF7BC;
	Tue, 21 Oct 2025 20:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076849; cv=none; b=T7fuShXBqb+eCcg4G61Xq/znBoP0mioYB4+y4oT3sgWsEgWakrZFp0lx6agEqeJ/OJnSLOyq9bU7NjniJw/9BX9jHVUQ6uzRoczS186QjGWxjgJAGjr7o4fRfo8/IbmqV1I6pg47iedKZjbMYOtQi+BK7+XXu/25smVWDzHzP/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076849; c=relaxed/simple;
	bh=lVAOsXwkbHHKAMirYlyhjxWcrKfUCyOSOf3yZ2QGv3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mcu0PnlrQRMPSMG9qhrObIxBFMuBVF7dTLCl/sK372RzRmxF0rCKTlEhFJ/nVTDRTKoQDS/+Dnuz/E5d2/W8O3MjRrHdEfaLovbnNuvt+CavWJkWuvN7h4Y+8tEd1kTr+SsBicyrrctrRPSaMpCFBO9g4puTys1PH/D1bDibNgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wcf+TSAg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wcf+TSAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46DFAC4CEF1;
	Tue, 21 Oct 2025 20:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076849;
	bh=lVAOsXwkbHHKAMirYlyhjxWcrKfUCyOSOf3yZ2QGv3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wcf+TSAgrwAhGIL0hN3IcV4wPjbSZx1yxZuCHEPR47wRiqyVWwCpGD5vfWcKHw5yN
	 Lpyrn8cbqk7Ex3fsgTfD4LaK+7mmCfPMzLOwhVBI59++mpWVqbB+GMGUjsVxv/XUvJ
	 Cb2CieHRkmgGTdu4bigL4VcbCoxiRmHWIXLe/83k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandr Sapozhnikov <alsp705@gmail.com>,
	Alexey Simakov <bigalex934@gmail.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 058/136] tg3: prevent use of uninitialized remote_adv and local_adv variables
Date: Tue, 21 Oct 2025 21:50:46 +0200
Message-ID: <20251021195037.376690740@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 717e110d23c91..dc170feee8ad7 100644
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



