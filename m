Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275814369A;
	Wed, 25 Feb 2026 01:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982993; cv=none; b=h1y0uE0mIpz4h1uygnvqZlRI1ZtjhmZQJuqMMOOzPZpo4O5ABQ2XaF5R3LODVHB++lOnJ2GvBJWuiRxTXWaIfhgHhkLUpQlfosLE3zvwQGur3koVPQfRSQBbvFHcHnFFhP8dulPWVip/oReaVbArZrLoxuSo3bfUWZAu6VXG9rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982993; c=relaxed/simple;
	bh=SK+ahMm4G/NMO4C9kV/hYzsBvcrepvKsJ+lQX3PdwNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o0K6kg4fTplbGEhqr6o7S/zmbs/jWkJM44LDx2qBisHJ9/w0ersBN8xMa9B2ewZVFyxjSeccxpSu3NQIrkxdX7WPOzTpz4wZeMWQw07DZTY1Hs65bwKF6aC8PRYPAmnfJUc2QXy6hf+AYHCteeccV6phj7Qy45M6gO7AWR24n38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WqujWswF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WqujWswF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8F4C116D0;
	Wed, 25 Feb 2026 01:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982993;
	bh=SK+ahMm4G/NMO4C9kV/hYzsBvcrepvKsJ+lQX3PdwNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WqujWswFje4BM5jRqCgD+wpEYWnmIcQ3YzT/I3kqMDuG0Ecf4FLHgnG/fIVFGn+5h
	 x23t6B8EIWDFBSQpRgjBforRc8uqwYOkcxKJU8mIEhiJ5QQf5k0/wWzLAkhb/by0mb
	 /JfB8/T2ZGHbemUEJ1A47wdGax2UrYEMCn22JOJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 120/781] Bluetooth: btintel_pcie: Use IRQF_ONESHOT and default primary handler
Date: Tue, 24 Feb 2026 17:13:49 -0800
Message-ID: <20260225012402.612204724@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 2936b535479f2..704767b334b98 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -1431,11 +1431,6 @@ static void btintel_pcie_msix_rx_handle(struct btintel_pcie_data *data)
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
@@ -1537,9 +1532,9 @@ static int btintel_pcie_setup_irq(struct btintel_pcie_data *data)
 
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



