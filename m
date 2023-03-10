Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D03848D
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:27:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5D8C433EF;
	Fri, 10 Mar 2023 14:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458442;
	bh=8OSjvR9c1Yk98G5cuFl6JHRq7lWmwm1Xw7XeEkkQASE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SooH1vVlqWnCMVHGg1Qka+5w+gihqzfkDKTYbLJJMZYN+NbbZKXOmyiSgbeVfHdtu
	 CTnbxTSEz+3SrSK4xUYLw00s91pyvSXgcqXw1ZX2f4uomreJB50Q4oGwbUVxrfhWx4
	 6wec57SFc5Vjm4kjA9SksrqB12bTWH6CrgiVP6Hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiheng Lin <linqiheng@huawei.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 028/357] s390/dasd: Fix potential memleak in dasd_eckd_init()
Date: Fri, 10 Mar 2023 14:35:17 +0100
Message-Id: <20230310133735.249983874@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Qiheng Lin <linqiheng@huawei.com>

[ Upstream commit 460e9bed82e49db1b823dcb4e421783854d86c40 ]

`dasd_reserve_req` is allocated before `dasd_vol_info_req`, and it
also needs to be freed before the error returns, just like the other
cases in this function.

Fixes: 9e12e54c7a8f ("s390/dasd: Handle out-of-space constraint")
Signed-off-by: Qiheng Lin <linqiheng@huawei.com>
Link: https://lore.kernel.org/r/20221208133809.16796-1-linqiheng@huawei.com
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Link: https://lore.kernel.org/r/20230210000253.1644903-3-sth@linux.ibm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/block/dasd_eckd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index d1429936f38c6..c6930c159d2a6 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -6763,8 +6763,10 @@ dasd_eckd_init(void)
 		return -ENOMEM;
 	dasd_vol_info_req = kmalloc(sizeof(*dasd_vol_info_req),
 				    GFP_KERNEL | GFP_DMA);
-	if (!dasd_vol_info_req)
+	if (!dasd_vol_info_req) {
+		kfree(dasd_reserve_req);
 		return -ENOMEM;
+	}
 	pe_handler_worker = kmalloc(sizeof(*pe_handler_worker),
 				    GFP_KERNEL | GFP_DMA);
 	if (!pe_handler_worker) {
-- 
2.39.2



