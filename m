Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A72334712;
	Mon, 18 Aug 2025 14:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526239; cv=none; b=UrBahIM1kAcSZMANwSndms+keR/2B0i8clCChCYJOjGd64+tWjtOmyCZwOkAhJ2YYQZdqsgAkIWqp3BSPGsR1HrfIPKXqQtdT1EDONHZ7Ia+5kKK5CWtEKVfFgP4OnRgzfi0Yh5vE9owMGMMnoAMAJCwFyZltmG+wMSbOIBWNQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526239; c=relaxed/simple;
	bh=wcCd+JOsaKcos0VQNNJp0jQrnzU0zyphT7GHEG1Lo+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dbkuu4ri+vBKjAIXh41bwkz1fJE3livF7dGpeRUJuTxRxzY10lib6XIkNPfzd1Gnh1XvCS1VdXFZde56/A5G6zP+XnWvBhfUQNwcY45bCX0dNdwJmHJkM/LnHGeWKALnxdKlPQPIlDazSRdAFtAdfbJpOcMoK3fY+MCmWUd5nqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B63sqMFu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B63sqMFu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D139C4CEEB;
	Mon, 18 Aug 2025 14:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526238;
	bh=wcCd+JOsaKcos0VQNNJp0jQrnzU0zyphT7GHEG1Lo+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B63sqMFu34UVRrAXVzZGgYaHMob0fNAzUudJ7n5dZ+g9FTFbb+mgFIUyKbash6OnI
	 626GG5TmjhNTrsrf5mneN/YkkZjmIcrRnp/XVSU8VA8n4M7xESdtA2UoqDyLuIquAU
	 soIsR2DhAaueCVXqk+EkBL1f4JW7DSSnpVnzo4Fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.16 498/570] iommu/arm-smmu-v3: Revert vmaster in the error path
Date: Mon, 18 Aug 2025 14:48:05 +0200
Message-ID: <20250818124525.049844909@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <nicolinc@nvidia.com>

commit 49f42634e8054e57d09c7f9ef5e4527e116059cb upstream.

The error path for err_free_master_domain leaks the vmaster. Move all
the kfrees for vmaster into the goto error section.

Fixes: cfea71aea921 ("iommu/arm-smmu-v3: Put iopf enablement in the domain attach path")
Cc: stable@vger.kernel.org
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Link: https://lore.kernel.org/r/20250711204020.1677884-1-nicolinc@nvidia.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 10cc6dc26b7b..dacaa78f69aa 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2906,8 +2906,8 @@ int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
 
 		master_domain = kzalloc(sizeof(*master_domain), GFP_KERNEL);
 		if (!master_domain) {
-			kfree(state->vmaster);
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto err_free_vmaster;
 		}
 		master_domain->domain = new_domain;
 		master_domain->master = master;
@@ -2941,7 +2941,6 @@ int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
 		    !arm_smmu_master_canwbs(master)) {
 			spin_unlock_irqrestore(&smmu_domain->devices_lock,
 					       flags);
-			kfree(state->vmaster);
 			ret = -EINVAL;
 			goto err_iopf;
 		}
@@ -2967,6 +2966,8 @@ int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
 	arm_smmu_disable_iopf(master, master_domain);
 err_free_master_domain:
 	kfree(master_domain);
+err_free_vmaster:
+	kfree(state->vmaster);
 	return ret;
 }
 
-- 
2.50.1



