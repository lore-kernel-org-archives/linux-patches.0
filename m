Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A038B397E9A;
	Tue, 21 Jul 2026 17:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653952; cv=none; b=d/s374iDhu/UuaHUf4KyXTE28eABugoB0e6PPdRMn+oSK/TRCJ/NtxYO8kF8ZmlrUAt11gVXhxnbF7nD04uCqti6jR969PtxRV4r/5VQ0AQ8SWJXZPKYdAQUa8ZHCrs5kObvZE5jFCnFecurZCwbtPDYSKavCmKiaELpmJhaGSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653952; c=relaxed/simple;
	bh=tLrwtmltW5HUP8aqFKIkUh7kavY1VEFFo+SpOO3UFrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z4CZQYGQkRJcLENnF6aMt6EZPwhMKe7DyXRTj/pN8b0GRJSR8TLmMreUjmMO/hMm2z5ua+Bx16JYv+oYis8bKy74Bhjh7JQcFcpM4j2chSFkZ6Gf/MTz7B+fmrgOPtyipPVa6qsZVXLEVfqEF5NZPr3yPutSN66x9tRKHL1DKJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WG0mPHfd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WG0mPHfd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10FD31F000E9;
	Tue, 21 Jul 2026 17:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653951;
	bh=zAisxemX5fdN80CbzxgH48BoKknSrV1mlKMzNHs3xJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WG0mPHfdh1AaRLXxXysuxqJpZK26lTONf2DGFruA8IGVOUdGm2di23ljWsvxRwOYa
	 KDyx3Ej8v1JUF+8fuFt9AYO9j0CuuUcpL4jMzWa/QfE4ywL3yZMhY1iiS56bCh+Ke8
	 KLeEsJitD9hz5N0w1GrEwje9lWhdPBSyGQ+B6Q4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Zhen <max.zhen@amd.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1478/2077] accel/amdxdna: Fix potential amdxdna_umap lifetime race
Date: Tue, 21 Jul 2026 17:19:11 +0200
Message-ID: <20260721152627.657628035@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 14f172eff9c19f8043a9858845f33cd034f3a41e ]

amdxdna_umap_release() calls the blocking mmu_interval_notifier_remove()
before removing the object from abo->mem.umap_list. If
aie2_populate_range() runs concurrently, it may obtain a reference to an
amdxdna_umap that is being released, leading to a potential use-after-free.

Use kref_get_unless_zero() in aie2_populate_range() when acquiring a
reference. If the reference count has already dropped to zero, release
is in progress and the entry is skipped.

Fixes: e486147c912f ("accel/amdxdna: Add BO import and export")
Reviewed-by: Max Zhen <max.zhen@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260706221228.434099-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_ctx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/accel/amdxdna/aie2_ctx.c b/drivers/accel/amdxdna/aie2_ctx.c
index 884a64fa3e4fac..a417b7d9ffac30 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -963,7 +963,7 @@ static int aie2_populate_range(struct amdxdna_gem_obj *abo)
 	found = false;
 	down_write(&xdna->notifier_lock);
 	list_for_each_entry(mapp, &abo->mem.umap_list, node) {
-		if (mapp->invalid) {
+		if (mapp->invalid && kref_get_unless_zero(&mapp->refcnt)) {
 			found = true;
 			break;
 		}
@@ -974,7 +974,7 @@ static int aie2_populate_range(struct amdxdna_gem_obj *abo)
 		up_write(&xdna->notifier_lock);
 		return 0;
 	}
-	kref_get(&mapp->refcnt);
+
 	up_write(&xdna->notifier_lock);
 
 	mm = mapp->notifier.mm;
-- 
2.53.0



