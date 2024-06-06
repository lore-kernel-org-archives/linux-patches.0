Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0FE198E79;
	Thu,  6 Jun 2024 14:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683468; cv=none; b=Nf457pvhOg89HAs6SRGsWxswC2Pb1J5L7v9xPqIp++6PcIsC2fDJLx5f82CN4OEYEJy+81gZ6CHVJjl6bDA4AU3oVC16bB67ezsBZeFaT70PFapOVyQJiihxh1VxGdXZi7iCkOeoyRdowidoaX9xxNdeBCvtcOLzwgmPQLHQD4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683468; c=relaxed/simple;
	bh=T6ckZg4ZBD677xsn0d9t8Ux2Zb6kuvNJADeRnRu6FzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E5GRmfRU0+5tR9MQHP4+YRzfiUMAy8o48rZkVZ4XQkJYW5D1m2ba8qwttWbaQMXpyzN7TQohE+IXX9bd+FEk0QXOM26oMXapdMN/DH560kZOiyBolfYd3iprWGcOTKrLbg3QWj3hExF4R2VeurgGgoG4spwr0V27BTxrfk04QRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v+a4i8Ju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v+a4i8Ju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F870C32786;
	Thu,  6 Jun 2024 14:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683468;
	bh=T6ckZg4ZBD677xsn0d9t8Ux2Zb6kuvNJADeRnRu6FzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v+a4i8JunZ7w5k/uKwReiqddWI665Jj0/C+qMwRrDcjB5dBZbiPhCpuFwhQa28HMQ
	 MYjsHkST42ptI4NgvOeGQRHXk+sImZHiqitf2YVvCC1EA77Vo6K41BHsaaKT0uBpkt
	 ZO+ax0gax2fD+oXJiO3ebxsKxXFUrp4bdHc5A73k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Egorenkov <egorenar@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 355/473] s390/ipl: Fix incorrect initialization of len fields in nvme reipl block
Date: Thu,  6 Jun 2024 16:04:44 +0200
Message-ID: <20240606131711.646022486@linuxfoundation.org>
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
index df5d2ec737d80..b06ec1d8815e3 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -834,8 +834,8 @@ static ssize_t reipl_nvme_scpdata_write(struct file *filp, struct kobject *kobj,
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



