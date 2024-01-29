Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DAA15AABD;
	Mon, 29 Jan 2024 17:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548171; cv=none; b=giT2QiWaPo8QsH2BBKl4uy68tuUQIBSuKwcFpnu8FbxmUO1yyurQNzVghS6cufSff/mGwZhUqKNY9XnIOUa2CwkqZzhnvCzb1Llfut8SZcUdvz41DYRJV/NtJ38YvWWFbOjO3iHzpr+DHVTEyW82plCuw9Do/q1pGspraYa4htM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548171; c=relaxed/simple;
	bh=LibS7/XAMj7RxhP6DOMEvfMHpAdRBX2Zg8+SHMY3Ukw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4mNsucPf4rJG4tNsAljkcHN0yVUmE2nK/dsaolNYxdgabi0WqWo9aguTo4FzqT+8/6AnBNEFG+MTJtlksoms71S2omjvJNDTGV8fer9oxwCemVwF1QO9fkIvzW1iiX8zu0LROieWCb9tVkdu+fxfMDlMUy0S/XmcmOPWrL7j50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HzqBXaPq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HzqBXaPq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783E9C433F1;
	Mon, 29 Jan 2024 17:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548171;
	bh=LibS7/XAMj7RxhP6DOMEvfMHpAdRBX2Zg8+SHMY3Ukw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HzqBXaPqNZOuz9njFSrKNDNf6GFol91bLU47+/wZ7wKgwUCN75Whwaz8vPv7CXKpv
	 vONKdqPvlSCLrCzjbl1oY/Z5jVK1/HlCa14RmtvRLOFtDB1QO48McNJIdxXaBxgjA/
	 FfA4dOTGtqIYUx3l9hBvxfM7/aHjPxipVp3+dcFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 216/346] i40e: update xdp_rxq_info::frag_size for ZC enabled Rx queue
Date: Mon, 29 Jan 2024 09:04:07 -0800
Message-ID: <20240129170022.737221829@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index f97a63812141..2bd7b29fb251 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -3611,7 +3611,14 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 
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



