Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3BB39E6EB;
	Thu, 17 Sep 2026 16:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663997; cv=none; b=oy3A8v3lt8I4zDskUKnpJhZlgnPPMug13cPlW7SixJSc5cS66qlRjA5mZKgRIpfQ4tlApTRYfw8kcnqaw3/PG5n8oR9TFgyl+E0dD38bh/dR4ILIiEL8vz3BnbTOEemF8Rd7d12SJKKL1sbVmh+1ziF2xS/31M9XwXY2ghu+Ogw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663997; c=relaxed/simple;
	bh=pcMcwVRaPU+Zrs0beLTBwSdECMHQU4JR/cyeg4lW4EI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CX+GXD3Tb6ML1UPIRzCxMDURzAB32EyEmj2vx0Hx/cqjANfWUQW2o6ADDu0q33LV9bHqj7tlsQpSAWtvC203gspEqXFJldhhQdcnfP3coJ04ZNy3EVo6U7oJ1PqMcfpxBkN/0CBFqcaGXVlVTQ3KRa6hJW6t/p/HctWYP5lTxvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pi8/Wzmu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pi8/Wzmu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF021F000FF;
	Thu, 17 Sep 2026 16:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789663996;
	bh=4Rb0scV5CmAY6Lv3GpHCDIqYE0XTpdSzpspWvfgLRKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pi8/WzmuWKFglLFmuuWdnyhj/sclvHGOHLPwJkCGRYHeSBO/cjQ8twjbVRhTw1Wyi
	 A3OtGebPVoVlbAVS3fFjDCY8z6QUNCB07y+PN95hsBYgUwDCm6YcX9SZw7Am7nZfre
	 ElbDDlOmEl78fCJrzvyX4g8Xs1q0S+KDcVmvPJ/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Mostafa Saleh <smostafa@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0225/1250] irqchip/gic-v4: Dont advertise VLPIs if no ITS is probed
Date: Thu, 17 Sep 2026 16:00:20 +0100
Message-ID: <20260917151558.240204156@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index cc03ab698987f..8607ed0d98841 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -5853,6 +5853,7 @@ int __init its_init(struct fwnode_handle *handle, struct rdists *rdists,
 		its_acpi_probe();
 
 	if (list_empty(&its_nodes)) {
+		rdists->has_vlpis = false;
 		pr_warn("ITS: No ITS available, not enabling LPIs\n");
 		return -ENXIO;
 	}
-- 
2.53.0



