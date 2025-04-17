Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC84825744D;
	Thu, 17 Apr 2025 18:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914565; cv=none; b=a6jpx5a8nV0Ac1GiSO3P9y/iHO/vLXuZGmxejehCl00Pa46V9KsVVo0CBCgAK5WsVml6P0H4b4yofYgeYWGkJBaeIChA2X95ppDZbUpuuAohWmU0DPIjwEcjuk3dAaf6meDta6DSefjtyNRUFdLw/9ha/hQrLj7vYQYr8OyrGpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914565; c=relaxed/simple;
	bh=BK1my3XYBV8dAoHZ8GSWValDxwVQo9F1bguQ943OB7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TOLh7RHhB3xFD7I02cDr0jsBYBWss3DI4kBZL/pvN0Cyb/vFeg9ckkSOAplrja1eoKaHcnaP92VdFwKv9TjwR1pb3gtxbJydbpAj6Mn/iAOVtFSMrAEttF29EKtZmO26oU9Ksb2jISB+pKWNDzebP9r1yNau3NOGXRXrwZBSHkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xPWywUwu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xPWywUwu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46492C4CEE4;
	Thu, 17 Apr 2025 18:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914565;
	bh=BK1my3XYBV8dAoHZ8GSWValDxwVQo9F1bguQ943OB7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xPWywUwuHj4AXzzRtFvwD63hi7o6b/Lk4z0QxGcFCcJURECV5hyyYP6JiFzflqmaA
	 RuEyHjG4tQHzM10uIr2XyAmFy6nbJhl+H6l5iqnwhANxDSG2zQ31qm3bSdWv9GbfV/
	 uby/EGTPQch7yJtcC4GNpe5r7ksx4C3ZgG5sWSR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.13 258/414] wifi: mt76: mt7925: fix country count limitation for CLC
Date: Thu, 17 Apr 2025 19:50:16 +0200
Message-ID: <20250417175121.808467621@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

commit 6458d760a0c0afd2fda11e83ed3e1125a252432f upstream.

Due to the increase in the number of power tables for 6Ghz on CLC,
the variable nr_country is no longer sufficient to represent the
total quantity. Therefore, we have switched to calculating the
length of clc buf to obtain the correct power table.

Cc: stable@vger.kernel.org
Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20250116062131.3860198-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -3119,13 +3119,14 @@ __mt7925_mcu_set_clc(struct mt792x_dev *
 		.env = env_cap,
 	};
 	int ret, valid_cnt = 0;
-	u8 i, *pos;
+	u8 *pos, *last_pos;
 
 	if (!clc)
 		return 0;
 
 	pos = clc->data + sizeof(*seg) * clc->nr_seg;
-	for (i = 0; i < clc->nr_country; i++) {
+	last_pos = clc->data + le32_to_cpu(*(__le32 *)(clc->data + 4));
+	while (pos < last_pos) {
 		struct mt7925_clc_rule *rule = (struct mt7925_clc_rule *)pos;
 
 		pos += sizeof(*rule);


