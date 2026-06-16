Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D83744CAE6;
	Tue, 16 Jun 2026 15:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624195; cv=none; b=r+b2F97b+uoKE5MchwHnxS0rwJFM9zZZpwtXUAIaJZU13Zzvk5DRMWq5x3KZbxYRghB+0Lag0b6Qky3giNkdz+4vbQ122UKGUTuF4lophyIAyCZf7dr4fAtIR+NoZAuldsxNbu/9mKLjDJADtwjzB0EMn/PzdD2sXMQi4e8S+io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624195; c=relaxed/simple;
	bh=W9W5wV05l7M7oqCINxXMoTyW4jVKeI5ClHgv6eR6MgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqsLlMk5v9raWu8mpjHwsGl4vnd2WEGFW67SJOtRNaYlau0J0qxDLDn39f+XubdlShg/Rq5+QTQEeOWri+KuIjOS+L5q4RGEt9M5fUrJ0J6rl7rRIsySZvnY6vNUb2yj2nBd2rB0+D/3MfsxTcRQi2LzA07Sn8h8vyZFqfVUw9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qHop+3Ag; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qHop+3Ag"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2141E1F000E9;
	Tue, 16 Jun 2026 15:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624194;
	bh=wrr2Oz/1wKeAOukN6iWF3hRIWW4ilymOMltlbsZmk2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qHop+3AgO16iwJRoWVhA2SvgOiA8g+D7gYCvjfmMS5tq8ogu1of8QqnT85UlwD48B
	 pdVKgZ+b/AkKi0ALcaDJ99X5PuIasC/bmGf3gW6Ap/JARvzhpinLVEKdNwsZZ6FBoh
	 eaQ8YZ9ek6bB+ZxHLLPVTUBkTVqyJLuQX3eewoAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 290/378] net: mv643xx: fix OF node refcount
Date: Tue, 16 Jun 2026 20:28:41 +0530
Message-ID: <20260616145125.339778643@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit 4aacf509e537a711fa71bca9f234e5eb6968850e upstream.

Platform devices created with platform_device_alloc() call
platform_device_release() when the last reference to the device's
kobject is dropped. This function calls of_node_put() unconditionally.
This works fine for devices created with platform_device_register_full()
but users of the split approach (platform_device_alloc() +
platform_device_add()) must bump the reference of the of_node they
assign manually. Add the missing call to of_node_get().

Cc: stable@vger.kernel.org
Fixes: 76723bca2802 ("net: mv643xx_eth: add DT parsing support")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260602073414.22500-1-bartosz.golaszewski@oss.qualcomm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mv643xx_eth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -2780,7 +2780,7 @@ static int mv643xx_eth_shared_of_add_por
 		goto put_err;
 	}
 	ppdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
-	ppdev->dev.of_node = pnp;
+	ppdev->dev.of_node = of_node_get(pnp);
 
 	ret = platform_device_add_resources(ppdev, &res, 1);
 	if (ret)


