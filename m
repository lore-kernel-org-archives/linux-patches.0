Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BEE215AE7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:17:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8401C433C9;
	Wed, 20 Sep 2023 12:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212223;
	bh=prOsYWbPwIsenZfF7vEtdOkBvsJvRZ4YuVBh2MiS2/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MkwgfXrIbBNq8RjbSo49+bEekS8w7YOpMhJSaa4o+MuNBd2WTsZcG2aiiTIBNsCeV
	 8G++rYGX3AG7QppOqjCnnZN3uZE+cxKdzk2gqiunBTpKQBhQzUN1Mc0zHjO8LWa0ij
	 beFZkwbbWbQZfFbe7BVAsagWGeQYaymWduXTV43k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Angus Ainslie (Purism)" <angus@akkea.ca>,
	Christian Bach <christian.bach@scs.ch>,
	Marco Felsch <m.felsch@pengutronix.de>,
	Fabio Estevam <festevam@denx.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 195/273] usb: typec: tcpci: clear the fault status bit
Date: Wed, 20 Sep 2023 13:30:35 +0200
Message-ID: <20230920112852.529708804@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Felsch <m.felsch@pengutronix.de>

[ Upstream commit 23e60c8daf5ec2ab1b731310761b668745fcf6ed ]

According the "USB Type-C Port Controller Interface Specification v2.0"
the TCPC sets the fault status register bit-7
(AllRegistersResetToDefault) once the registers have been reset to
their default values.

This triggers an alert(-irq) on PTN5110 devices albeit we do mask the
fault-irq, which may cause a kernel hang. Fix this generically by writing
a one to the corresponding bit-7.

Cc: stable@vger.kernel.org
Fixes: 74e656d6b055 ("staging: typec: Type-C Port Controller Interface driver (tcpci)")
Reported-by: "Angus Ainslie (Purism)" <angus@akkea.ca>
Closes: https://lore.kernel.org/all/20190508002749.14816-2-angus@akkea.ca/
Reported-by: Christian Bach <christian.bach@scs.ch>
Closes: https://lore.kernel.org/regressions/ZR0P278MB07737E5F1D48632897D51AC3EB329@ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM/t/
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Signed-off-by: Fabio Estevam <festevam@denx.de>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20230816172502.1155079-1-festevam@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tcpci.c | 4 ++++
 drivers/usb/typec/tcpci.h | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/usb/typec/tcpci.c b/drivers/usb/typec/tcpci.c
index 9f98376d9bef4..d1393371b6b0a 100644
--- a/drivers/usb/typec/tcpci.c
+++ b/drivers/usb/typec/tcpci.c
@@ -379,6 +379,10 @@ static int tcpci_init(struct tcpc_dev *tcpc)
 	if (time_after(jiffies, timeout))
 		return -ETIMEDOUT;
 
+	ret = tcpci_write16(tcpci, TCPC_FAULT_STATUS, TCPC_FAULT_STATUS_ALL_REG_RST_TO_DEFAULT);
+	if (ret < 0)
+		return ret;
+
 	/* Handle vendor init */
 	if (tcpci->data->init) {
 		ret = tcpci->data->init(tcpci, tcpci->data);
diff --git a/drivers/usb/typec/tcpci.h b/drivers/usb/typec/tcpci.h
index 303ebde265465..dcf60399f161f 100644
--- a/drivers/usb/typec/tcpci.h
+++ b/drivers/usb/typec/tcpci.h
@@ -72,6 +72,7 @@
 #define TCPC_POWER_STATUS_VBUS_PRES	BIT(2)
 
 #define TCPC_FAULT_STATUS		0x1f
+#define TCPC_FAULT_STATUS_ALL_REG_RST_TO_DEFAULT BIT(7)
 
 #define TCPC_COMMAND			0x23
 #define TCPC_CMD_WAKE_I2C		0x11
-- 
2.40.1



