Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C355F3B47F9;
	Sat, 17 Oct 2026 16:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255693; cv=none; b=euFCstWkrZggzpWKHolkFM1tOfmD04yuWg+YhaiP3Ac0qZFgxCQ0ti4jRScTSpq/wdOUlfOr6mhvWI8d62PEKYFI9pjreVPXkBin83RJG6L+TCN7h8MFFT+ShAipWDkB82KjIjWM6vKHTcSPbrTIVIYBz40M/P9Rg5FSb/sCA7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255693; c=relaxed/simple;
	bh=vUcdeBsQVXLeURDgW+RB5C+8CTfQ1vb/2nDwQIYAYG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E8M16PNFOEKq+gGT2sDXQ2siPfMGkCfSPFEAJHo5ZSSrD5M6s4IlEvffbsKakI/nbb6g+V0BnRpcdflvS2HCfNxwxpXRlZigHgiVVhLX17gqZBAO4dk/oDYdMcfFIws6ZuB9zIh3dCe/sty8nmejlbQ2q65LIFepEierlxIdrkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=odFep4mu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="odFep4mu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D915C1F000C4;
	Sat, 17 Oct 2026 16:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255692;
	bh=ZbgLsuTY0M2I+Eh/t4+ysyHAAplYz+cZrFPEabD0SRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=odFep4muAEqpOsKFx0ujbd9EFdo7gy4VuVEaCpUnY2txU/jPxLuDqSz7j7No45E+i
	 tF5ZvZ42cMIZ1qswhrdOo8oYv86mDRZiFjYJlDcrjQv3U0NyBRi+uUeXhjisatYyio
	 XSPRHVIuF6VonYU5v/1MuJ7UVh9JUm4MbG6Fl190=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Stanley Chu <yschu@nuvoton.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 860/869] i3c: master: svc: Fix i3c_master_get_free_addr return check
Date: Sat, 17 Oct 2026 18:01:41 +0200
Message-ID: <20261017160058.906792226@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Stanley Chu <yschu@nuvoton.com>

[ Upstream commit d6cb667b8e15bac47f19aec4bd81f3916b2ca9f5 ]

The return value of i3c_master_get_free_addr is assigned to a variable
with wrong type, so it can't be negative. Use a signed integer for the
return value. If the value is negative, break the process and propagate
the error code.

This commit also fixes the uninitialized symbol 'dyn_addr', reported
by Smatch static checker.

Fixes: 4008a74e0f9b ("i3c: master: svc: Fix npcm845 FIFO empty issue")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/029e5ac0-5444-4a8e-bca4-cec55950d2b9@stanley.mountain/
Signed-off-by: Stanley Chu <yschu@nuvoton.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250310023304.2335792-1-yschu@nuvoton.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/svc-i3c-master.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index 26e53717b8292..705e7b9256f0c 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -938,7 +938,7 @@ static int svc_i3c_master_do_daa_locked(struct svc_i3c_master *master,
 					u8 *addrs, unsigned int *count)
 {
 	u64 prov_id[SVC_I3C_MAX_DEVS] = {}, nacking_prov_id = 0;
-	unsigned int dev_nb = 0, last_addr = 0, dyn_addr;
+	unsigned int dev_nb = 0, last_addr = 0, dyn_addr = 0;
 	u32 reg;
 	int ret, i;
 
@@ -993,10 +993,11 @@ static int svc_i3c_master_do_daa_locked(struct svc_i3c_master *master,
 			 * filling within a few hundred nanoseconds, which is significantly
 			 * faster compared to the 64 SCL clock cycles.
 			 */
-			dyn_addr = i3c_master_get_free_addr(&master->base, last_addr + 1);
-			if (dyn_addr < 0)
-				return -ENOSPC;
+			ret = i3c_master_get_free_addr(&master->base, last_addr + 1);
+			if (ret < 0)
+				break;
 
+			dyn_addr = ret;
 			writel(dyn_addr, master->regs + SVC_I3C_MWDATAB);
 
 			/*
-- 
2.53.0



