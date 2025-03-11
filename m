Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6721E9B2C;
	Tue, 11 Mar 2025 15:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707567; cv=none; b=Qt+7qPxdrJ/LWeEW3QPjJoj0AI2qb1ogujwB/daNv1p8sb4ByG1LlBcuprhE0hGBQYbvLUrk2tgVfRjnkHORj183uiIkKagCaDzS9VntZO1WWmicuDQSuDv4zg159LeftUKR4fRhovuNg7eHuDGRxxV3gEbCrkXYElZZj1YEJuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707567; c=relaxed/simple;
	bh=qa5cGbJgmsI0FMc/8rDIMEWUk3CGg94AsWLnSRtn6k0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQxfTvIIfRuy9HKzlFRDOZg302uHXbUe/xqNUfnPcpJ5UFT4DC0DVxhieP7ysNbwNzjdfeVNN++QBuj1qXaC75yjSqF47Ii/9u8KJT/g/1moC1Fqo0DKsFFz9DQGQ43E8lXapGj7P79iN+u7Md/RBR57gQ9w6bcjVwEpHQ9Vb1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KdpSiAgx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KdpSiAgx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D7AEC4CEE9;
	Tue, 11 Mar 2025 15:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707566;
	bh=qa5cGbJgmsI0FMc/8rDIMEWUk3CGg94AsWLnSRtn6k0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KdpSiAgxqng7LsRpA4QrS9Pizr80JFctsyjLcrsAGD0LIUkrNcOyznv3WdsE8gRcE
	 rqQvqfiJkfTm5it4SSxk/LtxMghBPCFovZdtkkqoNzZvXsbn/7v0RdF2RluQaVqNgw
	 tH13JaCA0gnl1ERTUZWsKs+mPnS2hWIGsxmSqufU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 5.10 432/462] usb: typec: tcpci_rt1711h: Unmask alert interrupts to fix functionality
Date: Tue, 11 Mar 2025 16:01:38 +0100
Message-ID: <20250311145815.399915347@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

commit d6b82dafd17db0658f089b9cdec573982ca82bc5 upstream.

During probe, the TCPC alert interrupts are getting masked to
avoid unwanted interrupts during chip setup: this is ok to do
but there is no unmasking happening at any later time, which
means that the chip will not raise any interrupt, essentially
making it not functional as, while internally it does perform
all of the intended functions, it won't signal anything to the
outside.

Unmask the alert interrupts to fix functionality.

Fixes: ce08eaeb6388 ("staging: typec: rt1711h typec chip driver")
Cc: stable <stable@kernel.org>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20250219114700.41700-1-angelogioacchino.delregno@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpci_rt1711h.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/usb/typec/tcpm/tcpci_rt1711h.c
+++ b/drivers/usb/typec/tcpm/tcpci_rt1711h.c
@@ -217,6 +217,11 @@ static int rt1711h_probe(struct i2c_clie
 {
 	int ret;
 	struct rt1711h_chip *chip;
+	const u16 alert_mask = TCPC_ALERT_TX_SUCCESS | TCPC_ALERT_TX_DISCARDED |
+			       TCPC_ALERT_TX_FAILED | TCPC_ALERT_RX_HARD_RST |
+			       TCPC_ALERT_RX_STATUS | TCPC_ALERT_POWER_STATUS |
+			       TCPC_ALERT_CC_STATUS | TCPC_ALERT_RX_BUF_OVF |
+			       TCPC_ALERT_FAULT;
 
 	ret = rt1711h_check_revision(client);
 	if (ret < 0) {
@@ -258,6 +263,12 @@ static int rt1711h_probe(struct i2c_clie
 					dev_name(chip->dev), chip);
 	if (ret < 0)
 		return ret;
+
+	/* Enable alert interrupts */
+	ret = rt1711h_write16(chip, TCPC_ALERT_MASK, alert_mask);
+	if (ret < 0)
+		return ret;
+
 	enable_irq_wake(client->irq);
 
 	return 0;


