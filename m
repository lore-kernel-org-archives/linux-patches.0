Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C0D34FF78;
	Sat, 12 Sep 2026 09:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205613; cv=none; b=g8IRIb65X056jHl1Q4qLLBwebG1IrpHHchj82SJy80wRF3DzZBuobUhCUSgIVVC0CrgOXZ8iuK6jpmi2oxGZCK6fUiQcsCmPC6fORntYK+6VpX5Hg3+eU7M++qDSR1HaG1gvEQ9txv9zET6d76nlepgc663528l9e1a56n67D98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205613; c=relaxed/simple;
	bh=mZQwzjMsdYjlRtE/bI81N5xUXQw7BptKSNZ5jQDzqrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mmxxGNtTtZ0IkJiQN35Za1HjaLFoM1BU64Ro5Lz14Xg+2uU3biMpioiH+aNTuT/cz44jcPcK/t3QufLDFnX118mDeVcEwrPcUYtp7OmD1Eg5jQMEKZkwuVqMLQZnleOOb5kXaaXm8mc5Ywzz1VqfBa9oC5RnLad8zzUfnofrTtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CSbCPb8q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CSbCPb8q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDEC21F00893;
	Sat, 12 Sep 2026 09:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205609;
	bh=SonWjyfqpcmmfi+ZxehyMaZlu0cBjAXVE8miu1bAOq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CSbCPb8qn3DSjbvM5luh9TGxyC5uaixjnFnKY2O4RliGWDtZ1pKxYxK5WI20ot3Zr
	 BodlMRC40ueswdY3S1UOiuNdSwWYpCDpyqr2zKHr21RgGmzF3GSY82cyUXiIDYVNGv
	 wUKL26WOuVT0Q1BVh6IBwCu+PE1RGgmHa8F2j21E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Glenn Judd <gmj@meta.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0036/1518] net/mlx5e: do not HW-GRO coalesce small frames
Date: Sat, 12 Sep 2026 08:36:45 +0200
Message-ID: <20260912065624.247979511@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Glenn Judd <gmj@meta.com>

[ Upstream commit e2466392a0b8496000e12181cb1ee1535eb0da25 ]

When hardware GRO (SHAMPO) coalesces a small IPv4/TCP segment that was
padded up to the 60-byte minimum Ethernet frame, the trailing padding is
folded into the merged payload causing padding to be delivered
to the user as payload.

Detecting and reproducing the issue: the selftest
tools/testing/selftests/drivers/net/gro.py subtest
hw_ipv4_data_lrg_1byte sends {100, 1} expecting to receive {101}.
In current code, it receives {106} (100 + 1 payload + 5 pad) instead.

This patch avoids giving the user padding as payload by simply not
coalescing small packets (which fails the subtest; the same approach
and behavior as sw gro). This gains code simplicity at the cost of
more computation (passing an extra skb up the stack) for small packets
that could be coalesced.

The threshold is chosen as ETH_ZLEN + 2 * VLAN_HLEN. This is the largest
frame that may still contain minimum-frame padding (+ 2 VLAN tags), so
anything larger is safe to consider for coalesce. (We do not include
ETH_FCS_LEN in that threshold computation as netdev_fix_features()
drops NETIF_F_GRO_HW whenever NETIF_F_RXFCS is set, so retained FCS
can't reach this path.)

Fixes: 92552d3abd32 ("net/mlx5e: HW_GRO cqe handler implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Glenn Judd <gmj@meta.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260816064259.3279548-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -2401,6 +2401,11 @@ static void mlx5e_handle_rx_cqe_mpwrq_sh
 
 	data_offset = wqe_offset & (page_size - 1);
 	page_idx = wqe_offset >> rq->mpwqe.page_shift;
+	if (unlikely(cqe_bcnt <= ETH_ZLEN + 2 * VLAN_HLEN)) {
+		match = false;
+		flush = true;
+	}
+
 	if (*skb &&
 	    !(match && mlx5e_hw_gro_skb_has_enough_space(*skb, data_bcnt,
 							 page_size))) {


