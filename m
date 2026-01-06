Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D781C36402B;
	Tue,  6 Jan 2026 17:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721854; cv=none; b=bOi7f/AMK1XOluuKjNYnFfWuLEt9ADT6gyEP0vI6Icnz2NMtu4G9nvN/VT23++tH5HIYX2XQu9EqbcYZLEt0f1ifq1CGV+7/xtKNcXYiZsQByGf6K/DjvSgBlO1OMfOKdwdSxopVfsI1OiqXbInjL9cyXeA2CQSzBJRClCVVtL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721854; c=relaxed/simple;
	bh=Trv2bRl8k75w/wdo95I91PJ4FMqq65qZZSEtbYy1kZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OJ0gjbcLqkvmMGoTPwcOGhdhiat9BB8euaC20ATcb3WfLVk6zDFqaShL6CVpDolps1S7jhN51S+mm8R1FOhu8oKD2QdVjv+sua2Ha+Bth0woQOn60IHJZYd2akqCpR5gCaB65MxGLuG+LMccPXPftPdfUflw1CNamWeGpWOM3Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RoQqF98h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RoQqF98h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6A2C116C6;
	Tue,  6 Jan 2026 17:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721854;
	bh=Trv2bRl8k75w/wdo95I91PJ4FMqq65qZZSEtbYy1kZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RoQqF98h5UDdKx0EHHQCqitKAT7mF2bxu2pZad2B8/lM3V271tVvJuYgW7xoVkO9D
	 LYu9OZ/LyEl4umv4Y0iKBCNpcHKmD0Bm2JSxEjsAdOHZLFQwILCSUWUvgdfZWPpmdq
	 tq8WCHV16w74JaTYKv3Idt46wvTgx7evVPFK3Wx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anshumali Gaur <agaur@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 058/312] octeontx2-pf: fix "UBSAN: shift-out-of-bounds error"
Date: Tue,  6 Jan 2026 18:02:12 +0100
Message-ID: <20260106170549.951284119@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Anshumali Gaur <agaur@marvell.com>

[ Upstream commit 85f4b0c650d9f9db10bda8d3acfa1af83bf78cf7 ]

This patch ensures that the RX ring size (rx_pending) is not
set below the permitted length. This avoids UBSAN
shift-out-of-bounds errors when users passes small or zero
ring sizes via ethtool -G.

Fixes: d45d8979840d ("octeontx2-pf: Add basic ethtool support")
Signed-off-by: Anshumali Gaur <agaur@marvell.com>
Link: https://patch.msgid.link/20251219062226.524844-1-agaur@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index b90e23dc49de..b6449f0a9e7d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -418,6 +418,14 @@ static int otx2_set_ringparam(struct net_device *netdev,
 	 */
 	if (rx_count < pfvf->hw.rq_skid)
 		rx_count =  pfvf->hw.rq_skid;
+
+	if (ring->rx_pending < 16) {
+		netdev_err(netdev,
+			   "rx ring size %u invalid, min is 16\n",
+			   ring->rx_pending);
+		return -EINVAL;
+	}
+
 	rx_count = Q_COUNT(Q_SIZE(rx_count, 3));
 
 	/* Due pipelining impact minimum 2000 unused SQ CQE's
-- 
2.51.0



