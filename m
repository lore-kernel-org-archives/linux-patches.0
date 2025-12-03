Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD5523B60A;
	Wed,  3 Dec 2025 16:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778982; cv=none; b=WkjLV8JsTjIItlkMv62I7vsVws1Pw54sp7GXSGz997lqwEv1aTlf7qyT5VRBc/rSz5/YmwicJRDPZisBd48/d19QnKRtu+m5AnX4HD6OofLrzaKTdAxqL+OsDyrlB7Knw/7qTMxbtcq974McBoPYteQmiL7ZNfvwt8DyhsTiaxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778982; c=relaxed/simple;
	bh=s+IGvbUf21K3SmxTFWccRof3Zyn2HOTbdl8EVtflyk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+CcMJt7Cp1s1f/wyu6An6oYh/yGaq5Wb8WuVuMGY4TpV4HiYhUJdtX3AYvr+Bjcqz/JCVMsQLW9P/CE7d3MYUQHaVO4wkjBA/8o3d6FiDO+gQmDfEdTr5cRXB9yYotledWIVL+zb3CO0wCoEXnHVe/rOsGaWPP1yRInd0F36tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rvgO9+xD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rvgO9+xD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84814C4CEF5;
	Wed,  3 Dec 2025 16:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778982;
	bh=s+IGvbUf21K3SmxTFWccRof3Zyn2HOTbdl8EVtflyk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rvgO9+xD9hyNRtfTSHwTXwQ87s5wONj2O9wqnBGPYAbVymLopk6D/V1mBqaHdolON
	 gOeplWBULVYdbYY54sNrseanBm1NRVwaEEDGYDJXD+wjScHHdtzRdzat/0n7Tg50sC
	 WR4qPlQ/miA4NOMUkAksHbTvhFlM8LOnOo9oo/NU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amery Hung <ameryhung@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 120/568] bpf: Clear pfmemalloc flag when freeing all fragments
Date: Wed,  3 Dec 2025 16:22:02 +0100
Message-ID: <20251203152445.128402615@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amery Hung <ameryhung@gmail.com>

[ Upstream commit 8f12d1137c2382c80aada8e05d7cc650cd4e403c ]

It is possible for bpf_xdp_adjust_tail() to free all fragments. The
kfunc currently clears the XDP_FLAGS_HAS_FRAGS bit, but not
XDP_FLAGS_FRAGS_PF_MEMALLOC. So far, this has not caused a issue when
building sk_buff from xdp_buff since all readers of xdp_buff->flags
use the flag only when there are fragments. Clear the
XDP_FLAGS_FRAGS_PF_MEMALLOC bit as well to make the flags correct.

Signed-off-by: Amery Hung <ameryhung@gmail.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://patch.msgid.link/20250922233356.3356453-2-ameryhung@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xdp.h | 5 +++++
 net/core/filter.c | 1 +
 2 files changed, 6 insertions(+)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 55dbc68bfffce..8a0a69f691595 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -110,6 +110,11 @@ static __always_inline void xdp_buff_set_frag_pfmemalloc(struct xdp_buff *xdp)
 	xdp->flags |= XDP_FLAGS_FRAGS_PF_MEMALLOC;
 }
 
+static __always_inline void xdp_buff_clear_frag_pfmemalloc(struct xdp_buff *xdp)
+{
+	xdp->flags &= ~XDP_FLAGS_FRAGS_PF_MEMALLOC;
+}
+
 static __always_inline void
 xdp_init_buff(struct xdp_buff *xdp, u32 frame_sz, struct xdp_rxq_info *rxq)
 {
diff --git a/net/core/filter.c b/net/core/filter.c
index 9b4254feefccd..786064ac889a1 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4118,6 +4118,7 @@ static int bpf_xdp_frags_shrink_tail(struct xdp_buff *xdp, int offset)
 
 	if (unlikely(!sinfo->nr_frags)) {
 		xdp_buff_clear_frags_flag(xdp);
+		xdp_buff_clear_frag_pfmemalloc(xdp);
 		xdp->data_end -= offset;
 	}
 
-- 
2.51.0



