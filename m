Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F93843F085;
	Mon, 17 Aug 2026 15:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979818; cv=none; b=k8Fqaj8qtVSFkifzTQhRBW3P6BYxjlZZFhT/Gf7iVJOsRHjcfhRrmoYweckTLS0kTmJzGKfg11/rtVwPW93oSWBDeMDYZdaosbhDNCHecywf/QdHSHDmzFc4ItJsuR9+qozg6V7ZZIlcjZm935Sso7PQuDA764NatJixNC1WZik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979818; c=relaxed/simple;
	bh=JDksjossKXzJcj7EtfU+1zEIY69RYhpeZ5zpmYt617o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rtx5GZ8WZGK36KT4NlpMdnfjrbqNt8Yv4vvXHSyWokpYtrJdhDhlBJHrRyM7Km8XN5Pa92UoLLtULLYsNyfl14i5L6BbPSRMhlhDHQGSJHMliFGQND0JgasbPG0Py+SVlyoKl9Hi69lLJttEv9aAvYe9ZkwMu13O2OqqICx7rYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IyaAlpQu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IyaAlpQu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AA681F000E9;
	Mon, 17 Aug 2026 15:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979816;
	bh=4BG3VDIGR3BvUx8hD4ICTqd6ePrnYfFhHRQmw5gVYWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IyaAlpQuUQMNqRepLO5j++onIFwPjd7bZpuzx8Zkd/Uz9vmp82YxaHvjGhbw3JGyN
	 tr08wQkO/IsehV62A1BtRcwFr3RwRTW4reHE5TtgHpgDhnyuHNCpyeqgBQfn5xzPoq
	 jYdC/jo3NrIjuWmaii1selCixk/HrQCAHpcC1yhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 320/609] phy: zynqmp: fix runtime PM leak on probe allocation failure
Date: Mon, 17 Aug 2026 15:30:16 +0200
Message-ID: <20260817132554.943856976@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>

[ Upstream commit f3506e15cf72e94f62d5f2d173e5b7008f644cde ]

Allocate saved_regs before pm_runtime_resume_and_get() so a
devm_kmalloc() failure does not leave an unreleased runtime PM usage
counter.

Fixes: 5af9b304bc60 ("phy: xilinx: phy-zynqmp: Fix SGMII linkup failure on resume")
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Reviewed-by: Michal Simek <michal.simek@amd.com>
Link: https://patch.msgid.link/20260720153832.1130006-3-radhey.shyam.pandey@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/xilinx/phy-zynqmp.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/phy/xilinx/phy-zynqmp.c b/drivers/phy/xilinx/phy-zynqmp.c
index 517855fea8920..f1c2006dda602 100644
--- a/drivers/phy/xilinx/phy-zynqmp.c
+++ b/drivers/phy/xilinx/phy-zynqmp.c
@@ -1046,6 +1046,12 @@ static int xpsgtr_probe(struct platform_device *pdev)
 		return PTR_ERR(provider);
 	}
 
+	gtr_dev->saved_regs = devm_kmalloc(gtr_dev->dev,
+					   sizeof(save_reg_address),
+					   GFP_KERNEL);
+	if (!gtr_dev->saved_regs)
+		return -ENOMEM;
+
 	pm_runtime_set_active(gtr_dev->dev);
 	pm_runtime_enable(gtr_dev->dev);
 
@@ -1055,12 +1061,6 @@ static int xpsgtr_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	gtr_dev->saved_regs = devm_kmalloc(gtr_dev->dev,
-					   sizeof(save_reg_address),
-					   GFP_KERNEL);
-	if (!gtr_dev->saved_regs)
-		return -ENOMEM;
-
 	return 0;
 }
 
-- 
2.53.0



