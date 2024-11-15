Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A3018A921;
	Fri, 15 Nov 2024 07:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731654002; cv=none; b=NJ78xax9P0bKj2C932WSz8LqDsmrOtmcIvrx5ywePH1pyn6uJEgvxMtqLXq+o/a9ivsLr19awA6k2oFyBnQr7gJWsGHCr1Mmtk68Ssz9Uiu6jf1pO6RLfWibT1+YH4D9zFjAGducMXfnxbnzjCIy69yNTEWawJinkdzD0gmClUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731654002; c=relaxed/simple;
	bh=DtEVghmzGUGzzD4h9q3asKMaVMWBxnNOEP6cCoJYBB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PELbcNoX5zJQM7m66NA+GJE0GLDps6kzZ0TOzaXQnbqnfKrr1TDVDJpdogPXA8hJl0+p5qKT3qkxk6QzLmfCkqW62F+Xe/I8HK2oRt6TilK8E7GMS7kxrvEUckRH9W5/mwAuHh7MjPB13eA+z/lE8q+CC9J2XPOq4QSdPkl7yt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ctBUPPer; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ctBUPPer"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB15C4CECF;
	Fri, 15 Nov 2024 07:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731654002;
	bh=DtEVghmzGUGzzD4h9q3asKMaVMWBxnNOEP6cCoJYBB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ctBUPPer0pw96GunqR7LEJrOjPasanWFYx61YvVmGiDYODrh9Mt9PBMc/ID/+M+xb
	 4TdoZLYym5NzYtfpKYeIxoJ/yYaFb9QHoi7HaHjKql9GZeFsCPS4DHvjy2571y4gRW
	 Czr96Yl5KZbeiZW6MrgbsRCDBwKTUnXo2rgerxqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Hagar Gamal Halim <hagarhem@amazon.de>
Subject: [PATCH 5.15 16/22] md/raid10: improve code of mrdev in raid10_sync_request
Date: Fri, 15 Nov 2024 07:39:02 +0100
Message-ID: <20241115063721.762245347@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063721.172791419@linuxfoundation.org>
References: <20241115063721.172791419@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Nan <linan122@huawei.com>

commit 59f8f0b54c8ffb4521f6bbd1cb6f4dfa5022e75e upstream.

'need_recover' and 'mrdev' are equivalent in raid10_sync_request(), and
inc mrdev->nr_pending is unreasonable if don't need recovery. Replace
'need_recover' with 'mrdev', and only inc nr_pending when needed.

Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20230527072218.2365857-3-linan666@huaweicloud.com
Cc: Hagar Gamal Halim <hagarhem@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid10.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3443,7 +3443,6 @@ static sector_t raid10_sync_request(stru
 			sector_t sect;
 			int must_sync;
 			int any_working;
-			int need_recover = 0;
 			struct raid10_info *mirror = &conf->mirrors[i];
 			struct md_rdev *mrdev, *mreplace;
 
@@ -3451,14 +3450,13 @@ static sector_t raid10_sync_request(stru
 			mrdev = rcu_dereference(mirror->rdev);
 			mreplace = rcu_dereference(mirror->replacement);
 
-			if (mrdev != NULL &&
-			    !test_bit(Faulty, &mrdev->flags) &&
-			    !test_bit(In_sync, &mrdev->flags))
-				need_recover = 1;
+			if (mrdev && (test_bit(Faulty, &mrdev->flags) ||
+			    test_bit(In_sync, &mrdev->flags)))
+				mrdev = NULL;
 			if (mreplace && test_bit(Faulty, &mreplace->flags))
 				mreplace = NULL;
 
-			if (!need_recover && !mreplace) {
+			if (!mrdev && !mreplace) {
 				rcu_read_unlock();
 				continue;
 			}
@@ -3492,7 +3490,8 @@ static sector_t raid10_sync_request(stru
 				rcu_read_unlock();
 				continue;
 			}
-			atomic_inc(&mrdev->nr_pending);
+			if (mrdev)
+				atomic_inc(&mrdev->nr_pending);
 			if (mreplace)
 				atomic_inc(&mreplace->nr_pending);
 			rcu_read_unlock();
@@ -3579,7 +3578,7 @@ static sector_t raid10_sync_request(stru
 				r10_bio->devs[1].devnum = i;
 				r10_bio->devs[1].addr = to_addr;
 
-				if (need_recover) {
+				if (mrdev) {
 					bio = r10_bio->devs[1].bio;
 					bio->bi_next = biolist;
 					biolist = bio;
@@ -3624,7 +3623,7 @@ static sector_t raid10_sync_request(stru
 					for (k = 0; k < conf->copies; k++)
 						if (r10_bio->devs[k].devnum == i)
 							break;
-					if (!test_bit(In_sync,
+					if (mrdev && !test_bit(In_sync,
 						      &mrdev->flags)
 					    && !rdev_set_badblocks(
 						    mrdev,
@@ -3650,12 +3649,14 @@ static sector_t raid10_sync_request(stru
 				if (rb2)
 					atomic_dec(&rb2->remaining);
 				r10_bio = rb2;
-				rdev_dec_pending(mrdev, mddev);
+				if (mrdev)
+					rdev_dec_pending(mrdev, mddev);
 				if (mreplace)
 					rdev_dec_pending(mreplace, mddev);
 				break;
 			}
-			rdev_dec_pending(mrdev, mddev);
+			if (mrdev)
+				rdev_dec_pending(mrdev, mddev);
 			if (mreplace)
 				rdev_dec_pending(mreplace, mddev);
 			if (r10_bio->devs[0].bio->bi_opf & MD_FAILFAST) {


