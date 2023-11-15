Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF734177E
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sl8sE8Lp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D710C433C9;
	Wed, 15 Nov 2023 19:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076999;
	bh=AtmYpjL8XIuA/v80xdbqZ/SaSq0pBSLK90SiwFDQg+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sl8sE8LpmUmusLTv3CM106xF9chOKvDnuRCn8EJ1wxVlAdBQMBFq+159jMkOYHLhm
	 Cixc+1ObWq/sbiUk3N3ELikcMkVM0Kj2uPCJ+WEZrhFxnRNGxZ287ch2lWSzCzvaX0
	 LSUCVN3DAULzcGdZnqMwQj/zcS5jhkYT+ATEQBzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moudy Ho <moudy.ho@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 488/550] media: platform: mtk-mdp3: fix uninitialized variable in mdp_path_config()
Date: Wed, 15 Nov 2023 14:17:52 -0500
Message-ID: <20231115191634.700937499@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Moudy Ho <moudy.ho@mediatek.com>

[ Upstream commit 2a76e7679b594ea3e1b3b7fb6c3d67158114020d ]

Fix the build warnings that were detected by the linux-media
build scripts tool:

drivers/media/platform/mediatek/mdp3/mtk-mdp3-cmdq.c:
	In function 'mdp_path_config.isra':
drivers/media/platform/mediatek/mdp3/mtk-mdp3-cmdq.c:
	warning: 'ctx' may be used uninitialized [-Wmaybe-uninitialized]
      |                    out = CFG_COMP(MT8195, ctx->param, outputs[0]);
      |                                           ~~~^~~~~~~
drivers/media/platform/mediatek/mdp3/mtk-img-ipi.h: note:
	in definition of macro 'CFG_COMP'
      |         (IS_ERR_OR_NULL(comp) ? 0 : _CFG_COMP(plat, comp, mem))
      |                         ^~~~
drivers/media/platform/mediatek/mdp3/mtk-mdp3-cmdq.c:
	note: 'ctx' was declared here
      |         struct mdp_comp_ctx *ctx;
      |

Fixes: 61890ccaefaf ("media: platform: mtk-mdp3: add MediaTek MDP3 driver")
Signed-off-by: Moudy Ho <moudy.ho@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/mdp3/mtk-mdp3-cmdq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/mediatek/mdp3/mtk-mdp3-cmdq.c b/drivers/media/platform/mediatek/mdp3/mtk-mdp3-cmdq.c
index 3177592490bee..6adac857a4779 100644
--- a/drivers/media/platform/mediatek/mdp3/mtk-mdp3-cmdq.c
+++ b/drivers/media/platform/mediatek/mdp3/mtk-mdp3-cmdq.c
@@ -261,11 +261,11 @@ static int mdp_path_config(struct mdp_dev *mdp, struct mdp_cmdq_cmd *cmd,
 		const struct v4l2_rect *compose;
 		u32 out = 0;
 
+		ctx = &path->comps[index];
 		if (CFG_CHECK(MT8183, p_id))
 			out = CFG_COMP(MT8183, ctx->param, outputs[0]);
 
 		compose = path->composes[out];
-		ctx = &path->comps[index];
 		ret = call_op(ctx, config_frame, cmd, compose);
 		if (ret)
 			return ret;
-- 
2.42.0



