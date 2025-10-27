Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4CC32861F;
	Mon, 27 Oct 2025 18:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590761; cv=none; b=Fw9ykxi9i34745+2xJMLhY71XCJHdAzAVKgSxsJRdldKhE5yYQsDDqWBK6jPNHrAPMe9MJvrLLvlkwqXD5S9XWckv6QN1LayPH385z0UervM9QqQ5uiNUofHbcsn2UOypflGCAbbse68IOK2dedr5uwMInHxcrQOyF4Jy1PokfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590761; c=relaxed/simple;
	bh=5APvA1XvDYoZdaVBZGwjl3bwuxKhcsOJBwtULxRUd1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PBfrmLL5fD/F25IsirGpnSAPv/FTqqN/2PfoPJNAeJeKoVqJEY5pYBxKu6Cnst3w2WlMOoV0YdTfHjg3peMoFLnH1ewRL0sPN0yiFo8VfoMqhq9rJWurzrWipTey59U8ZQvRFzgweJ55GK7+rDlznNsA5Fbqal2rGVSXVyzOH4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0DtdWxfM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0DtdWxfM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C334BC4CEF1;
	Mon, 27 Oct 2025 18:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590761;
	bh=5APvA1XvDYoZdaVBZGwjl3bwuxKhcsOJBwtULxRUd1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0DtdWxfMQb0CZ7VESSfyQ19EKy4peFT4vhJBDmBWIV3BMvHq3dt408th1k+S5L02Y
	 XPuJRibCeXLVdqv17N/MbBYY0stUcowS/RJXGRxRspNilZe2OfxoUgXFWJLA6cvze3
	 ftfijx3fwxWBuh9gsXk+yG1trTsRvtqqFohbN5ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandr Sapozhnikov <alsp705@gmail.com>,
	Alexey Simakov <bigalex934@gmail.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 163/224] tg3: prevent use of uninitialized remote_adv and local_adv variables
Date: Mon, 27 Oct 2025 19:35:09 +0100
Message-ID: <20251027183513.288089770@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 55aa877713339..3ea966d85ea38 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -5827,7 +5827,7 @@ static int tg3_setup_fiber_mii_phy(struct tg3 *tp, bool force_reset)
 	u32 current_speed = SPEED_UNKNOWN;
 	u8 current_duplex = DUPLEX_UNKNOWN;
 	bool current_link_up = false;
-	u32 local_adv, remote_adv, sgsr;
+	u32 local_adv = 0, remote_adv = 0, sgsr;
 
 	if ((tg3_asic_rev(tp) == ASIC_REV_5719 ||
 	     tg3_asic_rev(tp) == ASIC_REV_5720) &&
@@ -5968,9 +5968,6 @@ static int tg3_setup_fiber_mii_phy(struct tg3 *tp, bool force_reset)
 		else
 			current_duplex = DUPLEX_HALF;
 
-		local_adv = 0;
-		remote_adv = 0;
-
 		if (bmcr & BMCR_ANENABLE) {
 			u32 common;
 
-- 
2.51.0



