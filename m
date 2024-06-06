Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DAD8197521;
	Thu,  6 Jun 2024 14:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682971; cv=none; b=XlJj1yOSTX5yTKKDZ/QLk96Uq20q82Ym7Tj0gO0ElnIvwCetulS8vHzoBTtg4WVu7uYl16rQE80lWJ+hqwgabHgGFArsUvZ2TW+Wb3tlpDGfNRhjV+pB2+n7rhCqnpbEt4ATIE1B66WdP3Ye9+BU+CPgdXOIYrSSsWJXtsKfc7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682971; c=relaxed/simple;
	bh=Kcwgt5OTh58/rahjlxfJtV7EwAA9K4MWAFco6Xq+1M4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ChJhFdwmAiollG2fgrwKvYGl4agNFRfm92QrHrDKTHVcx/sC/n4I8ibeH0U5BPtC0mZbqwDbleZHT2jv0JDhFG5QQg/hIyjktl7lm7IR1TnRY3MbOfewDo5WlVtqH2pr0IfeXCeLsMhgpjEMsCAUviF0rNkZYx3Xz8NzEmXb4Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KfcXfgGW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KfcXfgGW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EEEBC2BD10;
	Thu,  6 Jun 2024 14:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682971;
	bh=Kcwgt5OTh58/rahjlxfJtV7EwAA9K4MWAFco6Xq+1M4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KfcXfgGWSQVterbl1BJHNErm1mqAxorebLFJzWcTWOk5ITltOVy8mp8tLGSdKWodo
	 BZBLsLKuCXusxDZnHA6WUmCX1ICJTvQfGKGLlKkddVCJscWdhYLD3zdBpW1V+Kx5yx
	 C7wnEk1yx2yIKofEzSEVhNSbWXImMlASi40sJH6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Egorenkov <egorenar@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 137/374] s390/ipl: Fix incorrect initialization of nvme dump block
Date: Thu,  6 Jun 2024 16:01:56 +0200
Message-ID: <20240606131656.493606446@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index aedd256156bd9..469e8d3fbfbf3 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -1858,9 +1858,9 @@ static int __init dump_nvme_init(void)
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



