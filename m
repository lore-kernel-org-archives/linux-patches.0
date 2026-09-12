Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FB734752E;
	Sat, 12 Sep 2026 11:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211847; cv=none; b=mZ0OicK8ckoftzsbGtUWHWE9tXgzHVPIOiEedCZldrGvHQjX0NnUYeMm7YOkDv4Es/VNPI3DQ1sAXnK1WPedBez0l47ZBnihdAjdNKIjTHC2FQbMYqtty9Od1xg9e1ILgt57rhxwMsneH6+Qy74R7LSmw2NWyi6MwVpWd6LsQPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211847; c=relaxed/simple;
	bh=pDDC5/34gL+/A8Vwl2Mgb+vmnGrAWGxnkJLMs7bimBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gQOmp5hFJ85CX8ccrHJDRSz9enF3PO55R/VRVXy4p3MZpGGViSp1XD2Hc/vBnb2eSQDdNnmreQndupfzK5t090/rbHS1YEXo1929Dg5KlEMl0hEA1ugXRO5+6KCGgf+9AlUn//oo3SrIdtSSGoumuoPwmP+K5wWvVuy4x7Aw/V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=veXWJad2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="veXWJad2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EDF21F000FF;
	Sat, 12 Sep 2026 11:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211845;
	bh=6Hh1aeL+dDm9kbQhcwEoyIgfLNukqnIqdL7M8ijmCsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=veXWJad2fmnJ7kfvpECq2XUOkCjYbZoQT7qHopEp/hlmeEWaniSIQvIN9k+uLl3KJ
	 Ez1QQNzfZP6xFcNM7UdmpAioVQXJglB/Jq+URt7SJX6tFnqG9MsqSmsi+J/1gS7Bzm
	 6FnB+7mX4ANwiBHp/lRXFpKNw7kVSucND85L7pII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1314/1518] irqchip/gic-v5: Fix gicv5_init_common() error paths
Date: Sat, 12 Sep 2026 08:58:03 +0200
Message-ID: <20260912065653.251581280@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Pieralisi <lpieralisi@kernel.org>

[ Upstream commit 183750b276c229c5253b3b11581f6cd8877b753e ]

Current code fails to disable interrupts on gicv5_starting_cpu() failure
and to set the handle_arch_irq pointer to NULL if gicv5_irs_enable() fails.

Update the respective error paths to fix them.

Fixes: 7ec80fb3f025 ("irqchip/gic-v5: Add GICv5 PPI support")
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260812-gicv5-7-2-fixes-v1-4-3743e82c69a4@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v5.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
index a4997b3235b08..ebeb26b25dac8 100644
--- a/drivers/irqchip/irq-gic-v5.c
+++ b/drivers/irqchip/irq-gic-v5.c
@@ -1110,7 +1110,7 @@ static int __init gicv5_of_init(struct device_node *node, struct device_node *pa
 
 	ret = gicv5_starting_cpu(smp_processor_id());
 	if (ret)
-		goto out_dom;
+		goto out_int;
 
 	ret = set_handle_irq(gicv5_handle_irq);
 	if (ret)
@@ -1118,7 +1118,7 @@ static int __init gicv5_of_init(struct device_node *node, struct device_node *pa
 
 	ret = gicv5_irs_enable();
 	if (ret)
-		goto out_int;
+		goto out_handle;
 
 	gicv5_smp_init();
 
@@ -1128,9 +1128,10 @@ static int __init gicv5_of_init(struct device_node *node, struct device_node *pa
 
 	return 0;
 
+out_handle:
+	set_handle_irq(NULL);
 out_int:
 	gicv5_cpu_disable_interrupts();
-out_dom:
 	gicv5_free_domains();
 out_irs:
 	gicv5_irs_remove();
-- 
2.53.0



