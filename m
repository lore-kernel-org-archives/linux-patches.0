Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C2C13CA81;
	Thu, 12 Dec 2024 17:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024484; cv=none; b=jyguBSO20hcwnN/Y5zrBtw1ygkwapNaiRbIflPP+BRHhsCw1/jsk4AEKBpGL79WI6YAycpnzfDgsSapzRLXa2+Cf45T/Wl5pAxfwnJRqPTAPVVQN5UxYa/Y7ZtgB43d5BwkWipcFo5egJ3pbTIYsh6pCFxdvjjaMV6+bXUH9xZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024484; c=relaxed/simple;
	bh=AsezJIzwEhWY2yT6/tkq+fMNRwaKW6XCg3pLkMmmmvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O9TwEH5kG8JHYIC1gVzWgUeLpOYttGipUN2BOqJN3znfmKHQoFLmtkF2VIFR+Gy/yyqI51hlCFC2IbIH2iSHQBXKQAXMMuyXls7JVR7t7Hm4Q2bqys9OU810De8y3iIF5xm9cA1wT3k4g2CO7iEoj5CV9suTiMC5l3WW3LlN780=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H6KLUv5o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H6KLUv5o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED526C4CECE;
	Thu, 12 Dec 2024 17:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024484;
	bh=AsezJIzwEhWY2yT6/tkq+fMNRwaKW6XCg3pLkMmmmvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H6KLUv5oGLn4C+X7HuN8u1qCKotZogEs+zIphddY2H6Rx87QgiK4gCSE8co+cIq8B
	 8XHVEVBPnKB9SmrOGwd6ciHIGmi06fw35YnGdghCgLm+9VJ/4o+iukNjO6VZ9l8EPZ
	 aaVTLZUUGjl8YSrlL3XEsxKTjNnn/4AscBNoZHh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 310/459] sh: intc: Fix use-after-free bug in register_intc_controller()
Date: Thu, 12 Dec 2024 16:00:48 +0100
Message-ID: <20241212144305.891737130@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f8e070d67fa32..51586c5e993bb 100644
--- a/drivers/sh/intc/core.c
+++ b/drivers/sh/intc/core.c
@@ -194,7 +194,6 @@ int __init register_intc_controller(struct intc_desc *desc)
 		goto err0;
 
 	INIT_LIST_HEAD(&d->list);
-	list_add_tail(&d->list, &intc_list);
 
 	raw_spin_lock_init(&d->lock);
 	INIT_RADIX_TREE(&d->tree, GFP_ATOMIC);
@@ -380,6 +379,7 @@ int __init register_intc_controller(struct intc_desc *desc)
 
 	d->skip_suspend = desc->skip_syscore_suspend;
 
+	list_add_tail(&d->list, &intc_list);
 	nr_intc_controllers++;
 
 	return 0;
-- 
2.43.0



