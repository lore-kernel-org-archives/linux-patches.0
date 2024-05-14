Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42376135A4A;
	Tue, 14 May 2024 10:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682861; cv=none; b=iMOdGMMvys+m4Y7Sic2yH6w3ed9AfwztD8VU9gZT/PRtvG6xul9fLIej0sffWVZ4gXZ03IhE7fJneqTdvphlqwcvYWhi2Tp7cdAVhgiZchae01BJ7AVaFpSr657q/YXfgSD8+HbIQS8+ACpIKD/E5xvXs6TNI+QNeflm3BOhxUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682861; c=relaxed/simple;
	bh=E4u9VvzLWRs+1Vx0IMSE72Dn1WV4LRiC4DqLbT7JdS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amDe+U9VOxYGYYK4UKd+DHijYLKQRDeuB1reOPNchJdzmXVE0c9XiS/NfbjLha0g6V42ZZ58JTGUQ8qUofkyJOOgESR4qXEhKefJXx8p1hzpPa5ZPhjCjdat1eGJFKnFV2EJkPK6d7He/KELlXv00b0uSotsKeLRr8XirBYA9fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fTxjMuDG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fTxjMuDG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4690C2BD10;
	Tue, 14 May 2024 10:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682861;
	bh=E4u9VvzLWRs+1Vx0IMSE72Dn1WV4LRiC4DqLbT7JdS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fTxjMuDGHq0tr0WxeMEuDXdWDS498bKnR/Pp3TQBwwfga/2s6/5ffSdKeCJIsHsZt
	 58f3qXqJhEtzAkA3WIZ/sdIMfDF4/U8FM4t7Biv9s1L1F52BVKZig8mPyF2ngDGacz
	 5hrVh98SUDYSGTpW8A7qxzhYy0Qw4aExVEdqEnu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@huawei.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 124/336] scsi: libsas: Align SMP request allocation to ARCH_DMA_MINALIGN
Date: Tue, 14 May 2024 12:15:28 +0200
Message-ID: <20240514101043.284563424@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yihang Li <liyihang9@huawei.com>

[ Upstream commit e675a4fd6d1f8990d3bed5dada3d20edfa000423 ]

This series [1] reduced the kmalloc() minimum alignment on arm64 to 8 bytes
(from 128). In libsas, this will cause SMP requests to be 8-byte aligned
through kmalloc() allocation. However, for hisi_sas hardware, all command
addresses must be 16-byte-aligned. Otherwise, the commands fail to be
executed.

ARCH_DMA_MINALIGN represents the minimum (static) alignment for safe DMA
operations, so use ARCH_DMA_MINALIGN as the alignment for SMP request.

Link: https://lkml.kernel.org/r/20230612153201.554742-1-catalin.marinas@arm.com [1]
Signed-off-by: Yihang Li <liyihang9@huawei.com>
Link: https://lore.kernel.org/r/20240328090626.621147-1-liyihang9@huawei.com
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libsas/sas_expander.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 5c261005b74e4..f6e6db8b8aba9 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -135,7 +135,7 @@ static int smp_execute_task(struct domain_device *dev, void *req, int req_size,
 
 static inline void *alloc_smp_req(int size)
 {
-	u8 *p = kzalloc(size, GFP_KERNEL);
+	u8 *p = kzalloc(ALIGN(size, ARCH_DMA_MINALIGN), GFP_KERNEL);
 	if (p)
 		p[0] = SMP_REQUEST;
 	return p;
-- 
2.43.0



