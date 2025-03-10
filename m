Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861B422CBF1;
	Mon, 10 Mar 2025 17:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627792; cv=none; b=CfMaAQBCVbJzQ7Duk/USuAyQgDVUVUqxqgZUCpSIzpx8NcxcSTw2nrKuYAxcqW3NDmJj0WwYvhNGZBsgGWS4VgMo6o5HOBS/ltq7SBm2xDAOXvsf7k5/SE5pTiHgQE3vfuTFDyllV0QVEqop91ctS87syZ+6X/8hxqjCxwZ/YuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627792; c=relaxed/simple;
	bh=vywqVpTdYBLwqzcJ5Kdb1iwzB9syyFF2lksXYxnIlXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oTLIUOw9N3isBtTsgGUbZidL838FF3+YYi8nRXav/2EtyMgnJ1/JgLaHpjm9QhmXa/VjdQAc5M6w+0okFqlVFRceFr5DnLm+EPZKk0EEgH80xkVbVTSfEq4DGxJ7dPeXFLEQfrgC1efeZebRxYeaSDfa6qlydBBzxRTFME2NNb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P4TmR/kv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P4TmR/kv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A108C4CEE5;
	Mon, 10 Mar 2025 17:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627792;
	bh=vywqVpTdYBLwqzcJ5Kdb1iwzB9syyFF2lksXYxnIlXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P4TmR/kvCSsl7SERf0Dc7BYVUHC8rSF0CgGLu0k1wmsSPm2tnN+i3eWAGToXYHh/A
	 VUNv9AoOApl/20+fUU+Owy+po+0zxk2O1e9sOmHfxC4iNOjtxMiOXFL/BCDkTZ425x
	 oF+Mn3tim6G5fqmfFUMBF8F6MMYgxcBMYFAZGxIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 6.12 219/269] usb: typec: tcpci_rt1711h: Unmask alert interrupts to fix functionality
Date: Mon, 10 Mar 2025 18:06:12 +0100
Message-ID: <20250310170506.413617354@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -334,6 +334,11 @@ static int rt1711h_probe(struct i2c_clie
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
@@ -382,6 +387,12 @@ static int rt1711h_probe(struct i2c_clie
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


