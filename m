Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094AB1C7B69;
	Wed, 20 Nov 2024 13:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107609; cv=none; b=taqYrzQ50IWaR7fmpeZz2NPaBVI6IX78Rsc5bQilbAmcRcm+As3J8WpefcVhL8E8ATU10rD5CYwwumGEKc4+Ai7JM28mCd3P/e/ybYWpeYe+/Dm5SgPR/IW4LzMfsHZd/dh7Q6fMmQkQ59NRLAWxbhnnIXP/pBPk6Rd+43ANIE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107609; c=relaxed/simple;
	bh=OfDqWWqIQY4MydF5uhiLSK76wcvnle6E6a1+j2jG1ME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eZKrH3pyPZHd9H2is7yOFZxZWbt66xxZmjBgHuzQkW69gF/G1mhkCuxs5kKjtuQG6FKJ4ZWNkf7VczuefOTewJ+HLERMAu3Q6TJ/hyKXb4tYpJliwIHL/WWWhxejCEvq5FoHNRq0zW05wP5MQfyWiEg43tqrOIgenLtsrOp7fks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uRfbrKs/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uRfbrKs/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E030DC4CED1;
	Wed, 20 Nov 2024 13:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107608;
	bh=OfDqWWqIQY4MydF5uhiLSK76wcvnle6E6a1+j2jG1ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uRfbrKs/zYpuxWDSPj7agRMNGRIHZKpZ35NQoIfLWuTxLzVS8H6kDu/mXoSenq7Kj
	 xvooVcKhEBwDctyV/v+tdCYKv4Re6ll0IeyPHAjmrvCdVOUqWRXzGVn2oBrhVDb6Ej
	 DABYjhQmpXbLdP6aS7Z8ru45vEab5VLQUKss/gUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umang Jain <umang.jain@ideasonboard.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 58/82] staging: vchiq_arm: Use devm_kzalloc() for vchiq_arm_state allocation
Date: Wed, 20 Nov 2024 13:57:08 +0100
Message-ID: <20241120125630.916750050@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Umang Jain <umang.jain@ideasonboard.com>

[ Upstream commit 404b739e895522838f1abdc340c554654d671dde ]

The struct vchiq_arm_state 'platform_state' is currently allocated
dynamically using kzalloc(). Unfortunately, it is never freed and is
subjected to memory leaks in the error handling paths of the probe()
function.

To address the issue, use device resource management helper
devm_kzalloc(), to ensure cleanup after its allocation.

Fixes: 71bad7f08641 ("staging: add bcm2708 vchiq driver")
Cc: stable@vger.kernel.org
Signed-off-by: Umang Jain <umang.jain@ideasonboard.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/20241016130225.61024-2-umang.jain@ideasonboard.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
index 0a97fb237f5e7..92aa98bbdc662 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
@@ -577,7 +577,7 @@ vchiq_platform_init_state(struct vchiq_state *state)
 {
 	struct vchiq_arm_state *platform_state;
 
-	platform_state = kzalloc(sizeof(*platform_state), GFP_KERNEL);
+	platform_state = devm_kzalloc(state->dev, sizeof(*platform_state), GFP_KERNEL);
 	if (!platform_state)
 		return -ENOMEM;
 
-- 
2.43.0



