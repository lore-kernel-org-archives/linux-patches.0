Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379D4331A78;
	Mon, 20 Apr 2026 15:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700662; cv=none; b=r1IJ/VGFzMC9XbEfsHbSmwXvum4B46OLQ45dnO6NflqyfIdfCPWWlRMQ44X75RnDRlOG/ZYH1MbCfushOnZnIasbEz37N/d1fn8GIKnooRtxnOI/1FovxWqad2MY29/6/8Gg3A80PH+AszO2z1V46cinruCh7jZfNq4yfwWklQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700662; c=relaxed/simple;
	bh=AyVUf8naOfk2+7xWFmJNcB5wKhtAhffAdCYLyK6f9gM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIAl2GLddOTq2cROtDIFrV9r1UeF+F1o/EIp6FddZ7nScH26tuojMRUnFg2vm8oKdrZMuCfgoRpzAvVq86kHtRcPRmUNAHPHlD9fSf+9RdJlmkKxnDlXLQ0xl97g6JKFjw7mGUFYW4Ub+iFOyDqJlxezESq7PaGEjzLmdTATudQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D/0gcifq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D/0gcifq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C28EDC19425;
	Mon, 20 Apr 2026 15:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700662;
	bh=AyVUf8naOfk2+7xWFmJNcB5wKhtAhffAdCYLyK6f9gM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D/0gcifqCdanUdp0Z+l5ID1wsGWlX5Es2FXfkn34jemcMY2zU/MKKC5tmnx311HE6
	 IDnt6ewkaeT1FIVoc3z7stBfIDylXm6qH+T9noVPhLExJBgLFlXwOC70Nw57lBnqM2
	 CRkjUgu1RI0DL4C+FvGLUu5jqBOeGPEAxR2ZcjLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 007/198] media: rkvdec: reduce stack usage in rkvdec_init_v4l2_vp9_count_tbl()
Date: Mon, 20 Apr 2026 17:39:46 +0200
Message-ID: <20260420153935.878273725@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0e7e16f20eeb0..bc74d2d824ef2 100644
--- a/drivers/media/platform/rockchip/rkvdec/rkvdec-vp9.c
+++ b/drivers/media/platform/rockchip/rkvdec/rkvdec-vp9.c
@@ -923,7 +923,8 @@ static void rkvdec_vp9_done(struct rkvdec_ctx *ctx,
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



