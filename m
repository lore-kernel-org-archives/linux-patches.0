Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37F82F7AA1;
	Wed, 28 Jan 2026 15:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614894; cv=none; b=V4RGiaVjdsURYLT28Gsy6WC5neIYBonu550uIlOSeJJdcka+TX1ZD02b+MD6vfELc0yrRrU6rp8rR5C5GkTd7Dm1hC6lxbNSHIjZXEqeya7D56Vw1YiDk3dMvzl7sLG9m4ZV9oKZM1WNhSTaUNcOtxKjMTBvXTvjDMA25CESZaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614894; c=relaxed/simple;
	bh=wkltYFV6hQMXe/ZpwlmGxufIxe6hQKWs5dVf6uDO1Og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZVSaizBeqtZNTOhSqqy0LJjNky94avZdiXZqiTDlCp60NkX8ICOkyheLydxrbZHuVO1J8csRTxKNZ7iXR828OhiZnBRpU5FOAv4S976vDec4TXM/4dUI6HApnGP517326rxaqWOYsMF+uqglKfUdZt2rDIbRJgyquYsyQ9JfJjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cdzYIfK6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cdzYIfK6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1557CC4CEF7;
	Wed, 28 Jan 2026 15:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614894;
	bh=wkltYFV6hQMXe/ZpwlmGxufIxe6hQKWs5dVf6uDO1Og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cdzYIfK6DDp932FFo7chl+VU5YrK50dqCNKwR0jHjIQBFCMUYBYi3FKCnM4t3BEsC
	 FaIm072AzNkzBnuuomBtPZM6lxLVqnuQ8N/o4hvHXgKp5uZBLUfKWpt/b0HJiv/691
	 w0ATYZBUuuA9g1Y5GOhjCKtkgF27R26HMm10HcZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.12 019/169] ice: initialize ring_stats->syncp
Date: Wed, 28 Jan 2026 16:21:42 +0100
Message-ID: <20260128145334.709458395@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 8439016c3b8b5ab687c2420317b1691585106611 ]

The u64_stats_sync structure is empty on 64-bit systems. However, on 32-bit
systems it contains a seqcount_t which needs to be initialized. While the
memory is zero-initialized, a lack of u64_stats_init means that lockdep
won't get initialized properly. Fix this by adding u64_stats_init() calls
to the rings just after allocation.

Fixes: 2b245cb29421 ("ice: Implement transmit and NAPI support")
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 8961eebe67aa2..8f8bdc3072ccc 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -394,6 +394,8 @@ static int ice_vsi_alloc_ring_stats(struct ice_vsi *vsi)
 			if (!ring_stats)
 				goto err_out;
 
+			u64_stats_init(&ring_stats->syncp);
+
 			WRITE_ONCE(tx_ring_stats[i], ring_stats);
 		}
 
@@ -413,6 +415,8 @@ static int ice_vsi_alloc_ring_stats(struct ice_vsi *vsi)
 			if (!ring_stats)
 				goto err_out;
 
+			u64_stats_init(&ring_stats->syncp);
+
 			WRITE_ONCE(rx_ring_stats[i], ring_stats);
 		}
 
-- 
2.51.0



