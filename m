Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E1430E84D;
	Mon, 23 Jun 2025 13:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684924; cv=none; b=HmtSWXKhWr3ER31pZf+fSu88wkiAYoLoFhN21fHwU3NpsICx2FImajBfLuBF/cZMxz4lE4BYR0+YLNHlia8uBJ4KxwRbNWEKM717G7dLncS+42c/65Ve4SRs0bCc0ikR9O2UiQp5HiPYCXg8MpseD1CEn1tqmWdIaOfummN4rEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684924; c=relaxed/simple;
	bh=Z41g77yUFbcgHtzjHrv6p8kHyWm3B4W+MeLgvTTyua8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PCAHiDsicJDernK+mIr2ZOubTV7J6gB8PTnkufu4zhUPKmt98FnqdSdMA37vbvx0XvCenY4LLP2OI/TilJRyZc187xfwZRfBdesHwL+rTZyeI7lCuxsq8HjQ9CUc4wPEqljK7bVzzaP4gcljEns7/A2tmRgDh73o0XWhyO+SYnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LV3sL2TX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LV3sL2TX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E70C4CEEA;
	Mon, 23 Jun 2025 13:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684924;
	bh=Z41g77yUFbcgHtzjHrv6p8kHyWm3B4W+MeLgvTTyua8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LV3sL2TXTFmV+fqT06wMOB/cKBlK9HHuq3T3F7lT8DwuedUNbUtRyTHTv+UfFBxk9
	 W1eF4DJFQKeOXC7Ln2y2mdD1AFTKmkti/BkhnVCrqaaKXqJXAh/2ZgpGI8GwWIDYwI
	 pUndxMR0CM2uvdOwb9RP0U3f2ASA5Vn6MyLjdPZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 047/222] bus: fsl-mc: fix double-free on mc_dev
Date: Mon, 23 Jun 2025 15:06:22 +0200
Message-ID: <20250623130613.391026979@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit d694bf8a9acdbd061596f3e7549bc8cb70750a60 ]

The blamed commit tried to simplify how the deallocations are done but,
in the process, introduced a double-free on the mc_dev variable.

In case the MC device is a DPRC, a new mc_bus is allocated and the
mc_dev variable is just a reference to one of its fields. In this
circumstance, on the error path only the mc_bus should be freed.

This commit introduces back the following checkpatch warning which is a
false-positive.

WARNING: kfree(NULL) is safe and this check is probably not required
+       if (mc_bus)
+               kfree(mc_bus);

Fixes: a042fbed0290 ("staging: fsl-mc: simplify couple of deallocations")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://lore.kernel.org/r/20250408105814.2837951-2-ioana.ciornei@nxp.com
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/fsl-mc/fsl-mc-bus.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/bus/fsl-mc/fsl-mc-bus.c b/drivers/bus/fsl-mc/fsl-mc-bus.c
index 5c9bf2e065520..3a2107d1c5394 100644
--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -679,8 +679,10 @@ int fsl_mc_device_add(struct fsl_mc_obj_desc *obj_desc,
 
 error_cleanup_dev:
 	kfree(mc_dev->regions);
-	kfree(mc_bus);
-	kfree(mc_dev);
+	if (mc_bus)
+		kfree(mc_bus);
+	else
+		kfree(mc_dev);
 
 	return error;
 }
-- 
2.39.5



