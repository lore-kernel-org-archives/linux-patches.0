Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94D31D90CD;
	Tue, 15 Oct 2024 11:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993503; cv=none; b=aLdWqaVGzdhzzt79Ce/ba4hnUDKEQLWwUx2Xb4J7vbW2bnHj4a75H1PYUMLs6ZKI2RI+boeDPmqpW4yG7ONCFECnIN9HTJAW7RdZ+mjtIRmORgV/I7ymh3N/HUOhIh34xP2qKW6J+hwMFH/fvCER1zm6D4FjtnlPjJCHV8cv/yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993503; c=relaxed/simple;
	bh=ZYEQWnWLE+2M661lJBUxT9j5kgkRRA3yvBRa46uHkQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdxZHNTp/ymPk9MixXeU2zIKZqUL4/KUZ08vskdQqY7+FLwO1e3JyKGKWQ2ASe0n7pZF7fT50ZNei/7qdDVeP1eKtMjf83QACWJIhzd9i7bNVmxMg4bEAgFnBUHntpADXNhF7L6occKIuoRlMU1xIt7lS8Rj7TUStSWnV0yfAy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bYyxBzVe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bYyxBzVe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A12C4CEC6;
	Tue, 15 Oct 2024 11:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993503;
	bh=ZYEQWnWLE+2M661lJBUxT9j5kgkRRA3yvBRa46uHkQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bYyxBzVebYXaqA+ZT2yeEMzYDjZh3GdJyK4PtBda4gsB6KVVP6Le0TWobZVj4mYsx
	 1M9NuowqfOrUueHugy4yqQiHpKN78dXlCsCkzlWQ/v59rGf94qP+RBdknCkWTmmvWt
	 y+vPlGDhyul0ATVWDW62VrmW0EKlN+3Z6tgoQUV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 432/691] wifi: mt76: mt7915: hold dev->mt76.mutex while disabling tx worker
Date: Tue, 15 Oct 2024 13:26:20 +0200
Message-ID: <20241015112457.488295219@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a8a0e6af51f85..f6e686cc642b6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -1653,13 +1653,15 @@ void mt7915_mac_reset_work(struct work_struct *work)
 		set_bit(MT76_RESET, &phy2->mt76->state);
 		cancel_delayed_work_sync(&phy2->mt76->mac_work);
 	}
+
+	mutex_lock(&dev->mt76.mutex);
+
 	mt76_worker_disable(&dev->mt76.tx_worker);
 	napi_disable(&dev->mt76.napi[0]);
 	napi_disable(&dev->mt76.napi[1]);
 	napi_disable(&dev->mt76.napi[2]);
 	napi_disable(&dev->mt76.tx_napi);
 
-	mutex_lock(&dev->mt76.mutex);
 
 	mt76_wr(dev, MT_MCU_INT_EVENT, MT_MCU_INT_EVENT_DMA_STOPPED);
 
-- 
2.43.0



