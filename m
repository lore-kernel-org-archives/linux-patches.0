Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6FADF6F
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:58:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92939C433AE;
	Mon, 15 May 2023 17:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173484;
	bh=L4lpl+2vkeKeDOZJQLgs10LXlF6v6HNV8C3e7YI+k1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GyxetUhjzgTJyW+ens0/y6MaT3yJiHEUlEXN5aatfmV6jITTaHBnU39li/1K/Buk8
	 kx1TY5xrDHvCNklY9R+E+9pl7Rb7wY4vzj8yBIlNUfR7jKCAyzKfL9XnEewzpSEkRJ
	 4mNh7lzW8TcuH9gMf6v2e5RdIjLWgUHzgWNRv7Y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 102/282] md/raid10: fix leak of r10bio->remaining for recovery
Date: Mon, 15 May 2023 18:28:00 +0200
Message-Id: <20230515161725.311544345@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 26208a7cffd0c7cbf14237ccd20c7270b3ffeb7e ]

raid10_sync_request() will add 'r10bio->remaining' for both rdev and
replacement rdev. However, if the read io fails, recovery_request_write()
returns without issuing the write io, in this case, end_sync_request()
is only called once and 'remaining' is leaked, cause an io hang.

Fix the problem by decreasing 'remaining' according to if 'bio' and
'repl_bio' is valid.

Fixes: 24afd80d99f8 ("md/raid10: handle recovery of replacement devices.")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20230310073855.1337560-5-yukuai1@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 9fcc141e1ad64..dd91385a3526f 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2229,11 +2229,22 @@ static void recovery_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 {
 	struct r10conf *conf = mddev->private;
 	int d;
-	struct bio *wbio, *wbio2;
+	struct bio *wbio = r10_bio->devs[1].bio;
+	struct bio *wbio2 = r10_bio->devs[1].repl_bio;
+
+	/* Need to test wbio2->bi_end_io before we call
+	 * generic_make_request as if the former is NULL,
+	 * the latter is free to free wbio2.
+	 */
+	if (wbio2 && !wbio2->bi_end_io)
+		wbio2 = NULL;
 
 	if (!test_bit(R10BIO_Uptodate, &r10_bio->state)) {
 		fix_recovery_read_error(r10_bio);
-		end_sync_request(r10_bio);
+		if (wbio->bi_end_io)
+			end_sync_request(r10_bio);
+		if (wbio2)
+			end_sync_request(r10_bio);
 		return;
 	}
 
@@ -2242,14 +2253,6 @@ static void recovery_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	 * and submit the write request
 	 */
 	d = r10_bio->devs[1].devnum;
-	wbio = r10_bio->devs[1].bio;
-	wbio2 = r10_bio->devs[1].repl_bio;
-	/* Need to test wbio2->bi_end_io before we call
-	 * generic_make_request as if the former is NULL,
-	 * the latter is free to free wbio2.
-	 */
-	if (wbio2 && !wbio2->bi_end_io)
-		wbio2 = NULL;
 	if (wbio->bi_end_io) {
 		atomic_inc(&conf->mirrors[d].rdev->nr_pending);
 		md_sync_acct(conf->mirrors[d].rdev->bdev, bio_sectors(wbio));
-- 
2.39.2



