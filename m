Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE84379ED5
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301689; cv=none; b=IV+3UK/3kunpNl5ducURuyfhkVc7zmRKkS5Mt14YWZdQ1i3HyZTgp1GUBqfDpmBbytuvRoZdzTk014bFAfI7weHvN3dE0gnLp4Xhn2GfK3UkOApsFIUxDhGBpzDBnhOzwo7v5C/7AEqg0CeiwCoWEF0w9D2cA2aX4HSaF58Qfz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301689; c=relaxed/simple;
	bh=n2W+mP6j8jNCdhpXDn+dgPl1Vl0kvDC1kVuv+0F3kNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GjjUzhJeEMOtmETFot7tFTuydNoSzy/lZFCS9z7/RkgYHnTEwEoecPGz1wwVZ4YccmRG5Tih0TZmZ7nTDKeFJYCzclE9xhuov8JiZHzTKCSS9aGqkW9ngH11K2wHmJlITv997sPbY8oJn8ihHhy45rzfLT18mxDMrQAhmUEYcTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N5xrhi6b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N5xrhi6b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE2BC116D0;
	Sat, 28 Feb 2026 18:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301689;
	bh=n2W+mP6j8jNCdhpXDn+dgPl1Vl0kvDC1kVuv+0F3kNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N5xrhi6bNTZEavXKSn4aRyuL9AldWTa/ZIbRYPHHRmX5EFj/LLZi5cqx8sAYPwRq4
	 RYqPAJc8DT3AbLRKlEoMeZG7lvs0UYRTharGn+zHE/ID3F3NIDtcqHoqcqna4C7SP/
	 twpubo3U4DNr/Gnn8Zc1Z4IcRp4wRxeTEKKaiX4m7GliZvvPKSopCWSBeidCku+YOS
	 YfTx10SqnEnuixidKOyaB00+Rr7bgWV5SD1ql3mCGqR5+aczeowH/8YiLTUK7zXE2G
	 Go9sSxE3marqkGkJMrmZ6g5jRfGc6vYp5wiC9++D+6I4sBKErFkEpYylZ4QsRPOOaI
	 QacXu9dxScMAg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 079/385] Bluetooth: btintel_pcie: Use IRQF_ONESHOT and default primary handler
Date: Sat, 28 Feb 2026 12:55:01 -0500
Message-ID: <20260228180011.1568201-79-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 28abed6569c87eab9071ab56c64433c2f0d9ce51 ]

There is no added value in btintel_pcie_msix_isr() compared to
irq_default_primary_handler().

Using a threaded interrupt without a dedicated primary handler mandates
the IRQF_ONESHOT flag to mask the interrupt source while the threaded
handler is active. Otherwise the interrupt can fire again before the
threaded handler had a chance to run.

Use the default primary interrupt handler by specifying NULL and set
IRQF_ONESHOT so the interrupt source is masked until the secondary
handler is done.

Fixes: c2b636b3f788d ("Bluetooth: btintel_pcie: Add support for PCIe transport")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260128095540.863589-7-bigeasy@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel_pcie.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index 34812bf7587d6..d430645657e3d 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -798,11 +798,6 @@ static void btintel_pcie_msix_rx_handle(struct btintel_pcie_data *data)
 	}
 }
 
-static irqreturn_t btintel_pcie_msix_isr(int irq, void *data)
-{
-	return IRQ_WAKE_THREAD;
-}
-
 static inline bool btintel_pcie_is_rxq_empty(struct btintel_pcie_data *data)
 {
 	return data->ia.cr_hia[BTINTEL_PCIE_RXQ_NUM] == data->ia.cr_tia[BTINTEL_PCIE_RXQ_NUM];
@@ -896,9 +891,9 @@ static int btintel_pcie_setup_irq(struct btintel_pcie_data *data)
 
 		err = devm_request_threaded_irq(&data->pdev->dev,
 						msix_entry->vector,
-						btintel_pcie_msix_isr,
+						NULL,
 						btintel_pcie_irq_msix_handler,
-						IRQF_SHARED,
+						IRQF_ONESHOT | IRQF_SHARED,
 						KBUILD_MODNAME,
 						msix_entry);
 		if (err) {
-- 
2.51.0

