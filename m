Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124A8223C55;
	Thu, 12 Dec 2024 17:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025532; cv=none; b=jpjRYtUpWsppZmg88NS2xrycaCNGxnUAsPr9HG2lrgIZp/6iS307wqXbWfVVlSpNdAvW8SODoPNdQ7SYDT77BGh4DN+59xMh+zrtUrJSI2SuN7p3y/QpWVaCOmYKZ9CQ9znUz58HkZxMvu6pDGj9z/VmBVOpePBcB/8z00VX/VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025532; c=relaxed/simple;
	bh=6YRlOlvGumOw7bzrRdRds9qCiX88JGvLIBnp9/cIkvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DgZKLjgzM86HH5/yAqtdrPfhjvCMoJpYyLT5gqj3u5O7x0Ad14PsU30sSR7vmZlfmn2fkT6IhdOaq0gXStIDRums/JEgPea+kizW6uGExp74fU6Rz4/E3ZJOFZHN1kgNi/bvSXZqdI9iwKOC1nqS7Lj6vpt1OImrkEvsP9ixYgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SAWdvK2L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SAWdvK2L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B06C4CECE;
	Thu, 12 Dec 2024 17:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025532;
	bh=6YRlOlvGumOw7bzrRdRds9qCiX88JGvLIBnp9/cIkvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SAWdvK2LKukUczL9WIdaMy03JCaj5QuRtZq6Uxf+t3HkDzljZ/m44jYrqV5jxVyxh
	 Exb7Nc41zgsTXhm7cGAEuaFKuxci0n9fGdI4ezvMiU5va2azKuYoNL6TC6MDLEJXAV
	 oH1UL13aF2/APw/jiKbBMP8aDOopWLk4iHVeCCXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 200/321] sh: intc: Fix use-after-free bug in register_intc_controller()
Date: Thu, 12 Dec 2024 16:01:58 +0100
Message-ID: <20241212144237.880490964@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 46f0f322d4d8f..48fe5fab5693d 100644
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



