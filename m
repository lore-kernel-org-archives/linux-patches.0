Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02EDD158211;
	Tue, 23 Jul 2024 18:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759787; cv=none; b=Ncfb1btNhE5gM9s3CfiVYr4PgSAo3O1rN48wic7xBnZOUrjkhLf2tKpM2jSdMn+YSR88PUQU7YenvsME4+xEZF+8+RB+VeoHUuZLTzeHEJ/HUmFxBGzyYRonhnEcJst5XpEuXm//xYI1HhZFQxX6EXcLBzXxwz0/qwWvruWREwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759787; c=relaxed/simple;
	bh=7HHJiThQAYMyVIWiIxwV7O5aibjUSqxfkkRxABvId/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TNvzcvhHVy4iN+mD3nAtvn8jTaYQ910PpCRwCTRjjiQR+kVjJOrQqxuDtjFN2ubJGiwqYvCnyejXOS6N548gfcq2CwbbaOhlnGsbt2Nkdr+IgMFzepIcsLnj3SUMYnYsKkG1R8ZOA6oB8+J51VDL6Ce4K19hqaBT5oX6r6eTY0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I8y7V8mY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I8y7V8mY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F13C4AF11;
	Tue, 23 Jul 2024 18:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759786;
	bh=7HHJiThQAYMyVIWiIxwV7O5aibjUSqxfkkRxABvId/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I8y7V8mYibKcUJHwn36g31CKLZu+jG9WxlsXEQcyQJ4EYC68pvsEI0uZPxy2KwMqh
	 +nJDgDF32GAbl4f148WW4eYQgVlmv5NOkheMvmvfoVwiK+PK5QU+zO3OnEfqI9lieN
	 hHwqZZzBbr6nUhEZQBsmUY71qJM1gptN8gREsFJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 096/129] scsi: libsas: Fix exp-attached device scan after probe failure scanned in again after probe failed
Date: Tue, 23 Jul 2024 20:24:04 +0200
Message-ID: <20240723180408.497132569@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xingui Yang <yangxingui@huawei.com>

[ Upstream commit ab2068a6fb84751836a84c26ca72b3beb349619d ]

The expander phy will be treated as broadcast flutter in the next
revalidation after the exp-attached end device probe failed, as follows:

[78779.654026] sas: broadcast received: 0
[78779.654037] sas: REVALIDATING DOMAIN on port 0, pid:10
[78779.654680] sas: ex 500e004aaaaaaa1f phy05 change count has changed
[78779.662977] sas: ex 500e004aaaaaaa1f phy05 originated BROADCAST(CHANGE)
[78779.662986] sas: ex 500e004aaaaaaa1f phy05 new device attached
[78779.663079] sas: ex 500e004aaaaaaa1f phy05:U:8 attached: 500e004aaaaaaa05 (stp)
[78779.693542] hisi_sas_v3_hw 0000:b4:02.0: dev[16:5] found
[78779.701155] sas: done REVALIDATING DOMAIN on port 0, pid:10, res 0x0
[78779.707864] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
...
[78835.161307] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
[78835.171344] sas: sas_probe_sata: for exp-attached device 500e004aaaaaaa05 returned -19
[78835.180879] hisi_sas_v3_hw 0000:b4:02.0: dev[16:5] is gone
[78835.187487] sas: broadcast received: 0
[78835.187504] sas: REVALIDATING DOMAIN on port 0, pid:10
[78835.188263] sas: ex 500e004aaaaaaa1f phy05 change count has changed
[78835.195870] sas: ex 500e004aaaaaaa1f phy05 originated BROADCAST(CHANGE)
[78835.195875] sas: ex 500e004aaaaaaa1f rediscovering phy05
[78835.196022] sas: ex 500e004aaaaaaa1f phy05:U:A attached: 500e004aaaaaaa05 (stp)
[78835.196026] sas: ex 500e004aaaaaaa1f phy05 broadcast flutter
[78835.197615] sas: done REVALIDATING DOMAIN on port 0, pid:10, res 0x0

The cause of the problem is that the related ex_phy's attached_sas_addr was
not cleared after the end device probe failed, so reset it.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Link: https://lore.kernel.org/r/20240619091742.25465-1-yangxingui@huawei.com
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libsas/sas_internal.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index a6dc7dc07fce3..277e45fed85d6 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -133,6 +133,20 @@ static inline void sas_fail_probe(struct domain_device *dev, const char *func, i
 		func, dev->parent ? "exp-attached" :
 		"direct-attached",
 		SAS_ADDR(dev->sas_addr), err);
+
+	/*
+	 * If the device probe failed, the expander phy attached address
+	 * needs to be reset so that the phy will not be treated as flutter
+	 * in the next revalidation
+	 */
+	if (dev->parent && !dev_is_expander(dev->dev_type)) {
+		struct sas_phy *phy = dev->phy;
+		struct domain_device *parent = dev->parent;
+		struct ex_phy *ex_phy = &parent->ex_dev.ex_phy[phy->number];
+
+		memset(ex_phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
+	}
+
 	sas_unregister_dev(dev->port, dev);
 }
 
-- 
2.43.0



