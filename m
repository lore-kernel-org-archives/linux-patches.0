Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E5D145FED;
	Thu, 13 Jun 2024 12:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281257; cv=none; b=AGthcE2mBsT0KZLyGZR62kqziQQ+GfMvUplfpoTkFCIpPshGhT83s2PiLAs9Fo1WuMdAJ6e1jXfM7K5rceUq4dnE3TvBSOaaTL/WA886xGeRCTquDUBabOa0mmAMxSOhecXdsnA5bvnIEawpwoBTAiJ0dQDy43GvW/trvHyFu8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281257; c=relaxed/simple;
	bh=oqRvMv0zGCVguUzVd0jTeHiitwtJ3oE53HUMrbK6fsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pijucVeiQ5djYsLnHW7EHuVo6wDRZXickrVQlSuas9OtX5oXfxeNh7H8XIkljXnn9rNUry3L3pTGJ0pc1Sl98wnqirQTDEt0kvihPD/YdM4m03IQzNA2nVMlQIajb9VMA/adTgvmj0nMofwWE69MsBlpi3IEiVwXmxRVrH3Suec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xp2gLjSM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xp2gLjSM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29426C2BBFC;
	Thu, 13 Jun 2024 12:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281257;
	bh=oqRvMv0zGCVguUzVd0jTeHiitwtJ3oE53HUMrbK6fsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xp2gLjSMLHt20lDokGJ/MBHnjqz4NyT2vHjvtttsgSOVbvUmb6/vKRMPdV/elwU9e
	 2eMvOS5y/DV/a5XbvaUs6DjINTViQi6jEO3rh7Sex501LNFUw6n8wrK9kdLIkQVpjS
	 K9BPuK35/IfiCHcuS/k787SMsWyn5vAiw1um7mMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Egorenkov <egorenar@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 192/317] s390/ipl: Fix incorrect initialization of nvme dump block
Date: Thu, 13 Jun 2024 13:33:30 +0200
Message-ID: <20240613113254.984241315@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Egorenkov <egorenar@linux.ibm.com>

[ Upstream commit 7faacaeaf6ce12fae78751de5ad869d8f1e1cd7a ]

Initialize the correct fields of the nvme dump block.
This bug had not been detected before because first, the fcp and nvme fields
of struct ipl_parameter_block are part of the same union and, therefore,
overlap in memory and second, they are identical in structure and size.

Fixes: d70e38cb1dee ("s390: nvme dump support")
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/ipl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index ab23742088d05..939ceec83048f 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -1602,9 +1602,9 @@ static int __init dump_nvme_init(void)
 	}
 	dump_block_nvme->hdr.len = IPL_BP_NVME_LEN;
 	dump_block_nvme->hdr.version = IPL_PARM_BLOCK_VERSION;
-	dump_block_nvme->fcp.len = IPL_BP0_NVME_LEN;
-	dump_block_nvme->fcp.pbt = IPL_PBT_NVME;
-	dump_block_nvme->fcp.opt = IPL_PB0_NVME_OPT_DUMP;
+	dump_block_nvme->nvme.len = IPL_BP0_NVME_LEN;
+	dump_block_nvme->nvme.pbt = IPL_PBT_NVME;
+	dump_block_nvme->nvme.opt = IPL_PB0_NVME_OPT_DUMP;
 	dump_capabilities |= DUMP_TYPE_NVME;
 	return 0;
 }
-- 
2.43.0



