Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024620;
	b=QMtHwO6NpLuFGMGQg9qQO1TOlFQRzi+jmKH2j3rL1HVRuZAUET+GCshoBe/yqSE/qoCd
	 mIii1aq1icVqTbKlDYE1jJxeIJ7mgbgY8IHRtTAGPUp7rnEe8OD+VL1pO2dJy7obW0Uoo
	 pOAaQN0d4M4nNXnT70wJv2zTYFiXiLy2SCVLOHVLs1GHpmgkzyHivwW1hmRKgBzhe/ZCb
	 RIIvJ8E/3NfUeZx4MdoPLv+lIzxRoqXYWoua5B+3kYq4DmAu7JVSPjW35FgwksIHBiN3M
	 2+gGArkNim7Lf54SXJJiZLLbtYsEVHBsO9TPLcTmpKmPCEyK6XhT8Tg37RAVGwWlXNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024620;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yU08LkBFZZ2LTUo+F8aPIQ0bRl9Yu+mfOpYlMnjk+94=;
	b=dqHrSVwZdylOV28RVA3YBZSz4KbCcV48jGIsdbCKPhfc2Un6slgJzCAJnl5lrtlCChgN
	 C0/MQ1Y5TkOKt2vpiKgfk2VoTEHBs6AZg0Uehpg3sGyLyvuY7oRCZlOJy5VwmPa/AI/Lt
	 tTh3aq1/Tirp0TGkm8zlEshKJOmCua9/kGPBy7edGhoTHFMELt4yfBk+pubgnPuvFI55F
	 2Q/xKPoS9IhOnCIZXk8SPZtndWQBqkxxNJp9d+l5DfbJSmWQHc6ixbRVlJq5upAmGO7mg
	 GmZcoMSf+FtpLM6lCkuZZP3USUdphdIThk72dHKF0OoEeZFoIQiJuZryGA/TWcSLTxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e+2t6C8P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819BF606A31C;
	Wed, 18 Nov 2026 17:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e+2t6C8P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C652A1F000C4;
	Wed, 18 Nov 2026 17:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024620;
	bh=yU08LkBFZZ2LTUo+F8aPIQ0bRl9Yu+mfOpYlMnjk+94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e+2t6C8PPu3kcf4j1iM0c+PCo7idPBNsGC+6Bn8QIa3OfJos9qR+tDFSPPTa+MKO6
	 YPoj1JtW46rYR9BSjb6NSD1U5zSmg4pR5vOdb0anwnDaTopwu1d9n8DQPAw+kzAID/
	 /n1wDmScKglm2M984aFycLMdz5MsytFXDPCnSKDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0791/2151] iommu/vt-d: Fix iopf refcount leak in nested attach
Date: Wed, 18 Nov 2026 15:42:06 +0100
Message-ID: <20261118150150.914738633@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 83871c3ae10e3dce95408175df94ecfa0280e15f ]

intel_nested_attach_dev() takes an iopf reference for the new domain but
does not drop the possible reference from the old domain. This leaks
info->iopf_refcount, can keep the device permanently on the iopf queue,
and later triggers WARN_ON(info->iopf_refcount) when PRI is disabled.

Fix this by dropping the possible reference from the old domain after
the nested translation setup completes.

Fixes: 17fce9d2336d9 ("iommu/vt-d: Put iopf enablement in domain attach path")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/nested.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iommu/intel/nested.c b/drivers/iommu/intel/nested.c
index eb3e6d687e04d..1f47eb1a4f19b 100644
--- a/drivers/iommu/intel/nested.c
+++ b/drivers/iommu/intel/nested.c
@@ -64,6 +64,8 @@ static int intel_nested_attach_dev(struct iommu_domain *domain,
 	if (ret)
 		goto disable_iopf;
 
+	iopf_for_domain_remove(old, dev);
+
 	info->domain = dmar_domain;
 	info->domain_attached = true;
 	spin_lock_irqsave(&dmar_domain->lock, flags);
-- 
2.53.0



