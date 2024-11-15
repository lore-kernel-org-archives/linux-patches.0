Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891B814EC77;
	Fri, 15 Nov 2024 06:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653651; cv=none; b=fOt9SGJqnT6fQI/bpkJjzJkZq8poHkUZlPxjGxxIPC4VxrmesLHbn2BilQLvjl+NaGIPz8SXnuLl8ZPkHiaaRg/J/qMt5+Mv7BgWYUGxuL1QRxs1fSnWfVRsNxaacx4eTobBVV+FrkKtZEb/MqdGtzXZEEaTbpEMWAQuytO4Vas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653651; c=relaxed/simple;
	bh=jr9hKccuR71kVU5k5RF0pT1lAvqa3ysgbEdaqtxxwiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RWDwvZKuWikD5c4mNI0k0ozZGCIm02g2yxNg2AbER2mLDn3UgD9au32muCnbYtXPaJF2gDASLXbzh1ZBpFJCHlB7rXoY8DAFJM6s0YfY6fyHAtsob10PtwNK4XVXrvDnkY42MKzPCtognraf5IsmXrgStDW7QZAFvrTanwMVMIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=frfBx37f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="frfBx37f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A575DC4CECF;
	Fri, 15 Nov 2024 06:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653651;
	bh=jr9hKccuR71kVU5k5RF0pT1lAvqa3ysgbEdaqtxxwiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=frfBx37flpH94YOKcznohVBBJKATRVwlJQfQ2goXcrNRpxQPn8CUDRFXwSWnRei5/
	 pbNfLMgSepbPj8LHgtCuwdSz40kvZbNDW1/e6+JLMshtIf+aOzIvGYUTuuj5Z27/aX
	 UlFvjkJL50Ahbnlgn7mhsmQAd5S1UWbYZtHJMlng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Hagar Gamal Halim <hagarhem@amazon.de>
Subject: [PATCH 6.1 29/39] md/raid10: improve code of mrdev in raid10_sync_request
Date: Fri, 15 Nov 2024 07:38:39 +0100
Message-ID: <20241115063723.659085662@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.599985562@linuxfoundation.org>
References: <20241115063722.599985562@linuxfoundation.org>
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
@@ -3432,7 +3432,6 @@ static sector_t raid10_sync_request(stru
 			sector_t sect;
 			int must_sync;
 			int any_working;
-			int need_recover = 0;
 			struct raid10_info *mirror = &conf->mirrors[i];
 			struct md_rdev *mrdev, *mreplace;
 
@@ -3440,14 +3439,13 @@ static sector_t raid10_sync_request(stru
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
@@ -3481,7 +3479,8 @@ static sector_t raid10_sync_request(stru
 				rcu_read_unlock();
 				continue;
 			}
-			atomic_inc(&mrdev->nr_pending);
+			if (mrdev)
+				atomic_inc(&mrdev->nr_pending);
 			if (mreplace)
 				atomic_inc(&mreplace->nr_pending);
 			rcu_read_unlock();
@@ -3568,7 +3567,7 @@ static sector_t raid10_sync_request(stru
 				r10_bio->devs[1].devnum = i;
 				r10_bio->devs[1].addr = to_addr;
 
-				if (need_recover) {
+				if (mrdev) {
 					bio = r10_bio->devs[1].bio;
 					bio->bi_next = biolist;
 					biolist = bio;
@@ -3613,7 +3612,7 @@ static sector_t raid10_sync_request(stru
 					for (k = 0; k < conf->copies; k++)
 						if (r10_bio->devs[k].devnum == i)
 							break;
-					if (!test_bit(In_sync,
+					if (mrdev && !test_bit(In_sync,
 						      &mrdev->flags)
 					    && !rdev_set_badblocks(
 						    mrdev,
@@ -3639,12 +3638,14 @@ static sector_t raid10_sync_request(stru
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


