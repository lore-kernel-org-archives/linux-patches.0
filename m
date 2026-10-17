Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA9622F767;
	Sat, 17 Oct 2026 16:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254523; cv=none; b=sxq/m0bM842YXVIthxrgPF/E2oXZ8AzWB7syEgSwmpMT2lIjzvnkYMCR8nWQt59Ebf7/eIGSAmQ9lWL677hsMJgkBxFrmlr70MwEo7TX7KA/PF6hAdOrTl0dBWbTOk91p4QsRtCnS9zSJ8XhhCxwZpXqaI0I/F6vmCrM3kuSS5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254523; c=relaxed/simple;
	bh=Ts9FXatDmoxNErqQ/riltiSwc0kWzvU0MYv7mrSxZD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t0GsAww+EycsOYgbVmsF40hd3Hx/FUXhheaTTdQlLLINN4Jo3P8Lb58FVBkTGpQ8/0M7AkdAZfjmT/nfmzUgJwR4fhO0l0gW7pRCh5lkF+xKlyWtprZEnvWv2ifukdc9Vdl9BeBKuZx5hbujU9mf/Ap3K3WOEEvAj4i/TeYZhTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FgtiO4a5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FgtiO4a5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090911F000C4;
	Sat, 17 Oct 2026 16:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254522;
	bh=1JBCNz78ETZDvcaVfhDcyA8pvE2RFJaVFUbCpGtJKkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FgtiO4a5RxAbmLO7hZFH5Ume/P4zwknWz7aIIoLNctOP9WD17hI65Fd+Yv2N3vFKp
	 75GeYsGD5NjqDIgXz7Tl8NMpvXnMO1W8fo9afxKCNF7ZgzuPQd2XCgOMm6pE4zJEUh
	 6RUpXc/unXpFSI2x+BvEiv4VFLV1UiQQt9rCNqFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Xiao Ni <xiao@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 476/869] md/raid1,raid10: fix error-path detection with md_cloned_bio()
Date: Sat, 17 Oct 2026 17:55:17 +0200
Message-ID: <20261017160049.329655933@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

[ Upstream commit 811545e0926d02a6a0b1a1258bb5544777c164d4 ]

Detect the error path using md_cloned_bio() instead of relying
on r1_bio in raid1 or r10_bio->read_slot in raid10, which may be
NULL or -1 after splitting and resubmitting a failed bio.

As a result, the error path may not be recognized and memory
allocations can incorrectly use GFP_NOIO instead of
(GFP_NOIO | __GFP_HIGH), which can lead to a deadlock under
memory pressure.

Fixes: 689389a06ce7 ("md/raid1: simplify handle_read_error().")
Fixes: 545250f24809 ("md/raid10: simplify handle_read_error()")
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Reviewed-by: Xiao Ni <xiao@kernel.org>
Link: https://patch.msgid.link/20260501114652.590037-3-abd.masalkhi@gmail.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid1.c  | 13 ++++++++++---
 drivers/md/raid10.c | 20 ++++++++++++++------
 2 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index b365fd4595228..c1ed903fa9c03 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1322,11 +1322,18 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	bool r1bio_existed = !!r1_bio;
 
 	/*
-	 * If r1_bio is set, we are blocking the raid1d thread
-	 * so there is a tiny risk of deadlock.  So ask for
+	 * An md cloned bio indicates we are in the error path.
+	 * This is more reliable than checking r1_bio, which might
+	 * be NULL even in the error path if a failed bio was split.
+	 */
+	bool err_path = md_cloned_bio(mddev, bio);
+
+	/*
+	 * If we are in the error path, we are blocking the raid1d
+	 * thread so there is a tiny risk of deadlock.  So ask for
 	 * emergency memory if needed.
 	 */
-	gfp_t gfp = r1_bio ? (GFP_NOIO | __GFP_HIGH) : GFP_NOIO;
+	gfp_t gfp = err_path ? (GFP_NOIO | __GFP_HIGH) : GFP_NOIO;
 
 	/*
 	 * Still need barrier for READ in case that whole
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index fe136080a3798..875759fa86cab 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1152,9 +1152,22 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	char b[BDEVNAME_SIZE];
 	int slot = r10_bio->read_slot;
 	struct md_rdev *err_rdev = NULL;
-	gfp_t gfp = GFP_NOIO;
 	int error;
 
+	/*
+	 * An md cloned bio indicates we are in the error path.
+	 * This is more reliable than checking slot, which might
+	 * be -1 even in the error path if a failed bio was split.
+	 */
+	bool err_path = md_cloned_bio(mddev, bio);
+
+	/*
+	 * If we are in the error path, we are blocking the raid10d
+	 * thread so there is a tiny risk of deadlock.  So ask for
+	 * emergency memory if needed.
+	 */
+	gfp_t gfp = err_path ? (GFP_NOIO | __GFP_HIGH) : GFP_NOIO;
+
 	if (slot >= 0 && r10_bio->devs[slot].rdev) {
 		/*
 		 * This is an error retry, but we cannot
@@ -1164,11 +1177,6 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 		 * we lose the device name in error messages.
 		 */
 		int disk;
-		/*
-		 * As we are blocking raid10, it is a little safer to
-		 * use __GFP_HIGH.
-		 */
-		gfp = GFP_NOIO | __GFP_HIGH;
 
 		disk = r10_bio->devs[slot].devnum;
 		err_rdev = conf->mirrors[disk].rdev;
-- 
2.53.0



