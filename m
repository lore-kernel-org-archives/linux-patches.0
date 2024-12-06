Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4954B53A7;
	Fri,  6 Dec 2024 15:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498484; cv=none; b=CDxD/dX0DBWMULRYE8u/gQmkM1uVvubAe3mXfizdqnfvKMsbOeq+XatWW2dMzU3dmVZULvnLF6ap6IEw+n6Gzi8/jl0oTWxlFNxrANJm/dB9TD9bsjMvHC82/XL8okEBNQFIwPAiewDeiZg61+3ZrHj/SrckY+DuX+uvEQ8SgrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498484; c=relaxed/simple;
	bh=+yhRicKnabOtcxNnRU1QSEIvy7u0ux9Y1y4mZBpl5H8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kDSCskD3sPK1uCi8sR6c3FMhg3mRYz5BP/hXgjRHcjwriJoYeSJaktEpXPXMu7ZKu6OQRdPq0fo21a/dsALPPFH/9eHjOteGbtvNY/Bf3w/rrhOn1QKwPACpGaBZuW6N7p8DRO5npFQt4r9VS/UhAG8O3AecAXJXv6UkrgGsPeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1evgVnpi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1evgVnpi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C5CC4CED1;
	Fri,  6 Dec 2024 15:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498484;
	bh=+yhRicKnabOtcxNnRU1QSEIvy7u0ux9Y1y4mZBpl5H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1evgVnpiUDB7+Fmq6sYemHehs8TYGMEBRXQkbjZOeMeJ4l5539cXssAQXK1iZbZD0
	 6BPKmXCI7Uc0/cHU6fdIRKxtblejt4HFrLYKvTa8nhtCe1jb15H4yxvMk9Q7z9H7ZF
	 zfEKkiKVnFOWqH3D7Va1AAcx80Rm2iYOSZf7oj6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 599/676] sh: intc: Fix use-after-free bug in register_intc_controller()
Date: Fri,  6 Dec 2024 15:36:58 +0100
Message-ID: <20241206143716.768357179@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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



