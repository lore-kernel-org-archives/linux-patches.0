Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C198A22D792;
	Tue, 26 Aug 2025 11:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208579; cv=none; b=CckvZ00IpBA2bxjvOEWvX6w/Qct6Lha2ux3ikMjoJm++bpvNvAk04VmqhXTbDs4/6GU7SJALlQ09n/my+dk30s+d88QstSxzPYl69SiCale4nJNTjQWntNPVJWmW1V2kesKx/XBqk7BoHKJkGdmXPNr8TdCIMspVOYtDD9syeEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208579; c=relaxed/simple;
	bh=+5A3IbCx/wd+kq9L/Zi3a/X1WPrUeZ5dPrzyIFWLfk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ueNkwM7qVha6/3ShcZhAzIX5POw4pBwCNNLk9ZgNOa5q48o/zEBjwNKIcpoX9aM0CW1mTbMaASwfr/Ao8Eiqrgxi2XjvyU6cFPnj6qJPRvWXQQ13SBefwb2sjLeudOg35MsqvFEzGZF36iAmgS+9qGUF2HdCm95RWC3rnlg+mzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sWTCpFm0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sWTCpFm0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B84C16AAE;
	Tue, 26 Aug 2025 11:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208579;
	bh=+5A3IbCx/wd+kq9L/Zi3a/X1WPrUeZ5dPrzyIFWLfk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sWTCpFm0og3dQ2hnX2g/D7tHiV2g3OeF6HcfqoeQ7XMax9T10yBZzhLAjadJxxqP/
	 Z9hvn+sQTenQscXjH0S9j62+st4JRcxOfq6+aqE7X8jhjWNv8HjNMpqH7VY+Zr2iIO
	 1O57HQAzUTaaBaxHb5ob0bCcMSXK8jMpjLZJqqLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.12 165/322] iommu/arm-smmu-v3: Fix smmu_domain->nr_ats_masters decrement
Date: Tue, 26 Aug 2025 13:09:40 +0200
Message-ID: <20250826110919.906732492@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <nicolinc@nvidia.com>

commit 685ca577b408ffd9c5a4057a2acc0cd3e6978b36 upstream.

The arm_smmu_attach_commit() updates master->ats_enabled before calling
arm_smmu_remove_master_domain() that is supposed to clean up everything
in the old domain, including the old domain's nr_ats_masters. So, it is
supposed to use the old ats_enabled state of the device, not an updated
state.

This isn't a problem if switching between two domains where:
 - old ats_enabled = false; new ats_enabled = false
 - old ats_enabled = true;  new ats_enabled = true
but can fail cases where:
 - old ats_enabled = false; new ats_enabled = true
   (old domain should keep the counter but incorrectly decreased it)
 - old ats_enabled = true;  new ats_enabled = false
   (old domain needed to decrease the counter but incorrectly missed it)

Update master->ats_enabled after arm_smmu_remove_master_domain() to fix
this.

Fixes: 7497f4211f4f ("iommu/arm-smmu-v3: Make changing domains be hitless for ATS")
Cc: stable@vger.kernel.org
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Acked-by: Will Deacon <will@kernel.org>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Link: https://lore.kernel.org/r/20250801030127.2006979-1-nicolinc@nvidia.com
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2778,9 +2778,9 @@ static void arm_smmu_attach_commit(struc
 		/* ATS is being switched off, invalidate the entire ATC */
 		arm_smmu_atc_inv_master(master, IOMMU_NO_PASID);
 	}
-	master->ats_enabled = state->ats_enabled;
 
 	arm_smmu_remove_master_domain(master, state->old_domain, state->ssid);
+	master->ats_enabled = state->ats_enabled;
 }
 
 static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)


