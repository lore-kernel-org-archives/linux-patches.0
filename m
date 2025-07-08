Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7752E540C;
	Tue,  8 Jul 2025 16:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993073; cv=none; b=KmyKL50W2lp55zyMAIqfPejP1hcQUnEBlTQ6uNuqJZrIqOy0jIXGE3N6wdgTfz2EcLC3dVe+8jjwdBlkVqAOhpL+veyjThDS7Yk0QsRnQoXtI0P/7qMlnRHUH//xZUdv/6J+qwrZyL/o+tVgXLlTFZfe2kYBwPAMZ5GWFzwvKGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993073; c=relaxed/simple;
	bh=fLcKDY/BEiwve4Tztw8Z/GOBz1x7O0KG1r8HNte80E8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nIsWm+2bfpn4ouo0Py0f8bJQh/lFHe+HM/qE4ZeNiVO1xNj6M5BHlTC7Ab/K7158vO/2MsTxsRBxUWvs+eIpxiXR/kENO6PX//yiY1sGWuB4YwVG5niYSwjroSMWCUTi1hFzwYmvPw2akxage0OtnyxycT9UUE5eZdXLmMTpJ9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M6qyip4P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M6qyip4P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43EA9C4CEED;
	Tue,  8 Jul 2025 16:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993073;
	bh=fLcKDY/BEiwve4Tztw8Z/GOBz1x7O0KG1r8HNte80E8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M6qyip4P8Nxtnlfln3U0bDFrkgdCwkworMiuhRmpysCGgpSVnKZ07PtzlwXMeYiR0
	 S9zfJchkJT6LBPvVKcQP7znDZGg8MVpP6JM/G403ZEx6W+U2XRva073lI3/K/nB86O
	 oaUvpjlqVMm0JzY6fh9dOIW83NKZUYwXC5hA+fMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gyeyoung Baek <gye976@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 179/232] genirq/irq_sim: Initialize work context pointers properly
Date: Tue,  8 Jul 2025 18:22:55 +0200
Message-ID: <20250708162246.123564254@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gyeyoung Baek <gye976@gmail.com>

[ Upstream commit 8a2277a3c9e4cc5398f80821afe7ecbe9bdf2819 ]

Initialize `ops` member's pointers properly by using kzalloc() instead of
kmalloc() when allocating the simulation work context. Otherwise the
pointers contain random content leading to invalid dereferencing.

Signed-off-by: Gyeyoung Baek <gye976@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/20250612124827.63259-1-gye976@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/irq_sim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/irq/irq_sim.c b/kernel/irq/irq_sim.c
index 1a3d483548e2f..ae4c9cbd1b4b9 100644
--- a/kernel/irq/irq_sim.c
+++ b/kernel/irq/irq_sim.c
@@ -202,7 +202,7 @@ struct irq_domain *irq_domain_create_sim_full(struct fwnode_handle *fwnode,
 					      void *data)
 {
 	struct irq_sim_work_ctx *work_ctx __free(kfree) =
-				kmalloc(sizeof(*work_ctx), GFP_KERNEL);
+				kzalloc(sizeof(*work_ctx), GFP_KERNEL);
 
 	if (!work_ctx)
 		return ERR_PTR(-ENOMEM);
-- 
2.39.5



