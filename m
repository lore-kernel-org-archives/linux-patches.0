Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0DB1993A0;
	Thu,  6 Jun 2024 14:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683253; cv=none; b=bvUiAQzCWcc/nftIlq8wrM/ijMl6brRsC7OnWW3f6p80uEsv/0HedeZv5oOfqmno1+bMNvC07t9GRKUhvOked8z7T/+KC91LVfi5G0rWx0CGV65ShvxsupQUYovSwK2O3yzA8jUraF9mTLvuSOA0bK/i1JoxXt4N/hvzObuZ5kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683253; c=relaxed/simple;
	bh=1sV57Vu/vwTVEncKC7uYLbz0JQMTFsl64GHC4pu+VKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kBEV2ZuHPd1MexOQ8g44KRm9X4NfQcHDgNnhqDJFR6WeUl5MzV35tNypN+WDuXe0sZ+QKHPvDFa7hstbCtRPxOqkHCqhymruwEFpaiRXesFJxY6OCyghc6EceXxtuz9X7VIVG8BLS2qPb1IEVgn1GCE8NXEV/tuwrsUnmUmAhaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R70xDgIw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R70xDgIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3185C2BD10;
	Thu,  6 Jun 2024 14:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683252;
	bh=1sV57Vu/vwTVEncKC7uYLbz0JQMTFsl64GHC4pu+VKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R70xDgIwVvMYs/MaPHDjT0VK1ahZCqcQBGAuGjMEY/mS54j/gwd4XiVq6gOEQuRbn
	 ipzIzTGHMKjttPr3/s4xuatRt/3pQUCIqeOpzknOUn1P4vgWtFYxCusivelh3kxDAn
	 SHvRkGTTGjpEzAWljgge1pC1VE6oTGvA0KRqWjkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuri Karpov <YKarpov@ispras.ru>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 129/473] scsi: hpsa: Fix allocation size for Scsi_Host private data
Date: Thu,  6 Jun 2024 16:00:58 +0200
Message-ID: <20240606131704.200508602@linuxfoundation.org>
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
index f6da34850af9d..e529b3d3eaf39 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5850,7 +5850,7 @@ static int hpsa_scsi_host_alloc(struct ctlr_info *h)
 {
 	struct Scsi_Host *sh;
 
-	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(struct ctlr_info));
+	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(struct ctlr_info *));
 	if (sh == NULL) {
 		dev_err(&h->pdev->dev, "scsi_host_alloc failed\n");
 		return -ENOMEM;
-- 
2.43.0



