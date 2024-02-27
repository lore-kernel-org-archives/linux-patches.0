Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F23F14264A;
	Tue, 27 Feb 2024 13:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042110; cv=none; b=dy71lPGybbtBfnQDqOBM+7b0mlpvXJtdf1Iq4ZwemzKObAcsg2xGQuVPCy2YceuDpbBWUGjN773UM/9xWn6dFQIeIDXirhLFuXDsuhFZbqaNRZ9RX0PLj9Tcc0zfBhC/FZbsw8I5J8SwIbpffkE/AN+K9oLdcfXeyzRtLBAHM78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042110; c=relaxed/simple;
	bh=VVeiTU9tZD0pvTDYzrXDQlVGrCjYlFIpj/TxcQsB09U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ANb4NndchwyqtfKII3xp4Kg8q0Wn2Up8pLt5AxC7gGjh71B45rFbrQuarvja9eNc8s+ynjGuMA4dW9ow7JUI7LPNLXXFm5uxn3AibshXw4YekygVHh3OvtAsrM0dRFYCw8gn6PN6N+0T5XzL5j1Eu1knz2W9OlQKVEJW+pNXrxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kWQZ6tQi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kWQZ6tQi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF145C433F1;
	Tue, 27 Feb 2024 13:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042110;
	bh=VVeiTU9tZD0pvTDYzrXDQlVGrCjYlFIpj/TxcQsB09U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kWQZ6tQi+dcKfdJidnSORfLnFucsji0HX3QXx7uI88ULg82+fxgmJRP+Hsde/7pS/
	 jvhAHiS+3TWCiESjV7hDIlz8EoAFIG9EhVrq2XcZSzsapqOr46LrCGvkg2ooEdz3R2
	 oukXvcfPJ+uk1FT/yMkJdWIC9TrAsQW9uMQb4Sa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 155/299] scsi: target: pscsi: Fix bio_put() for error case
Date: Tue, 27 Feb 2024 14:24:26 +0100
Message-ID: <20240227131630.850066811@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Naohiro Aota <naohiro.aota@wdc.com>

commit de959094eb2197636f7c803af0943cb9d3b35804 upstream.

As of commit 066ff571011d ("block: turn bio_kmalloc into a simple kmalloc
wrapper"), a bio allocated by bio_kmalloc() must be freed by bio_uninit()
and kfree(). That is not done properly for the error case, hitting WARN and
NULL pointer dereference in bio_free().

Fixes: 066ff571011d ("block: turn bio_kmalloc into a simple kmalloc wrapper")
CC: stable@vger.kernel.org # 6.1+
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Link: https://lore.kernel.org/r/20240214144356.101814-1-naohiro.aota@wdc.com
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/target/target_core_pscsi.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -907,12 +907,15 @@ new_bio:
 
 	return 0;
 fail:
-	if (bio)
-		bio_put(bio);
+	if (bio) {
+		bio_uninit(bio);
+		kfree(bio);
+	}
 	while (req->bio) {
 		bio = req->bio;
 		req->bio = bio->bi_next;
-		bio_put(bio);
+		bio_uninit(bio);
+		kfree(bio);
 	}
 	req->biotail = NULL;
 	return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;


