Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211132FA622;
	Tue, 17 Jun 2025 16:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179232; cv=none; b=PuVuokp+OXAmCmgVuhDhCEnbL94aoX0rOEDyT9JkAQzsktpg0IyT3O+gw6z0ivfGWs6NqStVvbT/t1muwXQHNrwdB3dFHWVgLrUMnQ+G0xvtm3rtiVzDS06nD6YHqQQQy4Vcc0Lnknu2ySs4/1kJuUaP0q7dkFGgaLCABZNtGVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179232; c=relaxed/simple;
	bh=kQWich6l0AU01/EUqJ4iWOZFrR6N14705iiscEuXIzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r92S8qn+yJ+L/NmGm0A5Ofj4sIhD7Cf7s740KwLrokESIf6rsW6ae84hihcc6tjF/BubM3ZB9/zrfqpZ82UrlH19sMY3OhsCK3KPiA/QVVET8CScl6a/oerNtnoAGY+dAulw7rne7fT4HvLWHRNfeUkdLNIQ8FBsJsUu+0Bts94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SN3aXJfV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SN3aXJfV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818F1C4CEE7;
	Tue, 17 Jun 2025 16:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179232;
	bh=kQWich6l0AU01/EUqJ4iWOZFrR6N14705iiscEuXIzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SN3aXJfVWvqsVUHV1mYVJoaSrGxPZxqTf3SgecaQIwKU3ec9QhNPTU7nL33+j3XzY
	 rWfKmSUNrKfsJdh64SXnqCEIaGjdG3TcP6tEV3gHQ7/fq13CRUzw6qOjhh8jyInLdc
	 Xv9fhCWippODVRhcb12RZPvEwqHt98lwE5cu+/pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Connolly <caleb.connolly@linaro.org>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 671/780] ath10k: snoc: fix unbalanced IRQ enable in crash recovery
Date: Tue, 17 Jun 2025 17:26:19 +0200
Message-ID: <20250617152518.798068190@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 866bad2db3348..65673b1aba55d 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -937,7 +937,9 @@ static int ath10k_snoc_hif_start(struct ath10k *ar)
 
 	dev_set_threaded(ar->napi_dev, true);
 	ath10k_core_napi_enable(ar);
-	ath10k_snoc_irq_enable(ar);
+	/* IRQs are left enabled when we restart due to a firmware crash */
+	if (!test_bit(ATH10K_SNOC_FLAG_RECOVERY, &ar_snoc->flags))
+		ath10k_snoc_irq_enable(ar);
 	ath10k_snoc_rx_post(ar);
 
 	clear_bit(ATH10K_SNOC_FLAG_RECOVERY, &ar_snoc->flags);
-- 
2.39.5



