Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BCD262BE;
	Mon, 27 May 2024 19:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838100; cv=none; b=oEhU9iBgjhavSiqDjfiKgVrCudTxvFbM3Yiu2F/BB3WTeC21Ls3vEzWTMbgoEE9bzPc3rdHf7YK6+CTA8HgQksvkCsd/BhRe2peBniuMwEMe6mQdtj4A8vw1jm3vBPS6ewvZAvqJncneoVmESLifWn0Is7dGqEwDC3ebsysPfcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838100; c=relaxed/simple;
	bh=caXAhLDh9JPsrA09zvjJp+pa4CgbIvHkQQTFQQZkOBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QPO0MyvjJMQzQ9lnE2hegBaG/XKB2PLZ6eBfvLXRVLAe6YKfv3NXaQvFcFOkJLQXdBf90B/4Ey2d369CS+nSWYJpg+q5T0xwC7oRGREoZHhXEJH5ULlqdSRkx0+dkn7L/PYAVmPynlMBhCHGpluPNVDAUmGcupkLqQ9EdQzzWkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I4gooz6l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I4gooz6l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D27ABC2BBFC;
	Mon, 27 May 2024 19:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838100;
	bh=caXAhLDh9JPsrA09zvjJp+pa4CgbIvHkQQTFQQZkOBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I4gooz6l7cITgdiqhFzC4jFb5Fc1kPCevwI5oY2P/ylWdc0wGo/8gKnTYO6EcaJIg
	 tI84S3SguBpSRssTpUHAIqLpe5WEbO0jaP85Bme98CSwzIjuVfwuA/hTv0Edkhc4kK
	 fluKIaZoafLNQ2j2Ouk2sYDZ/2nHvDkKuIXEjKCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuri Karpov <YKarpov@ispras.ru>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 224/493] scsi: hpsa: Fix allocation size for Scsi_Host private data
Date: Mon, 27 May 2024 20:53:46 +0200
Message-ID: <20240527185637.631132867@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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
index af18d20f30794..49c57a9c110b5 100644
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



