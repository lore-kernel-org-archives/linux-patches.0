Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61AAA1C3720;
	Thu,  6 Jun 2024 14:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683660; cv=none; b=ai9LQEEOtZUGh6FTl7c/gHicnmz0dvSb21YQgDebGShnivvtp5G9fD+P+ZPIKlASehSeqvtmzRbQoLPnnmjnP+DKv50rqoqXCGTgkEm1kKxjVLXY5ROr91H0swdhubcR8fVYgxwIJsAr16m3nuBrnBU+QXqE9aFa6kzc+uz5AZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683660; c=relaxed/simple;
	bh=C4g69rAi3xEbxaaC8j54M6d2nacCW7H/8n1dxbZxF0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g1NJ3iiLHaioVshqnx/gAVsYFLK31t35DxFM9h0EetVK7iTfqs0q+5LGQEK9w/2bIyykLoaqMb1C05EaXiipQbKzewEu6e+8GbLEtSvYMKqh3phmDeSM8cXWJfh2uo1dPyyws9z6SUkasUOHfv34cuSrsAdymMMziTri0Ek9G8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lHRSI+lh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lHRSI+lh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41735C4AF07;
	Thu,  6 Jun 2024 14:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683660;
	bh=C4g69rAi3xEbxaaC8j54M6d2nacCW7H/8n1dxbZxF0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lHRSI+lhEHLALn2/NHv+eP76LWGomzpRuE56czreeGg0BvD8Kh2SaygtrRqv7hr6t
	 s+nHYNeZYYMBNb6pWCeHOX7C6eKjUmDKMNPeZou7CIcu2gdfXJrtnyL/9smNUwJjvm
	 8+KJpdpnW1b9RZFsrdtjpJaqPW2yXdwSyjCZDgFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Egorenkov <egorenar@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 540/744] s390/ipl: Fix incorrect initialization of nvme dump block
Date: Thu,  6 Jun 2024 16:03:32 +0200
Message-ID: <20240606131749.773469716@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 14365773aac79..a3d3cb39b021a 100644
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



