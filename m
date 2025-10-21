Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DC726738B;
	Tue, 21 Oct 2025 19:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076470; cv=none; b=lTXz4WQHDt/j7g/o1f6YfPIDFNMp3Co2+uyqXlKSVaNweEvPqrQ60qVEXoBNSyj8ZKmNQ5PFambMF3vIRtuX9znv0om442l+HRt1KYkiF7gl9JNbj4C5Ynb0XIBerpzKA5fTKwRSPkx8c9J4KNu01x0MoVLDh+Ch+u91yn+sGu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076470; c=relaxed/simple;
	bh=c/0/qfj6895Er1fntTzrZf6xQmKMCtqoeC87S8URPYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h9P9IitMn69yqefUHFUAvDJddBJkdmlmuw0CVPizWsEpHBNm+hUW1RgPtjzo7YQovwykfg2fDUA3oMKwBUPuGpVWXDq5pMD6HM+4dtiZyPCYLcpYUa/2U6xeDAlodXc0zoeIThP9faEabT2V8PHBrTzuolFEwu4/0qtLMrOVsCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HqzNmI/I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HqzNmI/I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB79AC4CEF1;
	Tue, 21 Oct 2025 19:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076470;
	bh=c/0/qfj6895Er1fntTzrZf6xQmKMCtqoeC87S8URPYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HqzNmI/IAhp2YwIfT/ZboNGpZBWMjjQPSx2QfIZOwOpK39QZD1cZleBT0wmXyZXud
	 t0lAGnLzlmQd7+z8VNInURjtJTpOg0xh9y3sD6R9Woy0AQXfRT2X0e2fAUjXxjbJ1d
	 dZFEZUEQK0XqL37Q7D+8Dy5GMjMK0M4PaYUmsHDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandr Sapozhnikov <alsp705@gmail.com>,
	Alexey Simakov <bigalex934@gmail.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 043/105] tg3: prevent use of uninitialized remote_adv and local_adv variables
Date: Tue, 21 Oct 2025 21:50:52 +0200
Message-ID: <20251021195022.709639178@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b3878975bd9c0..ea4973096aa28 100644
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



