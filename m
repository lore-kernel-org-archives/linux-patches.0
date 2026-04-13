Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1CA26CE32;
	Mon, 13 Apr 2026 16:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097682; cv=none; b=nStbEnT2mMwAF/ciyfCHGDvRraUnb7WtZJ+E7+iNlpf/MKJms2J2FtR5QiiYgG/N2NgT71sYVeaew8kQOGixL3XC1lauwimJZIBdb1WgRNJMUeLbV5Eqv+5/Udm0UwYqkAaJxs7CuB3HojJzKIN+gFLpc8brW6EMKXSjfIbuhdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097682; c=relaxed/simple;
	bh=NloKGyW5w1RcqXerE1A2v2PgSYEs5r5QTOE+7XzRe6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5T0sXz7Hkltg88DKa29PoP7h4owGDOtnDFd3DH1zTZu9vYRmsCnCtjjSg6N7ObXh8J5g9zXUtsCJei/iz3G4V0QAJPi3a7HdikzYdM+lgrYMh0JuPKBrxE+zD/4OFsQ8HTVbYv/AIwLuTvNr+1oY1IgtHWB5Bz8bC7GLS0gUeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MPieGnqL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MPieGnqL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A520FC2BCAF;
	Mon, 13 Apr 2026 16:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097682;
	bh=NloKGyW5w1RcqXerE1A2v2PgSYEs5r5QTOE+7XzRe6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MPieGnqLB4tb4Kj9uIr4NzKErGHIFRCJLqi2SWsFZnGFyYKY8E2MBwhHLPKgCB7XX
	 LzBzdtO3ajWWsAq2oS+M4qdduqQ/mPLFosCbgXJcJVTX2f4MUD2+1nnoZchxYYOShp
	 YOWcfS9htwBsUaS+lfGcsdPzs9grF53JLQTXpimE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Ray <ian.ray@gehealthcare.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 199/570] NFC: nxp-nci: allow GPIOs to sleep
Date: Mon, 13 Apr 2026 17:55:30 +0200
Message-ID: <20260413155837.913004965@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Ray <ian.ray@gehealthcare.com>

commit 55dc632ab2ac2889b15995a9eef56c753d48ebc7 upstream.

Allow the firmware and enable GPIOs to sleep.

This fixes a `WARN_ON' and allows the driver to operate GPIOs which are
connected to I2C GPIO expanders.

-- >8 --
kernel: WARNING: CPU: 3 PID: 2636 at drivers/gpio/gpiolib.c:3880 gpiod_set_value+0x88/0x98
-- >8 --

Fixes: 43201767b44c ("NFC: nxp-nci: Convert to use GPIO descriptor")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Ray <ian.ray@gehealthcare.com>
Link: https://patch.msgid.link/20260317085337.146545-1-ian.ray@gehealthcare.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nfc/nxp-nci/i2c.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -47,8 +47,8 @@ static int nxp_nci_i2c_set_mode(void *ph
 {
 	struct nxp_nci_i2c_phy *phy = (struct nxp_nci_i2c_phy *) phy_id;
 
-	gpiod_set_value(phy->gpiod_fw, (mode == NXP_NCI_MODE_FW) ? 1 : 0);
-	gpiod_set_value(phy->gpiod_en, (mode != NXP_NCI_MODE_COLD) ? 1 : 0);
+	gpiod_set_value_cansleep(phy->gpiod_fw, (mode == NXP_NCI_MODE_FW) ? 1 : 0);
+	gpiod_set_value_cansleep(phy->gpiod_en, (mode != NXP_NCI_MODE_COLD) ? 1 : 0);
 	usleep_range(10000, 15000);
 
 	if (mode == NXP_NCI_MODE_COLD)


