Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18AFD53365;
	Thu, 12 Dec 2024 17:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022940; cv=none; b=MEM3n0Tfb5r96jl00ktaWVF3ie0fOBPGKwkCx4rVUzsnU3DKlSvH7tn1SFCB0WyhmTBdIAeAbt6733GBYNURVv6o+mDY3XfAYYrCJTcmgOjATy5NxPa2BeqAigXrOC/QxMVo0IMzG4TtQROovDAV4MX6Gy+yUDUopdSaV+wcfxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022940; c=relaxed/simple;
	bh=kfyhCfGCD/KoQv/Cg+P4mPoCIDOTzVN5Gea6Mqs/XhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GG9PSXLv5FpG6h19Gc6u4m3ypiZjmzhSuusKQf8QrtLjijKaQwKLLlbnYGk3bxbBByyWDosTJfKiW5crjdtJVkngMWVZMvCXEt20toHoQqH57g1HE59caOP3nsCIX7mbNLA3ygcXIA0rquV+1AR+ITGu4ima11viHhkGncQMDSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b3SYQMN0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b3SYQMN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B40DC4CECE;
	Thu, 12 Dec 2024 17:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022940;
	bh=kfyhCfGCD/KoQv/Cg+P4mPoCIDOTzVN5Gea6Mqs/XhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b3SYQMN0fZDskkvTkks+JD+5x8TXEZ3Tvn+cxD2SKo12pXXK8v/SQUI+3p8Z8wuu9
	 UCKlrN5yTYBY6HvSN41c42F6WQRxC9TUabLGwKAVFO0rfnXspgfgceJ7HVLTQFYhnO
	 s+C6OlcMsjcSmDn+GKGEmhv4WkTIlk6vg5YwT3/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 374/565] sh: intc: Fix use-after-free bug in register_intc_controller()
Date: Thu, 12 Dec 2024 15:59:29 +0100
Message-ID: <20241212144326.409063057@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 63e72e551942642c48456a4134975136cdcb9b3c ]

In the error handling for this function, d is freed without ever
removing it from intc_list which would lead to a use after free.
To fix this, let's only add it to the list after everything has
succeeded.

Fixes: 2dcec7a988a1 ("sh: intc: set_irq_wake() support")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/sh/intc/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/sh/intc/core.c b/drivers/sh/intc/core.c
index ca4f4ca413f11..b19388b349be3 100644
--- a/drivers/sh/intc/core.c
+++ b/drivers/sh/intc/core.c
@@ -209,7 +209,6 @@ int __init register_intc_controller(struct intc_desc *desc)
 		goto err0;
 
 	INIT_LIST_HEAD(&d->list);
-	list_add_tail(&d->list, &intc_list);
 
 	raw_spin_lock_init(&d->lock);
 	INIT_RADIX_TREE(&d->tree, GFP_ATOMIC);
@@ -369,6 +368,7 @@ int __init register_intc_controller(struct intc_desc *desc)
 
 	d->skip_suspend = desc->skip_syscore_suspend;
 
+	list_add_tail(&d->list, &intc_list);
 	nr_intc_controllers++;
 
 	return 0;
-- 
2.43.0



