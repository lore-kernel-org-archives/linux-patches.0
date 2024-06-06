Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7098919D07B;
	Thu,  6 Jun 2024 14:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683469; cv=none; b=FFtboY05shQDVcWj8KMO0JvVriUmKrN6jT0341omb3nY6Y2OCNU8M/EiLEAzT1fjcJJ3BBnXDpfRHiNy+qPu6cr+MkFxqJA+QCJ6ptS1pmpLguzZP8d0WN+uAsuj9VLx1IqE73FrarztNj4hPbuRmRuX9rmZpO/jh4k30w+6tQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683469; c=relaxed/simple;
	bh=JTI/GFJsUk01hzU6N90I8fpyVatq1fWI0Lrmx4/ZtAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M53zPiMi7akxFAiC9IQhshUFc+HhYoeA3eNogCw5jzcVcwHai7aMYNFzj/12EJmQLYB3heQWJahyq8tqhSfnGJ/iFyof+mp8y872uvzXbSpuizW3Q7pP1o4CpsowALodtQcifG0LyquNFtg0L9CPqPM2uLqfKLtpMCqfDWO1IbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QjdnUYxa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QjdnUYxa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B45C2BD10;
	Thu,  6 Jun 2024 14:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683469;
	bh=JTI/GFJsUk01hzU6N90I8fpyVatq1fWI0Lrmx4/ZtAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QjdnUYxaUma/wVmzMB7Tnz4ZNle0oFFfPKoLqAd2s/WeSTaSat7eilOqPALZb3nCP
	 5TuC73a6c5LED3rEiAnM3jkkuD8PIlm43o8D85hJ7NS6b8XXOa1q+nhHadApulFJkV
	 Z163Z3ytM5eren/AhKlW2Lv9olV/dMV8IRnE4O9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Egorenkov <egorenar@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 356/473] s390/ipl: Fix incorrect initialization of nvme dump block
Date: Thu,  6 Jun 2024 16:04:45 +0200
Message-ID: <20240606131711.679033630@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b06ec1d8815e3..3aa3fff9bde0c 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -1604,9 +1604,9 @@ static int __init dump_nvme_init(void)
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



