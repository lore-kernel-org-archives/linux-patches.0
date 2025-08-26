Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6A03277A4;
	Tue, 26 Aug 2025 13:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214021; cv=none; b=F0CAsk/eN/Y/YCM2RK7TVoWICl+l96R/+TWmrWnXK9HZ7nOXWpNy28pdmmvZxRtVcEQDgY5XrHhnkK1W9j1N9eCYqXVybAVfRuYEWt9uDnno7VTi2aqn2UNSDZWTCntl+rM2IouOn/h6/fRdFHLH99gFqEOXVt18jgoK3usvtEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214021; c=relaxed/simple;
	bh=8jxOeEEoLIZNaJKwQXF0PuQ6CEmYAwppSBmrS7U7PY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CjOKYQ+sNw2BKT0IRgCV7jO9/9bwlZ+4CUfzyzEkQigQR+06rmcdHq4Cpw40zrX1scU0HPKTJnEk15jh+Iwj4sUP3dxVyUm+4ZZxHefMkzop2OLdEOCeTuqhVo1kMy8NFNvzqKKc0yu67Zzaa54fhzR7IOxqflaPnwa4LZfy+2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q+/UadA+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q+/UadA+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EECB4C4CEF1;
	Tue, 26 Aug 2025 13:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214021;
	bh=8jxOeEEoLIZNaJKwQXF0PuQ6CEmYAwppSBmrS7U7PY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q+/UadA+5T6qGuJzJ+c6OcOgBB6QguVgvUZjLQHCDUNkaBT0SUapobGIveluXK7Rb
	 IACcQ5zOWEqSVq17dW5Mr43GBynfgbNTIbAJ0LMiXl8OTfmezVuwD8if0i7Ep2Mzvr
	 RdjcHRR3whLIBIgWF+pO1ag2ePXryhqm4ToMqXhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <dqfext@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 567/587] net: ethernet: mtk_ppe: add RCU lock around dev_fill_forward_path
Date: Tue, 26 Aug 2025 13:11:56 +0200
Message-ID: <20250826111007.455929016@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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
index 889fd26843e6..11e16c9e4e92 100644
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



