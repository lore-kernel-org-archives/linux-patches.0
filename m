Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73533E0750;
	Wed, 30 Sep 2026 18:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794152; cv=none; b=Hy3PlzVjpko+7MMZzi9QVDpZ0Y/SfV1ge6jkTlrB2AZVvcrMF6SZsASXzduOSyA8R0hR8vfsOxfQxdQMmXhUJiS7KWdg3U9Mk38WhXvb9yW12vzhEpC0cyM+5rPKMIm2k1QQebCwDsDndqJgiZsQoEjuZLwr7oiH0PWVfvmeEU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794152; c=relaxed/simple;
	bh=WB4mYRf5meqxoIkXVCSywnT649FzLEASub6P+ssDwdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MIBy+2lnKtQEg64bk/e50ozcjCr3zXaSqyRJI1bfMdqQI07vQZ1brtixsFHu3AjGJ1iiXmTuSyBq25Se9hUhzfwAO1eCXLLVeBr1O82I3jIchVFTh+ERCA8V2EYx07CNOkZq0icmseY+fw3CCkpG+lDcNXIKwHQK4oytRhbfwjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i3QTY9Q6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i3QTY9Q6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C0B1F000FF;
	Wed, 30 Sep 2026 18:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794151;
	bh=cDBZVJ8rMxu5P3Ccl7p1/AdD2EhBpYeV0hOPqNSyRdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i3QTY9Q6JBMdvkq6JnU+5witNLo4g/ytxATatffj7VrHo+4z6F4pmezmxHuPSLpEI
	 C/pq2eN0XAzjcEPh1/Q0uJ/K0qvJ5KvYoeE+suN7U+rNkPzFvSCAIy31/ooEqrOTy9
	 auRPOEJ9G0zbrjHShbwUuUMbFzSn6UedQY4+1f20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Mostafa Saleh <smostafa@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0111/1193] irqchip/gic-v4: Dont advertise VLPIs if no ITS is probed
Date: Wed, 30 Sep 2026 17:13:15 +0200
Message-ID: <20260930152436.693491654@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mostafa Saleh <smostafa@google.com>

[ Upstream commit e61654fbc3bc5d07ec9fafe29f33e19b2b5d0fd5 ]

When accidentally setting “kvm-arm.vgic_v4_enable=1” on a system that has
no MSI controller device tree node and GICv4, it results a panic as
“gic_domain” is NULL and the kernel attempts to access it.

    Unable to handle kernel NULL pointer dereference at virtual address 0000000000000028
    Mem abort info:
      ESR = 0x0000000096000006

    CPU: 1 UID: 0 PID: 295 Comm: lkvm-static Not tainted 7.1.0-rc4-ge3f15ad3970e #5 PREEMPT
    Hardware name: linux,dummy-virt (DT)
    pstate: 81402005 (Nzcv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
    pc : __irq_domain_instantiate+0x1d4/0x578
    lr : __irq_domain_instantiate+0x1cc/0x578

Set vLPI support to false at init time if the host has no ITS, so it
propagates properly to kvm_vgic_global_state.has_gicv4.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Acked-by: Marc Zyngier <maz@kernel.org>
Link: https://patch.msgid.link/20260526125317.3672297-1-smostafa@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 53ca99b9d261f..592050e0246b9 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -5686,6 +5686,7 @@ int __init its_init(struct fwnode_handle *handle, struct rdists *rdists,
 		its_acpi_probe();
 
 	if (list_empty(&its_nodes)) {
+		rdists->has_vlpis = false;
 		pr_warn("ITS: No ITS available, not enabling LPIs\n");
 		return -ENXIO;
 	}
-- 
2.53.0



