Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71EC42566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:31:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0FAC4339B;
	Tue, 18 Apr 2023 12:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821119;
	bh=5FbvnDcsV0iHBMA6EomBETRkk0lcdkcoABMf9AmA5DI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WREINLnO9BtyoDUxhsuXzyo/7USuhEyO/tRXnnupAsSvWeVB0Kr/lNO8mmIqDRtEY
	 6FyRFS6S+VXvl8Eg+27cWLPxSld/bpQGYrxAMp0apnntsYlhRht+8M+5IVINSkIsoi
	 dhKqG4XJi/mOFIEjfb2amSOE7UQVvr09YXEssQBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhaoLong Wang <wangzhaolong1@huawei.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 72/92] ubi: Fix deadlock caused by recursively holding work_sem
Date: Tue, 18 Apr 2023 14:21:47 +0200
Message-Id: <20230418120307.317593602@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: ZhaoLong Wang <wangzhaolong1@huawei.com>

[ Upstream commit f773f0a331d6c41733b17bebbc1b6cae12e016f5 ]

During the processing of the bgt, if the sync_erase() return -EBUSY
or some other error code in __erase_worker(),schedule_erase() called
again lead to the down_read(ubi->work_sem) hold twice and may get
block by down_write(ubi->work_sem) in ubi_update_fastmap(),
which cause deadlock.

          ubi bgt                        other task
 do_work
  down_read(&ubi->work_sem)          ubi_update_fastmap
  erase_worker                         # Blocked by down_read
   __erase_worker                      down_write(&ubi->work_sem)
    schedule_erase
     schedule_ubi_work
      down_read(&ubi->work_sem)

Fix this by changing input parameter @nested of the schedule_erase() to
'true' to avoid recursively acquiring the down_read(&ubi->work_sem).

Also, fix the incorrect comment about @nested parameter of the
schedule_erase() because when down_write(ubi->work_sem) is held, the
@nested is also need be true.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217093
Fixes: 2e8f08deabbc ("ubi: Fix races around ubi_refill_pools()")
Signed-off-by: ZhaoLong Wang <wangzhaolong1@huawei.com>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/wl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 28110cd4400b5..fd0e8f948c3da 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -576,7 +576,7 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
  * @vol_id: the volume ID that last used this PEB
  * @lnum: the last used logical eraseblock number for the PEB
  * @torture: if the physical eraseblock has to be tortured
- * @nested: denotes whether the work_sem is already held in read mode
+ * @nested: denotes whether the work_sem is already held
  *
  * This function returns zero in case of success and a %-ENOMEM in case of
  * failure.
@@ -1110,7 +1110,7 @@ static int __erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk)
 		int err1;
 
 		/* Re-schedule the LEB for erasure */
-		err1 = schedule_erase(ubi, e, vol_id, lnum, 0, false);
+		err1 = schedule_erase(ubi, e, vol_id, lnum, 0, true);
 		if (err1) {
 			spin_lock(&ubi->wl_lock);
 			wl_entry_destroy(ubi, e);
-- 
2.39.2



