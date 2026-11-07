Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065298;
	b=N3vgn7QGGIPlD9RH1TVm0ibpbUWnJTbCM/6t80F5zvmCO3C3tb5tqeq21akfJPRU9Np1
	 ei2C+/isqEhWduuJXtFyXpM/dBTCHKWyCFUNKPWjDYe6h/LlS9pXLrf3N2qJbvNJG0Zxc
	 ZhFfAS0leGgEsxzGHJ/nqd5KVCghJsrL5GcacFw8wObOsOFxAstoevYdTrK5xhDI1OYB9
	 fAKCPuR+pQhQ2aRXHNxny4YaILwbjVkaV/i6M6qMRsX0z2foAl5b+TFbKMmOLb7YsAlnD
	 XUWQshljnytgtQVrpBbTXb+rdYbs33zNMf6Dsujz73L2gBAeG1SEN2ulNhc4VJBVhwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065298;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bb7iGW8GH6ic1GMnvTcE3/fAt1gBiln3dBAPHKI+j/g=;
	b=WwD99zahQoqhWHanJMJ2wg6r5NQ71f5jhfXX4me0IiDwi0qb3/F2O9gMhXwaj3qJr26g
	 tJumPAC2Pb222Kb+BoYn8Rqn9sL/qzDOn/S/gJb1/2vdfKC53lCSzU+pdT8mPIeN7lKk7
	 cv19o4iX5wRolo5YlfUdepDMZbptcxmW+YCOIfMkGhjhYIaS6H8Np2V35+o90znprOCcu
	 INi2f31M2nMzVxlGyoUST4Oaya6WTHACgpJZ3s5gjSAGTzwo6QszPlAw5fKXW9RwKIHLB
	 Cp+kXwxH9nzKxNG2dvqOP76yoG7c1N6PXBJyCpDRK82aFQ1amuARPZspF0a7epBStBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1g1CQHQC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAAD606A326;
	Sat,  7 Nov 2026 15:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1g1CQHQC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2E91F0089F;
	Sat,  7 Nov 2026 15:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065297;
	bh=bb7iGW8GH6ic1GMnvTcE3/fAt1gBiln3dBAPHKI+j/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1g1CQHQCJQvK1MgLeLyC2m7TmoroX8bkaaEu6AzgsTEzHXHo77k34uyobrDyGzsqp
	 ujJR3roI9WuEoFzk6YjFZ2bZza3uQOZGxWxAmSVBHc8YNo+0tUqLSTAyQOC87wfb42
	 wy3UzjhSUB2OY7F+Lm7BSn3gOtqUIr+k/wNvHZeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joonhoe Kim <26rote@gmail.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1053/1257] scsi: ufs: core: Fix a deadlock between clock scaling and device commands
Date: Sat,  7 Nov 2026 08:55:49 -0500
Message-ID: <20261107135008.376554927@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joonhoe Kim <26rote@gmail.com>

[ Upstream commit 2327df6d2a290af62a6da21b2ad301848bb86002 ]

Since commit 08b12cda6c44 ("scsi: ufs: core: Switch to
scsi_get_internal_cmd()"), device management commands go through
blk_execute_rq() on the pseudo SCSI device, which shares the tagset with
the logical units, while ufshcd_dev_man_lock() holds clk_scaling_lock for
reading.

ufshcd_clock_scaling_prepare() and ufshcd_pause_command_processing()
quiesce the tagset before taking clk_scaling_lock for writing. A device
management command holding the lock for reading at that point is never
dispatched and never times out, so the writer waits forever with all
logical units quiesced. On a Lenovo Legion Tab Y700 Gen 5 this ended in a
hung task panic.

Take clk_scaling_lock before quiescing the tagset, and in
ufshcd_clock_scaling_prepare() also wb_mutex, which is always taken before
clk_scaling_lock. Release them in the reverse order. Commit b52d695d0620
("scsi: ufs: core: Keep internal commands dispatchable during error
handling") fixed the same problem in the error handler.

Fixes: 08b12cda6c44 ("scsi: ufs: core: Switch to scsi_get_internal_cmd()")
Fixes: dc5dcac53278 ("scsi: ufs: core: Add helpers to pause and resume command processing")
Cc: stable@vger.kernel.org
Signed-off-by: Joonhoe Kim <26rote@gmail.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Link: https://patch.msgid.link/20261016124608.46-1-26rote@gmail.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 6f92e5b4cc832..025a16c50ffe6 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1360,13 +1360,13 @@ int ufshcd_pause_command_processing(struct ufs_hba *hba, u64 timeout_us)
 	int ret = 0;
 
 	mutex_lock(&hba->host->scan_mutex);
-	blk_mq_quiesce_tagset(&hba->host->tag_set);
 	down_write(&hba->clk_scaling_lock);
+	blk_mq_quiesce_tagset(&hba->host->tag_set);
 
 	if (ufshcd_wait_for_pending_cmds(hba, timeout_us)) {
 		ret = -EBUSY;
-		up_write(&hba->clk_scaling_lock);
 		blk_mq_unquiesce_tagset(&hba->host->tag_set);
+		up_write(&hba->clk_scaling_lock);
 		mutex_unlock(&hba->host->scan_mutex);
 	}
 
@@ -1383,8 +1383,8 @@ void ufshcd_resume_command_processing(struct ufs_hba *hba)
 	__releases(&hba->clk_scaling_lock)
 	__releases(&hba->host->scan_mutex)
 {
-	up_write(&hba->clk_scaling_lock);
 	blk_mq_unquiesce_tagset(&hba->host->tag_set);
+	up_write(&hba->clk_scaling_lock);
 	mutex_unlock(&hba->host->scan_mutex);
 }
 
@@ -1461,16 +1461,16 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba, u64 timeout_us)
 	 * clock scaling is in progress
 	 */
 	mutex_lock(&hba->host->scan_mutex);
-	blk_mq_quiesce_tagset(&hba->host->tag_set);
 	mutex_lock(&hba->wb_mutex);
 	down_write(&hba->clk_scaling_lock);
+	blk_mq_quiesce_tagset(&hba->host->tag_set);
 
 	if (!hba->clk_scaling.is_allowed ||
 	    ufshcd_wait_for_pending_cmds(hba, timeout_us)) {
 		ret = -EBUSY;
+		blk_mq_unquiesce_tagset(&hba->host->tag_set);
 		up_write(&hba->clk_scaling_lock);
 		mutex_unlock(&hba->wb_mutex);
-		blk_mq_unquiesce_tagset(&hba->host->tag_set);
 		mutex_unlock(&hba->host->scan_mutex);
 		goto out;
 	}
@@ -1487,9 +1487,9 @@ static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, int err)
 	__releases(&hba->wb_mutex)
 	__releases(&hba->host->scan_mutex)
 {
+	blk_mq_unquiesce_tagset(&hba->host->tag_set);
 	up_write(&hba->clk_scaling_lock);
 	mutex_unlock(&hba->wb_mutex);
-	blk_mq_unquiesce_tagset(&hba->host->tag_set);
 	mutex_unlock(&hba->host->scan_mutex);
 
 	/* Enable Write Booster if current gear requires it else disable it */
-- 
2.53.0



