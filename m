Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CF936A378;
	Tue, 12 May 2026 17:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608245; cv=none; b=uBBcC4BMw6TMfOB/yEzkgrcFxpaijvTNFdWA3E+C4llH1l2YzBNz0IMbSRBzJ1TSPGc8OsGkwSOEyndCrECSculp0cNAU2NXh/Tb3iEc20bvU13ZX2qhDA8KmVlHEtPqJnQf0gtcDNYoVZj+jWrL4ZWVVPeGQnBWJLNoho0qVTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608245; c=relaxed/simple;
	bh=rr8TcxGrlP8VomFFTKDaNHigpO/+ZajIfdo+iCOjdFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=goiyMeMOAVAcSNjFDWa/5RWTNSsqskRr2jHqzqeVJ7NBmeKou+8ucHzdIjYjoKEVvNTRbs1Mlsfm0o60g6ARs6rRnpQ7sVkRb6GwUHqA3EnEbvfuSSJlhwjTYSpwUIPXSHynROrJh8soOiZd+9C8AuXDtTULCtnzYmkVIJf3DqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V4j7WsIV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V4j7WsIV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A13EEC2BCB0;
	Tue, 12 May 2026 17:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608245;
	bh=rr8TcxGrlP8VomFFTKDaNHigpO/+ZajIfdo+iCOjdFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V4j7WsIVlsRLhg/9r1jHS1GHaykpBDjmuUaFJaenI35II7o/oUdKmaq6AuVj2Jo0Q
	 tpkCpwjRDyau1/MCigqLv59FOfrgkeXXDVSUvk1xMu2ZLBRNKeGBOsAbD8rZOkwuHK
	 LfwhPQHriNBBmUHehLJvHc5JIoZz6wG8hL/Gxjzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quan Zhou <quan.zhou@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 202/206] wifi: mt76: mt7925: fix incorrect TLV length in CLC command
Date: Tue, 12 May 2026 19:40:54 +0200
Message-ID: <20260512173937.154014806@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quan Zhou <quan.zhou@mediatek.com>

[ Upstream commit 62e037aa8cf5a69b7ea63336705a35c897b9db2b ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -3261,7 +3261,6 @@ __mt7925_mcu_set_clc(struct mt792x_dev *
 		u8 rsvd[64];
 	} __packed req = {
 		.tag = cpu_to_le16(0x3),
-		.len = cpu_to_le16(sizeof(req) - 4),
 
 		.idx = idx,
 		.env = env_cap,
@@ -3289,6 +3288,7 @@ __mt7925_mcu_set_clc(struct mt792x_dev *
 		memcpy(req.type, rule->type, 2);
 
 		req.size = cpu_to_le16(seg->len);
+		req.len = cpu_to_le16(sizeof(req) + seg->len - 4);
 		skb = __mt76_mcu_msg_alloc(&dev->mt76, &req,
 					   le16_to_cpu(req.size) + sizeof(req),
 					   sizeof(req), GFP_KERNEL);


