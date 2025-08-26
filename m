Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04781227EA8;
	Tue, 26 Aug 2025 13:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215312; cv=none; b=r2/32G9xYWEquljrb5Xv1hY1WQYxvGq7ji7KXaNhS+wTYqFM5/UgZy4DTVJbNbB6E/dM0mGBq/HOhOo1o0SHqU3NhW2GSnahdNmY7phSIysk2jsBpux54yU1esFEICxL+sjeSNyJpA6n3u79okKitIMw0SoiXeg8K0pbuYgdVNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215312; c=relaxed/simple;
	bh=yAPCpNAZEdcnroSqWGbenpavFmeIcJU1XrOz7LU7v3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZGSbug96trSz+QPXEkJa4e5RDGa32vuugmSlgSCYf3x8vhgvU4Ldzsu36E2VmEOkPcQQY71LSUtbSCF4zqxFvA+ZZS11OOLqQhVWrjfRiA0RBHnkwt7BpVHdczxrjGBYwKhkgU52xyazKzk7tUUlEqxB3O0E2LLRAIFYHD4Gdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=swXqSt94; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="swXqSt94"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F92C4CEF1;
	Tue, 26 Aug 2025 13:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215311;
	bh=yAPCpNAZEdcnroSqWGbenpavFmeIcJU1XrOz7LU7v3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=swXqSt94A9gqvSJFSaVULbpTWLJpzi6xgAL5BFsJZyt5rLYKYSUa3EFJtBZ2CiG60
	 3bUxoUvjGa/LmnMLoz4bAEh6Uf+RBXdD5ooezSLuxbbyhLPb2GoI469vHmphCgtrnz
	 scKIpn4RSUC7QBZ64AX+orV+8j4rwRcNS5os/UgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <dqfext@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 467/482] net: ethernet: mtk_ppe: add RCU lock around dev_fill_forward_path
Date: Tue, 26 Aug 2025 13:12:00 +0200
Message-ID: <20250826110942.360222143@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8cb8d47227f5..cc8f4f5decaf 100644
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



