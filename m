Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EEBA2EF2A6;
	Tue, 17 Jun 2025 16:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178013; cv=none; b=ep6hGrAtenAqEaO9tCOaHFZjNwEnKDP9YkaJA2Q45j/3D7TqXKCgHhS/5zbK9Evbp3BuslbwYoJxoc02yUT5YlbknvurJ47epcT9zM3w3RD1fjN4/sipUKDJ1aO2fPDRwGuy3/Yup+edfufcIu7aL7mrHF8TbyYnQDihjnZGK4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178013; c=relaxed/simple;
	bh=kMZrI2rrYOqig9Wr9WnaAd1II4GcVx0LZuqJH5FzwGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BaOoLT2NpsmxNxGDkaPolufo2mQx5HJHWSIQ9GuNvizmcqOQAr3KgI9NFJZgt+Tbi8MGzMoHLOJJ+ure7IVtMGhFUBOwg6YeinTZXlU4eephcAE2PA/4nmXnXmLDp6THvSs/jhajD8DHb7atpk1ePMMXwk+H2PmasUNTOpQxLcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cQ0BcqvP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cQ0BcqvP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 118C3C4CEE7;
	Tue, 17 Jun 2025 16:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178013;
	bh=kMZrI2rrYOqig9Wr9WnaAd1II4GcVx0LZuqJH5FzwGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cQ0BcqvPIjz7SlSpWiea7k0KpJ4ujP1+HtvZ+dw85HJZMWjU9lX+MMFDaw3ah8i8h
	 +YuSaAkOQ02lEXuV8twXtwry3ELkQ7PIRLBbjtMveiNJLmv4PqzIbNFWsIFdRnLPJn
	 HMeWflT1kpWCBMpRs9/XUho2OcZU/iE7r9I+rr/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 396/780] bus: fsl-mc: fix double-free on mc_dev
Date: Tue, 17 Jun 2025 17:21:44 +0200
Message-ID: <20250617152507.580471711@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index a8be8cf246fb6..0c3a38d7f3358 100644
--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -906,8 +906,10 @@ int fsl_mc_device_add(struct fsl_mc_obj_desc *obj_desc,
 
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



