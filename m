Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405FF1F238E;
	Tue, 21 Jan 2025 17:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482309; cv=none; b=W7YVqh3BPfSCnToRGaUGhE1NVljlWRpDgEHFceoNq8zPvqyUGfG6Y/4RbeD6d7lStdWo8YvlAAsDLfwI/GVLVtbLaUIU7Lkxj8Cg4csfzwEebnXyqTmo5WLieew6RVbc3QMCf73HXUec7C1TBvjXXCMHPwiaw0fvUNZWhmZucQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482309; c=relaxed/simple;
	bh=wgozrJu36BOuMOQrO8SKbMg2tkIDnhd0DucU44hRl50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZNC9tutxUHBD9ZHXxahKG+FayfGxYMi0bBGkWW8wf9DGMOUfvOv8Sm1nr/UcExtBvvzajoIDv2VV4QW8rkaCdkWzkDfYLxE0t1pjSVzc8YmTrQVnCVvGAVQmsO4KfvZQNqlONeG3aeoTS7ZQlF3GheMj59bqkCJB3u0d76nxsjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lOA++bxd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lOA++bxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B722EC4CEE0;
	Tue, 21 Jan 2025 17:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482309;
	bh=wgozrJu36BOuMOQrO8SKbMg2tkIDnhd0DucU44hRl50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lOA++bxdsSYuVhdUZKRsLkUR+iyLrFthO9VgJQ8i5nZmUIy9Hhs4+ThX25SO8J+zD
	 yX/CAD5ZTL8Wq2+v/dKz6fiLIQ1Bvbqvp8mvFB0debAdk4fXah0VOGsRE9f4oj+OYm
	 E+EVIPfZ6vQkmRpfoSa6WEtrGTWDwyhPGlCsiOPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Barker <paul.barker.ct@bp.renesas.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Simon Horman <horms@kernel.org>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 005/122] net: ravb: Fix max TX frame size for RZ/V2M
Date: Tue, 21 Jan 2025 18:50:53 +0100
Message-ID: <20250121174533.200580790@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Barker <paul.barker.ct@bp.renesas.com>

[ Upstream commit e7e441a4100e4bc90b52f80494a28a9667993975 ]

When tx_max_frame_size was added to struct ravb_hw_info, no value was
set in ravb_rzv2m_hw_info so the default value of zero was used.

The maximum MTU is set by subtracting from tx_max_frame_size to allow
space for headers and frame checksums. As ndev->max_mtu is unsigned,
this subtraction wraps around leading to a ridiculously large positive
value that is obviously incorrect.

Before tx_max_frame_size was introduced, the maximum MTU was based on
rx_max_frame_size. So, we can restore the correct maximum MTU by copying
the rx_max_frame_size value into tx_max_frame_size for RZ/V2M.

Fixes: 1d63864299ca ("net: ravb: Fix maximum TX frame size for GbEth devices")
Signed-off-by: Paul Barker <paul.barker.ct@bp.renesas.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://patch.msgid.link/20250109113706.1409149-1-paul.barker.ct@bp.renesas.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 907af4651c553..6f6b0566c65bc 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2756,6 +2756,7 @@ static const struct ravb_hw_info ravb_rzv2m_hw_info = {
 	.net_features = NETIF_F_RXCSUM,
 	.stats_len = ARRAY_SIZE(ravb_gstrings_stats),
 	.tccr_mask = TCCR_TSRQ0 | TCCR_TSRQ1 | TCCR_TSRQ2 | TCCR_TSRQ3,
+	.tx_max_frame_size = SZ_2K,
 	.rx_max_frame_size = SZ_2K,
 	.rx_buffer_size = SZ_2K +
 			  SKB_DATA_ALIGN(sizeof(struct skb_shared_info)),
-- 
2.39.5



