Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338F83859E6;
	Sat, 12 Sep 2026 08:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201040; cv=none; b=NB/O38z6TADEvJmzJJRWHXwFZA+94Inj+UlX8EsnoR0GFuShZC1YisaRIbTdf1BKaUcRPZ/csmSqqhJY8dQ5jz7GgN+n6T4Fqb856U3pJFaWKrOOKFy4SysOu8QTzmCoDsN0/77X9R1D3KzPb/9cdf0IaCr11diM9GvdQrRiv0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201040; c=relaxed/simple;
	bh=o77wX8o0vWqNSMK12N/vwbfxUUiMV3AS7+RhNrrDzFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EReBnReQnDrk1EjghAj3vokvtjLYdZ5wJ73islMXJ/1/GABvTqcCCd+aB28c67+GtK3bhmzPfV2OXBEgMrKJwJ4fjWRozcuorAqSJAew64T6AH+8P1gEjwAL3niavvuQ5ftMHYMvtzOy8Uk7atBCtRYlveEyf93g28LWQFGc/CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k4qiNyTi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k4qiNyTi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06851F000FF;
	Sat, 12 Sep 2026 08:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201039;
	bh=lkDwZQwhK+zugeO01w/am7IurS0CDbSJMoZBhaLYgv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k4qiNyTiNRpyyXaG+5FpyHSpTxW3tguJHw4vR2xKTeLs3rdlUzk0URJBxnM+Whicf
	 3hYq4hGb2lTA/IMBs0jF1Skuna37QmegIxmbQPy4UYaO0SF5hWRpKI4sNWVCxfqIqD
	 e5CUQLTn58phak9cSnJrAbZs8rueOCsPu6hAmvz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jared.Huang" <jared.huang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0871/1815] wifi: mt76: mt7925: fix msg len mismatch between driver and firmware
Date: Sat, 12 Sep 2026 08:43:41 +0200
Message-ID: <20260912065709.370823808@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jared.Huang <jared.huang@mediatek.com>

[ Upstream commit 9ddb7487aa7cccb6e1880b4151ab5895109eb8d6 ]

The mt7925_tx_power_limit_tlv struct begins with a 4-byte rsv[] field
that acts as a UNI command header prefix. The firmware dispatcher did
not use the 4-byte rsv[] and will only check the payloads after the
4-byte rsv[] As a result, the total message length minus the 4-byte
prefix. Fix this by setting len to msg_len - 4.

Fixes: ccb186326bb6 ("wifi: mt76: mt7925: fix incorrect length field in txpower command")
Signed-off-by: Jared.Huang <jared.huang@mediatek.com>
Link: https://patch.msgid.link/20260617071320.1808499-1-jb.tsai@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index ba43826a25ecd..53c142345a086 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -3843,7 +3843,7 @@ mt7925_mcu_rate_txpower_band(struct mt76_phy *phy,
 		memcpy(tx_power_tlv->alpha2, dev->alpha2, sizeof(dev->alpha2));
 		tx_power_tlv->n_chan = num_ch;
 		tx_power_tlv->tag = cpu_to_le16(0x1);
-		tx_power_tlv->len = cpu_to_le16(msg_len);
+		tx_power_tlv->len = cpu_to_le16(msg_len - 4);
 
 		switch (band) {
 		case NL80211_BAND_2GHZ:
-- 
2.53.0



