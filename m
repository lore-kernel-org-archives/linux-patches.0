Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D82221545;
	Mon, 23 Jun 2025 21:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713742; cv=none; b=U4AqdpE2bKqAlb1W4Rh/L0w+ZiNsMFNGvFCT5DpAaqCucXv8gmLQ71H0aadmPrbrKNsjq3sX6lZ4/7P6UFgjKU8cQsDLsUqyF5Mn0PveqDXbqyI5uB4s8G4F8cpHiJWqtepNjV7GzBipd4ddzlOUV4Ng1Nspppo4edLOssbx0sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713742; c=relaxed/simple;
	bh=IZFlmXPMmhjdm0H0sQF1Np0BpXYwMlMiAjxXmXDAQ+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d1NFV2+tcwdpPsttGxr6b4Se/p/iKvffkpf9uBJROLf/Po/zqb39VvwyIzh2TVsOuydssEN7jIggXHKjBCRhdNnfZe+fUV2amH6C0TyEBLcHzTcm7ZEsrMcK5OaqdwxtjsyhpfdMSFziMfswhpIH+1boU849PuzpL8DSVY0HcUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WkNH48Ok; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WkNH48Ok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B0B4C4CEEA;
	Mon, 23 Jun 2025 21:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713741;
	bh=IZFlmXPMmhjdm0H0sQF1Np0BpXYwMlMiAjxXmXDAQ+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WkNH48OkJ2ZAApt5Lzwi2RzszmKrZTQ5RWe4zZr4lqjmwpYhmXV1ZB5eigzYqmmRx
	 jfCmAxly8U/rtTxNsa3NDSgjZ3qwOdjW6l4Vq1IV8YhoeysLvQ2vjE1AL/37tc/mU9
	 vMQesvxFhB1RbgQ9ULjqDyflir2dNFswVWWKe358=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 120/508] bus: fsl-mc: fix double-free on mc_dev
Date: Mon, 23 Jun 2025 15:02:45 +0200
Message-ID: <20250623130648.248747533@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6143dbf31f311..6e4556530df58 100644
--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -910,8 +910,10 @@ int fsl_mc_device_add(struct fsl_mc_obj_desc *obj_desc,
 
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



