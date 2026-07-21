Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1746E47126D;
	Tue, 21 Jul 2026 17:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656512; cv=none; b=FyBBc9tNeGxK1SorcR25Hj7U3VLelpWw6JdTrvhSygjuG0wBQXbDCYDTMW/QNj+ox4jc1yHXw7PrHYFJ98jRKpv/tAJ1h5RQvWEg0mb/A0Y/u9EjjLkt2leDCap340QtbcineqcIXZldFNv5Qg9QmAtWkMBM3VbMllZQroYCayk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656512; c=relaxed/simple;
	bh=3uZpF0rHRdRMOUfgTYkPoxjmMl0VidujOy5tuux+Pb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RoyFTy8+9A83p7Tl0hxw94M9Pi6//eE/x9vnX797gxrEbmzn+kMMw2+HiwLlXNjWVRHKBiyaa/2jCxVGdBkU/v2vOFk5WSUX/Gs16pfhGiwmlrNBTPMNTMz7g9vrmkBcF5ls6kjrB8KuMpLgjtiqj9AqfV8+23e6+z/pYSjIfso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ctee0dBW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ctee0dBW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783E51F000E9;
	Tue, 21 Jul 2026 17:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656511;
	bh=2eTv9u6P8ike6y3sR9U1bctO58M/i01O3SBAXamm7wI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ctee0dBWNXYxo/79yiVfOsH+BUd3i4w6y1tUpAgFkgwgWR7Sb0SIBxlHMkbWe0cA1
	 na7j1KAzAMY8Q15VJyl0l2zclxfl5Y+LEqPcJTzSYoE3WvPivAxcOXlJB1r8c7CVK+
	 64VZn09NmyIvv7yG5l6ZxeIQ4u8hJBH7GYrFsC+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryder Lee <ryder.lee@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0413/1611] wifi: mt76: mt7921: fix potential tx_retries underflow
Date: Tue, 21 Jul 2026 17:08:49 +0200
Message-ID: <20260721152524.543218170@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit 3c5671ed81b1fff97fa868dae771690599db94f7 ]

When FIELD_GET returns 0 for the retry count, subtracting 1 causes
an unsigned integer underflow, resulting in tx_retries becoming a
very large value (0xFFFFFFFF for u32).

Fix by checking if count is non-zero before subtracting 1.

Fixes: 9aecfa754c7f ("wifi: mt76: mt7921e: report tx retries/failed counts in tx free event")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Link: https://patch.msgid.link/20260605113306.3485554-2-ryder.lee@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index bce26389ab18fd..d2731e9953bf84 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -530,8 +530,9 @@ static void mt7921_mac_tx_free(struct mt792x_dev *dev, void *data, int len)
 		stat = FIELD_GET(MT_TX_FREE_STATUS, info);
 
 		if (wcid) {
-			wcid->stats.tx_retries +=
-				FIELD_GET(MT_TX_FREE_COUNT, info) - 1;
+			u32 count = FIELD_GET(MT_TX_FREE_COUNT, info);
+
+			wcid->stats.tx_retries += count ? count - 1 : 0;
 			wcid->stats.tx_failed += !!stat;
 		}
 
-- 
2.53.0



