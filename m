Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BB9224AEB;
	Tue,  8 Apr 2025 11:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112329; cv=none; b=aFTbEmEcsuOd6YPNQdhKUVAi3G8oJUGdWKLik921vR4DybQFiDQUUSHmUghSVYjoiGgZPMxECbUFLJbG2Zcy/VW1x5ZbKhzN5G83Jfb0nanIyhU0hW4pOqGD27+m8fMYF5PSDRNTFPBHg2OIXZamM02Uiszif3/JzOdtAwnnD34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112329; c=relaxed/simple;
	bh=ty8dPpHfoxwoWFfpdXCFKT7pcpWpxJchnrASGFSpQr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IojFhK8qIxGtvVzt3LXUx6CMA0hPMunp6XvTG1kkv0OyC7M7E5aYO7GeRiYJAZ4VlHcI2IQi+OXGJ/Is2cNeTDlnOErVxId0RqjZ+0dRQ5FkArxjUKeCbu3FoSDx3kkkMyj0+CIAPuAcpWV7lva/asofoVs2BhzcWEb95MLVgp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XfaRpWtW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XfaRpWtW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F042C4CEE5;
	Tue,  8 Apr 2025 11:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112328;
	bh=ty8dPpHfoxwoWFfpdXCFKT7pcpWpxJchnrASGFSpQr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XfaRpWtWK8uev2Co2AnvuWwlZSrwkFu2mEaT990vEhBCmqrZ8F1ude6470//G552w
	 WfyRtzkN3JtSnAOYJDGldG9TpZogPmJqL+XfyK0Q/4QqixHvma6PcKs6k9ndoJXfzM
	 gWFZAkJsazKFKTqGinoYJIUVAPGDZEtwVQUKSCFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marc=20Aur=C3=A8le=20La=20France?= <tsi@tuyoix.net>,
	Rik van Riel <riel@surriel.com>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 028/279] scsi: core: Use GFP_NOIO to avoid circular locking dependency
Date: Tue,  8 Apr 2025 12:46:51 +0200
Message-ID: <20250408104827.140178837@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rik van Riel <riel@surriel.com>

[ Upstream commit 5363ee9d110e139584c2d92a0b640bc210588506 ]

Filesystems can write to disk from page reclaim with __GFP_FS
set. Marc found a case where scsi_realloc_sdev_budget_map() ends up in
page reclaim with GFP_KERNEL, where it could try to take filesystem
locks again, leading to a deadlock.

WARNING: possible circular locking dependency detected
6.13.0 #1 Not tainted
------------------------------------------------------
kswapd0/70 is trying to acquire lock:
ffff8881025d5d78 (&q->q_usage_counter(io)){++++}-{0:0}, at: blk_mq_submit_bio+0x461/0x6e0

but task is already holding lock:
ffffffff81ef5f40 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0x9f/0x760

The full lockdep splat can be found in Marc's report:

https://lkml.org/lkml/2025/1/24/1101

Avoid the potential deadlock by doing the allocation with GFP_NOIO, which
prevents both filesystem and block layer recursion.

Reported-by: Marc Aurèle La France <tsi@tuyoix.net>
Signed-off-by: Rik van Riel <riel@surriel.com>
Link: https://lore.kernel.org/r/20250129104525.0ae8421e@fangorn
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 9c155d5768144..f00b4624e46b5 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -229,7 +229,7 @@ static int scsi_realloc_sdev_budget_map(struct scsi_device *sdev,
 	}
 	ret = sbitmap_init_node(&sdev->budget_map,
 				scsi_device_max_queue_depth(sdev),
-				new_shift, GFP_KERNEL,
+				new_shift, GFP_NOIO,
 				sdev->request_queue->node, false, true);
 	if (!ret)
 		sbitmap_resize(&sdev->budget_map, depth);
-- 
2.39.5



