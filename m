Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8A450E587;
	Wed, 30 Sep 2026 16:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784268; cv=none; b=Yoq6b0+ZCglM8vtsnZTks/5BYRUXJA80fxjTd3EGnNLKzkWmWS9cdXxqmtri/m73KpdAeAwGKmzvcZkttldWGgz1Yj3ysYi+baNDW1AXS4VX3D5mdMeY2rC2IoKnyvuaP5BM/a98G2FmbUB4L5BrQkbIoaCzoHOHLKaIWD8z9z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784268; c=relaxed/simple;
	bh=k0jXveZWVhtN9z+WXYq3Wi1rtH+7PvOHr/Uy6XNhukg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TCmNOQi7pAflEMW4uYb5NPCo66KtJ9QTh9EUnH3JaQC+FFNvsw2U9cN0V3BaA9Hq7aGR+tFVIv8MdLqyZH9FXuqkGmpTBiEREEMkme4leCZzfjnixOOVpVrz7J0YWnR4tvu3LGrJYnfFOoYj5Q05lMgrhheLZnrhCQkK4Rc3zp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z97I1WBS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z97I1WBS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 648A31F000FF;
	Wed, 30 Sep 2026 16:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784263;
	bh=9aOGzC2bSAzobA9F4Tc8VbAGw1mR1pb9ZafUjrDA8Rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z97I1WBSp/7Yx+vRam7jJDZjd04a+3Zz5B2+fLkHmc+yQaV9NF6HgiPSxwmUY2syA
	 evSyJAdJUw++diIaWBa/d3/QHOjTFJGUlZiNO8GDwKBNryjJi2vWPZzvcL3ZfD2qQc
	 0G2dAILhx8lMRMgeFitwWR35tZlTUct+dMe1Htxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Mostafa Saleh <smostafa@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 094/982] irqchip/gic-v4: Dont advertise VLPIs if no ITS is probed
Date: Wed, 30 Sep 2026 17:13:50 +0200
Message-ID: <20260930152418.830957108@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 84b00e14860eb..105b8e24905ed 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -5583,6 +5583,7 @@ int __init its_init(struct fwnode_handle *handle, struct rdists *rdists,
 		its_acpi_probe();
 
 	if (list_empty(&its_nodes)) {
+		rdists->has_vlpis = false;
 		pr_warn("ITS: No ITS available, not enabling LPIs\n");
 		return -ENXIO;
 	}
-- 
2.53.0



