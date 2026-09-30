Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD084C33D1;
	Wed, 30 Sep 2026 16:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786374; cv=none; b=BZEHEHzEMlEOPdC3f4bnuqKeDD6s6jA5hHWBXGcv+xN18Je0hfdG/YERHOiCV1hVEsoMgH/m3/Ucj/TI69ZFmwLw8mWjb2ASg5kMC0SHKTzkSacs/DJfLmjxdY2yaPxVBTIBr09MBsRqgFACUMFaPJXStjE0OZvW+pMd2tPc9VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786374; c=relaxed/simple;
	bh=ngRsMYYoDMVurywZS+1wN+8ZQdoQBdJIeVUQ57LWu7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V/efNimNdsxGtVYrS8etK2fjCxYm4N0/Q+eApWlA1iLMQl+p9UcY0lYwRhYft31sXTNGP1eXfy88TTwRYV7V9nQ8FJ+cGpnx4UXAyqQijSncGpmApeHivbe+TQMkPX1y9R1s1ZSkl7LAsVxAPfZGh7bB+zQxRbdjAWa1LZurjRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NFWkmPPn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NFWkmPPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88EC31F00893;
	Wed, 30 Sep 2026 16:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786373;
	bh=oMwI8x+xF4nW7GfV0FK9l8ngd9LFwClesstlqunsLow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NFWkmPPnuGDkT23KfZUQAjPU7JGXojLBaGWbx+rIxWF7PzyvlhYDyipyVrAW2mxBB
	 fexmfbVUn7oubyPsWnoZjcwS8qEJQF//dpsvCA/4ESc4u//JztI3S+w4x6jEc8u8ZK
	 Srl4R6eNGgOMGT/ir2Uu1AQH8mJqQJd87IShHDd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Francesco Magazzu <postadelmaga@gmail.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 840/982] drm/nouveau/clk: fix list cursor use after loop in nvkm_clk_ustate_update
Date: Wed, 30 Sep 2026 17:26:16 +0200
Message-ID: <20260930152434.794382435@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit aff09d9e37e02dc60bde79035ac15b136d602259 ]

If list_for_each_entry() exits without hitting a break then "pstate" is
not a valid pstate pointer.  Introduce a "found" variable instead.

The check is reachable from userspace: nvkm_clk_ustate_update() takes the
pstate id straight from the 'pstate' debugfs file, so requesting an id
that is not in clk->states - or any id at all when the perf tables are
broken and the list is empty - makes the pstate->pstate != req test
dereference the list head cast to a struct nvkm_pstate, which is an
out-of-bounds read.

Fixes: 7c8565220697 ("drm/nouveau/clk: implement power state and engine clock control in core")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
[Francesco: rebased on drm-misc-next, expanded the commit message]
Signed-off-by: Francesco Magazzu <postadelmaga@gmail.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20260918131620.405133-2-postadelmaga@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c b/drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c
index da07a2fbef062..33f073ab3c49f 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c
@@ -473,6 +473,7 @@ static int
 nvkm_clk_ustate_update(struct nvkm_clk *clk, int req)
 {
 	struct nvkm_pstate *pstate;
+	bool found = false;
 	int i = 0;
 
 	if (!clk->allow_reclock)
@@ -480,12 +481,14 @@ nvkm_clk_ustate_update(struct nvkm_clk *clk, int req)
 
 	if (req != -1 && req != -2) {
 		list_for_each_entry(pstate, &clk->states, head) {
-			if (pstate->pstate == req)
+			if (pstate->pstate == req) {
+				found = true;
 				break;
+			}
 			i++;
 		}
 
-		if (pstate->pstate != req)
+		if (!found)
 			return -EINVAL;
 		req = i;
 	}
-- 
2.53.0



