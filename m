Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50BE47CA63;
	Sat, 12 Sep 2026 13:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219599; cv=none; b=auB7ItLI8rm9Rs0jJ5W8/nPSXNsvjzFT//bIz9omgvTkCrXhTBoxnYEKOsZzErCNRyACZNzibrNgmsCHW7jXFqilFMS8QnaRV8SgIMblo1wCmFlOtRMT9vfUv/Fn6Y9ua+SzHnX7KJRaXnR33PhZFYo64UC3xe+KzC4RcFUy1c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219599; c=relaxed/simple;
	bh=xOwbtotPZObhOK2cBPh3ADTbxtDSzKDR3oGxpdBXels=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DwwOenLnPHrmVtzMDBAt1p1XuoedEA4pi6Kjc5tCszxH3C4Gxa7v264pZBE0e+gbeW+uA1iFWi49cvQaKUmcUqvDWdyZ/nR3IA9vMdcSmfJsTQ8DrsM0JBWexfQNYrMvyx2DWTf1RU1ulEDndu6YY36XliOpi9FQhvu8SEjYka8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SclnTgdX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SclnTgdX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 635581F000FF;
	Sat, 12 Sep 2026 13:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219598;
	bh=aPqKA+QvsVAZ7g/Wo/h7/HNQxEM8XfV7lKxiU5GXCTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SclnTgdXQRIbk1gLeq1W7D4EB3gGso8Ek0O9OdYEDNwaz9ZpBkH0rnsYnUFf6StTm
	 FvDxGl1U6PRQhMc9t3Prk01zv63PJfzOJwXxuOFi9QOxPbD8WYGWJQLPmMgIB9/IW8
	 7hAEUdmCEj71EhNCzTeUc6UT9loMs3wpaIsxclxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1348/1376] scsi: sd: Fix error handling in sd_probe() after large pool creation failure
Date: Sat, 12 Sep 2026 09:02:54 +0200
Message-ID: <20260912065637.575288508@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Yang Xiuwei <yangxiuwei@kylinos.cn>

[ Upstream commit e3cc6ea1a745e7f5d326f919a428b244fa119d8f ]

After device_add(&sdkp->disk_dev) succeeds, sd_large_pool_create()
failure must unregister disk_dev and let scsi_disk_release() free
sdkp. Going through out_free_index kfree()s an already registered device
and leaks the sysfs entry.

Fixes: 7179e626b76e ("scsi: sd: Enable sector size > PAGE_SIZE in SCSI sd driver")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Link: https://patch.msgid.link/20260707030333.22245-2-yangxiuwei@kylinos.cn
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3b32d9356b204..b063ac7e7b34d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4063,7 +4063,9 @@ static int sd_probe(struct scsi_device *sdp)
 	if (sdp->sector_size > PAGE_SIZE) {
 		if (sd_large_pool_create()) {
 			error = -ENOMEM;
-			goto out_free_index;
+			device_unregister(&sdkp->disk_dev);
+			put_disk(gd);
+			goto out;
 		}
 	}
 
-- 
2.53.0



