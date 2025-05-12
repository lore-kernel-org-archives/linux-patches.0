Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476372980CC;
	Mon, 12 May 2025 18:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073238; cv=none; b=kJyF5AkxUAgCvyFrQlOnA9DkqZ1MPpc2UFcVxwklgQkS8k6Z11hKYCYyaytqapDeRRT8SG2EYfmUE8/Yz1lv9TfljyL0cPPHnmp2SrI2ceVvT0/b8PHGwt8OqKOUHqT3dclhTm7qCd/AQrbNEuvvnF9lhFfDYSW3kfdn+Uue+iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073238; c=relaxed/simple;
	bh=1jI/YXC+9wzb4S/edgwU6hlenGfHHUY5LtyaKTHFyPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uoWLnlAAH/bN13y6SSLoM+k+p4PrbQicBm8UrKhvDQjIuOOZVQFxR3ciWUp8PnpQL9J4rPH0F7R75wBjv1eilpP+MkSSSaDx6TRBjKLtkledN8WHytnnFFnkbkHHa9kW7W0Q7GjoGvGZcYTFpl/fjgWcPhEzRWuQxavSOgb51+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FnXJNkSA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FnXJNkSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDEE1C4CEE9;
	Mon, 12 May 2025 18:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073237;
	bh=1jI/YXC+9wzb4S/edgwU6hlenGfHHUY5LtyaKTHFyPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FnXJNkSAkm6GYOHkoosBjnlq/aVoC/GYoM8U6woN4gS1oCHvoZkABwaUQM9uJ8HY4
	 PoBdhdHXxUb/10mUV4aUAeJf8gnYa4AHKX6edfk2yexeted50/nZvyVN4vc59GDTNy
	 suaLQecUBgyDFbgl+GKKqlBV8oxmNevn3QsSJrhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 013/113] netdevice: add netdev_tx_reset_subqueue() shorthand
Date: Mon, 12 May 2025 19:45:02 +0200
Message-ID: <20250512172028.234762486@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Lobakin <aleksander.lobakin@intel.com>

[ Upstream commit 3dc95a3edd0a86b4a59670b3fafcc64c7d83e2e7 ]

Add a shorthand similar to other net*_subqueue() helpers for resetting
the queue by its index w/o obtaining &netdev_tx_queue beforehand
manually.

Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 4db6c75124d8 ("net: ethernet: mtk_eth_soc: reset all TX queues on DMA free")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 337a9d1c558f3..0b0a172337dba 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3614,6 +3614,17 @@ static inline void netdev_tx_reset_queue(struct netdev_queue *q)
 #endif
 }
 
+/**
+ * netdev_tx_reset_subqueue - reset the BQL stats and state of a netdev queue
+ * @dev: network device
+ * @qid: stack index of the queue to reset
+ */
+static inline void netdev_tx_reset_subqueue(const struct net_device *dev,
+					    u32 qid)
+{
+	netdev_tx_reset_queue(netdev_get_tx_queue(dev, qid));
+}
+
 /**
  * 	netdev_reset_queue - reset the packets and bytes count of a network device
  * 	@dev_queue: network device
@@ -3623,7 +3634,7 @@ static inline void netdev_tx_reset_queue(struct netdev_queue *q)
  */
 static inline void netdev_reset_queue(struct net_device *dev_queue)
 {
-	netdev_tx_reset_queue(netdev_get_tx_queue(dev_queue, 0));
+	netdev_tx_reset_subqueue(dev_queue, 0);
 }
 
 /**
-- 
2.39.5



