Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0144315A;
	Mon, 23 Jun 2025 21:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715314; cv=none; b=WADmUCq0olwrYS+A2GxN5AgUO+p4yigc9yH6xIEqhTksO13Usjz0YDItXXoQTEoxQ+FpohMJ4IhNhQYE5Rc5k8l90GppdPTY0xR83hDeuSdWrlu0YIyroaAQ9WpAdPJQ4Pv45N5SQuP28CuAPDB5GyTIR8nvGactDAh0fxxewmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715314; c=relaxed/simple;
	bh=qa2yeibhODCCbiZXjqxOwIC3vJ1krdzEqQ+/IQzhmIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fhgwj9d/Ezu80fjXhmdfSKrbmucO4tcPeBurFdYILwUG4vZHwDLyE3fXMyOK+KKRh86nk6w6fnR8ijIw48IrPilIepmxPKjLY9Ba/sDuRq+rNJgDRHUdrOVDrd2m+0/evOPMJWug8XT+MsCgCsQsraEnMVOdaS+FTtCM4s/FY+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wOI8j+8g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wOI8j+8g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01974C4CEEA;
	Mon, 23 Jun 2025 21:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715314;
	bh=qa2yeibhODCCbiZXjqxOwIC3vJ1krdzEqQ+/IQzhmIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wOI8j+8gV9ufGbVEAtHWTWtqh3l8u9W05JYJWtVSlGjld2DbZGLKgBLvm+c+ZYL7G
	 fERoP0g4aj1Lsoutay/ESWQ9ujdTm3dTgGAEOHFZMicHd7YpREJ1/6g3yp3NsIC4xh
	 gI8dMA1WepQEK9Ppx4FkRe2APSrf5oQKkNJ8lJ78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Connolly <caleb.connolly@linaro.org>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 227/508] ath10k: snoc: fix unbalanced IRQ enable in crash recovery
Date: Mon, 23 Jun 2025 15:04:32 +0200
Message-ID: <20250623130650.847043212@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4b7266d928470..b43658b016844 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -936,7 +936,9 @@ static int ath10k_snoc_hif_start(struct ath10k *ar)
 	bitmap_clear(ar_snoc->pending_ce_irqs, 0, CE_COUNT_MAX);
 
 	ath10k_core_napi_enable(ar);
-	ath10k_snoc_irq_enable(ar);
+	/* IRQs are left enabled when we restart due to a firmware crash */
+	if (!test_bit(ATH10K_SNOC_FLAG_RECOVERY, &ar_snoc->flags))
+		ath10k_snoc_irq_enable(ar);
 	ath10k_snoc_rx_post(ar);
 
 	clear_bit(ATH10K_SNOC_FLAG_RECOVERY, &ar_snoc->flags);
-- 
2.39.5



