Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3135C26B0BC;
	Thu, 13 Feb 2025 15:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459961; cv=none; b=O+pqW55uTxsxWV4mIvvkf2hG+igS8sxxq4TBEyiaVnkFegcwYRM3cnmu2TxCrD1AjMKgp3qFTNCUO0tc1arGmc6f0v/VyLtkMA02DfNqR+xabv7ojuY5wgNDLcFcWkH5xPW+J2K+L0SVL6di51VTnW1CZUxNFjsd8uXX3ryMO+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459961; c=relaxed/simple;
	bh=fcvtWx1fu2CabrPjmf4gc/9yDoylQzjDRxCmu0UNeAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=flYFGI7ad7UbQd+6kN15+2fwg+avldKzSwpvwxXFuOlrj+I/tmoLwd8lhNHEuz4so7tVVTxv067waprPOHt1q06cJf3SQuFKeQQgXma0IMMKkvC5VFgvxTMkwynDMHMRSzVc2FaCF1vdaDROkrUEL20VTHSwi/Nunypo+VvG6ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FG//z6VS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FG//z6VS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0610C4CED1;
	Thu, 13 Feb 2025 15:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459961;
	bh=fcvtWx1fu2CabrPjmf4gc/9yDoylQzjDRxCmu0UNeAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FG//z6VSnsQPHpMg6rt5K48qvE1md/6vLQiPgmrbRwl2wrPlQbqG4oApuZnpGaqEL
	 HLWa8LPK7a3bFrmzxwHAKcEBpBjc/QxDc514fMIWq4aJA6p6rN9WXC1eyjPaHAV0cl
	 RgPFVs4qScI9bo+gSpOQ24ZSHusDSLuf039n+zgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Eichenberger <eichest@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.13 384/443] irqchip/irq-mvebu-icu: Fix access to msi_data from irq_domain::host_data
Date: Thu, 13 Feb 2025 15:29:09 +0100
Message-ID: <20250213142455.428931678@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

From: Stefan Eichenberger <eichest@gmail.com>

commit 987f379b54091cc1b1db986bde71cee1081350b3 upstream.

mvebu_icu_translate() incorrectly casts irq_domain::host_data directly to
mvebu_icu_msi_data. However, host_data actually points to a structure of
type msi_domain_info.

This incorrect cast causes issues such as the thermal sensors of the
CP110 platform malfunctioning. Specifically, the translation of the SEI
interrupt to IRQ_TYPE_EDGE_RISING fails, preventing proper interrupt
handling. The following error was observed:

  genirq: Setting trigger mode 4 for irq 85 failed (irq_chip_set_type_parent+0x0/0x34)
  armada_thermal f2400000.system-controller:thermal-sensor@70: Cannot request threaded IRQ 85

Resolve the issue by first casting host_data to msi_domain_info and then
accessing mvebu_icu_msi_data through msi_domain_info::chip_data.

Fixes: d929e4db22b6 ("irqchip/irq-mvebu-icu: Prepare for real per device MSI")
Signed-off-by: Stefan Eichenberger <eichest@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20250124085140.44792-1-eichest@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-mvebu-icu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/irqchip/irq-mvebu-icu.c
+++ b/drivers/irqchip/irq-mvebu-icu.c
@@ -68,7 +68,8 @@ static int mvebu_icu_translate(struct ir
 			       unsigned long *hwirq, unsigned int *type)
 {
 	unsigned int param_count = static_branch_unlikely(&legacy_bindings) ? 3 : 2;
-	struct mvebu_icu_msi_data *msi_data = d->host_data;
+	struct msi_domain_info *info = d->host_data;
+	struct mvebu_icu_msi_data *msi_data = info->chip_data;
 	struct mvebu_icu *icu = msi_data->icu;
 
 	/* Check the count of the parameters in dt */


