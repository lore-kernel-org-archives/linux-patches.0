Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A2A2C028F;
	Thu, 15 Jan 2026 17:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496527; cv=none; b=aTrjs87zMD0JjVJnzN+vkGJADoKV2MI4uwzJH0Jzx5P5UY4HtsqqZ9xWT3oZ9Q5HR+YmFmVe5r1kmLyVdIPBjxsUI223Nd0qs/uGEGqw1u7+JXvzsJq1ieDjoQWDLDi54gl7+9pm+u8cnw0gzZbr2Nn7hfH68zUvqW5qCQEdNDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496527; c=relaxed/simple;
	bh=V9uIGD4ABcMLdIaNUt1Ht7hu+CGCjZnO3Q8SAcqa+bI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D+pXObocJiS1sPAmdCG93E+JdypQyMwam3E8EQpOjLnSSk9qHNnHp1Ug7ASxcabs3bwrYOwDu87ylLjuqvl9RnrbJLXDtnAggxxW3dVZ1TdS54ctEbMHlTRFSbGC2lKsdSCgV9mBY+VqEE730ygajVK43SHijOa9E4h/X20m+Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ugXbE272; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ugXbE272"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F3DDC116D0;
	Thu, 15 Jan 2026 17:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496526;
	bh=V9uIGD4ABcMLdIaNUt1Ht7hu+CGCjZnO3Q8SAcqa+bI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ugXbE272Oz5a11EraPqoRiryPcKDi0M2Ky8YmDCaZ+kSM4LvQOfomN8R7R5jglV2i
	 R6DEWrGsweS2MUYa5MxgKk4UBSblnzsn+KQestrMeJ6Waa9kbHB3jTLgESEqB5f4cP
	 d0jnl0wHm58313d22IRQ5nYUSbQZ5XD0wPtYOy6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	Jason Yan <yanaijie@huawei.com>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 044/119] scsi: Revert "scsi: libsas: Fix exp-attached device scan after probe failure scanned in again after probe failed"
Date: Thu, 15 Jan 2026 17:47:39 +0100
Message-ID: <20260115164153.550365622@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xingui Yang <yangxingui@huawei.com>

[ Upstream commit 278712d20bc8ec29d1ad6ef9bdae9000ef2c220c ]

This reverts commit ab2068a6fb84751836a84c26ca72b3beb349619d.

When probing the exp-attached sata device, libsas/libata will issue a
hard reset in sas_probe_sata() -> ata_sas_async_probe(), then a
broadcast event will be received after the disk probe fails, and this
commit causes the probe will be re-executed on the disk, and a faulty
disk may get into an indefinite loop of probe.

Therefore, revert this commit, although it can fix some temporary issues
with disk probe failure.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Link: https://patch.msgid.link/20251202065627.140361-1-yangxingui@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libsas/sas_internal.h | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 03d6ec1eb970b..85948963fb97a 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -145,20 +145,6 @@ static inline void sas_fail_probe(struct domain_device *dev, const char *func, i
 		func, dev->parent ? "exp-attached" :
 		"direct-attached",
 		SAS_ADDR(dev->sas_addr), err);
-
-	/*
-	 * If the device probe failed, the expander phy attached address
-	 * needs to be reset so that the phy will not be treated as flutter
-	 * in the next revalidation
-	 */
-	if (dev->parent && !dev_is_expander(dev->dev_type)) {
-		struct sas_phy *phy = dev->phy;
-		struct domain_device *parent = dev->parent;
-		struct ex_phy *ex_phy = &parent->ex_dev.ex_phy[phy->number];
-
-		memset(ex_phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
-	}
-
 	sas_unregister_dev(dev->port, dev);
 }
 
-- 
2.51.0



