Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1A35187EB;
	Wed, 30 Sep 2026 18:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792929; cv=none; b=uZ22ULrbpMugUjZeJr4gg/0iCPuLlVSRUMMA6Uv8R5uS8lRNylo/O9Ovxt3pKUriaKMdXtiA5s106AT3jOz9L2nhh5xEcjt1rr8+vuL3peuWEx3T2OUvKNxhBnWF8mLCVw4iMgU7MCa52+kCMhcIEYZpzZ/D3z3pYowIlhggBnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792929; c=relaxed/simple;
	bh=+x4Z4fA4qMpCodkirdNKGtGE6ScF4dGfQCCVnbRcdHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpMEmdxx1LI/Ip/w0HKXghZUzVx2p2DbMgpc1MH/9lhAMytWQwYAi8mXFjc8BWcYXLyTNn4tNmOT4+A1TUkdf0HhMgDHhY0dXxT5FxPv6NY7LCdu+4JCocNINP5t8uYr0b5XVhQVqJ+BJ3DVH2x3/ef29KaiSvOTaPa4N8DfLmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MoBN58yj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MoBN58yj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F5F1F000FF;
	Wed, 30 Sep 2026 18:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792928;
	bh=9ngyJP9BzfWR7cR1IWoD9tv7v98iKqMUarGVcFmz46k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MoBN58yjffccpf9pvf4ilUNgdxc51E+8NRw/2CK3Djt2msP7Pdu7d7gfSmLIipHOk
	 MiDE+Q6xj+z9b9I9aG1o2+tmuD9W0ln+8w/Y9Jf+ft1ugqv0gNmyTsysjx8yv8VwkS
	 5oOQ71wJQgk/cPaDLxpmK186HDSFMw2f+xob19Lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Francesco Magazzu <postadelmaga@gmail.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 073/395] drm/nouveau/clk: fix list cursor use after loop in nvkm_clk_ustate_update
Date: Wed, 30 Sep 2026 17:25:35 +0200
Message-ID: <20260930152342.221142354@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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
index 71420f81714b3..8d1874dc3d7f2 100644
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



