Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7749144D2C;
	Thu, 13 Jun 2024 12:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280868; cv=none; b=VNlRdLWTeU+nXexTzISd2asvbtueQn4lutqys0UzHMc6L07Lrn1iNXH5lbZwM6niOn/ywU+6Pj+trcQXGustKcSiATZ2qq9+B7X/4zKvRcbFa3nSzNWt9IV71ofTJiKIBh4IjichM1o8iqIJpegQ1SkdNtk4wWOKrxaB0AydvL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280868; c=relaxed/simple;
	bh=2hcx5jvBXamuVyRDPPGaxdLBrGzyhlc7z3a+fsSPxI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FLld9jDyjIzJypVaGEjYuWwdJDkvuBgvp1SZFPK4EivweiiQqqJ4HKxNABHTBCLcs0K+TgMYHYK0Wus7d0vR07Y5D1f3OS28Yi32ZYxDfH6Rsqb7lVV24KYCpmKfCrkdxEFti9aoixzrBWtiUMZSrO0Sw5hzSqk5cktzKAmQUTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ORSqE5jZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ORSqE5jZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E74BFC2BBFC;
	Thu, 13 Jun 2024 12:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280868;
	bh=2hcx5jvBXamuVyRDPPGaxdLBrGzyhlc7z3a+fsSPxI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ORSqE5jZkvgbAvv82IMKaU2EfiTTqrMJlNDpRQ/BkbXSnYwq7xv0OTTwN4W9s3WHr
	 MRyboNMNpAZt340r4pWSpqP1YPkD4wD08ivxY2LUpF6x490BZlOnjFDATA3gaElHKy
	 dEdiv3k+D9uoameM+AtbxxeO+PZvgED7Lqd4yhzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuri Karpov <YKarpov@ispras.ru>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 060/317] scsi: hpsa: Fix allocation size for Scsi_Host private data
Date: Thu, 13 Jun 2024 13:31:18 +0200
Message-ID: <20240613113249.872473042@linuxfoundation.org>
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

From: Yuri Karpov <YKarpov@ispras.ru>

[ Upstream commit 504e2bed5d50610c1836046c0c195b0a6dba9c72 ]

struct Scsi_Host private data contains pointer to struct ctlr_info.

Restore allocation of only 8 bytes to store pointer in struct Scsi_Host
private data area.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: bbbd25499100 ("scsi: hpsa: Fix allocation size for scsi_host_alloc()")
Signed-off-by: Yuri Karpov <YKarpov@ispras.ru>
Link: https://lore.kernel.org/r/20240312170447.743709-1-YKarpov@ispras.ru
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index a44a098dbb9c7..4e7ec83c07cf6 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5834,7 +5834,7 @@ static int hpsa_scsi_host_alloc(struct ctlr_info *h)
 {
 	struct Scsi_Host *sh;
 
-	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(struct ctlr_info));
+	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(struct ctlr_info *));
 	if (sh == NULL) {
 		dev_err(&h->pdev->dev, "scsi_host_alloc failed\n");
 		return -ENOMEM;
-- 
2.43.0



