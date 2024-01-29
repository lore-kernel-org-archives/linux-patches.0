Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEFBF15AABF;
	Mon, 29 Jan 2024 17:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548168; cv=none; b=A6fUCBKfPfXb0g9AhSJs+29YkMThBcZgpQ7ePhnsiO0Q1wJR8fh2q2YwfAa9Q69r6fuMeuif4MUN3be8V6b3vA8bQoRlCOT90yEpLnUmVztkdi/ZYMxFm3vVB1lBwRnkcZoIpNctQHGoR6HR3JIL7KdXTbgU5GJ9qYexGNT4wTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548168; c=relaxed/simple;
	bh=4lGc4eff8RcJ/udBmK2LGPHNHDmKWAb+uSRtn2EPIXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dPgddfkgcNKc/drhBkerdBgaPqg/i4e3EVB+4Ko+kPlQW/ZIUr1a90Ftpbc3uVIjdqcQN93oJPnnOqGPQfZnQcgKZoxx4XrBSzkHLaQQLW9cGvslTJe4srqKsb4ZAHMLAGI4JbKQ2eARfncPakf2WcwpZLztu06MVcfNXBz+hP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CFCtURAZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CFCtURAZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87409C433F1;
	Mon, 29 Jan 2024 17:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548168;
	bh=4lGc4eff8RcJ/udBmK2LGPHNHDmKWAb+uSRtn2EPIXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CFCtURAZw0f1M1+On+sJ9T36iTXKi7YhY9G/TXU6H5pe4muhQC9B3hSVf1VkGU0TJ
	 oxbMWu2o4ep3atcmeyu17w7cIEFFogL+8atve19eBfCKsX/wN2LdHRKhXDIlj7CkWw
	 pIbMFAxmCrJ8HE5jk6bqkrAdErIfsart+q/OA/ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 212/346] intel: xsk: initialize skb_frag_t::bv_offset in ZC drivers
Date: Mon, 29 Jan 2024 09:04:03 -0800
Message-ID: <20240129170022.618945086@linuxfoundation.org>
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

[ Upstream commit 290779905d09d5fdf6caa4f58ddefc3f4db0c0a9 ]

Ice and i40e ZC drivers currently set offset of a frag within
skb_shared_info to 0, which is incorrect. xdp_buffs that come from
xsk_buff_pool always have 256 bytes of a headroom, so they need to be
taken into account to retrieve xdp_buff::data via skb_frag_address().
Otherwise, bpf_xdp_frags_increase_tail() would be starting its job from
xdp_buff::data_hard_start which would result in overwriting existing
payload.

Fixes: 1c9ba9c14658 ("i40e: xsk: add RX multi-buffer support")
Fixes: 1bbc04de607b ("ice: xsk: add RX multi-buffer support")
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://lore.kernel.org/r/20240124191602.566724-8-maciej.fijalkowski@intel.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 3 ++-
 drivers/net/ethernet/intel/ice/ice_xsk.c   | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index fede0bb3e047..65f38a57b3df 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -414,7 +414,8 @@ i40e_add_xsk_frag(struct i40e_ring *rx_ring, struct xdp_buff *first,
 	}
 
 	__skb_fill_page_desc_noacc(sinfo, sinfo->nr_frags++,
-				   virt_to_page(xdp->data_hard_start), 0, size);
+				   virt_to_page(xdp->data_hard_start),
+				   XDP_PACKET_HEADROOM, size);
 	sinfo->xdp_frags_size += size;
 	xsk_buff_add_frag(xdp);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 951f84bfdf2b..f3663b3f6390 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -820,7 +820,8 @@ ice_add_xsk_frag(struct ice_rx_ring *rx_ring, struct xdp_buff *first,
 	}
 
 	__skb_fill_page_desc_noacc(sinfo, sinfo->nr_frags++,
-				   virt_to_page(xdp->data_hard_start), 0, size);
+				   virt_to_page(xdp->data_hard_start),
+				   XDP_PACKET_HEADROOM, size);
 	sinfo->xdp_frags_size += size;
 	xsk_buff_add_frag(xdp);
 
-- 
2.43.0



