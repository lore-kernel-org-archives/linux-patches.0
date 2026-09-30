Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A66A51CF5E;
	Wed, 30 Sep 2026 17:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789222; cv=none; b=jFeETU3bSZW/mSRObKuMfaXhejd35VRoFMsrIrhLuiRBe/3appFFTD2rOWlI5wr43FFYt/Q8tm/w37Pii4o7kieIAkeyiKXik9q4iAqOgz4ZKGdTSTupSnoL/it+qEOLV6frqWZ1k3fcxul0wDfkwFZXDqdsAb5IRA3wgyJGyuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789222; c=relaxed/simple;
	bh=OaBCtu4cSel43+3Jv5WREeyhtfp5gjixYTxe2E3I110=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AmY/lsqQTvwSEd6MJpVoA/MJbiyuacrcqGWFQkAbHIUQV/UonoYOezSyaACqPsTWfk7LaEbK+JHq2155uzkjh2GrELJwSPHxKPDI2XD9NW/pOIb/2Pq4NCISKKHMpULTUSL0TXxyl3vZQ+RsL7XLBGH2ZSnaNuTilTPLDTlkShs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GULFTBuy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GULFTBuy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C47EE1F00898;
	Wed, 30 Sep 2026 17:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789221;
	bh=zD0TtnsG9YPL6eLmcbdf+1/vqeH50kI3mIKDwZ7qqFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GULFTBuy8umpz6y4984e/KEXBIhOd71jFa/xDWKQajHjPBazYUDPXq6TVez0zilEY
	 1v0Ip+F6Mou5T9FEP/OADLQ4kdCqDIN6zMFG4dzlvoIYEMl/KIODM3WS5gJEgg1RjE
	 TaHwUXq55V+Mna20kR0wUcsmWR+lYvet9OI6ZHog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Francesco Magazzu <postadelmaga@gmail.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 355/877] drm/nouveau/clk: fix list cursor use after loop in nvkm_clk_ustate_update
Date: Wed, 30 Sep 2026 17:21:06 +0200
Message-ID: <20260930152422.332104477@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
index 178dc56909c27..5f4cd122415fa 100644
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



