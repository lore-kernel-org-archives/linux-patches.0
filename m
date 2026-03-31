Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80F442317F;
	Tue, 31 Mar 2026 16:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974992; cv=none; b=eWiKrgexL28Pc32gqqFhTE0QCdqKWqrnxUWVwZwyDWSHcf02agp+9eS20/Y2Z87qRjl06DdqNeS9XFTtMlvQGtApyoqrUcFyKd7SKCL2PnGHxMvmIOqZLg7zZAoU55ZDKmZ6JEek81E5ibCzDnVa0rI0aZtlZ88VJ03L1eQUZcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974992; c=relaxed/simple;
	bh=5Fn7pJo7Ed6O9X0x7pTj5v+Jh7d7J1bQOWI5CecTUDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hHRssvJ179Vbi895BAZRvrGwkMeBYs2XFnimktZrxb3ha3nWd5JmRLHnv9MfK9UsRrqfHfPGQH7sKMx6m+EQm92YPJl1KkB/irBVnIE/leKHtsA329pzS/53qv6lzv1SpGkwiyKfWxGbNzRqNF5QTCWbmSzX8pvnqH8vNOhV4R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rOlIn5SC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rOlIn5SC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC13C19424;
	Tue, 31 Mar 2026 16:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974992;
	bh=5Fn7pJo7Ed6O9X0x7pTj5v+Jh7d7J1bQOWI5CecTUDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rOlIn5SC+wm0XpkG6SOhNgIzQ5gLyfau/uOn4N75p/e+y5i1NgJpFhqzBVAcVjSB6
	 G3necKzN14mrUigZdcyNiDHjFMsB1TzLiLYDoTra5XQJ9wGqGs6fAR1iuQBo04hebE
	 vkG+KCEmHw7J1VrS6t1RadiU8RbAH+xmNKtT5aUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <dqfext@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 121/342] net: airoha: add RCU lock around dev_fill_forward_path
Date: Tue, 31 Mar 2026 18:19:14 +0200
Message-ID: <20260331161803.461979910@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 2221bafaf7c9f..36e4f328c6e81 100644
--- a/drivers/net/ethernet/airoha/airoha_ppe.c
+++ b/drivers/net/ethernet/airoha/airoha_ppe.c
@@ -227,7 +227,9 @@ static int airoha_ppe_get_wdma_info(struct net_device *dev, const u8 *addr,
 	if (!dev)
 		return -ENODEV;
 
+	rcu_read_lock();
 	err = dev_fill_forward_path(dev, addr, &stack);
+	rcu_read_unlock();
 	if (err)
 		return err;
 
-- 
2.51.0



