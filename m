Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B512528F1;
	Tue, 29 Apr 2025 18:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949947; cv=none; b=SA6Tr4C/b/nIcrbDCaDUuk18M6/V62eruBQFafmDuCGMNWVgqMKNs+7mJWNIf4uQ3riMlMb/5TQlRbnnNsSJDh32wrczSv/5ySRPsXr1VdxAtbOZ8eUFKiQfh6kv6p0J60hxNvvto8kmgvwc09dZH4n6W3ID9wa7YE6XoLMWxVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949947; c=relaxed/simple;
	bh=x7G9AteN3E7B10DphmW9Yb5iLjPjz26hqzCtuVklmvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HdSzJD9r50J1v6bGJBR7zo5kn8Wi/Hb3jPy75Zg+zCzraOeoEP61A+PF+PWi5t0qbCkvfn/cf23ICE5KqJyhzxpPvYjD9i3b0rEZY+RrRls7df1NMrxrq/wTIB4yd1sYa6NU8DNWfpUqP2gqq5yG6UiUsoaGVDOMM2B1qkVXCnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uUsgOF77; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uUsgOF77"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31123C4CEE3;
	Tue, 29 Apr 2025 18:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949947;
	bh=x7G9AteN3E7B10DphmW9Yb5iLjPjz26hqzCtuVklmvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uUsgOF77QaWe/T4HZYUKc9qiaKC9LC9nRoXcgCiUp1+rItZ7R3ZNggg1YU2AKMNx/
	 6AqJ5oG7a8rsMW1fcpur9bk+NH0cTg1nxSEjhkHW3VFcR0hyeOZrkhzTk6IcGshpKY
	 +Nqxah5S1Mg0awJEAARfriktRBKYS2fH8x8pHVpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Ferry Toth <fntoth@gmail.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 108/167] usb: dwc3: gadget: Avoid using reserved endpoints on Intel Merrifield
Date: Tue, 29 Apr 2025 18:43:36 +0200
Message-ID: <20250429161056.111257128@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 461f24bff86808ee5fbfe74751a825f8a7ab24e0 ]

Intel Merrifield SoC uses these endpoints for tracing and they cannot
be re-allocated if being used because the side band flow control signals
are hard wired to certain endpoints:

• 1 High BW Bulk IN (IN#1) (RTIT)
• 1 1KB BW Bulk IN (IN#8) + 1 1KB BW Bulk OUT (Run Control) (OUT#8)

In device mode, since RTIT (EP#1) and EXI/RunControl (EP#8) uses
External Buffer Control (EBC) mode, these endpoints are to be mapped to
EBC mode (to be done by EXI target driver). Additionally TRB for RTIT
and EXI are maintained in STM (System Trace Module) unit and the EXI
target driver will as well configure the TRB location for EP #1 IN
and EP#8 (IN and OUT). Since STM/PTI and EXI hardware blocks manage
these endpoints and interface to OTG3 controller through EBC interface,
there is no need to enable any events (such as XferComplete etc)
for these end points.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Ferry Toth <fntoth@gmail.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20250212193116.2487289-5-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-pci.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 6110ab1f91318..e2401cc4f1556 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -143,11 +143,21 @@ static const struct property_entry dwc3_pci_intel_byt_properties[] = {
 	{}
 };
 
+/*
+ * Intel Merrifield SoC uses these endpoints for tracing and they cannot
+ * be re-allocated if being used because the side band flow control signals
+ * are hard wired to certain endpoints:
+ * - 1 High BW Bulk IN (IN#1) (RTIT)
+ * - 1 1KB BW Bulk IN (IN#8) + 1 1KB BW Bulk OUT (Run Control) (OUT#8)
+ */
+static const u8 dwc3_pci_mrfld_reserved_endpoints[] = { 3, 16, 17 };
+
 static const struct property_entry dwc3_pci_mrfld_properties[] = {
 	PROPERTY_ENTRY_STRING("dr_mode", "otg"),
 	PROPERTY_ENTRY_STRING("linux,extcon-name", "mrfld_bcove_pwrsrc"),
 	PROPERTY_ENTRY_BOOL("snps,dis_u3_susphy_quirk"),
 	PROPERTY_ENTRY_BOOL("snps,dis_u2_susphy_quirk"),
+	PROPERTY_ENTRY_U8_ARRAY("snps,reserved-endpoints", dwc3_pci_mrfld_reserved_endpoints),
 	PROPERTY_ENTRY_BOOL("snps,usb2-gadget-lpm-disable"),
 	PROPERTY_ENTRY_BOOL("linux,sysdev_is_parent"),
 	{}
-- 
2.39.5



