Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D86183CB8;
	Tue,  8 Oct 2024 12:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391588; cv=none; b=Dvnwp8XkZwUBBbSGBm/ouBB9bsZ5IlVMRu83POT9JVTzBtuejXUM00FJd/RZyEqZJ/DkrcItGf0iYPxs6fMNaj4u8WqWF3nA89NmanDMbB5g/dyG4sAqUeGPHZHnBtExkC5pib+r8yLW1DzjXiS7374srxq8tEBa38wYmWy5eaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391588; c=relaxed/simple;
	bh=4e/TDzNCIu60xU6nFxK7iAVNuesLpFquYoTCb6Ybhqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ggtiKV0TSkE1L9VDu+4mJxcKivWeySYeGn4eoJyEuXL6HxczbM1hJZDZtA0mD5LjF+0t5/eQPyFiGa0EDWQ3W5OaM+NVsshLNtTFxFK/g3/mKJUrTdxEkKBKrACLcvqT+tAQ7VldzJAnKkSVUueZrZ5uzpdA8FAw+g1mM4iwj4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c6jRzRGx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c6jRzRGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2EAFC4CEC7;
	Tue,  8 Oct 2024 12:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391588;
	bh=4e/TDzNCIu60xU6nFxK7iAVNuesLpFquYoTCb6Ybhqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c6jRzRGx9zPbbvETFxItMCg4ol76KTxYCk6lpJhOY+5dcoThs4rWGZGsK+i1l8zr6
	 LojFmCanWJoQxPSJ31eB/R6cWjVC8Ae/XzcHdsr6cTUzOGaoidzEDNMqdY50AqQe9I
	 mqlE/ZGWivxor0T/JcAw4O3OOozR16tOCeTo+yOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 161/558] wifi: mt76: mt7915: hold dev->mt76.mutex while disabling tx worker
Date: Tue,  8 Oct 2024 14:03:11 +0200
Message-ID: <20241008115708.696036304@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 8008ce3fa6c7e..387d47e9fcd38 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -1537,12 +1537,14 @@ void mt7915_mac_reset_work(struct work_struct *work)
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
 
 	if (mtk_wed_device_active(&dev->mt76.mmio.wed))
 		mtk_wed_device_stop(&dev->mt76.mmio.wed);
-- 
2.43.0



