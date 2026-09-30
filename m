Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7A6519907;
	Wed, 30 Sep 2026 17:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790788; cv=none; b=lQfz9+RwwMnQlPQx6wpf8tV4ttZe69+EtnW/IFAngD6v77BqiKfZKLuOr0A+36N6a3oeYx85ormc+jAnA0ks442nL/Jk0sCTFsutrWPimLbq7Wf4lMYVsncMFQysmxKFIVKmXOHKCHY9AGZg6HUN0QLTXUF3R+T2RFt1br/VhC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790788; c=relaxed/simple;
	bh=LRkUwguKbANZ4cpoNlBqUiQdc/PT7AEvk0wZoJxuyAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uaGKOdEjQTBL0u54z3Kx7jM4FFiS2BVrdtj/mERngWcJLjqHIIGsBjO/3fZ8GXOFDnSAYRIv2/syefwPM0MIjBtXs73D18peBQjhxUFBDhDuPmjJI6C0s8r3v2kMc/I+2wjZBn8ZYajV/cjz0gXfKzTTZPFPf3vGOrzh2oTQGdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JRu/dlIO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JRu/dlIO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07AAF1F000FF;
	Wed, 30 Sep 2026 17:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790787;
	bh=DlPKE6k73G3mZ6H6i0vbeypuAGEX8gX2QbUrn8HJFt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JRu/dlIOgfIdqCFCE1QaqxN9mW3tLBev2P1slS9whGORGw4+wF05w4g0o2HbtRbR0
	 UOoEOYeKDsj8jlWD58d1K5dhQbLxsTBenQEJED6346qyRZ9tZ/rDluLKpXQCFFicog
	 qp7Hp/flDLRWJZdrD5+HpBw2Is7F7D0LVKENW2Ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Mostafa Saleh <smostafa@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 072/752] irqchip/gic-v4: Dont advertise VLPIs if no ITS is probed
Date: Wed, 30 Sep 2026 17:19:02 +0200
Message-ID: <20260930152359.722360569@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 37eb37b89f308..297c76cb6e054 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -5451,6 +5451,7 @@ int __init its_init(struct fwnode_handle *handle, struct rdists *rdists,
 		its_acpi_probe();
 
 	if (list_empty(&its_nodes)) {
+		rdists->has_vlpis = false;
 		pr_warn("ITS: No ITS available, not enabling LPIs\n");
 		return -ENXIO;
 	}
-- 
2.53.0



