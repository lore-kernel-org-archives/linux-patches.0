Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01FC91C9EDB;
	Wed, 20 Nov 2024 13:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107678; cv=none; b=NM+N0YRjyMQNsS6laWzaX974+6z8ZXIt1hsRKr3RaR9L2gJ+r8J3Q0eTQE69+b/2SfmsspclBoysKE0/UXw/A25EKml/fBaIj5eAW2vZ52oNd8WnLpAmSyV7b3igC45MjWDC/NcX+DXMpqUSha1mwquTWDoLSuVBW6/dSFO9GEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107678; c=relaxed/simple;
	bh=0UOLAat4n5DLyO+KWKairEA7L70jLQtvrt+LJjB8Eek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jSJ2OdsWPIMUGVNr2GnP/bdiVCjFLHdkRdb7hrOLRzcuxu4ZQaQQfmyqr1njCqcZ79C+kYGaSUkkrepLIBmWV6l7KH5q0mdp8rYhTLX4x4xaKCSqd9h1Np3OEBD3b37KAdeDv3ydMmYOnR/AbFfEPxtP65AEZCwvCEm6kYbMxfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ApuKJ0Sk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ApuKJ0Sk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6749C4CECD;
	Wed, 20 Nov 2024 13:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107677;
	bh=0UOLAat4n5DLyO+KWKairEA7L70jLQtvrt+LJjB8Eek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ApuKJ0SkcBRLUZYVVH9Rwq3NGFEzBo55X2/nUyKMpu6dtiXQaTXMaeMEYfvunl8zJ
	 7oNBHRWlKsBgzp4j9ptQCeX0RnSD+ccYZfO66xGSM7deU0uaoH7cytBdgZHrEyfJo9
	 n83SHg3dVVRFDdZLEaWP9wZ5nTyL/JP2L0MeZ4Y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umang Jain <umang.jain@ideasonboard.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 35/73] staging: vchiq_arm: Use devm_kzalloc() for vchiq_arm_state allocation
Date: Wed, 20 Nov 2024 13:58:21 +0100
Message-ID: <20241120125810.453918434@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bb1342223ad0d..456a9508fb911 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
@@ -571,7 +571,7 @@ vchiq_platform_init_state(struct vchiq_state *state)
 {
 	struct vchiq_arm_state *platform_state;
 
-	platform_state = kzalloc(sizeof(*platform_state), GFP_KERNEL);
+	platform_state = devm_kzalloc(state->dev, sizeof(*platform_state), GFP_KERNEL);
 	if (!platform_state)
 		return -ENOMEM;
 
-- 
2.43.0



