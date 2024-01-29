Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A01015B30A;
	Mon, 29 Jan 2024 17:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548575; cv=none; b=JU7z5dT/b0/VnsdFHoaOP7fiDMTCnuph+KxB4npqcFLkRRLUNUbrLkjb5PDqwgQKQvlyrzNJeOr3We1bifPhoK0xuiXCDe2YlBr4rfG42OEMleJcN8G0zwKLYhnGPl1A46LSRPALa3IG+O5vK9d6wpwMb2wVjTdFH9jPHsnBXKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548575; c=relaxed/simple;
	bh=hUtBs7sjFJglnoeeFETQv+68oGT+GBmeqj/S9dEKpdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZdQvxLYuoXPbl3fNMomTg3w/VBK70PiafaZ2aPVSMF9eFDtUd5Dx2zJIcOAZXnAQNRb9cJQimXQMvXhtGpYnjdjL3F0LriuXlP+9SU9wcS2AkhUgIBQ9+peS9KUxJfEJ4ZnCAZ6V8qRJoYmj0qn238EpZoXNStCVie+Yr4zgnAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tO3EpJKQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tO3EpJKQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBD2C43394;
	Mon, 29 Jan 2024 17:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548575;
	bh=hUtBs7sjFJglnoeeFETQv+68oGT+GBmeqj/S9dEKpdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tO3EpJKQ+Yl6VFRqX5e0TImPs+WrhfI2VuEEnmJ1O7TE9+4uD8HsPb5GTO1lgaNtq
	 k2ojY34s3zHVQeigxE5f7kJ/B+Tdz6iTnqsjtdfprt2JVxAbHHDZ+QJ+l9Hp5cCzVe
	 cAiKZQFoTssp8VLVkHkSPTvdnaRrJxuZatZUQHg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 220/331] intel: xsk: initialize skb_frag_t::bv_offset in ZC drivers
Date: Mon, 29 Jan 2024 09:04:44 -0800
Message-ID: <20240129170021.316215550@linuxfoundation.org>
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
index b75e6b6d317c..1f8ae6f5d980 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -418,7 +418,8 @@ i40e_add_xsk_frag(struct i40e_ring *rx_ring, struct xdp_buff *first,
 	}
 
 	__skb_fill_page_desc_noacc(sinfo, sinfo->nr_frags++,
-				   virt_to_page(xdp->data_hard_start), 0, size);
+				   virt_to_page(xdp->data_hard_start),
+				   XDP_PACKET_HEADROOM, size);
 	sinfo->xdp_frags_size += size;
 	xsk_buff_add_frag(xdp);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 33f194c870bb..307c609137bd 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -826,7 +826,8 @@ ice_add_xsk_frag(struct ice_rx_ring *rx_ring, struct xdp_buff *first,
 	}
 
 	__skb_fill_page_desc_noacc(sinfo, sinfo->nr_frags++,
-				   virt_to_page(xdp->data_hard_start), 0, size);
+				   virt_to_page(xdp->data_hard_start),
+				   XDP_PACKET_HEADROOM, size);
 	sinfo->xdp_frags_size += size;
 	xsk_buff_add_frag(xdp);
 
-- 
2.43.0



