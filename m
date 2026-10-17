Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D94E31B828;
	Sat, 17 Oct 2026 18:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260531; cv=none; b=o8FUnewWSqU/qVTfawSSyF/QEs6BrBJM2ivJ3WENKFIsoEsxkImLy1I6Vu6edmr4EN927QgWMKs8YITPnPM/4PyLOfbhrd6wEGmcscSpHrQkK2Gn+V26jOgezVXNAwU4LADhocxup9LQr9mnOc0NlCH/UlaOP/GfGAh579JX8ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260531; c=relaxed/simple;
	bh=fhi7kU9fIB3P4jxNyn30/SuqT/zOGBrAzwQu2kgZI44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBDKkZ9uArPdxb74liWeXeQHVO+oDgoFMcbpxi/mHrAsohYvfBcWqTgi7MhhzVUwSOcuENBmjuq9fy1Qqoin0LufjfajQDRiEWY74IQYff7YSymeNClmR3Q3Ucain/dADoBp5/4/VhPkLn1JK/RYjwlw7a5/Bo6+edGRBa2rUsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XysQkX1v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XysQkX1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C71F1F000C4;
	Sat, 17 Oct 2026 18:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260530;
	bh=vH7J1bZXSgikz/e2/7gNWY5Hpfv/BfjpSjnY+DxRtnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XysQkX1vR/1udVA2TmWYfn+s0WnzbXNs8CK3Ypj+Iec3X3F5Qwom2Mu5kOtt3YpRo
	 FOxJrMNaGE/D6htPr7iqch5zg9eS8TPOkFVG+Z/J7FAA2u1ocVJ8TSLycdPRoneZbs
	 RNbjL6rwiKiTa3ymXNADq0nJKbtHQraVLlt3mbIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Xiao Ni <xiao@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1574/1674] md/raid1,raid10: fix error-path detection with md_cloned_bio()
Date: Sat, 17 Oct 2026 18:04:06 +0200
Message-ID: <20261017160511.499609806@linuxfoundation.org>
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
index 86c5319de7ad3..710727814ea8b 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1220,11 +1220,18 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	char b[BDEVNAME_SIZE];
 
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
 
 	if (r1bio_existed) {
 		/* Need to get the block device name carefully */
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 3e1fabd72dab9..2f06b406d9147 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1173,7 +1173,20 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	char b[BDEVNAME_SIZE];
 	int slot = r10_bio->read_slot;
 	struct md_rdev *err_rdev = NULL;
-	gfp_t gfp = GFP_NOIO;
+
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
 	int error;
 
 	if (slot >= 0 && r10_bio->devs[slot].rdev) {
@@ -1185,11 +1198,6 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 		 * we lose the device name in error messages.
 		 */
 		int disk;
-		/*
-		 * As we are blocking raid10, it is a little safer to
-		 * use __GFP_HIGH.
-		 */
-		gfp = GFP_NOIO | __GFP_HIGH;
 
 		rcu_read_lock();
 		disk = r10_bio->devs[slot].devnum;
-- 
2.53.0



