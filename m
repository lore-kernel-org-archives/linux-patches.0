Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7854DDB32;
	Tue, 13 Oct 2026 12:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894940; cv=none; b=ne2yJM7eZcBzWCsbUQZofQVujDL0tH/6po/GpwcqXaI0GvXdNIARNpByH75lEfs7M2s/H0XbqrRP/+AfBzM4q+OS1E8/TiseSZ2ah30i528lkJ+2CTh3PDTEXlvm9Tw6eF127PQxLLlEG+ebo0+10ShM81sLLKzmxv4ccdqdZvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894940; c=relaxed/simple;
	bh=g4rIvW6i4JBQe0mXupo0oJezUR0pDX9Hzk9sXx04wnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EuYIaXsvufJfKwqA5nNWgFR3oTQEWba5ah4NVrzcyINLSWpax/91bFSRPWy0Gtc+J647aOcDjMLjR2Zu/epJRwrGlcWKnG0p21o/Q4Z7frg3ACbwIfck5fMDglltrmOWOwWgSs67OtDu0DVmpA8N0ZY7c0RuxQoba7S9d5kWW6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VGdugluG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VGdugluG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759C91F000FF;
	Tue, 13 Oct 2026 12:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894938;
	bh=rgCIw0vz1wlfYZ7HXTyvQOWotrOL3uHltp74ArxVEi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VGdugluGNUzCSBF8NKhILwl4+rKxFyC7oC+37dfRaZKmmdP0MjX26wcImHA4aa4Yj
	 kwl41OGgZ6tpjTBwE3rRrT4N9sjzxtkPqoMhfXTnhOuBKFYgiokIdZ9dLrKb1xS3eX
	 bSph7OvtP9trUqI3D256h/6Tq/Ezt5QmStgjhTlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 107/497] net: mvneta: clear XDP pfmemalloc flag between frames
Date: Tue, 13 Oct 2026 13:34:34 +0200
Message-ID: <20261013112910.431220146@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a20a02b7926b8..48a0286b4012f 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2340,7 +2340,7 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 
 	/* Prefetch header */
 	prefetch(data);
-	xdp_buff_clear_frags_flag(xdp);
+	xdp_reinit_buff(xdp);
 	xdp_prepare_buff(xdp, data, pp->rx_offset_correction + MVNETA_MH_SIZE,
 			 data_len, false);
 }
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 73599857f0847..9427c796ac79d 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -88,6 +88,11 @@ struct xdp_buff {
 	u32 flags; /* supported values defined in xdp_buff_flags */
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



