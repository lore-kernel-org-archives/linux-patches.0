Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCCB1DE8BA;
	Tue,  8 Oct 2024 12:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392007; cv=none; b=Bex/5P/BmSCz14V12npAFHDDh+SuKKVl0TNZMLIeXjJc49D0CSRDooovS2KM8ieWaBwYLAvvLXWJzh1cz250FWFUJ/cBE6cUA/4lkhKotLouTz0OKLP9qwPZRrsipMKp1fATj/nzUpGZFSyFTaG4B65dPz64p0X20kxWX7ac3C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392007; c=relaxed/simple;
	bh=FF3l1pw0Z9Up9KfDlVRoZ2i4iUgo709jJ3a+ylxeRTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Boi85CNMnP1qTm+Kw0H1MpWo4vmJc39Mu+KYTVkwF9NPu++olNjFYO9sf0A+AhFRD99uq0oltcQBdDjgbo7QMJdvIi7CMcrNO3o7U7Tt2YjUr8AEVlclk3O+LMgyK7dm4JWqZSQmHgkIJmyzX1oMUKnBl/b3RmtnOjXkI+UxcG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qs2bPw5e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qs2bPw5e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB95C4CEC7;
	Tue,  8 Oct 2024 12:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392006;
	bh=FF3l1pw0Z9Up9KfDlVRoZ2i4iUgo709jJ3a+ylxeRTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qs2bPw5eEtZDnNEJ6Zzyq9bxlgEDvtMP6zCtdjiCbJTHGti4aQ2ALljy0gq3TIGU6
	 1ren0fabrbN+MQX+ia3b48bjSk1YSebQ55p2pDolySCBNRdf7ic1omuJ5HjKq/ZP79
	 auyB784HpPMW8QPWcd0yAF2sfZeh8U7xr/yhhu3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 289/558] drm/amdkfd: Check int source id for utcl2 poison event
Date: Tue,  8 Oct 2024 14:05:19 +0200
Message-ID: <20241008115713.698517142@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hawking Zhang <Hawking.Zhang@amd.com>

[ Upstream commit db6341a9168d2a24ded526277eeab29724d76e9d ]

Traditional utcl2 fault_status polling does not
work in SRIOV environment. The polling of fault
status register from guest side will be dropped
by hardware.

Driver should switch to check utcl2 interrupt
source id to identify utcl2 poison event. It is
set to 1 when poisoned data interrupts are
signaled.

v2: drop the unused local variable (Tao)

Signed-off-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/amdkfd/kfd_int_process_v9.c    | 18 +-----------------
 drivers/gpu/drm/amd/amdkfd/soc15_int.h         |  1 +
 2 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_int_process_v9.c b/drivers/gpu/drm/amd/amdkfd/kfd_int_process_v9.c
index a9c3580be8c9b..fecdbbab98949 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_int_process_v9.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_int_process_v9.c
@@ -431,25 +431,9 @@ static void event_interrupt_wq_v9(struct kfd_node *dev,
 		   client_id == SOC15_IH_CLIENTID_UTCL2) {
 		struct kfd_vm_fault_info info = {0};
 		uint16_t ring_id = SOC15_RING_ID_FROM_IH_ENTRY(ih_ring_entry);
-		uint32_t node_id = SOC15_NODEID_FROM_IH_ENTRY(ih_ring_entry);
-		uint32_t vmid_type = SOC15_VMID_TYPE_FROM_IH_ENTRY(ih_ring_entry);
-		int hub_inst = 0;
 		struct kfd_hsa_memory_exception_data exception_data;
 
-		/* gfxhub */
-		if (!vmid_type && dev->adev->gfx.funcs->ih_node_to_logical_xcc) {
-			hub_inst = dev->adev->gfx.funcs->ih_node_to_logical_xcc(dev->adev,
-				node_id);
-			if (hub_inst < 0)
-				hub_inst = 0;
-		}
-
-		/* mmhub */
-		if (vmid_type && client_id == SOC15_IH_CLIENTID_VMC)
-			hub_inst = node_id / 4;
-
-		if (amdgpu_amdkfd_ras_query_utcl2_poison_status(dev->adev,
-					hub_inst, vmid_type)) {
+		if (source_id == SOC15_INTSRC_VMC_UTCL2_POISON) {
 			event_interrupt_poison_consumption_v9(dev, pasid, client_id);
 			return;
 		}
diff --git a/drivers/gpu/drm/amd/amdkfd/soc15_int.h b/drivers/gpu/drm/amd/amdkfd/soc15_int.h
index 10138676f27fd..e5c0205f26181 100644
--- a/drivers/gpu/drm/amd/amdkfd/soc15_int.h
+++ b/drivers/gpu/drm/amd/amdkfd/soc15_int.h
@@ -29,6 +29,7 @@
 #define SOC15_INTSRC_CP_BAD_OPCODE	183
 #define SOC15_INTSRC_SQ_INTERRUPT_MSG	239
 #define SOC15_INTSRC_VMC_FAULT		0
+#define SOC15_INTSRC_VMC_UTCL2_POISON	1
 #define SOC15_INTSRC_SDMA_TRAP		224
 #define SOC15_INTSRC_SDMA_ECC		220
 #define SOC21_INTSRC_SDMA_TRAP		49
-- 
2.43.0



