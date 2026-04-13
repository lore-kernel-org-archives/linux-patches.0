Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119723164BB;
	Mon, 13 Apr 2026 16:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098939; cv=none; b=eBZZo07m3lXVM131HXLYkGK1yKCS2Y4aaFnmaSM3pPaHZVGtX27f1C1axmllxhjhvsRgnQkA/qmP8AqUVzc5wmDXzxSM4CXHvYTUB7/bRvo0j5tgGShOf51unXMVYFNyfPy4dtbfJQgdSiNgvcFo+031/WdqPM2IqxNylQ55DVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098939; c=relaxed/simple;
	bh=qa27mWJRGBgCKTxaRqKncRLXCeitxf1QUjldlvVOnww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mB9fKvpc43GD8T4xZ6yKNrX46eBdLzBclj6lnjYT3yByDe+Ti6iRbUcP+AZ+kDUcnA9UhUauCmMA03+H0DvfOQG6tA2PtN7EVy20DKR5t1gINrBv88YixtjPxsMj7l0zhmzRfvpLa8nPgAjrppvLNnbeo0zaQP8HSk2BeVkbmKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2fX3g70G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2fX3g70G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DA5C2BCAF;
	Mon, 13 Apr 2026 16:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098938;
	bh=qa27mWJRGBgCKTxaRqKncRLXCeitxf1QUjldlvVOnww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2fX3g70G8Qtgjg6zazOZtOO0dXAQtlqXKk49KHFgXI2VNNPNrE/eRrzDfi5wHuGP5
	 BJ1uAhuceTq5+1e6HJ+B27EAmeglgt1WZxkZS7gmbKwsaYmmXMNk/N2Y2ShioI2dCP
	 WbF/SMFI++yIvV51GXrp7WPRk5X5/YOrDV/lQXro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Ray <ian.ray@gehealthcare.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 140/491] NFC: nxp-nci: allow GPIOs to sleep
Date: Mon, 13 Apr 2026 17:56:25 +0200
Message-ID: <20260413155824.280258517@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


