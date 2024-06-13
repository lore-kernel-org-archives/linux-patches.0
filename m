Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0D614883B;
	Thu, 13 Jun 2024 11:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279803; cv=none; b=ZQ2ydYOaZUgZ8iNDiKgqUz6Fr6jdOBE6q+g/HmxREpm2Jf5jcElQ23M4JOOTnxBSv/aCJeJimw3LawCA8run9D7jjbQZQOK9aSpO8ZzFyvyjye2wiLEJ5zSsHVfaLqWVao16BhFY/sFspsLbHqzcWyPptBAzBzUUnbpqOXodDOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279803; c=relaxed/simple;
	bh=E/48ChbXLW5R0WjUwo4CqzFGQpwq0rD+5krmkNFGeGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nPSrkYCa9/UCeqc7E2m/AdzPisqjt6ab/AQgmzpmGnAz+97GzKBoCRUyTH7s9GDZW5AiaRkjpkjLPULQmaZPk3lZ+mtZkfEaCAL5PeoWgvbFrTaqE264uFYqouUoJPEMsR1Clg2p272mIZaWpOVCTiimFtWggH8bwTmZFVYxt60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rKnXDRfp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rKnXDRfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851C3C2BBFC;
	Thu, 13 Jun 2024 11:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279802;
	bh=E/48ChbXLW5R0WjUwo4CqzFGQpwq0rD+5krmkNFGeGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rKnXDRfpWIhjXfMnozh/sw+xynScfLjKPq1C+TojQPEu6Ep/3lVGBqgdlCAPhrEc9
	 mIM/tPB/zHoIEUgwvShzDcwl8FTkEcVDXGLaKMqwmTP9uJ1VrE8t5X3XbhpPT0SAtK
	 77y+6ka1RaAsRffuqsi+k1Gk8alXT/3pJU1TYG30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuri Karpov <YKarpov@ispras.ru>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 041/202] scsi: hpsa: Fix allocation size for Scsi_Host private data
Date: Thu, 13 Jun 2024 13:32:19 +0200
Message-ID: <20240613113229.357180993@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index e670cce0cb6ef..b760477b57424 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5810,7 +5810,7 @@ static int hpsa_scsi_host_alloc(struct ctlr_info *h)
 {
 	struct Scsi_Host *sh;
 
-	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(struct ctlr_info));
+	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(struct ctlr_info *));
 	if (sh == NULL) {
 		dev_err(&h->pdev->dev, "scsi_host_alloc failed\n");
 		return -ENOMEM;
-- 
2.43.0



