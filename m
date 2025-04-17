Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9D8255E23;
	Thu, 17 Apr 2025 18:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913267; cv=none; b=oh1GDi+YagZuKy6TlXrBXNYeRlry1jyCcDS9ea8NC0TxcyVJfZAYuKg3moI19tBBmfUkBK/X5oOk0O6FSWqOH5OM0XdDSfyzFMHMjMdpdCVDZyOJ3kRFSPOnRff78BMwax9j2AmBiGWfMl92Ozwy3dIuqN3u1WwCiAoIlYeeGto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913267; c=relaxed/simple;
	bh=klH8CB0Or8NseXjC9P+LJQOr3+QaeiNyWwSKZ/8HIXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U0/nbWVYsUpqP+TvHULsskiCkKyZt4aWUPKK+Wuiog5v41BAuGTkZoQkJVIsd7wh5glDDYFARMK19Yd61YHdsYD1EpgyBhMBWHEmIgP/WP6tzUwB43dHFrIxe48pyAEz7rQ6YJjCv2HQUJIZcBBA30WeIWviN2ZrkkJo4Obkfq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l/6kcavl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l/6kcavl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5713DC4CEE4;
	Thu, 17 Apr 2025 18:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913267;
	bh=klH8CB0Or8NseXjC9P+LJQOr3+QaeiNyWwSKZ/8HIXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l/6kcavld//WIQ9jLxZYIlA6Lc1vhrs5MnAFUKjOGRP8duunf8yghLE/fcD/K7VAW
	 ZWY1XRGhgmY0jilZ4vbx54DwUpOeW/3yXCjgzkVOMJB7sY22/sxLQMCRCe6vOy4foS
	 DyP9ohhr+qMOT3Kp52leey4Gs1PHxHJQiaxGh0zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.14 282/449] wifi: mt76: mt7925: fix country count limitation for CLC
Date: Thu, 17 Apr 2025 19:49:30 +0200
Message-ID: <20250417175129.423250504@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3125,13 +3125,14 @@ __mt7925_mcu_set_clc(struct mt792x_dev *
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


