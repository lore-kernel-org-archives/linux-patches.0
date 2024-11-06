Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CBA1DFDB2;
	Wed,  6 Nov 2024 12:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895963; cv=none; b=oPncGmb3g6wtJ1SiHFf0jB7xbKriC1IYa7dclgWl7VBEz6IvESKV1P2m0gQOzW/IU/a7rKBsUZIK6IhwNqDHrXQ+dLvSdZpjZKOR9gCWJzG7/S7QJ3aTWggRkjqc09PALzsXONzwsxsOTN96gx+y5tvI7Y9YELynJ+DfbYvZUY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895963; c=relaxed/simple;
	bh=02kXFyCj4+d5VnWCxIeFqZQplt90Xn1RKyKbTf0lEAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kyDBi5lo/bw7+0qGLo6y5rMN8DOXd3rqtSArSWYWiUzwjxPlG/lbKJN/zoYCp1x88t973GSNldMIMVv9eX6MabZcMKLmw6xOVrDFfzD1FbrffsMMKn0NCgTcApziZlB5ccE+iHOvmroXXymcD6ff9MNnaG+Fp3ilIufOTnCotmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yhpXM/rA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yhpXM/rA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E11EC4CECD;
	Wed,  6 Nov 2024 12:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895962;
	bh=02kXFyCj4+d5VnWCxIeFqZQplt90Xn1RKyKbTf0lEAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yhpXM/rAYi0qSuMPo22xDN3YmW74+QSb5VgBVxk08cP0t6gsK0cU//iGCTQu0P4XO
	 /SSKuHxCFeFGD4IBKpxDWbnSf1VIPam5Piy6unkoiyilmJBbPZ26mQnxtp7HRLcRYz
	 D34Rp6/F7+WN0OI9SmWBnpj0VAs4X6kS+Rstk4W8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 008/245] scsi: scsi_debug: Fix do_device_access() handling of unexpected SG copy length
Date: Wed,  6 Nov 2024 13:01:01 +0100
Message-ID: <20241106120319.449499887@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit d28d17a845600dd9f7de241de9b1528a1b138716 ]

If the sg_copy_buffer() call returns less than sdebug_sector_size, then
we drop out of the copy loop. However, we still report that we copied
the full expected amount, which is not proper.

Fix by keeping a running total and return that value.

Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
Reported-by: Colin Ian King <colin.i.king@gmail.com>
Suggested-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: John Garry <john.g.garry@oracle.com>
Link: https://lore.kernel.org/r/20241018101655.4207-1-john.g.garry@oracle.com
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index a9d8a9c62663e..e41698218e62f 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3652,7 +3652,7 @@ static int do_device_access(struct sdeb_store_info *sip, struct scsi_cmnd *scp,
 	enum dma_data_direction dir;
 	struct scsi_data_buffer *sdb = &scp->sdb;
 	u8 *fsp;
-	int i;
+	int i, total = 0;
 
 	/*
 	 * Even though reads are inherently atomic (in this driver), we expect
@@ -3689,18 +3689,16 @@ static int do_device_access(struct sdeb_store_info *sip, struct scsi_cmnd *scp,
 		   fsp + (block * sdebug_sector_size),
 		   sdebug_sector_size, sg_skip, do_write);
 		sdeb_data_sector_unlock(sip, do_write);
-		if (ret != sdebug_sector_size) {
-			ret += (i * sdebug_sector_size);
+		total += ret;
+		if (ret != sdebug_sector_size)
 			break;
-		}
 		sg_skip += sdebug_sector_size;
 		if (++block >= sdebug_store_sectors)
 			block = 0;
 	}
-	ret = num * sdebug_sector_size;
 	sdeb_data_unlock(sip, atomic);
 
-	return ret;
+	return total;
 }
 
 /* Returns number of bytes copied or -1 if error. */
-- 
2.43.0



