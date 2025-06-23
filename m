Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759E224A06D;
	Mon, 23 Jun 2025 13:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686152; cv=none; b=kH0qpqLMPcdLqE4mV/o4oGGk1zxMiV3jTN+zul4wyCqf2EIKR01IE6SvVQ7wwoM7kDWXSDlsxlQ4KGnSdTNkZAvyzPB77PzpcCSL7qUP6vlevnkJ2Luk1pMiJ156ZtUGKp3Dlc8oILrqvWQ3oy3UBzC0yIAOuiDOSB4wfrXnX6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686152; c=relaxed/simple;
	bh=sKB4isgO2/S79vNhdNFck6svYvunJ806LREd6TOi8ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D+FV83jfIflKtY5/mgEefQNzQkKMciQ1KYucpxT6pq8AMo/pX2W3N9Y45LFYgy5RzjmL71DKPI573prcH+KGQ+bl8fpFKOq8qCgTLkG+x8oHnLA0gTaQzp2FmvmP8K/DW8H9v/esq1w8t4k6hpuvLEij2j2jAluaTbuB17MSVF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hnl03+9s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hnl03+9s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A988C4CEEA;
	Mon, 23 Jun 2025 13:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686152;
	bh=sKB4isgO2/S79vNhdNFck6svYvunJ806LREd6TOi8ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hnl03+9sgrKtRCITos4mje3FIPMFCPWzTjW4GeGt40Ven733TV6VZluXdnjWNfso9
	 CHWe54kb/bfyaeODZuPOUlQttPLs+WKaVdK8f7BtJTN65xhUrrWeHjazc9Rk28D4S3
	 v19ba3oYi2Z/uE7GwiWlw77P3dDsIPYW3V291lUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Connolly <caleb.connolly@linaro.org>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 118/355] ath10k: snoc: fix unbalanced IRQ enable in crash recovery
Date: Mon, 23 Jun 2025 15:05:19 +0200
Message-ID: <20250623130630.306900349@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 513794099f03f..616fcaed061f9 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -935,7 +935,9 @@ static int ath10k_snoc_hif_start(struct ath10k *ar)
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



