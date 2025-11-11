Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C4A4204E;
	Tue, 11 Nov 2025 01:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823021; cv=none; b=iyYLg3Ig7jCaCcE+OGvRePLPEmzZ1PFKQpcpDzTKoGmGlggUWj1SsFjWBAUPryFz/phi9x4weGcp5bT+KuBpSenQ0UVYYQyi2o/f/gpVoQQ3iWGLA8kBkTLgvOkSAchUCQCmATnY3WszAXtEgr0EEsntPA9e47/2UqmGSv8yeV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823021; c=relaxed/simple;
	bh=2eay0a6cb0F4jL2VxFZVsAKXUkzaytpytvpMyWYjwnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqVlndT0D31qemXMBkZrwnNOUubz23v95kUFywonlCKTEvXPhXXw98qeRMhB9NpORf/mCa+6PVP7IbX9ucNkHlbwAVgvOWIretPUEu5dFeU8jMVmwWEowQ2L/9nOHYdl/zn1Yz/3FHMyhfd36KRnsv8Mr0HEK2fnnRRUZbybvic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bi8eToKz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bi8eToKz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8006C113D0;
	Tue, 11 Nov 2025 01:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823021;
	bh=2eay0a6cb0F4jL2VxFZVsAKXUkzaytpytvpMyWYjwnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bi8eToKzgcCkpgPG0HqKuDyK6fu7L2F7fhBzet9sjnVg1lNBEYCgpuYmnmXffLL5A
	 ZvmB0kfew2KFTaTvP76iXPgiRRmb4N0sEf1d1iJKPvbe+tGV2k48oB2VTWTFBa3tXR
	 9NX5WKn1Hw/j2b0AA9t91X/OnMHUqs0DhDDkQEfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amery Hung <ameryhung@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 156/565] bpf: Clear pfmemalloc flag when freeing all fragments
Date: Tue, 11 Nov 2025 09:40:12 +0900
Message-ID: <20251111004530.449252143@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index e6770dd40c917..b80953f0affb0 100644
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
index fef4d85fee008..89ed625e14744 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4223,6 +4223,7 @@ static int bpf_xdp_frags_shrink_tail(struct xdp_buff *xdp, int offset)
 
 	if (unlikely(!sinfo->nr_frags)) {
 		xdp_buff_clear_frags_flag(xdp);
+		xdp_buff_clear_frag_pfmemalloc(xdp);
 		xdp->data_end -= offset;
 	}
 
-- 
2.51.0



