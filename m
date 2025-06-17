Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2825A2EA155;
	Tue, 17 Jun 2025 16:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176711; cv=none; b=Vium3tKwvgpCJmwPVWLf4kflDDiu2O/w3GBRwZrR3n26Zvm0Y/uVaGcEEUPGQlC78IUZMbyfZ1Qad3VDow+IO7237o0BiulwJ3RDe4sUVYvbFF+J6bh1u1DQav6JFzczgTUWh4mdJkakWjxI4WnboNO/UNox+jjlql6SThbFLFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176711; c=relaxed/simple;
	bh=IVkL0W8Z2Yc7EktNA2c9VG2+te18MPTNphAOSijfjZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JyoKAzy7U6uODOjPdn5vQC2TX6d/mNjdMJUu9lber90D06i1BKLV1XZl5xREsG8mUAAbrGWN6rnCBza41Q4qiaTgMR2C7dMyOElFcSWYb6SfGaaDh7Dzg0Dyi28T2tT4hlr80TX65tqYIULRbRyiwrn5aDCuE1VA3QK54v740CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XDc2fQG4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XDc2fQG4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DB1C4CEE3;
	Tue, 17 Jun 2025 16:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176711;
	bh=IVkL0W8Z2Yc7EktNA2c9VG2+te18MPTNphAOSijfjZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XDc2fQG4C2ToxbdLQFMirkiYahMggAv8KiKdy5nC3321YF05TVcBh/MdC06m5KYJD
	 jzBgtCsanPXjVpcd4UsSH6fMqNyP1AjiryKgEsIqmo8Iy73C/yHUORwWICloy8xwLB
	 K9PxAAJdWVqybXXE3x4K2YVQfVVEPuXNoiKo/Aj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 255/512] bus: fsl-mc: fix double-free on mc_dev
Date: Tue, 17 Jun 2025 17:23:41 +0200
Message-ID: <20250617152429.929568557@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 930d8a3ba722b..58d16ff166c2d 100644
--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -905,8 +905,10 @@ int fsl_mc_device_add(struct fsl_mc_obj_desc *obj_desc,
 
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



