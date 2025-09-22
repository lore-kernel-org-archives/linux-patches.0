Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4072517AC;
	Mon, 22 Sep 2025 19:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570382; cv=none; b=afw9YfP4BaUqWgjA3P+MFzEeAzkT/NIo4oMBk9YP9IWxzXD56GWatHdLQmSrb4qZLU490Eu52r1/kxVj2brRSjoGSq2DXIRPpV/zn4GU+2ZAqBaBcEqzPw0/7tYoo0vo1zEVHsqRf2ZkEf4ZyiJoVP9AyQrRLyfvVcos7uUENFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570382; c=relaxed/simple;
	bh=ZTIooHVpjKcRQZLpLDxgANbpdY/HCFN0ffrlmLphjv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UzJ3jkVkfjZf7QjQpKqFxkpY0MUd+QFtQ/RDjv+69a/Hyysl5AjfsVa+Dhaf+nVk2B1OlNXJP9rSbv2xwZcmNzMTArmMm1+24jfVnRIMipd86/QORZ/balmNxO1AjGHRPCaDXdXYhwLngZf7rNM7oHfL9CLaUy7IVtshWc4cjxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BKpH0hIL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BKpH0hIL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D963AC4CEF0;
	Mon, 22 Sep 2025 19:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570382;
	bh=ZTIooHVpjKcRQZLpLDxgANbpdY/HCFN0ffrlmLphjv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BKpH0hILf39Prc/ElqsiRIR2haVzJnzQUjyZTis8A394+KCR09F+pAXPvWYBMsrDX
	 qrLhIo6vWNsz+yLnGqXYvUkUkNcS+M+3jhkvhUFgmv2OiAv3GP3TVo1+5/WxEh8h5w
	 nUsTgmTVqkS+ewm8gNCps2/9jR85uPVi6RyoXxvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 115/149] iommu/amd: Fix alias device DTE setting
Date: Mon, 22 Sep 2025 21:30:15 +0200
Message-ID: <20250922192415.776603371@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

From: Vasant Hegde <vasant.hegde@amd.com>

[ Upstream commit a0c17ed907ac3326cf3c9d6007ea222a746f5cc2 ]

Commit 7bea695ada0 restructured DTE flag handling but inadvertently changed
the alias device configuration logic. This may cause incorrect DTE settings
for certain devices.

Add alias flag check before calling set_dev_entry_from_acpi(). Also move the
device iteration loop inside the alias check to restrict execution to cases
where alias devices are present.

Fixes: 7bea695ada0 ("iommu/amd: Introduce struct ivhd_dte_flags to store persistent DTE flags")
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/init.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 3a97cc667943f..eef55aa4143c1 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -1450,12 +1450,12 @@ static int __init init_iommu_from_acpi(struct amd_iommu *iommu,
 				    PCI_FUNC(e->devid));
 
 			devid = e->devid;
-			for (dev_i = devid_start; dev_i <= devid; ++dev_i) {
-				if (alias)
+			if (alias) {
+				for (dev_i = devid_start; dev_i <= devid; ++dev_i)
 					pci_seg->alias_table[dev_i] = devid_to;
+				set_dev_entry_from_acpi(iommu, devid_to, flags, ext_flags);
 			}
 			set_dev_entry_from_acpi_range(iommu, devid_start, devid, flags, ext_flags);
-			set_dev_entry_from_acpi(iommu, devid_to, flags, ext_flags);
 			break;
 		case IVHD_DEV_SPECIAL: {
 			u8 handle, type;
-- 
2.51.0



