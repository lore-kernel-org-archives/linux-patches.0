Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7755637C109;
	Sat, 17 Oct 2026 17:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259323; cv=none; b=IjdmxDK0Iwv93py1RtL2X/h1tzXwuNu6i0G6jl4xQa6a8IuoeqAVcA9NULBu//vKgMNETSlt1osexKTQSo+XeSCsOaVmHatokV6EYDtcLHtn8m2ltpOrcbA0zELxM0H951exrX+70r4p1NEVIHGTrA30Y0Hn7VkhJbDRLaqOmok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259323; c=relaxed/simple;
	bh=FRXYEFrENRu0K87MDig75+tD8PAt50QyR2sJ6gNNhJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PRljqe8SUjiHXacapWYPzKKpsjS9lYeo9Nw6qlnRGJeL6PuQpa/YIZaBubmeGkTwMx0jNombNrrGP/IZoyZ9/31A72V2uso3SyHjVuVFFcfwacC5T25swO9IIXUx+AOIbdE0fnNQsnVU3VxtX9olDwVjcdKfgkck0O0q8E+4UV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mmq0mcHL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mmq0mcHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DCFF1F000C4;
	Sat, 17 Oct 2026 17:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259322;
	bh=mnK2LUpDSP2bKwEVuum+986BlE17yKSVNOGv+esXwWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mmq0mcHL1ylyHkuUNtCgdINBUzqL8MygMjMf223Ns+f6WkygA/FeEs0S15vio/G+9
	 ueEauxj+oeL/hc1XEGGEGaVoogv0eckUNNLdjvl6w81dDZFZrIzXkDnRdCrd0JZsiZ
	 xe20vPJZKFAEvUie8Hn8uRJ+BPGbCq/NAj2RQP+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Xiao Ni <xiao@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1174/1674] md/raid1,raid10: fix deadlock in read error recovery path
Date: Sat, 17 Oct 2026 17:57:26 +0200
Message-ID: <20261017160501.285017356@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

[ Upstream commit 7b15c24f805339a585cfe7d72f446b7e88b9bcc0 ]

raid1d and raid10d may resubmit a split md cloned bio while handling
a read error. In this case, resubmitting the bio can lead to a deadlock
if the array is suspended before md_handle_request() acquires an
active_io reference via percpu_ref_tryget_live().

Since the cloned bio already holds an active_io reference,
trying to acquire another reference via percpu_ref_tryget_live()
can lead to a deadlock while the array is suspended.

Fix this by using percpu_ref_get() for md cloned bios.

Fixes: bb2a9acefaf9 ("md/raid1: switch to use md_account_bio() for io accounting")
Fixes: 820455238366 ("md/raid10: switch to use md_account_bio() for io accounting")
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Reviewed-by: Xiao Ni <xiao@kernel.org>
Reviewed-by: Yu Kuai <yukuai@fygo.io>
Link: https://patch.msgid.link/20260501114652.590037-2-abd.masalkhi@gmail.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 41 ++++++++++++++++++++++++-----------------
 drivers/md/md.h |  5 +++++
 2 files changed, 29 insertions(+), 17 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c8cb2a83e2f54..83b53e02b1382 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -371,25 +371,32 @@ static bool is_suspended(struct mddev *mddev, struct bio *bio)
 void md_handle_request(struct mddev *mddev, struct bio *bio)
 {
 check_suspended:
-	if (is_suspended(mddev, bio)) {
-		DEFINE_WAIT(__wait);
-		/* Bail out if REQ_NOWAIT is set for the bio */
-		if (bio->bi_opf & REQ_NOWAIT) {
-			bio_wouldblock_error(bio);
-			return;
-		}
-		for (;;) {
-			prepare_to_wait(&mddev->sb_wait, &__wait,
-					TASK_UNINTERRUPTIBLE);
-			if (!is_suspended(mddev, bio))
-				break;
-			schedule();
+	if (unlikely(md_cloned_bio(mddev, bio))) {
+		/*
+		 * This bio is an MD cloned bio and already holds an
+		 * active_io reference, so percpu_ref_get() is safe here.
+		 */
+		percpu_ref_get(&mddev->active_io);
+	} else {
+		if (is_suspended(mddev, bio)) {
+			DEFINE_WAIT(__wait);
+			/* Bail out if REQ_NOWAIT is set for the bio */
+			if (bio->bi_opf & REQ_NOWAIT) {
+				bio_wouldblock_error(bio);
+				return;
+			}
+			for (;;) {
+				prepare_to_wait(&mddev->sb_wait, &__wait,
+						TASK_UNINTERRUPTIBLE);
+				if (!is_suspended(mddev, bio))
+					break;
+				schedule();
+			}
+			finish_wait(&mddev->sb_wait, &__wait);
 		}
-		finish_wait(&mddev->sb_wait, &__wait);
+		if (!percpu_ref_tryget_live(&mddev->active_io))
+			goto check_suspended;
 	}
-	if (!percpu_ref_tryget_live(&mddev->active_io))
-		goto check_suspended;
-
 	if (!mddev->pers->make_request(mddev, bio)) {
 		percpu_ref_put(&mddev->active_io);
 		goto check_suspended;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index a2e480ad3861e..337efde4b3e34 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -908,4 +908,9 @@ int do_md_run(struct mddev *mddev);
 
 extern const struct block_device_operations md_fops;
 
+static inline bool md_cloned_bio(struct mddev *mddev, struct bio *bio)
+{
+	return bio->bi_pool == &mddev->io_clone_set;
+}
+
 #endif /* _MD_MD_H */
-- 
2.53.0



