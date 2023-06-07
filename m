Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01123922F
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:56:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43970C433EF;
	Wed,  7 Jun 2023 20:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171416;
	bh=+EPnEaBEo4eT+i/kxebO7oRLxhTOl1+3MKQTixGZGH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LdkFYSGL0uTydZuO7m1z8xcrrGnbsGl6oxguioUQdjJASo8mLADyrNaJ8iJ/ecG7i
	 y+q/pccTEWuspv/A8M25aKoxnoOWWeO+fUwomeAQ6U2hDqUOFIaQy42Mh2ZGAeJek0
	 dP77zAYy582Mhszli7DZYMC2hyxae8+W9PcmDXlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joao Martins <joao.m.martins@oracle.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 010/159] iommu/amd: Dont block updates to GATag if guest mode is on
Date: Wed,  7 Jun 2023 22:15:13 +0200
Message-ID: <20230607200904.009171611@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200903.652580797@linuxfoundation.org>
References: <20230607200903.652580797@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Joao Martins <joao.m.martins@oracle.com>

[ Upstream commit ed8a2f4ddef2eaaf864ab1efbbca9788187036ab ]

On KVM GSI routing table updates, specially those where they have vIOMMUs
with interrupt remapping enabled (to boot >255vcpus setups without relying
on KVM_FEATURE_MSI_EXT_DEST_ID), a VMM may update the backing VF MSIs
with a new VCPU affinity.

On AMD with AVIC enabled, the new vcpu affinity info is updated via:
	avic_pi_update_irte()
		irq_set_vcpu_affinity()
			amd_ir_set_vcpu_affinity()
				amd_iommu_{de}activate_guest_mode()

Where the IRTE[GATag] is updated with the new vcpu affinity. The GATag
contains VM ID and VCPU ID, and is used by IOMMU hardware to signal KVM
(via GALog) when interrupt cannot be delivered due to vCPU is in
blocking state.

The issue is that amd_iommu_activate_guest_mode() will essentially
only change IRTE fields on transitions from non-guest-mode to guest-mode
and otherwise returns *with no changes to IRTE* on already configured
guest-mode interrupts. To the guest this means that the VF interrupts
remain affined to the first vCPU they were first configured, and guest
will be unable to issue VF interrupts and receive messages like this
from spurious interrupts (e.g. from waking the wrong vCPU in GALog):

[  167.759472] __common_interrupt: 3.34 No irq handler for vector
[  230.680927] mlx5_core 0000:00:02.0: mlx5_cmd_eq_recover:247:(pid
3122): Recovered 1 EQEs on cmd_eq
[  230.681799] mlx5_core 0000:00:02.0:
wait_func_handle_exec_timeout:1113:(pid 3122): cmd[0]: CREATE_CQ(0x400)
recovered after timeout
[  230.683266] __common_interrupt: 3.34 No irq handler for vector

Given the fact that amd_ir_set_vcpu_affinity() uses
amd_iommu_activate_guest_mode() underneath it essentially means that VCPU
affinity changes of IRTEs are nops. Fix it by dropping the check for
guest-mode at amd_iommu_activate_guest_mode(). Same thing is applicable to
amd_iommu_deactivate_guest_mode() although, even if the IRTE doesn't change
underlying DestID on the host, the VFIO IRQ handler will still be able to
poke at the right guest-vCPU.

Fixes: b9c6ff94e43a ("iommu/amd: Re-factor guest virtual APIC (de-)activation code")
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Link: https://lore.kernel.org/r/20230419201154.83880-2-joao.m.martins@oracle.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 5ceaaabb4f9da..a91545b9a1cba 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3316,8 +3316,7 @@ int amd_iommu_activate_guest_mode(void *data)
 	struct irte_ga *entry = (struct irte_ga *) ir_data->entry;
 	u64 valid;
 
-	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir) ||
-	    !entry || entry->lo.fields_vapic.guest_mode)
+	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir) || !entry)
 		return 0;
 
 	valid = entry->lo.fields_vapic.valid;
-- 
2.39.2



