Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B051E98FB;
	Tue, 11 Mar 2025 15:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706263; cv=none; b=OmphZJoX45htLGa8hcdMT5FSegGAnihf8tkBH5Pr87mSeq1ux+mlNkUDju45DgWrlC8tpXg2Yf87RVTzOeVtaaUHwq+3AAmztOQysjxr+VakvJY4qckGCP3UB9z1b2chjroh25D2TmA/b1Sah/XMYZ8L9fS6kH/xl65kIXdzolM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706263; c=relaxed/simple;
	bh=IaxhjUYlo6Re1LtGQYFQpV4FI8dcSM9T1/gKI0BEbPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q29XDjhZWVcLG1IOMSyyWRS6veS7do5K8UQCLqt3N/XQd+G9ev4r8FGJEMNBCuUHZEyILz8wUKx+onPtyu3KaCAzyqwxHrlMmevUlVsZcbqWiaZqBIfy05YddOXM5Iz6XcaFQI3LMXjeGjONA7wzNt+xoyC9scxARLkbHMEJIto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=djKHOd7l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="djKHOd7l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A8AC4CEEC;
	Tue, 11 Mar 2025 15:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706263;
	bh=IaxhjUYlo6Re1LtGQYFQpV4FI8dcSM9T1/gKI0BEbPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=djKHOd7lUhdnnmFgI5Z59ixmah6Y6mxCMnh1Ax7U6+89YXQT+eYQWySmNDxzkdbtQ
	 kDugcw7Hu3/iOlFQpZ/pMm+tglEDjGtvhMf4ltsAi7gSfEDJ1u7nsLwYzZdpjPQD2A
	 zTbLgzsixpymnTxGYKu9zLkHkYxAoCMPbhMl0GCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 5.4 318/328] usb: typec: tcpci_rt1711h: Unmask alert interrupts to fix functionality
Date: Tue, 11 Mar 2025 16:01:28 +0100
Message-ID: <20250311145727.540421427@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


