Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7823B17FD;
	Thu, 13 Jun 2024 12:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282342; cv=none; b=Hmocr5Hl/dQPh6MTgM4vO+OnqaMLYU6DQO97ocgtyo9sHQA1X5Ld+dZH2HMbsOJFr09q65O+g8neEroYZocTpuP+iUh94NVQ7fqRJkMaYQ0oEdXOVUfGbd/xiUqXBkalXCtC8lOK/CG1dQJYbpeaUcYl1yrP8VO1xCuQVRnQREc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282342; c=relaxed/simple;
	bh=V8F6w5ieYb8xNtve80HL6ZKWiSn+lglT8r6eNcxmuT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJAKvP+DSaHJKXWVWHwYvNwGe6byN3N7H8qBj/clfIhETU9qmfmWnWI6KpgWUuvJnWf9ss7A5ZHNS/t9SUuuu/31YY/5KJyLccCeEk7+PxAKZd0knlBcni+dtUzZ1WGp25fhBjnasiZQkC/S4iojhkX72ItB/r714NWRpqVSW0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bo+9aY1j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bo+9aY1j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B21C2BBFC;
	Thu, 13 Jun 2024 12:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282342;
	bh=V8F6w5ieYb8xNtve80HL6ZKWiSn+lglT8r6eNcxmuT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bo+9aY1jEbf4hz9yZSpFf6+NRkYD7MSopcs6jFwxzk7eLv1vZCVGJ2ZVs4lMMnIif
	 3av5T7KA7wtSJmISph1ryP1qmk6tPTovOg3uT98UVMd0YWsrSRHssk1ZPmlzvu83+Y
	 a4Nqfm7NCeUy1cezdsskaw0SbCvSXBICaxCHeoSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Egorenkov <egorenar@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 244/402] s390/ipl: Fix incorrect initialization of nvme dump block
Date: Thu, 13 Jun 2024 13:33:21 +0200
Message-ID: <20240613113311.667485977@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 77246ff5b0141..d2ba82873abfd 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -1603,9 +1603,9 @@ static int __init dump_nvme_init(void)
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



