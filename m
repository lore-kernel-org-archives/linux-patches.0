Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B3946D2CA;
	Tue, 21 Jul 2026 18:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658038; cv=none; b=MwCrUdngXZYCD7/L5c8AeN2HAIX1ITU4dXJKmrSV0/xnh4BZRsEsIR2bTmcDJJn84nNBetr6FthDX32eN4hBhMSbcGKCKjSLP7nSFml57wBDmLdK1F6HgVLrgG11DCxKl19ZOaI+xo8h4Jhbo2MjcdXhtkAnxHeRqpfU0X0U0Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658038; c=relaxed/simple;
	bh=vkTPY563AToUudkgCGK3sWt02e7/pCNe08qoaeK7DRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+yQuJrC9OEzdfwiZENgyqQrcIlvnBCILvubCQSFNMmMIyFdszm4zoC2I63v9pO5FtzjetSlGwMxGO0kb/p95D+fxD1Mz2toVE8xsAfb8hjjupBbke+B9AyCx1JSEa2eFCX/QzGTYSI+0WbK0RvNxMDDJSzEdbaB4StvbldEULc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=apJRhQDZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="apJRhQDZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5FF1F000E9;
	Tue, 21 Jul 2026 18:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658037;
	bh=qc7iROAOvPOFTkL1ZfyBxR5V5NFGSWFedTBFEzpKGy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=apJRhQDZGL2jituvJFm7uql9T/+cVs4G6gsPqQDsnkEOqNV2I+NKnN1lLZLyvxF2K
	 wrq3c8C1h63kpgpOKSdfu/fSsYggtAlO6jvPSJJuIM8T/Zt5RB+YAuDFbXZS/VN3e7
	 HSIV3cDvgAlNKAYQbz0sLuyY0ldFPtvqF18LU5a4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0975/1611] drm/panthor: Fix potential invalid pointer deref in group_process_tiler_oom()
Date: Tue, 21 Jul 2026 17:18:11 +0200
Message-ID: <20260721152537.322775811@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit b39436d0ba1571dbcda69d20ec567344b3eecfc7 ]

If heaps is an ERR_PTR(), panthor_heap_pool_put() will deref an invalid
pointer. Make sure we set it to NULL in that case.

Fixes: de8548813824 ("drm/panthor: Add the scheduler logical block")
Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260625-panthor-signal-from-irq-v5-0-8836a74e0ef9@collabora.com?part=2
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20260625-panthor-misc-fixes-v1-4-b67ed973fea6@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_sched.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/panthor/panthor_sched.c
index 6930053009d5ce..749fe34b06db28 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -1488,7 +1488,10 @@ static int group_process_tiler_oom(struct panthor_group *group, u32 cs_id)
 	if (unlikely(csg_id < 0))
 		return 0;
 
-	if (IS_ERR(heaps) || frag_end > vt_end || vt_end >= vt_start) {
+	if (IS_ERR(heaps)) {
+		ret = -EINVAL;
+		heaps = NULL;
+	} else if (frag_end > vt_end || vt_end >= vt_start) {
 		ret = -EINVAL;
 	} else {
 		/* We do the allocation without holding the scheduler lock to avoid
-- 
2.53.0



