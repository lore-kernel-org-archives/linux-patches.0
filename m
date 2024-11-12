Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B7621C19D;
	Tue, 12 Nov 2024 10:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408520; cv=none; b=BzECF2EqPIyNLTUn0sQ0xg8oNLZJgcjK1DLrFFuBZkzhbrrZAALdX7YIrPBK0/OXZ2bZk83fDH28HVWCA1WiCg0fZ8w99RqME6kmgeQIglfCJ8J2VHGRsm3dN016vA6LNhB9KZzuWwLkF1jT1NBYzJkskhZnunC9qrasuSIAnN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408520; c=relaxed/simple;
	bh=TRTRgecfg+U35DKp46yqEVYJGijpCxtkzAtn6dovJxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jHAXYSUiZje86mIOZFZppSaoteTf9snt0gyBDRKPvTV5Ad93QJk6y6MVENp1ROHzh0gzv94gTN8YKRfAPnQF5Y7Had9cp98tZxl2i9qyGHLX1y6Mo+Kx9zurxcauFcrd4C5wzwht97KRqprSVvCC4GowhHLfXFf+jB+xx21knT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mv8uD3pM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mv8uD3pM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32397C4CECD;
	Tue, 12 Nov 2024 10:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408520;
	bh=TRTRgecfg+U35DKp46yqEVYJGijpCxtkzAtn6dovJxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mv8uD3pMHb/pjPGZmvlrhZ4of07JYCQNA/mtX7dKO2DivgYIpfm53KCGULyMplNYR
	 rQNucJbaOBg5CNz6msHq5k8lux8pq1WurSN0cw9PpwEk0vZSm9pdGRdJ+yGHeK54Mi
	 m+9n8sC9rYNtAW1CHYUn7teUFYri5XNHWpati+/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umang Jain <umang.jain@ideasonboard.com>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH 6.11 167/184] staging: vchiq_arm: Use devm_kzalloc() for drv_mgmt allocation
Date: Tue, 12 Nov 2024 11:22:05 +0100
Message-ID: <20241112101907.277352471@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Umang Jain <umang.jain@ideasonboard.com>

commit 807babf69027b4f1c55e72b06879658e83830880 upstream.

The struct drv_mgmt 'mgmt' is currently allocated dynamically using
kzalloc(). Unfortunately, it is subjected to memory leaks in the error
handling paths of the probe() function.

To address this issue, use device resource management
helper devm_kzalloc(), to ensure cleanup after the allocation.

Cc: stable@vger.kernel.org
Fixes: 1c9e16b73166 ("staging: vc04_services: vchiq_arm: Split driver static and runtime data")
Signed-off-by: Umang Jain <umang.jain@ideasonboard.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/20241016130225.61024-3-umang.jain@ideasonboard.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
index 0d8d5555e8af..6c488b1e2624 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
@@ -1731,7 +1731,7 @@ static int vchiq_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	mgmt = kzalloc(sizeof(*mgmt), GFP_KERNEL);
+	mgmt = devm_kzalloc(&pdev->dev, sizeof(*mgmt), GFP_KERNEL);
 	if (!mgmt)
 		return -ENOMEM;
 
@@ -1789,8 +1789,6 @@ static void vchiq_remove(struct platform_device *pdev)
 
 	arm_state = vchiq_platform_get_arm_state(&mgmt->state);
 	kthread_stop(arm_state->ka_thread);
-
-	kfree(mgmt);
 }
 
 static struct platform_driver vchiq_driver = {
-- 
2.47.0



