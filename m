Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7707229D273;
	Tue, 26 Aug 2025 11:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207571; cv=none; b=NE1iJfk1QlGeh1/XIe7zZEJW4u+oWnT7LywBj/skIPJCUdwxB9k7N9j36wnoUpozvXElK0/0UUIN/2iw7aXBFJVR7g9CZL24SMsez7yG6FrNzdJP7gptxXaB5d6bH1MgaoXW+biQydV+65cTXT17TvZgR8vhR38rH7lPKoHliGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207571; c=relaxed/simple;
	bh=vj0xebZVJS8xaXu7ecdcpbtztkoRsPsZ8NXBLDNFEvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/JO+SSjMSB8D1ZNBwh1VqX+wMcajZlwQbbiv/DaN18WbZT2FwiFtpFjHcFtFArbvdR4PM2bDOj/jLQOjrAxECE1gPsMU8h8NsOCo3Ekfd/6trNWGn7dAXRMV9RBQp5kCp5igJwH52SYiNZTil8RidsM2Bcd0OoSMqP/Ze/w4nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X7Fa7Y9G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X7Fa7Y9G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0752DC4CEF1;
	Tue, 26 Aug 2025 11:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207571;
	bh=vj0xebZVJS8xaXu7ecdcpbtztkoRsPsZ8NXBLDNFEvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X7Fa7Y9GQiEIsvNGCbBoJuHYYOTvRJTQmVuy/xDeff7ht1fNJ1LO9ihH8r45UErUV
	 rQwTAm09K/NHvljbJjb1optsGXn1CF47zZ/0L7nUXC4Ex41ICupjPaHfxP9HaoyFcG
	 KEXFcWwOegv6eVLIIWrtNls72ykUbrP/1DFNPjFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.16 233/457] iommu/arm-smmu-v3: Fix smmu_domain->nr_ats_masters decrement
Date: Tue, 26 Aug 2025 13:08:37 +0200
Message-ID: <20250826110943.132732354@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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
@@ -2997,9 +2997,9 @@ void arm_smmu_attach_commit(struct arm_s
 		/* ATS is being switched off, invalidate the entire ATC */
 		arm_smmu_atc_inv_master(master, IOMMU_NO_PASID);
 	}
-	master->ats_enabled = state->ats_enabled;
 
 	arm_smmu_remove_master_domain(master, state->old_domain, state->ssid);
+	master->ats_enabled = state->ats_enabled;
 }
 
 static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)


