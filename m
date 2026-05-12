Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62B03DD84A;
	Tue, 12 May 2026 17:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608265; cv=none; b=mNXFGy7q6oRY6Gt+AHFaRyynHpJ8Wxbl/7JqFOOPxs4dxwUmK+P2wnaOr0gi6t/rs5Z/1A/CxLJ2J39pfByTctFPPLyr57dcIROsYcQ3Lv5QdSVGRjm5IybkUe6EYOfJW30cWWccq9K9JCO59/S5iTc77mL1ggfv5jfDTTCSxXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608265; c=relaxed/simple;
	bh=haBtdlnp9n7dO3OQU+aR2RPnu4ml+8ki1oU1oo95LCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNKVpANjA1Zo9mltLdAx5qmqQefpPUimnbYHa4SQVzWKHhLxw83EXkFyjW4AqgYu8PiIgy8VGwXoPERxSb25r8q4/v0dyy9EpH5i/Lfuxw7EEnOPLhH20ZfG353C8W6UfonhBSR0m/fVW3m0eGo+oFizqRrTyZDVxOMEivFWITE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BXbQZZv/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BXbQZZv/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BDE8C2BCC7;
	Tue, 12 May 2026 17:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608265;
	bh=haBtdlnp9n7dO3OQU+aR2RPnu4ml+8ki1oU1oo95LCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BXbQZZv/r3aqISjv/bUnhA13Yiz3fJr/TMRFfaMTaSFb0UJtrte3vK/U6eUIM8vlJ
	 jjcVyhyCEY50rCcf3hbNP1liycxTBNRUkPUd8ASeh2NN3nCIMmNwzydVqZpR8ZE89A
	 mY+DpCgmVyZHhufe8W/1CCnyoygkOCeu9Cv/Vok4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quan Zhou <quan.zhou@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.18 013/270] wifi: mt76: mt7925: fix incorrect TLV length in CLC command
Date: Tue, 12 May 2026 19:36:54 +0200
Message-ID: <20260512173938.735197272@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

From: Quan Zhou <quan.zhou@mediatek.com>

commit 62e037aa8cf5a69b7ea63336705a35c897b9db2b upstream.

The previous implementation of __mt7925_mcu_set_clc() set the TLV length
field (.len) incorrectly during CLC command construction. The length was
initialized as sizeof(req) - 4, regardless of the actual segment length.
This could cause the WiFi firmware to misinterpret the command payload,
resulting in command execution errors.

This patch moves the TLV length assignment to after the segment is
selected, and sets .len to sizeof(req) + seg->len - 4, matching the
actual command content. This ensures the firmware receives the
correct TLV length and parses the command properly.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Cc: stable@vger.kernel.org
Signed-off-by: Quan Zhou <quan.zhou@mediatek.com>
Acked-by: Sean Wang <sean.wang@mediatek.com>
Link: https://patch.msgid.link/f56ae0e705774dfa8aab3b99e5bbdc92cd93523e.1772011204.git.quan.zhou@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -3324,7 +3324,6 @@ __mt7925_mcu_set_clc(struct mt792x_dev *
 		u8 rsvd[64];
 	} __packed req = {
 		.tag = cpu_to_le16(0x3),
-		.len = cpu_to_le16(sizeof(req) - 4),
 
 		.idx = idx,
 		.env = env_cap,
@@ -3353,6 +3352,7 @@ __mt7925_mcu_set_clc(struct mt792x_dev *
 		memcpy(req.type, rule->type, 2);
 
 		req.size = cpu_to_le16(seg->len);
+		req.len = cpu_to_le16(sizeof(req) + seg->len - 4);
 		dev->phy.clc_chan_conf = clc->ver == 1 ? 0xff : rule->flag;
 		skb = __mt76_mcu_msg_alloc(&dev->mt76, &req,
 					   le16_to_cpu(req.size) + sizeof(req),


