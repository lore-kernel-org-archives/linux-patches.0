Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2924409;
	Mon, 23 Jun 2025 22:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716085; cv=none; b=pDcG63mxjCLz50rb2AV9NfW9nywcrcq6Xm0d9EXUYCQ1NOdADQv6lVs7zra1VQJsm7WDMAoXHgJMGL2iqjCpjYb+c+t/Wh6sYmu3m8NUd5K2REATGE5h7Wrirn+pOd/p2UKzihJuOT+qoGPwgUHWtepDWzFIJfhChb8SHWqG2dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716085; c=relaxed/simple;
	bh=b2abJvd3aOZILrsA7Sfvo+HXsQJ22NhSouEYSoZIV9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jEu4akOWQV38k/GZ9qkdX1ZbJYsq3ZNrTL9b1AO/amjCHCnxCduWiQmPYY2RFeFKQzFerXh0aUzF0nnld7RWSIgZx5gD+OEZ4vhpoCIniVxaSLaTAvsFk/+cXFwvDflvmuOMf3FJl2DnnK4zj7+yZL0/6wOuBqsTr+Kze8eCdy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r4ejDDzf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r4ejDDzf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 449C6C4CEEA;
	Mon, 23 Jun 2025 22:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716085;
	bh=b2abJvd3aOZILrsA7Sfvo+HXsQJ22NhSouEYSoZIV9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r4ejDDzfZFxJpfpNHeiSgsZQVW9am7V3UHkMNLlmcpUEZpWN8sU2mogXRYwM6E/4Q
	 dM6fEhEuR88fF39TecJQvxhCYzDZtFlfRKX7l1xtqAF9G5Gzvg1rYB3DAbroQKLs07
	 dKgHIymQpjG+t6h5d52PRVqUlYEw7zvV7HfsSIlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Pawel Laszczak <pawell@cadence.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.1 279/508] usb: cdnsp: Fix issue with detecting USB 3.2 speed
Date: Mon, 23 Jun 2025 15:05:24 +0200
Message-ID: <20250623130652.119676811@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

From: Pawel Laszczak <pawell@cadence.com>

commit 2852788cfbe9ca1ab68509d65804413871f741f9 upstream.

Patch adds support for detecting SuperSpeedPlus Gen1 x2 and
SuperSpeedPlus Gen2 x2 speed.

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/PH7PR07MB95387AD98EDCA695FECE52BADD96A@PH7PR07MB9538.namprd07.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-gadget.c |    3 ++-
 drivers/usb/cdns3/cdnsp-gadget.h |    4 ++++
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/cdns3/cdnsp-gadget.c
+++ b/drivers/usb/cdns3/cdnsp-gadget.c
@@ -28,7 +28,8 @@
 unsigned int cdnsp_port_speed(unsigned int port_status)
 {
 	/*Detect gadget speed based on PORTSC register*/
-	if (DEV_SUPERSPEEDPLUS(port_status))
+	if (DEV_SUPERSPEEDPLUS(port_status) ||
+	    DEV_SSP_GEN1x2(port_status) || DEV_SSP_GEN2x2(port_status))
 		return USB_SPEED_SUPER_PLUS;
 	else if (DEV_SUPERSPEED(port_status))
 		return USB_SPEED_SUPER;
--- a/drivers/usb/cdns3/cdnsp-gadget.h
+++ b/drivers/usb/cdns3/cdnsp-gadget.h
@@ -285,11 +285,15 @@ struct cdnsp_port_regs {
 #define XDEV_HS			(0x3 << 10)
 #define XDEV_SS			(0x4 << 10)
 #define XDEV_SSP		(0x5 << 10)
+#define XDEV_SSP1x2		(0x6 << 10)
+#define XDEV_SSP2x2		(0x7 << 10)
 #define DEV_UNDEFSPEED(p)	(((p) & DEV_SPEED_MASK) == (0x0 << 10))
 #define DEV_FULLSPEED(p)	(((p) & DEV_SPEED_MASK) == XDEV_FS)
 #define DEV_HIGHSPEED(p)	(((p) & DEV_SPEED_MASK) == XDEV_HS)
 #define DEV_SUPERSPEED(p)	(((p) & DEV_SPEED_MASK) == XDEV_SS)
 #define DEV_SUPERSPEEDPLUS(p)	(((p) & DEV_SPEED_MASK) == XDEV_SSP)
+#define DEV_SSP_GEN1x2(p)	(((p) & DEV_SPEED_MASK) == XDEV_SSP1x2)
+#define DEV_SSP_GEN2x2(p)	(((p) & DEV_SPEED_MASK) == XDEV_SSP2x2)
 #define DEV_SUPERSPEED_ANY(p)	(((p) & DEV_SPEED_MASK) >= XDEV_SS)
 #define DEV_PORT_SPEED(p)	(((p) >> 10) & 0x0f)
 /* Port Link State Write Strobe - set this when changing link state */


