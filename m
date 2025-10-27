Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1832DAFC3;
	Mon, 27 Oct 2025 19:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592237; cv=none; b=QVhXGznKi8SixYOi7LUx1IEzH7JzGw+L3+zUOREeNzwYe7FclRseqHrbR6KizsdEO3uJl2dTyqfZlr3u3RTEP+GENDTlIBTBHnHlsOHu8ZVyS5XjOV6gLBnAdy85IKLSg3kLr00hyL1bKVoKf9IfM2bHIcC8r3B//er3yFVr48A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592237; c=relaxed/simple;
	bh=YewE0aYX/LKzIJ2q/aqKRzTuQmmNtXeBynLNXAOSYZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h9CFrYWtZWI4fidg5Ot+QN6Argjc8hHAeV8Z+yhiBgOGlWg5vCaL3jvONK5TZOyA/aPBMJuJ0XcDxCVvZ3mbcE/LtPv9jgHDeK0HvjZzsun8KpKanRoZ5woVFn28CQYY3/tFaTV5S6zdFFDYRHs2PLMiaj639bmJ5mCh19rPJvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NJ+AVQNy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NJ+AVQNy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2219C4CEF1;
	Mon, 27 Oct 2025 19:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592237;
	bh=YewE0aYX/LKzIJ2q/aqKRzTuQmmNtXeBynLNXAOSYZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NJ+AVQNy4VRf3xxlG4kLeq1AX9wlvOcADWRMOWHs6Jim70mc0EvIRUOa9wMdk1cjm
	 fuNd+fkTEkxPDcgm3blPRQbXGV+Wnh7k7Zklty8EdixUAcm6YOK86mkAgAZusQnWo/
	 Gf3JdBQeWNh8sxhXRgSSMhXY5lo/BnjlxRJ70cmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandr Sapozhnikov <alsp705@gmail.com>,
	Alexey Simakov <bigalex934@gmail.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/157] tg3: prevent use of uninitialized remote_adv and local_adv variables
Date: Mon, 27 Oct 2025 19:35:05 +0100
Message-ID: <20251027183502.478775574@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 95d460237835d..8e5236142aaca 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -5814,7 +5814,7 @@ static int tg3_setup_fiber_mii_phy(struct tg3 *tp, bool force_reset)
 	u32 current_speed = SPEED_UNKNOWN;
 	u8 current_duplex = DUPLEX_UNKNOWN;
 	bool current_link_up = false;
-	u32 local_adv, remote_adv, sgsr;
+	u32 local_adv = 0, remote_adv = 0, sgsr;
 
 	if ((tg3_asic_rev(tp) == ASIC_REV_5719 ||
 	     tg3_asic_rev(tp) == ASIC_REV_5720) &&
@@ -5955,9 +5955,6 @@ static int tg3_setup_fiber_mii_phy(struct tg3 *tp, bool force_reset)
 		else
 			current_duplex = DUPLEX_HALF;
 
-		local_adv = 0;
-		remote_adv = 0;
-
 		if (bmcr & BMCR_ANENABLE) {
 			u32 common;
 
-- 
2.51.0



