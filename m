Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8FD145B33;
	Thu, 13 Jun 2024 12:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281251; cv=none; b=jcLNfx8fuvy5I9NGMqYvnJKkQ/0YlMB2VPRNQIns3NdniFQzz8ubEV/L4odq+lLDcIech7/JhADXURlcMARInHCFdgZFRxzAu54CScg6bHwFY0qRtyo5Ccngn6SKShZ1Ag8yV16CbXrP+l+MRzqGwCuuamBmwhfeyF7TuX9FoO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281251; c=relaxed/simple;
	bh=n7UeesZY/GDJISOrgQaoLfevs6ilKEFckfcpbrLHvpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AFn7V7G/99ZMqfRoiKS+FmHsCoROqHTsl1YcKtFCPh5yHqZeye1CSQtnpky39+y1/4P6biAg6aQvuDwRNOS67VJwQgdQrz4GHaNCiSEtmxOMG7+kM2GqhpAfY6J1nn1eoWROqXL8UKFJekpAjHWzR0pddiZ5DV04EdipEHkrG+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tncSq6qx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tncSq6qx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418DFC2BBFC;
	Thu, 13 Jun 2024 12:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281251;
	bh=n7UeesZY/GDJISOrgQaoLfevs6ilKEFckfcpbrLHvpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tncSq6qxr1hTlOEgh66UyKsDVd+g3IrBm5UfXtpfNRRqE0mgWrdA+reoOPYCSyZSV
	 tIVhNbj1yiHncBDFHdcgx9/dEh0DOGO5R3xU1Za2cPSPQkp/AYPGFHw9E/MfmA2alJ
	 cVsoT7jio8jup2o5qsepzDvFz3EpesAmcVKghUXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Egorenkov <egorenar@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 191/317] s390/ipl: Fix incorrect initialization of len fields in nvme reipl block
Date: Thu, 13 Jun 2024 13:33:29 +0200
Message-ID: <20240613113254.945702166@linuxfoundation.org>
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

[ Upstream commit 9c922b73acaf39f867668d9cbe5dc69c23511f84 ]

Use correct symbolic constants IPL_BP_NVME_LEN and IPL_BP0_NVME_LEN
to initialize nvme reipl block when 'scp_data' sysfs attribute is
being updated. This bug had not been detected before because
the corresponding fcp and nvme symbolic constants are equal.

Fixes: 23a457b8d57d ("s390: nvme reipl")
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/ipl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index c469e8848d659..ab23742088d05 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -832,8 +832,8 @@ static ssize_t reipl_nvme_scpdata_write(struct file *filp, struct kobject *kobj,
 		scpdata_len += padding;
 	}
 
-	reipl_block_nvme->hdr.len = IPL_BP_FCP_LEN + scpdata_len;
-	reipl_block_nvme->nvme.len = IPL_BP0_FCP_LEN + scpdata_len;
+	reipl_block_nvme->hdr.len = IPL_BP_NVME_LEN + scpdata_len;
+	reipl_block_nvme->nvme.len = IPL_BP0_NVME_LEN + scpdata_len;
 	reipl_block_nvme->nvme.scp_data_len = scpdata_len;
 
 	return count;
-- 
2.43.0



