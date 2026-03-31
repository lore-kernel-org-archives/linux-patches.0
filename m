Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8119A2E0413;
	Tue, 31 Mar 2026 17:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976482; cv=none; b=UVwt3wxoA/Jgkf4Fh5gixgholes8eeoi4LMl83HIKM7ilmWoNL6lAbLLG2zhdH0qnGgqbiNWdjOafEDduCfF3J1s/IVYK+j3J7bT/4lyHFQunrsuPa2B8J4n65YvOxjB+fbpAgajXBN4TCQXcm+FqloZxdUZFFcH2jIxKUvfVt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976482; c=relaxed/simple;
	bh=8THfTtgIuVQs8ubS/PFDc8Mh35LjZqkGEvdgft1SeOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N3i81/rcyJvFMXMje4UYLRTZcJU+l8bYKenU7PyMy1nJraBZSamx63Y2falM+MFGBgmNH62qwStPedP1umptsz3AgchMEcXXVFjftyuyJ/FkPCPbyuiv3PyE3u8xrZoPMHiUECvmvg8f1395LoePiz+n8ifO62oHV/ngB9s5gMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B2jxoyKq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B2jxoyKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04352C19423;
	Tue, 31 Mar 2026 17:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976482;
	bh=8THfTtgIuVQs8ubS/PFDc8Mh35LjZqkGEvdgft1SeOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B2jxoyKqCB4SB1O34XvlAZL/z9vbk0NANfe5vhZBvc1lYrpAP2/TRoBbXZRvXRMmv
	 SqTGzBTEybXRZ2aVdfkYAjfMqtY7hCq1q21UN2eRlmvg3pjXmFE9SWimWY9gR9V2sm
	 XI2snKqIMRq9IoNl6CvL2glLmyrB/OzYccmrn2dM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <dqfext@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 110/309] net: airoha: add RCU lock around dev_fill_forward_path
Date: Tue, 31 Mar 2026 18:20:13 +0200
Message-ID: <20260331161757.534868718@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Qingfang Deng <dqfext@gmail.com>

[ Upstream commit 1065913dedfd3a8269816835bfe810b6e2c28579 ]

Since 0417adf367a0 ("ppp: fix race conditions in ppp_fill_forward_path")
dev_fill_forward_path() should be called with RCU read lock held. This
fix was applied to net, while the Airoha flowtable commit was applied to
net-next, so it hadn't been an issue until net was merged into net-next.

Fixes: a8bdd935d1dd ("net: airoha: Add wlan flowtable TX offload")
Signed-off-by: Qingfang Deng <dqfext@gmail.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260320094315.525126-1-dqfext@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_ppe.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/airoha/airoha_ppe.c b/drivers/net/ethernet/airoha/airoha_ppe.c
index 190d98970014f..b3632f964a580 100644
--- a/drivers/net/ethernet/airoha/airoha_ppe.c
+++ b/drivers/net/ethernet/airoha/airoha_ppe.c
@@ -201,7 +201,9 @@ static int airoha_ppe_get_wdma_info(struct net_device *dev, const u8 *addr,
 	if (!dev)
 		return -ENODEV;
 
+	rcu_read_lock();
 	err = dev_fill_forward_path(dev, addr, &stack);
+	rcu_read_unlock();
 	if (err)
 		return err;
 
-- 
2.51.0



