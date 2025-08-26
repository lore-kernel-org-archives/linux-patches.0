Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ADFE341659;
	Tue, 26 Aug 2025 11:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208018; cv=none; b=VlIQ/chtgER0IORA6YZ/sKZi76Qv9Up5Okk1LFkPh2fdo6D3LhsTAqy5K4rQT8cWPSDvKuzHLz+8IVVhpeCmCftceOouuScoMJX3EEAqmqI8GWDFRZP6XUXUJ+KRySjKTxymd1ppuoK44Iq0EunkqLj5SV5zlo5nR4712wYfYfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208018; c=relaxed/simple;
	bh=Yw7erqmMwLDTaDWdYm5Lt/6FWmswBUWZUkvFMu9BSsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=to1MNuOOlHj7ssLt3QtZlQbTK6hSUPkND0FQ60aOy91mtPrlVWWSEcBwY1Qaosx26+ulTf9R0yVx86FjHFtPV6+kksMjcfy/xHJ8bfp12COTq5VAZiEoTw52QrjJYt5lY6Z7xjZtZ4eAdDmziFs0+pbhA7SY09JdQrHssYCTfT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZFwU6K+l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZFwU6K+l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A7BC4CEF4;
	Tue, 26 Aug 2025 11:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208015;
	bh=Yw7erqmMwLDTaDWdYm5Lt/6FWmswBUWZUkvFMu9BSsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZFwU6K+lI5n1HQrttZg1fEA0K6OoF0icJdgxOmWxa9IjS35nnESJuQ3TOVqhCWClO
	 a48H44iWSLt0HN+0zx3Q5+wHigZ8ZIqId7OKUcHUxkTmBG3nhJxHY7NXMkKqvyxIjS
	 IVgTOt/yPpkXVZDs3yiSS4M2jlfWD3jwclX0pfEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <dqfext@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 405/457] net: ethernet: mtk_ppe: add RCU lock around dev_fill_forward_path
Date: Tue, 26 Aug 2025 13:11:29 +0200
Message-ID: <20250826110947.304291685@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qingfang Deng <dqfext@gmail.com>

[ Upstream commit 62c30c544359aa18b8fb2734166467a07d435c2d ]

Ensure ndo_fill_forward_path() is called with RCU lock held.

Fixes: 2830e314778d ("net: ethernet: mtk-ppe: fix traffic offload with bridged wlan")
Signed-off-by: Qingfang Deng <dqfext@gmail.com>
Link: https://patch.msgid.link/20250814012559.3705-1-dqfext@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index c855fb799ce1..e9bd32741983 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -101,7 +101,9 @@ mtk_flow_get_wdma_info(struct net_device *dev, const u8 *addr, struct mtk_wdma_i
 	if (!IS_ENABLED(CONFIG_NET_MEDIATEK_SOC_WED))
 		return -1;
 
+	rcu_read_lock();
 	err = dev_fill_forward_path(dev, addr, &stack);
+	rcu_read_unlock();
 	if (err)
 		return err;
 
-- 
2.50.1



