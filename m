Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5936E757EA;
	Mon, 15 Apr 2024 14:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191130; cv=none; b=rrf8LoqVysJ9CsccqzGecOnHIYWbTL2uOGS1mkst28hQa8tTIrkDSSw6wxuZDJUGYUa8uVWBujJ8lr7KrKkpCP74dilcPg7rC0tI9sFmSfESxxsWtm1BfAVlrhHtQF/ROPihI/yiglmFYDqErIntjS6c3EGMt+t9TA4b0njd3ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191130; c=relaxed/simple;
	bh=z8IkLK4wIZWRk8nqjQKV+v9kJ2bRU0RAQel9D9M3nPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eFgi83gAXiEYBMZB11N/qyKf9df8ZaNuVYGE3PVhJqrrsPzrbkDtqyidBt+aD4QAYWYR+9xdLQfUVnMklB8WXK9KlQUlm8YBUBA8G0rBHWg3Qdxl3U1m5VfkVcXUHHT2j5yXQ3GSO4+2gVajEOiKYwEwqPyV1An8dnPyUiXM2H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x8s0SuN8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x8s0SuN8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D224FC113CC;
	Mon, 15 Apr 2024 14:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191130;
	bh=z8IkLK4wIZWRk8nqjQKV+v9kJ2bRU0RAQel9D9M3nPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x8s0SuN8GLmA38/M7eDH6J0cNJjZkcgFYJr6hyeCxwdBWcLzmaDPjqH7UIEsufp94
	 HWyEZ8XE/jI5g+tJONyVnTvN4lFJt7GBEnHblyK1pKCJAlkSVYsDMJowZ2zQYkURIJ
	 tC0g2RCrytF/PU5xS3t+Mp0P/K0eOhCb6rNxFvLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xiabing <xiabing12@h-partners.com>,
	Yihang Li <liyihang9@huawei.com>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 041/172] scsi: hisi_sas: Modify the deadline for ata_wait_after_reset()
Date: Mon, 15 Apr 2024 16:19:00 +0200
Message-ID: <20240415142001.671547142@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

From: Xiang Chen <chenxiang66@hisilicon.com>

[ Upstream commit 0098c55e0881f0b32591f2110410d5c8b7f9bd5a ]

We found that the second parameter of function ata_wait_after_reset() is
incorrectly used. We call smp_ata_check_ready_type() to poll the device
type until the 30s timeout, so the correct deadline should be (jiffies +
30000).

Fixes: 3c2673a09cf1 ("scsi: hisi_sas: Fix SATA devices missing issue during I_T nexus reset")
Co-developed-by: xiabing <xiabing12@h-partners.com>
Signed-off-by: xiabing <xiabing12@h-partners.com>
Co-developed-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Link: https://lore.kernel.org/r/20240402035513.2024241-3-chenxiang66@hisilicon.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 1abc62b07d24c..05c38e43f140a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1792,7 +1792,7 @@ static int hisi_sas_debug_I_T_nexus_reset(struct domain_device *device)
 	if (dev_is_sata(device)) {
 		struct ata_link *link = &device->sata_dev.ap->link;
 
-		rc = ata_wait_after_reset(link, HISI_SAS_WAIT_PHYUP_TIMEOUT,
+		rc = ata_wait_after_reset(link, jiffies + HISI_SAS_WAIT_PHYUP_TIMEOUT,
 					  smp_ata_check_ready_type);
 	} else {
 		msleep(2000);
-- 
2.43.0



