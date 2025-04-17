Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DDB258CD4;
	Thu, 17 Apr 2025 18:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914110; cv=none; b=fcY5GinlaA5WXTyC3pm4nCXtfV5Gbc2GPcmBEUXvOahm/Qqd//FUOGYXtBB2R09Cb4Mku3M+UuQrKmRs+LntaZ6PW75qkvSXs7FyE++VbIbIgDTnisZjUkndeU4OcLdJuUMu6yd605yQsb2sACjE0ldQeSfqPO47NyG2UePVQSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914110; c=relaxed/simple;
	bh=EEVUOpaTPcp6V8u2UPjJvA2vqY/3yGU3JRCIH93jPnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+756o1GkHCZyJNUsVDxMyGyl62MwfbA5aqotHG+x1svNzb/ZA/kN+Fuk7u2rJ3Zrddt9glEWbw1do/uUjqqUJqimNHli2ybfj12vR3LafpcmHD31KMblU+cMGVek9AqrP0XPDbau+f7cPEYGHoRxV4RtzpLm/sv8WG+z+jKT+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NPxhC9/w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NPxhC9/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCFA6C4CEE4;
	Thu, 17 Apr 2025 18:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914110;
	bh=EEVUOpaTPcp6V8u2UPjJvA2vqY/3yGU3JRCIH93jPnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NPxhC9/wwDdOt+96D+U7qWMtLksig8f302NrXfg0pfgJdFlZpSH6JponRTVCkltIN
	 vM5/yIsfpZpfVMJizAu3s3nhZcTgEU+hstXRGWFdMk9tSYguWaMWg0RE9cT4LjmkhS
	 rOggF0MQjJM2i8AKK0lpsv1q3vBv5Vw+/Rr4EYeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Schiller <ms@dev.tdt.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 108/414] net: sfp: add quirk for FS SFP-10GM-T copper SFP+ module
Date: Thu, 17 Apr 2025 19:47:46 +0200
Message-ID: <20250417175115.786348867@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Schiller <ms@dev.tdt.de>

[ Upstream commit 05ec5c085eb7ae044d49e04a3cff194a0b2a3251 ]

Add quirk for a copper SFP that identifies itself as "FS" "SFP-10GM-T".
It uses RollBall protocol to talk to the PHY and needs 4 sec wait before
probing the PHY.

Signed-off-by: Martin Schiller <ms@dev.tdt.de>
Link: https://patch.msgid.link/20250227071058.1520027-1-ms@dev.tdt.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 9369f52977694..c88217af44a14 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -385,7 +385,7 @@ static void sfp_fixup_rollball(struct sfp *sfp)
 	sfp->phy_t_retry = msecs_to_jiffies(1000);
 }
 
-static void sfp_fixup_fs_2_5gt(struct sfp *sfp)
+static void sfp_fixup_rollball_wait4s(struct sfp *sfp)
 {
 	sfp_fixup_rollball(sfp);
 
@@ -399,7 +399,7 @@ static void sfp_fixup_fs_2_5gt(struct sfp *sfp)
 static void sfp_fixup_fs_10gt(struct sfp *sfp)
 {
 	sfp_fixup_10gbaset_30m(sfp);
-	sfp_fixup_fs_2_5gt(sfp);
+	sfp_fixup_rollball_wait4s(sfp);
 }
 
 static void sfp_fixup_halny_gsfp(struct sfp *sfp)
@@ -479,9 +479,10 @@ static const struct sfp_quirk sfp_quirks[] = {
 	// PHY.
 	SFP_QUIRK_F("FS", "SFP-10G-T", sfp_fixup_fs_10gt),
 
-	// Fiberstore SFP-2.5G-T uses Rollball protocol to talk to the PHY and
-	// needs 4 sec wait before probing the PHY.
-	SFP_QUIRK_F("FS", "SFP-2.5G-T", sfp_fixup_fs_2_5gt),
+	// Fiberstore SFP-2.5G-T and SFP-10GM-T uses Rollball protocol to talk
+	// to the PHY and needs 4 sec wait before probing the PHY.
+	SFP_QUIRK_F("FS", "SFP-2.5G-T", sfp_fixup_rollball_wait4s),
+	SFP_QUIRK_F("FS", "SFP-10GM-T", sfp_fixup_rollball_wait4s),
 
 	// Fiberstore GPON-ONU-34-20BI can operate at 2500base-X, but report 1.2GBd
 	// NRZ in their EEPROM
-- 
2.39.5



