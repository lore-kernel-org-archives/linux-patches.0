Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C371A680D;
	Mon, 23 Mar 2026 14:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275540; cv=none; b=ef50JaH4maMKLlULqvm1v86lrVc3fhJCN7qQlj9BKRFPTJOEentS6sj1SaHvedMlWoI2Eu0B6fHMGQZ2jDASgTjr2MvoojX2ycRU5xRxzrxdcJlr/sjf8LOJtljc413vYXJZ7UR6Acmwqx4QLIFhcd+g5sxNKaJhGtMG9E3QbQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275540; c=relaxed/simple;
	bh=llzlygYVS1/+pwm0RTDECJfCtZdyg4nz//PZlOet4WI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R2/cPUfvlKmIJ3rmdG2ELY5whqMYCjKSk7rffwQRd8tEL9RLT7NqlPs/u9DneJ/xSn6YzSH2zpqXcPl9/uvf18Cp7vnPdGoXsdtxlf4xYWMyvlULFJ5fk4OeyZoIkpVITSchJuJZNKBm4Gs1DMD/7i75mfIm26JKbId5jM2aVXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CZ3BfZ7J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CZ3BfZ7J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD73C4CEF7;
	Mon, 23 Mar 2026 14:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275540;
	bh=llzlygYVS1/+pwm0RTDECJfCtZdyg4nz//PZlOet4WI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CZ3BfZ7J4FK7VjnS6WjbqWw+6xzMGhXJuT6xCMY+FEYP8yPceg9g3LTd1JaNy+iUr
	 ZRH4N7PxgaYT3KIiWuzLvZS8Aw5sBD4vFUM4VT9zI4WqqzeHALMn2RfmYFJHmESk8L
	 uV1ki+mWqWrnGBGFyCu4fj282bz1Agac3G3PJ8AU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	Yihang Li <liyihang9@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 136/460] scsi: hisi_sas: Add time interval between two H2D FIS following soft reset spec
Date: Mon, 23 Mar 2026 14:42:12 +0100
Message-ID: <20260323134529.942116538@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

[ Upstream commit 3c62791322e42d1afd65acfdb5b3a371bde21ede ]

Spec says at least 5us between two H2D FIS when do soft reset, but be
generous and sleep for about 1ms.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Link: https://lore.kernel.org/r/20241008021822.2617339-11-liyihang9@huawei.com
Reviewed-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 8ddc0c269165 ("scsi: hisi_sas: Fix NULL pointer exception during user_scan()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index d9500b7306905..43d2ca4c6605f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1341,6 +1341,7 @@ static int hisi_sas_softreset_ata_disk(struct domain_device *device)
 	}
 
 	if (rc == TMF_RESP_FUNC_COMPLETE) {
+		usleep_range(900, 1000);
 		ata_for_each_link(link, ap, EDGE) {
 			int pmp = sata_srst_pmp(link);
 
-- 
2.51.0



