Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92C82DFF14;
	Tue, 17 Jun 2025 16:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176597; cv=none; b=psa6Li2Esj16qE4g3fnQUPQlGOiNeXAXy4+ziTUwjMyQp2TcLvh6mNJabb/6K/5wuEl+vCsQLcodTL57oY8bFrHPnEodMpoU+D+UMcJJiiWYtv59mmXhWGDDz+bI3B/EDf2tLRqk2fwXysHr7+MG2xXPGBm4+oKuD0aXzFIQ6KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176597; c=relaxed/simple;
	bh=CSO9S61RN2fFJTcpq8v6NI/ZxY3diLU3mzC2d6JItys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TraKWXPlMFb91MSGcafta3MKNrQmpQ3OWAHq7QZOfvUoX8m9gVakKeB92N5lNrQ4PASgrsDlIxpbENf4/UU5qc9KtbOfjLAeRtPaZxO/sVGtVzligJPVfr2M7o6dFpIMEijujLE5lfGhx9zDMMZnxAc1yXLQm5Lh2mqhJaqdDRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VHdlqMbo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VHdlqMbo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E60BC4CEE3;
	Tue, 17 Jun 2025 16:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176597;
	bh=CSO9S61RN2fFJTcpq8v6NI/ZxY3diLU3mzC2d6JItys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VHdlqMboCxAtUQatfbw0mPFA0mnjiXDVqN1+XSCEIOKwyGJ27P3mcHAnD/+MKXMZ5
	 fUjPXm9SB2MAw4fVrtEysnmwdjtIFyQQ6e2U8xbggdxL9ep0aFplQQnL+s4vuNHRXK
	 XdYu19ePzbehWHr/1OkO66XuOiJS/1mjV6i/D/Ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Connolly <caleb.connolly@linaro.org>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 296/356] ath10k: snoc: fix unbalanced IRQ enable in crash recovery
Date: Tue, 17 Jun 2025 17:26:51 +0200
Message-ID: <20250617152350.087643471@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Caleb Connolly <caleb.connolly@linaro.org>

[ Upstream commit 1650d32b92b01db03a1a95d69ee74fcbc34d4b00 ]

In ath10k_snoc_hif_stop() we skip disabling the IRQs in the crash
recovery flow, but we still unconditionally call enable again in
ath10k_snoc_hif_start().

We can't check the ATH10K_FLAG_CRASH_FLUSH bit since it is cleared
before hif_start() is called, so instead check the
ATH10K_SNOC_FLAG_RECOVERY flag and skip enabling the IRQs during crash
recovery.

This fixes unbalanced IRQ enable splats that happen after recovering from
a crash.

Fixes: 0e622f67e041 ("ath10k: add support for WCN3990 firmware crash recovery")
Signed-off-by: Caleb Connolly <caleb.connolly@linaro.org>
Tested-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Link: https://patch.msgid.link/20250318205043.1043148-1-caleb.connolly@linaro.org
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 2c39bad7ebfb9..1d06d4125992d 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -937,7 +937,9 @@ static int ath10k_snoc_hif_start(struct ath10k *ar)
 
 	dev_set_threaded(&ar->napi_dev, true);
 	ath10k_core_napi_enable(ar);
-	ath10k_snoc_irq_enable(ar);
+	/* IRQs are left enabled when we restart due to a firmware crash */
+	if (!test_bit(ATH10K_SNOC_FLAG_RECOVERY, &ar_snoc->flags))
+		ath10k_snoc_irq_enable(ar);
 	ath10k_snoc_rx_post(ar);
 
 	clear_bit(ATH10K_SNOC_FLAG_RECOVERY, &ar_snoc->flags);
-- 
2.39.5



