Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF449235071;
	Tue, 17 Jun 2025 16:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177274; cv=none; b=ATffv6qLW0Q5fWVaC3uq7R1Lk573FNtjH+GAJlXDzzJOKjAi3EytSoYD+euAKgesCua8ZldZGO9KJoObmCMmCCHIDP/fTfNl/s2Zr7gsFKQlt5tWsnu+Gnytr4LvVJztrhJ//NispspkQh17Y6VPGvyvZvf25OsUb3I44729uno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177274; c=relaxed/simple;
	bh=Cl+cQx5UM7lSIkQW6SJONsXWpUzoz0IxnwP0XCHrXCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n7Hv/kTsbMUy2VlmL8LiaFvwD3ZT+AW93H+VWfAIz8MKO31RMk6oyhElCXKtwkgGw6ZienN1SFMzGIOFL7FivoJOKm8hkYLoWq0DyUCVCBEPjqaorSpR/M4xWEGIjEp8J6zNA4Ty8+i6Hu37c0dfXN4/KNzW2UPj4MrQg9E0YIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mKT2102G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mKT2102G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23123C4CEE3;
	Tue, 17 Jun 2025 16:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177274;
	bh=Cl+cQx5UM7lSIkQW6SJONsXWpUzoz0IxnwP0XCHrXCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mKT2102GffkEl+fWJJnYuvoI+JZhO4EhUdiwMm81F22r70a98FkJZ4j7gd/ajQ19M
	 PEeAcOp4KhB11JOFv3B5rlQFUK7hKIhFyVUz55smxird6tevJdIlsxAwCo8Cs8x66q
	 RpW3cQdrmDz6+CT7efCrbEXAtRmMC3w6oBREOIqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Pawel Laszczak <pawell@cadence.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.6 348/356] usb: cdnsp: Fix issue with detecting USB 3.2 speed
Date: Tue, 17 Jun 2025 17:27:43 +0200
Message-ID: <20250617152352.142737716@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


