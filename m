Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4318623372B;
	Mon, 10 Mar 2025 17:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628483; cv=none; b=g08+FrEnLyc14Z2t7O5I8CpDm6kQoGuscxq5rS6p5Iq4JLXH7njCUUcNezD4G5s9/oLG7tQjDfIlEYVvAdQskiszlAjzJ9VfJQEiKkaGEU6QQNjJWRdyv/3Q7hD28eg+4WneQtr33g/0KmKk+PL4Qc+LEn2cqq4EJkBeTKxg5G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628483; c=relaxed/simple;
	bh=f7YBsyZ6IDxzvLqlJUper7YIkPQCZrRPCia5K8OJbcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+Ej3haiVVU5efwZigpXYW0SkVH+5B3nynhdIb7/vEGGWTHPZ7UuSbEmD22Gl+qwNIae1f4m0CTuHccD2kuwTYbkLwlkFkOhqxm+sYt9GuAtkBlMlmwiQsOVtt8Nmnx6A7vCXBbUtx1a1AFMYd4KY5G0uegf853FitK/kYQXghs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pSCcpKgq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pSCcpKgq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C9B9C4CEE5;
	Mon, 10 Mar 2025 17:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628482;
	bh=f7YBsyZ6IDxzvLqlJUper7YIkPQCZrRPCia5K8OJbcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pSCcpKgqsLnYgzAj6S5rWq93gkipYX8VX/qJJmUNJrbLvUOIQu0/+SsHnjG3dBX2S
	 3fkOVk/zlWjooTxd5FZz2K0dZGv/YYMwNgNTCY+IEv6GM/z0dsJFNA52Egzuwr/SWJ
	 ptOfEq6XuBGQeCGXhBf3N2DfhDqeG/DW02wvujgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 6.1 073/109] usb: typec: tcpci_rt1711h: Unmask alert interrupts to fix functionality
Date: Mon, 10 Mar 2025 18:06:57 +0100
Message-ID: <20250310170430.464809001@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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
@@ -332,6 +332,11 @@ static int rt1711h_probe(struct i2c_clie
 {
 	int ret;
 	struct rt1711h_chip *chip;
+	const u16 alert_mask = TCPC_ALERT_TX_SUCCESS | TCPC_ALERT_TX_DISCARDED |
+			       TCPC_ALERT_TX_FAILED | TCPC_ALERT_RX_HARD_RST |
+			       TCPC_ALERT_RX_STATUS | TCPC_ALERT_POWER_STATUS |
+			       TCPC_ALERT_CC_STATUS | TCPC_ALERT_RX_BUF_OVF |
+			       TCPC_ALERT_FAULT;
 
 	chip = devm_kzalloc(&client->dev, sizeof(*chip), GFP_KERNEL);
 	if (!chip)
@@ -380,6 +385,12 @@ static int rt1711h_probe(struct i2c_clie
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


