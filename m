Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3721EB5CE;
	Tue, 29 Apr 2025 16:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945975; cv=none; b=MYu6vtoEakZsj5Gc6mixVfSBa0b93fMkxxmVv3k9z+QPC8KQ4hLOy4pVe2K4XC0VJJu1r6B/FxnyyS8X+slz+BenzFiVs71tyZ5hPSpXsUpOxoxhC8pmrXfE0bwb4GDqyhDqfzaKNKsV20E0/JLeNcia4rssUII7qPByrvwdcyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945975; c=relaxed/simple;
	bh=QGj3qBjWTxNKrzuhk6+BKv6UTBlaVktivtbxpJcmedw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQKzLMvSDUzCH1AsuQlQIuQadAu1RmZXk5mfIpPOKPDYtZOTQTd8so7qOV9kRrbYVgBDCKdVXLvstGcEoIGe34hi2BYmOmHiXmtk/cg2qoAzg+rJirQza+glNUEGRY4q7Qf4JRRprSS282iMKvc6T26sC64c6kDfPH1/V17n+A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mmtSEKfr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mmtSEKfr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA4FC4CEE3;
	Tue, 29 Apr 2025 16:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945975;
	bh=QGj3qBjWTxNKrzuhk6+BKv6UTBlaVktivtbxpJcmedw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mmtSEKfrcPyg4zq6Hk2fJB7MKLK0BoERltMqbDyqIrB3zpwX9x9KvPD83/NjYufhU
	 gzkGKLk37QtGDtJEALcW/jQrTw3VxVOMt03CyBUsGbk7m9eSVGPH0uAypUK0tIqTHx
	 gLGYX9YkfgNtQ2/DzJ+2sFjh8WXyJsESjJaHoawU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 085/311] iommu/amd: Return an error if vCPU affinity is set for non-vCPU IRTE
Date: Tue, 29 Apr 2025 18:38:42 +0200
Message-ID: <20250429161124.534215524@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 07172206a26dcf3f0bf7c3ecaadd4242b008ea54 ]

Return -EINVAL instead of success if amd_ir_set_vcpu_affinity() is
invoked without use_vapic; lying to KVM about whether or not the IRTE was
configured to post IRQs is all kinds of bad.

Fixes: d98de49a53e4 ("iommu/amd: Enable vAPIC interrupt remapping mode by default")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20250404193923.1413163-6-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index cd5116d8c3b28..b3a01b7757ee1 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3850,7 +3850,7 @@ static int amd_ir_set_vcpu_affinity(struct irq_data *data, void *vcpu_info)
 	 * we should not modify the IRTE
 	 */
 	if (!dev_data || !dev_data->use_vapic)
-		return 0;
+		return -EINVAL;
 
 	ir_data->cfg = irqd_cfg(data);
 	pi_data->ir_data = ir_data;
-- 
2.39.5



