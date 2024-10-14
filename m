Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA3D1AB536;
	Mon, 14 Oct 2024 15:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918887; cv=none; b=YhYnl3mvwNnJLTonO1hWz4d4m7xaxQW6NQ/l0BCS6J/ZQpcgrbEIMiSAOXL1S+qMbI1in9L4YZk9q1yDVnuV5QDK1NnrHbUIzS7jq+QWELIzRT344K0zs/zqI+eWR+iEhUdNM4TFUyT0IBySn+2Dqbnwo9JDUqfkanX7kHULiRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918887; c=relaxed/simple;
	bh=ncxo4VlCp8F+Jf9k+LN7SQBKSjw+eHEqClmwIfu+4ZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eRODim56SZ6Nx0lZ52TlTg63EsKHxGINW7VXggxDX/gTyHDpDqyvcrOkJGbXUjrLpRc6uc+GItB9GbjVLXoTeE73WeJD5+Beh0WqQyVim9G1IHyZCisXelY4jNIhtrLydAY2Jqz80gad+2nZBlMP6S/p79QASVApUQ2gUKkggx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E+EUoxjA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E+EUoxjA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E31DAC4CEC3;
	Mon, 14 Oct 2024 15:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918887;
	bh=ncxo4VlCp8F+Jf9k+LN7SQBKSjw+eHEqClmwIfu+4ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E+EUoxjAeGUSQieT3zPNVbRy4HSQFNAK/i1uO7Hb4u9jaMAgOktMBl8xQXuznUUH7
	 D+VuSQtGLDkKQQXW7Jp8IVRqlydAydkuz2uJw9mSCgIJYhYpr2v7awjLPCHKBdkCUk
	 JPiP6ZFrGWSomCqCNDRlc2c+kTSWVQ3APv2V+a7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 451/798] wifi: mt76: mt7915: hold dev->mt76.mutex while disabling tx worker
Date: Mon, 14 Oct 2024 16:16:45 +0200
Message-ID: <20241014141235.690585740@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1f3b7e7f48d50..36c4bfb7776b1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -1409,12 +1409,14 @@ void mt7915_mac_reset_work(struct work_struct *work)
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



