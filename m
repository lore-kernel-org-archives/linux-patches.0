Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCE73F54BD;
	Fri,  9 Oct 2026 14:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556315; cv=none; b=paweEWcGpRLx5ACwrgHVuLw9FQNvu0K19U6z14pN/+NyDC8r7gV+hDrlFMCG9/KiU13O/vkzOwrjezD+0Lhf2ktePqb7IDLyIAK7/8PLD8Yon8eE/kg2HhgGCcSOfBRG9SLrj7VM7y3hTPfUbv71k/y+LvhRG/p8q98X75r3zng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556315; c=relaxed/simple;
	bh=KVNqv7dcVNtfCUE03uOOplmiXDi1mQ0kWtbDiqRr9nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cAKx7ODFKlUldQOdR0C0SbWeQXqcEyV4JzNprmLgb5dc6R8mh4IKVgxAEEvqcfh8MDQCSijZ2Bt7FiQYlDeyYbakCLYpGvA9PnENng1rXCTsih+mwDXN10ZYU32VLRJPnb5OozFOxVyvyzRxFrpKKQXB/CV+sAiT78y/FovWoP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ISAyNe/s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ISAyNe/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A757B1F00893;
	Fri,  9 Oct 2026 14:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556311;
	bh=m4jAflZOXXAVMxN/Rf8auVi/GIRJyX/AyX5w3iStrmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ISAyNe/sB8mkEtsbHJGqsz1WH3vIMY+y6NfICRv/2g2HRNO9wifVuofZCz8TzMWPl
	 cKDZIhPgj6ppoKgC4Zjzw3noGrt3tquYlRtqaE5OwN+tL1DbiQETd916hzUJKo67ce
	 Vzmpf1EaaRzqOROS8P68tiHswIOpSmpaTPAVErYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 156/428] net: mvneta: clear XDP pfmemalloc flag between frames
Date: Fri,  9 Oct 2026 16:08:13 +0200
Message-ID: <20261009140949.593465932@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

[ Upstream commit 8f1c2a10500a84a621ff13073f96deea0753ed42 ]

mvneta_swbm_add_rx_fragment() sets XDP_FLAGS_FRAGS_PF_MEMALLOC on the
xdp_buff when a fragment page is a pfmemalloc one (page under memory
pressure). The xdp_buff is reused for the next frame, but only the
XDP_FLAGS_HAS_FRAGS bit was cleared at frame start, so the pfmemalloc
bit leaked from one frame into the following ones. mvneta_swbm_build_skb()
propagates the flag to skb->pfmemalloc through xdp_update_skb_frags_info(),
so the skb of a subsequent fragmented frame could be wrongly marked as
pfmemalloc even if none of its pages are under pressure.

Clear all the xdp_buff flags in mvneta_swbm_rx_frame(), which is invoked
for each new frame, instead of just the XDP_FLAGS_HAS_FRAGS bit.

Fixes: ed7a58cb40bd ("net: marvell: rely on xdp_update_skb_shared_info utility routine")
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://patch.msgid.link/20260929-mvneta-xdp-clear-frag-fix-v4-1-1e63b25eeed8@oss.qualcomm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 2 +-
 include/net/xdp.h                     | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 744d6585a949d..ad71b5e39e338 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2340,7 +2340,7 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 
 	/* Prefetch header */
 	prefetch(data);
-	xdp_buff_clear_frags_flag(xdp);
+	xdp_reinit_buff(xdp);
 	xdp_prepare_buff(xdp, data, pp->rx_offset_correction + MVNETA_MH_SIZE,
 			 data_len, true);
 }
diff --git a/include/net/xdp.h b/include/net/xdp.h
index aa742f413c358..07231adfb5f82 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -106,6 +106,11 @@ struct xdp_buff {
 	};
 };
 
+static __always_inline void xdp_reinit_buff(struct xdp_buff *xdp)
+{
+	xdp->flags = 0;
+}
+
 static __always_inline bool xdp_buff_has_frags(const struct xdp_buff *xdp)
 {
 	return !!(xdp->flags & XDP_FLAGS_HAS_FRAGS);
-- 
2.53.0



