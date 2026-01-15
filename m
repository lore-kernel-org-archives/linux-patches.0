Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60643BF2F0;
	Thu, 15 Jan 2026 17:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499611; cv=none; b=uamrvvN5tAunDHDAY+ivirvCA9OgFU6Gq3wclVV9NEexo6EGaCRqXs0nixQSfiwxoIwozrdaHy28FtrlOuTXUDAzM3RhVNhcWO/3UgmwCArH0W0ci/AKXXbsYBvcCgybPjFIcAW/kedHDzeupkUmsj2idujLZe8/CNGsEfO4LUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499611; c=relaxed/simple;
	bh=gB0USa7f6MEtE5eA6cyvH+pulpcoP1Clf1hfaYFpUhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FvnsKVpEHsZVWJJx59uAv/Y509AuRRuOTpmsVN8HeXq9sYADmPOH3sFzL5zBEqgU2AkKtVTSZU9PCI0mSTluufeyEE6MQ+T5gEFycrIFv7HeRslgrjFCe4EI+A9LiLEBrMvUykxrf5gOleVHkuptw5r6Jmyc3G4C6XIr2g28qK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WpWLjTjS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WpWLjTjS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67DB0C116D0;
	Thu, 15 Jan 2026 17:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499610;
	bh=gB0USa7f6MEtE5eA6cyvH+pulpcoP1Clf1hfaYFpUhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WpWLjTjSxUEu81HsZMcsmevik7Oob7bGE9YkmDfU+ulQeEqrVpQFCLQkydB30myUf
	 ZCXBSY7NtckXsgmBZIhqOiILhF8eoQ9Xe9sLj/RNZF0lf8YiuQ2VndVWVQjzTLd9wb
	 UpOMC1F6Wksb+ZqSbaup8bofeQuLsYiFgUwfmTaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anshumali Gaur <agaur@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 287/451] octeontx2-pf: fix "UBSAN: shift-out-of-bounds error"
Date: Thu, 15 Jan 2026 17:48:08 +0100
Message-ID: <20260115164241.265187399@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9b6938dde267..6e547e177511 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -382,6 +382,14 @@ static int otx2_set_ringparam(struct net_device *netdev,
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



