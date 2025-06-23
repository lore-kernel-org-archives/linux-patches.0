Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8EF257424;
	Mon, 23 Jun 2025 13:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685782; cv=none; b=DlpdNep86ChFtSrDDKbzIAFXY6MAnwG00WksnyA48K8UGxsz1GT2+vhscXIAiqazeWGhiQvc7wLlqnwRWEK2qInsO27v7S8QSvBa+Mk0xl3NRjfUbZN3J9eQmcxb+0m8BIhHO/yA/pRxhBJplsas1VLegityE6VNxMNfx60oqrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685782; c=relaxed/simple;
	bh=pLjdsJu9cJiM50TbQtoZeTlwuqDehFZ64meCkZ2isqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dnY9zNHk+t2Cvb1qEb7dk+pUczHuhxorKnGpmSXm1XEKzwlN+xnvfYWOoAOKIYFFXncSgbajz+I4B9Z+TRaL0UmcZr0aouGRU/wnC3DU7fsKrK9+gwyUJuHnckXb1ssHac5+0KfQJCwijxWGCrNtA33kBxA3+kcNS27XyanZsV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M8Scne53; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M8Scne53"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92424C4CEF0;
	Mon, 23 Jun 2025 13:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685781;
	bh=pLjdsJu9cJiM50TbQtoZeTlwuqDehFZ64meCkZ2isqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M8Scne536/e5O/RLRvqcjrOd9DaDQscBgXoLUzsT6T0VJZ1ILl7km6jijwljux7iy
	 m1fvff81a5rvLEyRSmtW4nrcZkAZ/aHmB4ctvyJJHftQ7v92dYu0jSv+KGTsZo//dy
	 4wNhYo01kPVieIiWwTl3M/6MO0iCZje0fHf7kRFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 083/411] bus: fsl-mc: fix double-free on mc_dev
Date: Mon, 23 Jun 2025 15:03:47 +0200
Message-ID: <20250623130635.494826777@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 74593a1722fe0..108ff5658e26c 100644
--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -907,8 +907,10 @@ int fsl_mc_device_add(struct fsl_mc_obj_desc *obj_desc,
 
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



