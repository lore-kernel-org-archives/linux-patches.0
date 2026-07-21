Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE11046A612;
	Tue, 21 Jul 2026 15:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649465; cv=none; b=lFgNuSey1tCg9f9pa1go+p+kvkkNOZE4wcUlVEO5m6xb5WeZEx6WLQ4ZLvL1s4Ks22sccOryDg7JHMGR1/2WVt8Id39gNDoKc+PLxXN8zWIYaBJfB/XRjwWNgvpDhUfeHlEapfcAb5I4LqKqLJx9sRgLqRxZDjYxySbqwRWHfb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649465; c=relaxed/simple;
	bh=PxCM6vYT+UEyIDbDr5o4ilqFhuQ5P5bfauxtPcNmjqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HmxF3Qp5nbdoPBpXJ8VWEA1IIJF3JLQmlihWr7EPy0Xos8DUkyLP4UnsxqOYKkq0wedKTGmGVcj+GtKbm9ZAfT46uPKjcHTYGag0Qnr/euOgUjYI1WoN17kY+wUNn7a+OymW8qLO3sjY4v4oaggtusvnj7lMiy2MWKVNDXD81IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o88bz8Yw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o88bz8Yw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FFA31F000E9;
	Tue, 21 Jul 2026 15:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649463;
	bh=SZ4mk8QLOznW5mcLF9PcIJxdcRhxfC9PNF+P+zzVbYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o88bz8Yw4BcN3528BPVTeuspxf5Xc3IjrihM5Y1AAvh8+VBWVwAHOR7Ts+QWE/EbI
	 RNEPAJ4aPSNRGZU8qD+juPS+WT8W+eA60t80YYCA2xw3LoM+qWx/axuu6PbHFaB2cS
	 BVT4bSqIU5ZIk+f46F79KW0pQ+tQS1KlQ5yKHRyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aviel Zohar <avielzohar123@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0586/2077] wifi: mt76: mt7925: validate skb length in testmode query
Date: Tue, 21 Jul 2026 17:04:19 +0200
Message-ID: <20260721152606.634071697@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Aviel Zohar <avielzohar123@gmail.com>

[ Upstream commit c7369a00860a0704461d440e7c3bf9b49bfdbaee ]

In mt7925_tm_query(), the response skb from mt76_mcu_send_and_get_msg()
is used in a memcpy without validating its length:

  memcpy(evt_resp, skb->data + 8, MT7925_EVT_RSP_LEN);

where MT7925_EVT_RSP_LEN is 512. If the firmware returns a response
shorter than 520 bytes (8 + 512), this reads beyond the skb data
buffer. The over-read data is then returned to userspace via nla_put()
in mt7925_testmode_dump().

Add a length check before the memcpy to ensure the skb contains
sufficient data.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Aviel Zohar <avielzohar123@gmail.com>
Link: https://patch.msgid.link/20260413033136.5417-2-avielzohar123@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/testmode.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/testmode.c b/drivers/net/wireless/mediatek/mt76/mt7925/testmode.c
index 3d40aacfc011f5..22a8f1ddc321da 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/testmode.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/testmode.c
@@ -105,6 +105,11 @@ mt7925_tm_query(struct mt792x_dev *dev, struct mt7925_tm_cmd *req,
 	if (ret)
 		goto out;
 
+	if (skb->len < MT7925_EVT_RSP_LEN + 8) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	memcpy((char *)evt_resp, (char *)skb->data + 8, MT7925_EVT_RSP_LEN);
 
 out:
-- 
2.53.0



