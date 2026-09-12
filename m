Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4FD2F617C;
	Sat, 12 Sep 2026 07:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199274; cv=none; b=OgY2ZEiLPtLKJp5kEo7RP3qPuIiw0s5063RqFNe6L7/MYtzHvF3PwRL04oNumz/qgho17kVVwS8lMrJ9If+2E4Iu16ZCjrjHy1qBJTyucfhg796/jxyXGnY5WSPsVK0B+bL/1AIv/sFKW2dBb+OTQKNsgRS4MlW0ocRMcRM9BI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199274; c=relaxed/simple;
	bh=gtO/RPjiPCkhHEzYj4N3Ps2CEHsMBWCRY4xMsWBtBSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qTHyIaEFMtmGPzbt82Zrssus27PAQ+6bEWtTzt3afJNBocByZBzUDaN2x+wjaQMHUX/RWSJCFa7q+/XUbzpQeXFdgTFO38xkKqrW6TjcJLVbARBndYWZ02F27p13sclDxuDIiZAYAM4Q7NEAHEAmWXZ27Is18Dgg2inlhbd8g58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IQL0Iape; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IQL0Iape"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D4A91F000FF;
	Sat, 12 Sep 2026 07:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199273;
	bh=rreX8Nt6ha11J87MyEcS06pMXuXq8n2Q0DxpKlIc9NA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IQL0IapeIlxxnWWbnZdR9QLyZ/c7VKJgkDrqfFFGM9BACOlMr7HyrJ6svuRofRn/r
	 buEQ99c6+4jcIeSTrQuIuprRDecyWicZtzshzx5DUd/Nq4MKGRBveHEN31Fs2j1SQB
	 iA5yQ4SdOpfKjSxih+qcYlO9ON5WXOncPbA+gOWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Raag Jadav <raag.jadav@intel.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0509/1815] mtd: intel-dg: Fix runtime PM error path in probe
Date: Sat, 12 Sep 2026 08:37:39 +0200
Message-ID: <20260912065700.839181575@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit df6f582df3377af316a60ca8ee0d590b2d03924d ]

intel_dg_mtd_probe() allocates region names before enabling runtime PM
and before calling pm_runtime_resume_and_get().

If kasprintf() fails while building a region name, the error path jumps
to err, which calls pm_runtime_put(). At that point there has not been a
successful pm_runtime_resume_and_get() call to balance, so the runtime PM
usage count can underflow.

Jump to err_norpm from the kasprintf() failure path, as the runtime PM
reference has not been acquired yet.

Fixes: 779c59274d03 ("mtd: intel-dg: Fix accessing regions before setting nregions")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Raag Jadav <raag.jadav@intel.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/devices/mtd_intel_dg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/devices/mtd_intel_dg.c b/drivers/mtd/devices/mtd_intel_dg.c
index f2fa8f68d1905..a566e86eb5e3a 100644
--- a/drivers/mtd/devices/mtd_intel_dg.c
+++ b/drivers/mtd/devices/mtd_intel_dg.c
@@ -780,7 +780,7 @@ static int intel_dg_mtd_probe(struct auxiliary_device *aux_dev,
 				       dev_name(&aux_dev->dev), invm->regions[i].name);
 		if (!name) {
 			ret = -ENOMEM;
-			goto err;
+			goto err_norpm;
 		}
 
 		nvm->regions[n].name = name;
-- 
2.53.0



