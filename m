Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184BC247280;
	Tue, 29 Apr 2025 17:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947296; cv=none; b=aTn58WEHsAfqvRrszOTAFukKd83/UnnYNiJGuOuRhHwMn+usNX5t7YQKjq7n0v6hyRTlodm4OsOLAahpj3eQV8rV5ACcVJBHE7FOj6wUnoARc4kET+DnpqwKKVgF1W/GEKCFrJwoJWG5hkKmYMeiFQD9F6efd87JYn6hym5BeQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947296; c=relaxed/simple;
	bh=t24KnFbf+ea0JuXWQv2DKntUtv7/ghmgD2JDiJ3eNV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZqWHQ6jBRxescQ5/9VyBYhXsIEhqDxRuk21rRD+4D9Jk5TQ7JP06+FALftxfGqe2t3jKnXHEBZgFPhweiH6aLD0wQ027tWl0Vi5kNWKuXSTH66LU5M24Lt+5rfNJyGJ/NGEbmtHjFd5HuZjusLO4UcGF2//LrVNsegLCSpkPlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FJ4pHeP4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FJ4pHeP4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96088C4CEE9;
	Tue, 29 Apr 2025 17:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947295;
	bh=t24KnFbf+ea0JuXWQv2DKntUtv7/ghmgD2JDiJ3eNV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FJ4pHeP4i0iKgdujHz9RASiDpzy2Cm5z77aE/jWYo3qzT2cEIqjIqycRVXW3iUWA6
	 WFhi2xpFgKUjIIH00NiDknRdK7yVZUQ+SF+6o+aviK0bMuakgCDWcMtmgONF6Eikpu
	 OFdmq2kipsqQcuUVayhdg9b6TXGyzfFyvKQPJ6iU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 236/286] iommu/amd: Return an error if vCPU affinity is set for non-vCPU IRTE
Date: Tue, 29 Apr 2025 18:42:20 +0200
Message-ID: <20250429161117.636504563@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0a061a196b531..a9a3f9c649c7e 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3979,7 +3979,7 @@ static int amd_ir_set_vcpu_affinity(struct irq_data *data, void *vcpu_info)
 	 * we should not modify the IRTE
 	 */
 	if (!dev_data || !dev_data->use_vapic)
-		return 0;
+		return -EINVAL;
 
 	ir_data->cfg = irqd_cfg(data);
 	pi_data->ir_data = ir_data;
-- 
2.39.5



