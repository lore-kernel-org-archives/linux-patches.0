Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A66A33D6FC;
	Mon, 20 Apr 2026 15:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700086; cv=none; b=O0Fz713/nXDsAPQj29n9u7tXHqv+iCS05xhjEvEp2Fd13WYjDoo8naWhQTtlEOudrs6UXe5y5+MjZkl8ZqWAopzGmlk17Bm98nMQeEiEoI2OA8IvctKrnjIGRasY2jyC4jUOTp3CxQTH5KLbnHKo8QUV38rAtjSWSDZwtBayjoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700086; c=relaxed/simple;
	bh=fLgIk35Rhi1vK8yn+OeNa5eFUsa8jAXqnpaoSAsWiPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pacpIa1wWLPVXfrCqj5SBd3igPNXAhgj3bdgD2c9zeQfjH7LdDHILqdVua/vVr1zYvg8bclVKdciKtJBm9+JJ08UHgiSbKe7Qxn4bkndRILBLRgrefS+epOuTTqEG6hgJe9L/fZAJdrlcBmGXIO+fQjfzB3rn2jRsfqG4k3ieBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DtBls5Dg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DtBls5Dg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7FCC19425;
	Mon, 20 Apr 2026 15:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700086;
	bh=fLgIk35Rhi1vK8yn+OeNa5eFUsa8jAXqnpaoSAsWiPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DtBls5DgDSALULolKKUNoAbLN+ui2n0BqjrhpkyAGSrsIH7vvAe1V+Y07ZCSVkuSQ
	 r7/9xX22Us7XXDN4ZTyYHzy7DGbrOgewTH1s+1KEyANq44KoaQF+YQtBnjcGOTZK+y
	 wD+YL3Yx5KGn0TKliZq64q142Rvu9q0hpgKS5zs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 007/220] media: rkvdec: reduce stack usage in rkvdec_init_v4l2_vp9_count_tbl()
Date: Mon, 20 Apr 2026 17:39:08 +0200
Message-ID: <20260420153934.286152074@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit c03b7dec3c4ddc97872fa12bfca75bae9cb46510 ]

The deeply nested loop in rkvdec_init_v4l2_vp9_count_tbl() needs a lot
of registers, so when the clang register allocator runs out, it ends up
spilling countless temporaries to the stack:

drivers/media/platform/rockchip/rkvdec/rkvdec-vp9.c:966:12: error: stack frame size (1472) exceeds limit (1280) in 'rkvdec_vp9_start' [-Werror,-Wframe-larger-than]

Marking this function as noinline_for_stack keeps it out of
rkvdec_vp9_start(), giving the compiler more room for optimization.

The resulting code is good enough that both the total stack usage
and the loop get enough better to stay under the warning limit,
though it's still slow, and would need a larger rework if this
function ends up being called in a fast path.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rockchip/rkvdec/rkvdec-vp9.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/rockchip/rkvdec/rkvdec-vp9.c b/drivers/media/platform/rockchip/rkvdec/rkvdec-vp9.c
index b4bf01e839eff..8fb6a1624a14f 100644
--- a/drivers/media/platform/rockchip/rkvdec/rkvdec-vp9.c
+++ b/drivers/media/platform/rockchip/rkvdec/rkvdec-vp9.c
@@ -927,7 +927,8 @@ static void rkvdec_vp9_done(struct rkvdec_ctx *ctx,
 	update_ctx_last_info(vp9_ctx);
 }
 
-static void rkvdec_init_v4l2_vp9_count_tbl(struct rkvdec_ctx *ctx)
+static noinline_for_stack void
+rkvdec_init_v4l2_vp9_count_tbl(struct rkvdec_ctx *ctx)
 {
 	struct rkvdec_vp9_ctx *vp9_ctx = ctx->priv;
 	struct rkvdec_vp9_intra_frame_symbol_counts *intra_cnts = vp9_ctx->count_tbl.cpu;
-- 
2.53.0



