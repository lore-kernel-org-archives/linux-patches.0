Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBB92FB2;
	Tue, 27 Aug 2024 15:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770959; cv=none; b=ujpAQFThU45eQmsvmL/nv9P63Lrl5YggwmiGNOuRMG7z9MGZMgw0rptijoS2DgIqXt50jleN5vY2ft2Pi40Xe4Pqi2bquJ9JiBzaHbP800tSv9DrkaA3M22RKgA3nvZVc5WE61DyTgI/Fc786bJAnOR6xC6pAGYQwM6yytDSNxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770959; c=relaxed/simple;
	bh=Rva2fDtDVeYe2uM/04nUeHAXWMQuPFVTFF9yck/0hFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u64X5/V7DwOC1HAAxWd+ZV6VDac096C+pDlSa4BORUZcV7Lmqh+CyKje6X6X3HbRPIGW5LddVOSdZtSMYbbOCCxX4P1I5iUQPYph/ZuttLCzqVsx91Y8zhkG8rfd1nqaW+JRbB8DbOQpj9I5Je15e6+mSINRK/TzgDRJtbX8f7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JiSDmAyY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JiSDmAyY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE39C61042;
	Tue, 27 Aug 2024 15:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770959;
	bh=Rva2fDtDVeYe2uM/04nUeHAXWMQuPFVTFF9yck/0hFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JiSDmAyYSjlz9R40qz6Wnv4p52pCqDDGaR5BEKggGA2QpuJNL7Bp7BODelYKSb4KU
	 u222UVQu8edQlQHIt0rBWsYyT9MMi6VdbS0WfamU4hHWZqY4GzeL64vUZHn+vT4DZj
	 /Pd0kht2ORa1MGgKIKn44jzo+x9TQ2e6HZ10vh2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	=?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>
Subject: [PATCH 6.10 045/273] md/raid1: Fix data corruption for degraded array with slow disk
Date: Tue, 27 Aug 2024 16:36:09 +0200
Message-ID: <20240827143835.112709105@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

commit c916ca35308d3187c9928664f9be249b22a3a701 upstream.

read_balance() will avoid reading from slow disks as much as possible,
however, if valid data only lands in slow disks, and a new normal disk
is still in recovery, unrecovered data can be read:

raid1_read_request
 read_balance
  raid1_should_read_first
  -> return false
  choose_best_rdev
  -> normal disk is not recovered, return -1
  choose_bb_rdev
  -> missing the checking of recovery, return the normal disk
 -> read unrecovered data

Root cause is that the checking of recovery is missing in
choose_bb_rdev(). Hence add such checking to fix the problem.

Also fix similar problem in choose_slow_rdev().

Cc: stable@vger.kernel.org
Fixes: 9f3ced792203 ("md/raid1: factor out choose_bb_rdev() from read_balance()")
Fixes: dfa8ecd167c1 ("md/raid1: factor out choose_slow_rdev() from read_balance()")
Reported-and-tested-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Closes: https://lore.kernel.org/all/9952f532-2554-44bf-b906-4880b2e88e3a@o2.pl/
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20240803091137.3197008-1-yukuai1@huaweicloud.com
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid1.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7acfe7c9dc8d..761989d67906 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -617,6 +617,12 @@ static int choose_first_rdev(struct r1conf *conf, struct r1bio *r1_bio,
 	return -1;
 }
 
+static bool rdev_in_recovery(struct md_rdev *rdev, struct r1bio *r1_bio)
+{
+	return !test_bit(In_sync, &rdev->flags) &&
+	       rdev->recovery_offset < r1_bio->sector + r1_bio->sectors;
+}
+
 static int choose_bb_rdev(struct r1conf *conf, struct r1bio *r1_bio,
 			  int *max_sectors)
 {
@@ -635,6 +641,7 @@ static int choose_bb_rdev(struct r1conf *conf, struct r1bio *r1_bio,
 
 		rdev = conf->mirrors[disk].rdev;
 		if (!rdev || test_bit(Faulty, &rdev->flags) ||
+		    rdev_in_recovery(rdev, r1_bio) ||
 		    test_bit(WriteMostly, &rdev->flags))
 			continue;
 
@@ -673,7 +680,8 @@ static int choose_slow_rdev(struct r1conf *conf, struct r1bio *r1_bio,
 
 		rdev = conf->mirrors[disk].rdev;
 		if (!rdev || test_bit(Faulty, &rdev->flags) ||
-		    !test_bit(WriteMostly, &rdev->flags))
+		    !test_bit(WriteMostly, &rdev->flags) ||
+		    rdev_in_recovery(rdev, r1_bio))
 			continue;
 
 		/* there are no bad blocks, we can use this disk */
@@ -733,9 +741,7 @@ static bool rdev_readable(struct md_rdev *rdev, struct r1bio *r1_bio)
 	if (!rdev || test_bit(Faulty, &rdev->flags))
 		return false;
 
-	/* still in recovery */
-	if (!test_bit(In_sync, &rdev->flags) &&
-	    rdev->recovery_offset < r1_bio->sector + r1_bio->sectors)
+	if (rdev_in_recovery(rdev, r1_bio))
 		return false;
 
 	/* don't read from slow disk unless have to */
-- 
2.46.0



