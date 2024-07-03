Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4E417BB11;
	Wed,  3 Jul 2024 10:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003893; cv=none; b=FSahHG00j5iz4nD0jRWv+WcC/r3vwDn/IFBeCHk+B9NGi2TBpqsQfjoJsMQ2NSY25jwTuwcAktyQu0Ob8fdW7pJecQk9l5ZpbwPP1SPN4jFQayqAufXY9MBF8jfa50HoUnXNsJkk59T2+QmDwI9SBRJhi3nexYBNLELD0fnEYRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003893; c=relaxed/simple;
	bh=l5hpcUq9CsakyXnyCnbtxR2WjS2tXNUzpodKnpww6ZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vDffCynQKf88cy2rzxdiVecuY8okqgesKcF3FlnxQAB3uEuiTXSBlxY6CRnwICN40UPqeLjfc2KtpJ11OsliEV5AXskEijZDBS1RrxPc4FTBUne6Vv3qshhVot+3YXi8MYWm62Ry9ACa8+mMEtUJEdNjRL0GB6kuMwWhOBscw1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KuauXKOz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KuauXKOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9473C2BD10;
	Wed,  3 Jul 2024 10:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003893;
	bh=l5hpcUq9CsakyXnyCnbtxR2WjS2tXNUzpodKnpww6ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KuauXKOzMFdY10wey2H+wcXzKxmSFs+30FLAThgUXkJJ/qmPtvXlP3bp+OhBeNQVh
	 U5sIzrTlWWV/4t72+/ECbQlsBg7Jzj80eQOEZrLdxpcNr4NfaeB8133OflnT0DNaHr
	 U7o75+8kLS2lQGikMuAf+6GslZYQ7eV4bXiegAcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kun(llfl)" <llfl@linux.alibaba.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 054/189] iommu/amd: Fix sysfs leak in iommu init
Date: Wed,  3 Jul 2024 12:38:35 +0200
Message-ID: <20240703102843.552117061@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kun(llfl) <llfl@linux.alibaba.com>

[ Upstream commit a295ec52c8624883885396fde7b4df1a179627c3 ]

During the iommu initialization, iommu_init_pci() adds sysfs nodes.
However, these nodes aren't remove in free_iommu_resources() subsequently.

Fixes: 39ab9555c241 ("iommu: Add sysfs bindings for struct iommu_device")
Signed-off-by: Kun(llfl) <llfl@linux.alibaba.com>
Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Link: https://lore.kernel.org/r/c8e0d11c6ab1ee48299c288009cf9c5dae07b42d.1715215003.git.llfl@linux.alibaba.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd_iommu_init.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1410,8 +1410,17 @@ static int __init init_iommu_from_acpi(s
 	return 0;
 }
 
+static void __init free_sysfs(struct amd_iommu *iommu)
+{
+	if (iommu->iommu.dev) {
+		iommu_device_unregister(&iommu->iommu);
+		iommu_device_sysfs_remove(&iommu->iommu);
+	}
+}
+
 static void __init free_iommu_one(struct amd_iommu *iommu)
 {
+	free_sysfs(iommu);
 	free_command_buffer(iommu);
 	free_event_buffer(iommu);
 	free_ppr_log(iommu);


