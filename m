Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824313EDE61;
	Tue, 12 May 2026 18:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608966; cv=none; b=SBlHX/a7lh/c2rlybl6iuWP7Y0t/VaHy/GSaF00v6yCdkcr8+TGeetoZNVClXl2GCcIpJeLWFMtbe0qHvFVp/8MhHkwizVM2lKr9I45MU+3KRfkaUg9C7cr8TSTT9zqGwF9cW5thPTIb6mBE2ZpoYuEQveYeL63BXHa1r42Qqvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608966; c=relaxed/simple;
	bh=/jrIi81PAv5dTKutoo0qj5le1b9uIN65LDeuKS1G0J4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PVCbS471ms1lXznk4T17TQ/xomfj1mKS3NQYq2wwxHuaTS9LHK+aDYe6bSCooKCli7woNgqKsryefgKODdjEbxxWRm77WQgVuV/5OIBYZ7bb7amyj2bdlm5QZOE7t6wANh1zscfLmthWO35jVuOIp2nhPAq1mCf29LMZv91m34k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M0ss3BjK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M0ss3BjK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17AC6C2BCB0;
	Tue, 12 May 2026 18:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608966;
	bh=/jrIi81PAv5dTKutoo0qj5le1b9uIN65LDeuKS1G0J4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M0ss3BjKDd/W9sgqkdln6RyfxK7TcwZgGk45dOSNRKIJIAirbsSM5wOGCZs/0PKs7
	 CCnndN8YLxWS56um5+A7pJvHbfQZlAcJfxC6jLs+qkwbOyGz/O17TVbITaitbOaTak
	 gsG0ZR48XckAwwgQwn0ItqHrZAya4h0VyY6IHgKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quan Zhou <quan.zhou@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 7.0 014/307] wifi: mt76: mt7925: fix incorrect TLV length in CLC command
Date: Tue, 12 May 2026 19:36:49 +0200
Message-ID: <20260512173940.425458319@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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
@@ -3375,7 +3375,6 @@ __mt7925_mcu_set_clc(struct mt792x_dev *
 		u8 rsvd[64];
 	} __packed req = {
 		.tag = cpu_to_le16(0x3),
-		.len = cpu_to_le16(sizeof(req) - 4),
 
 		.idx = idx,
 		.env = env_cap,
@@ -3404,6 +3403,7 @@ __mt7925_mcu_set_clc(struct mt792x_dev *
 		memcpy(req.type, rule->type, 2);
 
 		req.size = cpu_to_le16(seg->len);
+		req.len = cpu_to_le16(sizeof(req) + seg->len - 4);
 		dev->phy.clc_chan_conf = clc->ver == 1 ? 0xff : rule->flag;
 		skb = __mt76_mcu_msg_alloc(&dev->mt76, &req,
 					   le16_to_cpu(req.size) + sizeof(req),


