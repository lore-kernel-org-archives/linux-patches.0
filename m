Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828583AEF20;
	Mon, 23 Mar 2026 14:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274489; cv=none; b=Q6T54Es0Ug68yRkZ9CjdaMkxk9kMJHpZsHdSCIT8zR0JSNbPuqb0FGP3ul6iIqzGp4EO7MFKSj/qCBr2FUGJef7kdY+ybGYaHKjOBpHHW838XlEbs37xUd8MyAZQWPR0ujKHh/CZXCLssKACuqxWoJC4lcEuGrDaNEpe48DvbLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274489; c=relaxed/simple;
	bh=lsTB7XKrKVynZS9zXJxD3nqJbze47Jg21ldvzmEdR9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TRE8NVZZaeSgv9StblkGOdsG2O1foMHbP5KbYsWPyvGbRkJV6mjyDnbKzLUnOPRgkVxThQsCHBBs03sgvALADTead+ay8KRZMBDMXGEFgzmVN4Yz6YoXuMVeeisDB4UejNvgxN5x53g2xZlTwHVPuzU+fnrKlIp5Wc6MCtSkc8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=phCYUFse; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="phCYUFse"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 048D1C2BCB1;
	Mon, 23 Mar 2026 14:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274489;
	bh=lsTB7XKrKVynZS9zXJxD3nqJbze47Jg21ldvzmEdR9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=phCYUFsekGLjAr2U9AFfDpGoP6lN/vQvvE0MZQvESdPPZHQAE9KNtNAk5yPXLndxB
	 th0I0McB/qbZ/yAedkbhU06DkzN8s0PsvJmFfEqP7z1BU5UbRgHKFaLm7H2nd6XPnw
	 Z/HnfL1vv4FNljUEYr42/NCKICw8WLa5DGDZzq8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Ray <ian.ray@gehealthcare.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 014/212] NFC: nxp-nci: allow GPIOs to sleep
Date: Mon, 23 Mar 2026 14:43:55 +0100
Message-ID: <20260323134504.214191216@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


