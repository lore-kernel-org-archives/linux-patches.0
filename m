Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0745D34FF4C;
	Fri, 21 Nov 2025 13:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732479; cv=none; b=ikosMmigqgOUsPjTiPNFm2yUcXQcUKTlvbNlJadt1NPkDe4QcaPUcemRTmO200ig/5romKMGDJSSO63VdKyM3nnMn+5u/vpzwOADvUQe2hB1R4QP4xxpICidK/XJL6q8xYviJ5Y98qD/1mEKEj1gGe5OBQ3+YjzmbSNQ8kItzLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732479; c=relaxed/simple;
	bh=0yXMpWm72jl2Ty6FPTP6gMWkSuutOildIIYW+gPQU7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I7Hcmz7BfY5nfKumrMarVvrXegIkSkz9CX/rYA7GjX4/9Gz2VESkwgaESaY4KwVGOyXZBItu+Jz13hNEKKSusoeWNGrHCBCleupG2bVvua3asa3v7KvfD99rXMfjuFBitzA+nnUQwVbCA6CJhtWSmyODMPcSViVMeyBX+IU/bHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2FkM2swY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2FkM2swY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DEC0C4CEF1;
	Fri, 21 Nov 2025 13:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732478;
	bh=0yXMpWm72jl2Ty6FPTP6gMWkSuutOildIIYW+gPQU7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2FkM2swY1yOF2ih3c8orUg8nd+93JgEPLo7WCeXov+j/2MTCzD7Oc1qVB/V3ysQ/Y
	 NHpEUw7Pqpw2yiOZDd7a4ChB8UmQVjK380XlzCnRX5fBmkCzUa3N1CPJL9PHlb7jjm
	 CZBmWFDqSL+9uBm+HRS8RjXJfnKLxcadsyy046lI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amery Hung <ameryhung@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 102/529] bpf: Clear pfmemalloc flag when freeing all fragments
Date: Fri, 21 Nov 2025 14:06:41 +0100
Message-ID: <20251121130234.654180437@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b39ac83618a55..3d8989096b5d2 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -113,6 +113,11 @@ static __always_inline void xdp_buff_set_frag_pfmemalloc(struct xdp_buff *xdp)
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
index c2e888ea54abb..0564ee6ac8731 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4203,6 +4203,7 @@ static int bpf_xdp_frags_shrink_tail(struct xdp_buff *xdp, int offset)
 
 	if (unlikely(!sinfo->nr_frags)) {
 		xdp_buff_clear_frags_flag(xdp);
+		xdp_buff_clear_frag_pfmemalloc(xdp);
 		xdp->data_end -= offset;
 	}
 
-- 
2.51.0



