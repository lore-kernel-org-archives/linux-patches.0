Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795A93B38BD;
	Mon, 23 Mar 2026 14:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274415; cv=none; b=qYbGn0fR7AXq2tq4idOvrHhy2S2LgZ3vyMBMPFvzL9zAYyt9qZ0BN0Ho0jPAFM/3R1gQDf0wucbEHZTgOGYq/qpWhOOhbQNorgEZG97kslQvAJWjAXPZE7l8eOTlUtCNH4gTdK1BaGWltEP82EIt43v8PkEeRgH9GJXf/mTWEQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274415; c=relaxed/simple;
	bh=5ey9fCOULzlMb4jkNKtvBiswmtOl2B7c/VHjkgFcm3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EyJPatODUZ0WP5xjG6YidvmvlV81DabwsZuwZ+eMS+487MH5gRgF0Qnqlfnubru18MtdpVLHmnEOuNbCII8uRKMxD/sZU+tN6BvbOQj1YkTWvWACAh2Y2jX0T8m4xn9Kj0v/K9l0ij+I6orC5dAIVer0eWj3Ih4unuDShUFDNu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TZb1EwSP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TZb1EwSP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A18BAC2BC9E;
	Mon, 23 Mar 2026 14:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274415;
	bh=5ey9fCOULzlMb4jkNKtvBiswmtOl2B7c/VHjkgFcm3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TZb1EwSPhJZwDt1779L7IYj81Eka5P3GWCwKsLUeTqBh+JPSGCMkh0DxCeiinrJLT
	 bISquqlENOvUrcn5g+MLCgXphdTJgzCdG9DL5mkBkJRAdPHEcfzo/J8mmNpqpljoyo
	 XBwdmdNezo1Kg7WyqS8fB+QKmmmllruTOL2MSZI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 208/220] iommu/amd: Block identity domain when SNP enabled
Date: Mon, 23 Mar 2026 14:46:25 +0100
Message-ID: <20260323134511.126623444@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Damato <joe@dama.to>

[ Upstream commit ba17de98545d07285d15ce4fe2afe98283338fb0 ]

Previously, commit 8388f7df936b ("iommu/amd: Do not support
IOMMU_DOMAIN_IDENTITY after SNP is enabled") prevented users from
changing the IOMMU domain to identity if SNP was enabled.

This resulted in an error when writing to sysfs:

  # echo "identity" > /sys/kernel/iommu_groups/50/type
  -bash: echo: write error: Cannot allocate memory

However, commit 4402f2627d30 ("iommu/amd: Implement global identity
domain") changed the flow of the code, skipping the SNP guard and
allowing users to change the IOMMU domain to identity after a machine
has booted.

Once the user does that, they will probably try to bind and the
device/driver will start to do DMA which will trigger errors:

  iommu ivhd3: AMD-Vi: Event logged [ILLEGAL_DEV_TABLE_ENTRY device=0000:43:00.0 pasid=0x00000 address=0x3737b01000 flags=0x0020]
  iommu ivhd3: AMD-Vi: Control Reg : 0xc22000142148d
  AMD-Vi: DTE[0]: 6000000000000003
  AMD-Vi: DTE[1]: 0000000000000001
  AMD-Vi: DTE[2]: 2000003088b3e013
  AMD-Vi: DTE[3]: 0000000000000000
  bnxt_en 0000:43:00.0 (unnamed net_device) (uninitialized): Error (timeout: 500015) msg {0x0 0x0} len:0
  iommu ivhd3: AMD-Vi: Event logged [ILLEGAL_DEV_TABLE_ENTRY device=0000:43:00.0 pasid=0x00000 address=0x3737b01000 flags=0x0020]
  iommu ivhd3: AMD-Vi: Control Reg : 0xc22000142148d
  AMD-Vi: DTE[0]: 6000000000000003
  AMD-Vi: DTE[1]: 0000000000000001
  AMD-Vi: DTE[2]: 2000003088b3e013
  AMD-Vi: DTE[3]: 0000000000000000
  bnxt_en 0000:43:00.0: probe with driver bnxt_en failed with error -16

To prevent this from happening, create an attach wrapper for
identity_domain_ops which returns EINVAL if amd_iommu_snp_en is true.

With this commit applied:

  # echo "identity" > /sys/kernel/iommu_groups/62/type
  -bash: echo: write error: Invalid argument

Fixes: 4402f2627d30 ("iommu/amd: Implement global identity domain")
Signed-off-by: Joe Damato <joe@dama.to>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index e216b5a13d49d..cdcce33336826 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2854,8 +2854,21 @@ static struct iommu_domain blocked_domain = {
 
 static struct protection_domain identity_domain;
 
+static int amd_iommu_identity_attach(struct iommu_domain *dom, struct device *dev,
+				     struct iommu_domain *old)
+{
+	/*
+	 * Don't allow attaching a device to the identity domain if SNP is
+	 * enabled.
+	 */
+	if (amd_iommu_snp_en)
+		return -EINVAL;
+
+	return amd_iommu_attach_device(dom, dev, old);
+}
+
 static const struct iommu_domain_ops identity_domain_ops = {
-	.attach_dev = amd_iommu_attach_device,
+	.attach_dev = amd_iommu_identity_attach,
 };
 
 void amd_iommu_init_identity_domain(void)
-- 
2.51.0



