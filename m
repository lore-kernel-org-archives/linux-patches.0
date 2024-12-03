Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200AB1EF08A;
	Tue,  3 Dec 2024 14:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236887; cv=none; b=nsq5GdvQv/CLzovODWdUNM3OedTIQTo/CSbmOuhzfujPWRL5RbLC7CALGxsY2NGwnON7FBOnAS6XDDwNRwLBqMpW4yzvGc1m8nzs/w9UR4Vg12dLQDph7Y+IHRszRXNyCIZ9CZTfZuSMg+O5GO8KN3PcPBTDS2arld0QYgmQN1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236887; c=relaxed/simple;
	bh=A63LVcEsSMzy4hlvTXI7TMhsCbx9grBZraODA+1YJlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QI7kyAhZuaCnWUfslz1juUtiM7e1NIezlnajzUokyvJycIifcfdjN2mE1104zJ/X8tF6wl18AAW7BibL6C49/IhciI+d/gBqeXwBFXGStrisOFMxUe+4eBrwvCZsQ4HA0MpdG+LmBHXKhCyMnhkJpZ8OVg+YzFJ6znux1s+CLJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U8hiLYvL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U8hiLYvL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82892C4CECF;
	Tue,  3 Dec 2024 14:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236887;
	bh=A63LVcEsSMzy4hlvTXI7TMhsCbx9grBZraODA+1YJlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U8hiLYvL7H8QcysxummJgpPqrSSxCmZOCYKK07zqzwRz7QtBID9wf/6Z2q4GpL3tk
	 3YOtGC390MhF7HBGH9UoPS/xAs42VmYXjHMxbvLrDOiPndCOdwvI2tnj6KmVEQGzuZ
	 EjJGJG7vrEdz0z5WBr1hIRx1i6CHZvtlkJEF60rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 138/138] sh: intc: Fix use-after-free bug in register_intc_controller()
Date: Tue,  3 Dec 2024 15:32:47 +0100
Message-ID: <20241203141928.847582169@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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



