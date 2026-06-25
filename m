Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80EE22F7F18;
	Thu, 25 Jun 2026 13:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782393084; cv=none; b=NKfnuU2bm89jPxTZSlmUNyBpwk1PR3ox4Rb5NUb+whRgv++Dv8NwH3Qi4Jj6MDHywLSkqX8BFcf8u1Sv0aVUNLxilobwZuvfXiVu94JsT40JgIP/J2J6dNClDeWrXyXVp7B4g/9uU0Mg8QHyNsAQmppO29TuJgeReZXD54lH1RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782393084; c=relaxed/simple;
	bh=uvQsswY/cQmYJMPTaEdAR8qGY+PZjdp2fM13zN/ygfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UMm92u39VQAPBlT+WaY3F+cVuKzAfg046jEQNqMwbAlKdlfCpGuAILzlfuZGZTq6ufcssGNP0R8aucAuDLNpsVHEOTRRMETVziORyJa4mDq42kIA6s7XkecxuKh8Bo/T9GUOI8gpphpcR2AYuBwWpSiYqkPoADtsnj7Abf2w0p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ollB48jv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ollB48jv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE551F000E9;
	Thu, 25 Jun 2026 13:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782393080;
	bh=rQ1WWTMEJ6el73qdI4RFVR79AlGrHlaIsLvyaPRcMMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ollB48jvNUNADL1wQNzLMpLAZZOK6hkXXi/q2XaXZ0uLFIoKO8ZrgbLZCMLNDYPyY
	 dmUGSqbhikKoF68f0pC6O80SoBOj6gURJHYcJx1C3guBHnStoSLCh7DQRp6LzdU0+X
	 vzLs1zzDTQUWSue+m0XTqLVOp6Wi9HvDapSNnI1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.0 38/49] Input: rmi4 - fix num_subpackets overflow in register descriptor
Date: Thu, 25 Jun 2026 14:03:50 +0100
Message-ID: <20260625125642.875190587@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125637.527552689@linuxfoundation.org>
References: <20260625125637.527552689@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


