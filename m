Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51BB547886A;
	Sat, 12 Sep 2026 11:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212663; cv=none; b=CeWnViF+qI9QXeHtQX16IepVrQZtKy4vDmE0Uiw+0MposO2GaIwjfedKfu2tEyNH8iYU6f7GYCmaihcu25NhiBvV8Snb7KNKjE5W134WQVt/HIbSMhkZaFxtgsXFykRZ86lF3IFHMqG+Dpqp7bieXpSb9MRTpY4hV2Zf5SfQxDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212663; c=relaxed/simple;
	bh=UgnihiCHCdxzg5XIRXe8W1H2r9J7eVzS49R7+sS3OpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PcnBKc3o8zQzAljmUC9CwFKk0i5JPqDYygXq/3JzCSZxwp9aXShLhSWrx8rra9Q1xhUJLv75g16LfOlEWCRY0RaUq+gADHT2O9jnrQNoZ5wQqZfd2q2B47B+AxCxlaPf/5bpay+fnyE8+QDgwvn51yJ+tyveiTGNt8dYIQZbHcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BUomkH5W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BUomkH5W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C501F000FF;
	Sat, 12 Sep 2026 11:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212662;
	bh=BTx0MeuInveb0V3hFYxeZQ8g5a9qF41nPRSFd+ZHwCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BUomkH5WlHV91Guu+/yOCRpp75hnY6wFqdGTSf4qFfwUkCysZdcQNdEJ6+2HmLgjz
	 Srn7TrGWNXJWh6PftqUWZBjyAxljOxfWDl3vBVwkk8Gy7wwfoRvMw8oue82c3ljuH1
	 dGhuzFEYVUbcSacolabqYu8syii5dtDT9TCel3qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1483/1518] scsi: sd: Fix error handling in sd_probe() after large pool creation failure
Date: Sat, 12 Sep 2026 09:00:52 +0200
Message-ID: <20260912065657.109489325@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ff6b953da68a7..58d28c80c93a9 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4060,7 +4060,9 @@ static int sd_probe(struct scsi_device *sdp)
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



