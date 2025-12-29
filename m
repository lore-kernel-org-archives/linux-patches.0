Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6640833121F;
	Mon, 29 Dec 2025 16:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025208; cv=none; b=IMPEAJBUCiKf8PdPilGIX1wQfz7n2lss7CSveT5oXBBGY9x8DL3xtO9+sEaiePbIzcV6CcUjSdR9rJAm7+G59Bszngospq8rdkk1doC49SL5kbdOzbc6y5JwyDUD3UAz0q64gwe9VHtfL0Um5VAdNjwSsxJaTl84BSs8oZPnZw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025208; c=relaxed/simple;
	bh=2ofTeb1HgeYlC2cWHzLyFLLyuEqGzTz/TxN5jg/ryw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BK9Zx+I1y8q88iGw7930mqrT5uuRCJqZ+lwi1ovqdRzuoDUC7nOCgkb3uWYiwGhrPcpecEFfxPk8Et85OLz4+a0Un/LAC5nCuY4EcNsLesKke9UJ1BqwFK1EBlPMInQmhbI+pnCSHIOC+d2gu7XYcqGjdXV5vhC4sThn8Oof6No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0bKHuK90; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0bKHuK90"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97A8C4CEF7;
	Mon, 29 Dec 2025 16:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025208;
	bh=2ofTeb1HgeYlC2cWHzLyFLLyuEqGzTz/TxN5jg/ryw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0bKHuK90Bn1XQk//Pzv0maFsOiF+BmZK64e5EB1NBpTVfK23L3yGj6J095Ni1op/K
	 umKB5iqCK49PMvMuN6k7C6+NAsC4M5d8/g+cvHrGFTQaff/8+IuAmVfrC0rP7LTMn4
	 N0s+Uaj1tPwVTQNis1gsnWNjsjIFZHeN8YyibkRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Shahar Shitrit <shshitrit@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 099/430] net/mlx5e: Dont include PSP in the hard MTU calculations
Date: Mon, 29 Dec 2025 17:08:21 +0100
Message-ID: <20251229160728.010059152@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Cosmin Ratiu <cratiu@nvidia.com>

[ Upstream commit 4198a14c8c6252fd1191afaa742dd515dcaf3487 ]

Commit [1] added the 40 bytes required by the PSP header+trailer and the
UDP header to MLX5E_ETH_HARD_MTU, which limits the device-wide max
software MTU that could be set. This is not okay, because most packets
are not PSP packets and it doesn't make sense to always reserve space
for headers which won't get added in most cases.

As it turns out, for TCP connections, PSP overhead is already taken into
account in the TCP MSS calculations via inet_csk(sk)->icsk_ext_hdr_len.
This was added in commit [2]. This means that the extra space reserved
in the hard MTU for mlx5 ends up unused and wasted.

Remove the unnecessary 40 byte reservation from hard MTU.

[1] commit e5a1861a298e ("net/mlx5e: Implement PSP Tx data path")
[2] commit e97269257fe4 ("net: psp: update the TCP MSS to reflect PSP
packet overhead")

Fixes: e5a1861a298e ("net/mlx5e: Implement PSP Tx data path")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Shahar Shitrit <shshitrit@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1765284977-1363052-10-git-send-email-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index a163f81f07c13..a6479e4d8d8c6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -69,7 +69,7 @@ struct page_pool;
 #define MLX5E_METADATA_ETHER_TYPE (0x8CE4)
 #define MLX5E_METADATA_ETHER_LEN 8
 
-#define MLX5E_ETH_HARD_MTU (ETH_HLEN + PSP_ENCAP_HLEN + PSP_TRL_SIZE + VLAN_HLEN + ETH_FCS_LEN)
+#define MLX5E_ETH_HARD_MTU (ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN)
 
 #define MLX5E_HW2SW_MTU(params, hwmtu) ((hwmtu) - ((params)->hard_mtu))
 #define MLX5E_SW2HW_MTU(params, swmtu) ((swmtu) + ((params)->hard_mtu))
-- 
2.51.0



