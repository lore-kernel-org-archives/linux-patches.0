Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC33E28640B;
	Thu, 25 Jun 2026 13:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782393112; cv=none; b=j//Uzu6dTqiEmVQSo+QR/ZfbXWhjAVzDvqQGZkN8BXH2HdYxzLD/BR/ylmfxY1vbpQCYBSoy19BTXW1X4z8MfYtoXxhiXEL3D8LMuNs2o2Z63ycgWozrmPeWiG/NszFj4IvCfCC8fDcvhqlDL9vQ7TVr/9suB+Qtiv3qBDNs5Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782393112; c=relaxed/simple;
	bh=ut6Ix14Qjpk5q05DLmt4lzcfWly0Vq2FEq4WwXVqgkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gagX3Uo6GrWnN60SLWeU47Sc+23uLWazUUzmZBBD2etNxZCkpsuhd2A6MCZemufxIe1JUQPA0Ddss8K5pb9aIPXAEAwKD8+5O8u73O3K5qv/aCOaZebJhr8gWAVakE1Vy/qtCXPqw7ejwUrN3f/ayQI8ukbOBXml5FtZuiunsLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mr8DJ8NU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mr8DJ8NU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4CCF1F00A3D;
	Thu, 25 Jun 2026 13:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782393110;
	bh=42x/QYL+beHf82e1QuXXTL3wEV/hbbRCxow6WpglxCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mr8DJ8NU4ISHZySq8jASDsZJEnrfE+2kvgeNaOr3KmwV/9hJSA7lgcemHH6g4VmWp
	 8tMX4vByqoi4GabuQ/lO3KnnTOu9d+x70+W10n81YoWoBiiDtm+jtAgMZ/hmeMjalq
	 YIxubcYsk5oXKLJsF3vbEJlyvCCdWm6FlAKHHwjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 10/21] Input: rmi4 - fix num_subpackets overflow in register descriptor
Date: Thu, 25 Jun 2026 14:04:02 +0100
Message-ID: <20260625125614.682899601@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125613.243729608@linuxfoundation.org>
References: <20260625125613.243729608@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 2b4b482d5c4c23c668b998a7da985aea0fa4a978 upstream.

RMI_REG_DESC_SUBPACKET_BITS is defined as 296 (37 * BITS_PER_BYTE). This
may overflow num_subpackets in struct rmi_register_desc_item which is
defined as a u8.

Fix this by changing the type of num_subpackets to u16.

Fixes: 2b6a321da9a2 ("Input: synaptics-rmi4 - add support for Synaptics RMI4 devices")
Cc: stable@vger.kernel.org
Assisted-by: Gemini:gemini-3.1-pro
Link: https://patch.msgid.link/20260505045952.1570713-4-dmitry.torokhov@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/rmi4/rmi_driver.h |    2 +-
 drivers/input/rmi4/rmi_f12.c    |    7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/input/rmi4/rmi_driver.h
+++ b/drivers/input/rmi4/rmi_driver.h
@@ -53,7 +53,7 @@ struct pdt_entry {
 struct rmi_register_desc_item {
 	u16 reg;
 	unsigned long reg_size;
-	u8 num_subpackets;
+	u16 num_subpackets;
 	unsigned long subpacket_map[BITS_TO_LONGS(
 				RMI_REG_DESC_SUBPACKET_BITS)];
 };
--- a/drivers/input/rmi4/rmi_f12.c
+++ b/drivers/input/rmi4/rmi_f12.c
@@ -467,6 +467,13 @@ static int rmi_f12_probe(struct rmi_func
 		f12->data1 = item;
 		f12->data1_offset = data_offset;
 		data_offset += item->reg_size;
+
+		if (item->num_subpackets > 255) {
+			dev_err(&fn->dev, "Too many fingers declared: %d\n",
+				item->num_subpackets);
+			return -EINVAL;
+		}
+
 		sensor->nbr_fingers = item->num_subpackets;
 		sensor->report_abs = 1;
 		sensor->attn_size += item->reg_size;


