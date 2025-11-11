Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7953B4204E;
	Tue, 11 Nov 2025 01:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822977; cv=none; b=m3cSUx4BScj4dw4SaDCoIsJ7IKUBdKN74Q+QSF1XJMVHLu+z/yFVF59Q3OMyHHKSLGVJB1nZBzYZZKubxemuRStVABrK6EKO/SY4e/331qT0jVRdivWMCZ9932Y6O4tb+1pmmTzGW03sHvLC+dqAEvqcNJ1aRKANBEcRFWb/yhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822977; c=relaxed/simple;
	bh=Bt58H6p/AsknRIH7Misv9BtHy/mvdhQoQUeBDo38+PE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DO+MoGwB3PXt9aox5Huwayn5MMepebvO/ZD8BNyP7FJOmJvJP/CJ6S8T3hbiJdNpw5taC1neupDu9dxK3C20Hor8ECYpaJeNcAXp3xSOf1Rji4oHYkcleghU3PEM9hCV5LHzNB/QXi0ANRJEinRBLknoo4AbEsO6J3QZuiiLvb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gbH38FFn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gbH38FFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D04C116B1;
	Tue, 11 Nov 2025 01:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822977;
	bh=Bt58H6p/AsknRIH7Misv9BtHy/mvdhQoQUeBDo38+PE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gbH38FFnWiqlNYAvBAjknRrDyW3LYjPhQdyFl/uVKE12nsdA+duTvszawn6mCD73f
	 tsKr6uyMtuyGgvoqOhWwC+DCdVV6QLa+6y+nX9t3PMDai4COaVv5j7Qmc8Spzsf3P0
	 QMnlUMlklkRyVFwhTw7N3yU7usE40ywSCH0NObgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amery Hung <ameryhung@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 205/849] bpf: Clear pfmemalloc flag when freeing all fragments
Date: Tue, 11 Nov 2025 09:36:15 +0900
Message-ID: <20251111004541.396906988@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index b40f1f96cb117..f288c348a6c13 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -115,6 +115,11 @@ static __always_inline void xdp_buff_set_frag_pfmemalloc(struct xdp_buff *xdp)
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
index c5cdf3b08341a..b20d5fecdbc95 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4212,6 +4212,7 @@ static int bpf_xdp_frags_shrink_tail(struct xdp_buff *xdp, int offset)
 
 	if (unlikely(!sinfo->nr_frags)) {
 		xdp_buff_clear_frags_flag(xdp);
+		xdp_buff_clear_frag_pfmemalloc(xdp);
 		xdp->data_end -= offset;
 	}
 
-- 
2.51.0



