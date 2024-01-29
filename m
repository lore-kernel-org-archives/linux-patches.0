Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96BE755E3;
	Mon, 29 Jan 2024 17:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548591; cv=none; b=if9ueo68Bh8Kgt/yYmHMVyyi/Gb1EGSHMUdn/dPAAZ+X2sJuZeJWOw0XlaEzbUU2d/oULkjwH1c7pdW+MAp7Gx4CTQdgxThlQbFVAqtIbqny4RaXMVWTEc3c6dQNIyijuQUUEb7wlLRCSxI+VjrK27XzA/mADMYSJPA891wX3A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548591; c=relaxed/simple;
	bh=CJgNPEAX1+NOcvuGLMZv1saz72Wrt4JkEumEv+Fcyeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ltsUiPkieZmVO0/rNwmKqr0NOo+Z53hYob89H/KzSsBl/CU273OtWd4msXCimpVeAtMBstSU7hrifZyuKw0YpXNJiORw4ydC2WNwQMEYekJuIah4xfK+BBk5C2dEiTaIACjBdlRa4eRtd5mHh4OIOYf55PRYgQEguVbis8XZqnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JJD0i1wZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JJD0i1wZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8F1C433F1;
	Mon, 29 Jan 2024 17:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548590;
	bh=CJgNPEAX1+NOcvuGLMZv1saz72Wrt4JkEumEv+Fcyeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JJD0i1wZwWAg9GOa31JV+pI6pWtl6QNfVm2LZ0v3LXXlAzYSOlUkLOhTJlL+w/73m
	 T5daxTbhXCdBNEJotcvQQacE+ExuOXFan0R/FvDnb/bh51c/xM1LL9mTkKhPsyd/KW
	 AydUe0oQ2UfqWs+f8JXOG/nJByp+1m8u4W7aZukg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 224/331] i40e: update xdp_rxq_info::frag_size for ZC enabled Rx queue
Date: Mon, 29 Jan 2024 09:04:48 -0800
Message-ID: <20240129170021.426036863@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit 0cbb08707c932b3f004bc1a8ec6200ef572c1f5f ]

Now that i40e driver correctly sets up frag_size in xdp_rxq_info, let us
make it work for ZC multi-buffer as well. i40e_ring::rx_buf_len for ZC
is being set via xsk_pool_get_rx_frame_size() and this needs to be
propagated up to xdp_rxq_info.

Fixes: 1c9ba9c14658 ("i40e: xsk: add RX multi-buffer support")
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://lore.kernel.org/r/20240124191602.566724-12-maciej.fijalkowski@intel.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index aadca7b3443c..aad39ebff4ab 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -3601,7 +3601,14 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 
 	ring->xsk_pool = i40e_xsk_pool(ring);
 	if (ring->xsk_pool) {
+		xdp_rxq_info_unreg(&ring->xdp_rxq);
 		ring->rx_buf_len = xsk_pool_get_rx_frame_size(ring->xsk_pool);
+		err = __xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
+					 ring->queue_index,
+					 ring->q_vector->napi.napi_id,
+					 ring->rx_buf_len);
+		if (err)
+			return err;
 		err = xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
 						 MEM_TYPE_XSK_BUFF_POOL,
 						 NULL);
-- 
2.43.0



