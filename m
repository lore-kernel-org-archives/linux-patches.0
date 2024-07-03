Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3A117C7A0;
	Wed,  3 Jul 2024 10:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003400; cv=none; b=TYAPVcNhpvMsvkTUBamI9ZqYAoU8e3ZvY/lpY1k5gZ2z03Vh9KW5P42IQnbtWl9U6h5gnrlgwxezq5ab80EL2A3KmTSsbDl2AFC9VAU2t+BYU0Iuq7+kTUiz4KD3wfsUaoNveMNSs3/Zc3k5r92Dd9jrkynxrxkQR/WxhvpkiV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003400; c=relaxed/simple;
	bh=yqpXsQfdTAhWMkU13ehkwk/wiFdNmUaBzKyh/Fd1Cus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TMUKAtDT9Jzbts+NN9+h3bKCS3ZmfLT8vccQp72iWT7VRhCCDo4+oP8Xo4koIAt435POaG3q/ebqQTywWlP80xNEsvAmjnakHnxzxfPolppAEBbTUD3zBwdPf4OUHPSsXl8HSGBmZa4aEW+jJTp5uAwcamPqCoFqXuxZvQ1L0BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fTkuZw02; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fTkuZw02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7408FC32781;
	Wed,  3 Jul 2024 10:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003399;
	bh=yqpXsQfdTAhWMkU13ehkwk/wiFdNmUaBzKyh/Fd1Cus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fTkuZw02pQYWk/m4j56BEDQ7KdHmWYdKbip6iDor0+AuGwyi1/xJkUlTMv7jKSnqa
	 5CFfP27J0v1FZz6IHQhAeJnb0uo8n6l5RwyzfwglgCWQTPRU7mfQ4UZO3+cgQdwcS3
	 /Ku8T3OhKR8D2Um4PdSstBXdAGaPFt9c4Qikwqm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kun(llfl)" <llfl@linux.alibaba.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 037/139] iommu/amd: Fix sysfs leak in iommu init
Date: Wed,  3 Jul 2024 12:38:54 +0200
Message-ID: <20240703102831.839871278@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1409,8 +1409,17 @@ static int __init init_iommu_from_acpi(s
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


