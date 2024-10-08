Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90E31DE89A;
	Tue,  8 Oct 2024 13:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393273; cv=none; b=ilBnJ3y6HFQeRqSj8L85WDIZ8NUDDrh6SvQ56sUtAqIDAZS57j83GHsD9vZqCCVWAcCUgH+KQPfIBoc+s5JiC2GhyvJnfZHnpmpH7UZCUsMSz5AzJwnirEznHhTuiAy41lAdYmn/WpXnDSHGOWnw4EmNW1jiy6lUc/hMS55nB4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393273; c=relaxed/simple;
	bh=kQUFC7bT3lQpiOHtWC+l16Kd3r/DtgzeF83bbQp0nMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LcvKx2zS1devaxHOcDmYhca3G2WKI0Iwo4jhnvKTLRUPYu1oIBqxbT4V8xgwNTuLgfKwn8qZRQuPDIloureaxOtqhOcogTLPLX9N4HJCdW7I+wic8OfCqB8Wk658UYwNwfILr/95Jg6eDXOVMmMI19rdX5vsOe8Xwg/XgyF/HnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L5rxzTMZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L5rxzTMZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82E7C4CEC7;
	Tue,  8 Oct 2024 13:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393273;
	bh=kQUFC7bT3lQpiOHtWC+l16Kd3r/DtgzeF83bbQp0nMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L5rxzTMZk3JZPcCK8zdMseZdGSD0yqrOfrbvggKrt6GyB6IuQBIydMcfXi5eY+uGi
	 GoqiE0RRixmM9O+yIaGSQZsxubRFiO9yKStXQ09JfIerUbbBJ5WEhxUUMXYbwRTJTg
	 1p+L+H3cIr6jinGvUGsTlQht//yhwHpQLKkBSRzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 104/386] wifi: mt76: mt7915: hold dev->mt76.mutex while disabling tx worker
Date: Tue,  8 Oct 2024 14:05:49 +0200
Message-ID: <20241008115633.539215864@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 8f7152f10cb434f954aeff85ca1be9cd4d01912b ]

Prevent racing against other functions disabling the same worker

Link: https://patch.msgid.link/20240827093011.18621-17-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index 2222fb9aa103e..38d27f8721733 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -1538,12 +1538,14 @@ void mt7915_mac_reset_work(struct work_struct *work)
 		set_bit(MT76_RESET, &phy2->mt76->state);
 		cancel_delayed_work_sync(&phy2->mt76->mac_work);
 	}
+
+	mutex_lock(&dev->mt76.mutex);
+
 	mt76_worker_disable(&dev->mt76.tx_worker);
 	mt76_for_each_q_rx(&dev->mt76, i)
 		napi_disable(&dev->mt76.napi[i]);
 	napi_disable(&dev->mt76.tx_napi);
 
-	mutex_lock(&dev->mt76.mutex);
 
 	mt76_wr(dev, MT_MCU_INT_EVENT, MT_MCU_INT_EVENT_DMA_STOPPED);
 
-- 
2.43.0



