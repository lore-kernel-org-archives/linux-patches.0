Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2FE11706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:03:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F178C433C8;
	Mon, 11 Sep 2023 15:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444611;
	bh=pm/GNvWnQPPRI/ws4JhZLxaL92i/qrBvu6uZPpKVeGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mVlD6wErfu4mx0COYErgiQcAAM2ZNAhgGjrnyXvbmb1DceK7Vj8Jc4tF1plXwy0K1
	 X92cBSFyG3VDZuQ4SqCt213eEZXch8PewyvdWjR9h/AwMSdYyYhaDTxbmZ6mR3gUXH
	 HKdPF5hZf2GrFmpb1wCIqw0jLeq7CIW8X/9ItH/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Haberland <sth@linux.ibm.com>,
	Jan Hoeppner <hoeppner@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 025/600] s390/dasd: use correct number of retries for ERP requests
Date: Mon, 11 Sep 2023 15:40:58 +0200
Message-ID: <20230911134634.355100671@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Haberland <sth@linux.ibm.com>

[ Upstream commit acea28a6b74f458defda7417d2217b051ba7d444 ]

If a DASD request fails an error recovery procedure (ERP) request might
be built as a copy of the original request to do error recovery.

The ERP request gets a number of retries assigned.
This number is always 256 no matter what other value might have been set
for the original request. This is not what is expected when a user
specifies a certain amount of retries for the device via sysfs.

Correctly use the number of retries of the original request for ERP
requests.

Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Reviewed-by: Jan Hoeppner <hoeppner@linux.ibm.com>
Link: https://lore.kernel.org/r/20230721193647.3889634-3-sth@linux.ibm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/block/dasd_3990_erp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/block/dasd_3990_erp.c b/drivers/s390/block/dasd_3990_erp.c
index d030fe2e29643..91cb9d52a4250 100644
--- a/drivers/s390/block/dasd_3990_erp.c
+++ b/drivers/s390/block/dasd_3990_erp.c
@@ -2441,7 +2441,7 @@ static struct dasd_ccw_req *dasd_3990_erp_add_erp(struct dasd_ccw_req *cqr)
 	erp->block    = cqr->block;
 	erp->magic    = cqr->magic;
 	erp->expires  = cqr->expires;
-	erp->retries  = 256;
+	erp->retries  = device->default_retries;
 	erp->buildclk = get_tod_clock();
 	erp->status = DASD_CQR_FILLED;
 
-- 
2.40.1



