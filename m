Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE502820C6;
	Thu, 15 Jan 2026 17:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496904; cv=none; b=SMWZAvlr8kX5mxwMdxtVtUytfmyuk2uHq8kELsKe0wUhIJpDkNVuDsqVy1aiPR/aVHBtZP+xE3zNyRb8Cv9oJLEhdE0gu+LtYwp+YgXrgBt16yKfYlRMwK192J3TmMaRxy4sOGAQclj9k1KogbKgWm+jkaji+hLKXe8Nc6sCsnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496904; c=relaxed/simple;
	bh=vEHe7qyGdCcdFbOvk6vZ3uS6KmO0A+YKn+DNesbTqNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rgzzo9ErbAkozXw0ayZISbF7203GcdQmk+xnE12irjb+bUPhSuOmXP4FzFJf3Gm87DvjYN1zfTqMu6M5uybIOlioHpCCpLGmc0cQWebMI/dklPrEM7vY+oQSg196gx1RncJeZw5b2/LJ7NJQ6LmYzdFsfF/H2BNqVLRa0yT5DIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hVd88MVi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hVd88MVi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C3BC116D0;
	Thu, 15 Jan 2026 17:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496904;
	bh=vEHe7qyGdCcdFbOvk6vZ3uS6KmO0A+YKn+DNesbTqNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hVd88MViCJkOvtq0hwT7iPIcLlkmzzO5KR1YPzPKBMQgWY2twKHjBVwOBsMq3lEFl
	 J6FVx0jE8xeljr62XqdzqQfioAlT93t9MthQzw7pDnv/LllaIpNLh4nBJ4TW8Je3UJ
	 FA7RFII/4hNe4MRLUOGr8lO/AdCk0NOk1dBYN25E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	Jason Yan <yanaijie@huawei.com>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 39/88] scsi: Revert "scsi: libsas: Fix exp-attached device scan after probe failure scanned in again after probe failed"
Date: Thu, 15 Jan 2026 17:48:22 +0100
Message-ID: <20260115164147.726454239@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 277e45fed85d6..a6dc7dc07fce3 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -133,20 +133,6 @@ static inline void sas_fail_probe(struct domain_device *dev, const char *func, i
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



