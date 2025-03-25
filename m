Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21ED626B972;
	Tue, 25 Mar 2025 12:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906301; cv=none; b=OsNVKmjkxC53mBAFBrH+6MNRHbUoCQ6EO1wO6ps7OULNnTgKFeaU8MZFUbSrlRXLE7zU5n5wW/mMnoj/HxAthkq7EcawLp+5Uu6Zrlj8qznKXE0xrGMJgm9Ht7eAcEHxX29obeWwTeTneO5gR4BhBNQdL7SE3AjeVuLnH9u7GKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906301; c=relaxed/simple;
	bh=WY3jZ5l97NIdbZqiIA7VJLBodCkN531zwgtdgAzWv9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqOTJYKrmTrGBo2bRUJ4zsgoezOdS4Mk1GKPcK/JqFyl0bPd0oKoADlZ8IECGKYhOHcgcatsGgHHB4PP582z29Dj1vVb9d3F+/Y6bM7vTfvFB7tqDmFkLMBKwC3Qg9lxuuzvYSE2tcpqdXxAPzbNQcaCIx1gkSybxNE9uFIMo0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FshwMhAK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FshwMhAK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7916C4CEE4;
	Tue, 25 Mar 2025 12:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906301;
	bh=WY3jZ5l97NIdbZqiIA7VJLBodCkN531zwgtdgAzWv9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FshwMhAKkYtzXiIm0qvH91pxgJIQSdRQHV4sNuJQgA9DCzRA3gXMVmcxeOEt14Hwv
	 gSo6K2FhK4sp6iW0v0ZEA7vq7SD5/bcawfycCxQ4BVmt8I689kyEkQgbig/riAucrN
	 3ugtxjNH89xjtl9Ql9TyHM+LFaIAqAQ9nXp3VOMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MD Danish Anwar <danishanwar@ti.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 045/116] net: ti: icssg-prueth: Add lock to stats
Date: Tue, 25 Mar 2025 08:22:12 -0400
Message-ID: <20250325122150.359512137@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: MD Danish Anwar <danishanwar@ti.com>

[ Upstream commit 47a9b5e52abd2b717dfc8b9460589f89936d93cf ]

Currently the API emac_update_hardware_stats() reads different ICSSG
stats without any lock protection.

This API gets called by .ndo_get_stats64() which is only under RCU
protection and nothing else. Add lock to this API so that the reading of
statistics happens during lock.

Fixes: c1e10d5dc7a1 ("net: ti: icssg-prueth: Add ICSSG Stats")
Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250314102721.1394366-1-danishanwar@ti.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/icssg/icssg_prueth.c | 1 +
 drivers/net/ethernet/ti/icssg/icssg_prueth.h | 2 ++
 drivers/net/ethernet/ti/icssg/icssg_stats.c  | 4 ++++
 3 files changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/ti/icssg/icssg_prueth.c b/drivers/net/ethernet/ti/icssg/icssg_prueth.c
index cb11635a8d120..6f0700d156e71 100644
--- a/drivers/net/ethernet/ti/icssg/icssg_prueth.c
+++ b/drivers/net/ethernet/ti/icssg/icssg_prueth.c
@@ -1555,6 +1555,7 @@ static int prueth_probe(struct platform_device *pdev)
 	}
 
 	spin_lock_init(&prueth->vtbl_lock);
+	spin_lock_init(&prueth->stats_lock);
 	/* setup netdev interfaces */
 	if (eth0_node) {
 		ret = prueth_netdev_init(prueth, eth0_node);
diff --git a/drivers/net/ethernet/ti/icssg/icssg_prueth.h b/drivers/net/ethernet/ti/icssg/icssg_prueth.h
index 5473315ea2040..e456a11c5d4e3 100644
--- a/drivers/net/ethernet/ti/icssg/icssg_prueth.h
+++ b/drivers/net/ethernet/ti/icssg/icssg_prueth.h
@@ -297,6 +297,8 @@ struct prueth {
 	int default_vlan;
 	/** @vtbl_lock: Lock for vtbl in shared memory */
 	spinlock_t vtbl_lock;
+	/** @stats_lock: Lock for reading icssg stats */
+	spinlock_t stats_lock;
 };
 
 struct emac_tx_ts_response {
diff --git a/drivers/net/ethernet/ti/icssg/icssg_stats.c b/drivers/net/ethernet/ti/icssg/icssg_stats.c
index 8800bd3a8d074..6f0edae38ea24 100644
--- a/drivers/net/ethernet/ti/icssg/icssg_stats.c
+++ b/drivers/net/ethernet/ti/icssg/icssg_stats.c
@@ -26,6 +26,8 @@ void emac_update_hardware_stats(struct prueth_emac *emac)
 	u32 val, reg;
 	int i;
 
+	spin_lock(&prueth->stats_lock);
+
 	for (i = 0; i < ARRAY_SIZE(icssg_all_miig_stats); i++) {
 		regmap_read(prueth->miig_rt,
 			    base + icssg_all_miig_stats[i].offset,
@@ -51,6 +53,8 @@ void emac_update_hardware_stats(struct prueth_emac *emac)
 			emac->pa_stats[i] += val;
 		}
 	}
+
+	spin_unlock(&prueth->stats_lock);
 }
 
 void icssg_stats_work_handler(struct work_struct *work)
-- 
2.39.5



