Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F4A1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:32:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1730BC433C7;
	Tue, 25 Jul 2023 11:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284721;
	bh=4feQCupDBZM4/+ZwNpSCewzsMwBjLTJw22xNQgln+K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HZrf6wsaCjXu/+chbE+Vn5ihlIYzi6crA7pvAVM6ekEKsS9nXvjG8FSXNhoBJ7iN8
	 ljHN3zbCgljqmvIdrMipjcYDrmFYoOPa5HGbmOCZcYOdoMuNnymtPUnQKDoCQOHEmk
	 uso9KRTHUoepFkSQ2TzFYfaePFt26fD9Q1hkDUnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Neuwirth <reddunur@online.de>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 457/509] md: fix data corruption for raid456 when reshape restart while grow up
Date: Tue, 25 Jul 2023 12:46:36 +0200
Message-ID: <20230725104614.663454584@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
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

[ Upstream commit 873f50ece41aad5c4f788a340960c53774b5526e ]

Currently, if reshape is interrupted, echo "reshape" to sync_action will
restart reshape from scratch, for example:

echo frozen > sync_action
echo reshape > sync_action

This will corrupt data before reshape_position if the array is growing,
fix the problem by continue reshape from reshape_position.

Reported-by: Peter Neuwirth <reddunur@online.de>
Link: https://lore.kernel.org/linux-raid/e2f96772-bfbc-f43b-6da1-f520e5164536@online.de/
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20230512015610.821290-3-yukuai1@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index bbf39abc32b79..ae0a857d6076a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4890,11 +4890,21 @@ action_store(struct mddev *mddev, const char *page, size_t len)
 			return -EINVAL;
 		err = mddev_lock(mddev);
 		if (!err) {
-			if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
+			if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
 				err =  -EBUSY;
-			else {
+			} else if (mddev->reshape_position == MaxSector ||
+				   mddev->pers->check_reshape == NULL ||
+				   mddev->pers->check_reshape(mddev)) {
 				clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 				err = mddev->pers->start_reshape(mddev);
+			} else {
+				/*
+				 * If reshape is still in progress, and
+				 * md_check_recovery() can continue to reshape,
+				 * don't restart reshape because data can be
+				 * corrupted for raid456.
+				 */
+				clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 			}
 			mddev_unlock(mddev);
 		}
-- 
2.39.2



