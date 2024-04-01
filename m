Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE0E53370;
	Mon,  1 Apr 2024 15:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986861; cv=none; b=SlJPgbldspNnkORQrBT6ZoqnSqMMV7a7Hyk9OHKpoOJwjDYQE0+dhTARAk6CaV1y6TrFwTr5Pzi+8yVFcsBF2c/lEKbXbKQplCO0xh7VPYyJVQ9HdMbMdbzuyNWkCRFu73YsOCsPbx13Hh5ylbqCuNEUG59CowL8M245oqXxnto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986861; c=relaxed/simple;
	bh=vNCxTrfr7elRRcBO9nGgQClAWt8GidNvWuTWRfG1690=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q4o268nPdQUfbD4zKqzAYj5qKM4Ggc46a0J5DYqOhwNDRkITM0Qd4lyfLMYsWkqotBNmUqTg6GUeRh64QXjmB9ljNzue5ZNTXJ7XEEmMKTGSAe16j9pw+Vj1mHH6xUbPAPQnkHSA6cO/qU4yPqtKS1h2WU6fR2hUc5busZ1kd0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wi1mvles; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wi1mvles"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A40C433F1;
	Mon,  1 Apr 2024 15:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986860;
	bh=vNCxTrfr7elRRcBO9nGgQClAWt8GidNvWuTWRfG1690=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wi1mvleslNQ7tgBwEVhwHJiZEzIckZ4+N207M66egBZ411X2iioNIWDto2uUhohKQ
	 ksex3RHyJOdlx4cgGkC1amxs42yDYriIbABeIqc9hFE+5X8VT6Gjo7NgQMsuZnv7HV
	 9/VnPXiVtSunYZnWfsiz4tvkztI8bBadnc7BEMw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Xiao Ni <xni@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 109/399] md/dm-raid: dont call md_reap_sync_thread() directly
Date: Mon,  1 Apr 2024 17:41:15 +0200
Message-ID: <20240401152552.442293018@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit cd32b27a66db8776d8b8e82ec7d7dde97a8693b0 ]

Currently md_reap_sync_thread() is called from raid_message() directly
without holding 'reconfig_mutex', this is definitely unsafe because
md_reap_sync_thread() can change many fields that is protected by
'reconfig_mutex'.

However, hold 'reconfig_mutex' here is still problematic because this
will cause deadlock, for example, commit 130443d60b1b ("md: refactor
idle/frozen_sync_thread() to fix deadlock").

Fix this problem by using stop_sync_thread() to unregister sync_thread,
like md/raid did.

Fixes: be83651f0050 ("DM RAID: Add message/status support for changing sync action")
Cc: stable@vger.kernel.org # v6.7+
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Xiao Ni <xni@redhat.com>
Acked-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20240305072306.2562024-7-yukuai1@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-raid.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index fff9336fee767..8d38cdb221453 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3719,6 +3719,7 @@ static int raid_message(struct dm_target *ti, unsigned int argc, char **argv,
 {
 	struct raid_set *rs = ti->private;
 	struct mddev *mddev = &rs->md;
+	int ret = 0;
 
 	if (!mddev->pers || !mddev->pers->sync_request)
 		return -EINVAL;
@@ -3726,17 +3727,24 @@ static int raid_message(struct dm_target *ti, unsigned int argc, char **argv,
 	if (test_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags))
 		return -EBUSY;
 
-	if (!strcasecmp(argv[0], "frozen"))
-		set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-	else
-		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+	if (!strcasecmp(argv[0], "frozen")) {
+		ret = mddev_lock(mddev);
+		if (ret)
+			return ret;
 
-	if (!strcasecmp(argv[0], "idle") || !strcasecmp(argv[0], "frozen")) {
-		if (mddev->sync_thread) {
-			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-			md_reap_sync_thread(mddev);
-		}
-	} else if (decipher_sync_action(mddev, mddev->recovery) != st_idle)
+		md_frozen_sync_thread(mddev);
+		mddev_unlock(mddev);
+	} else if (!strcasecmp(argv[0], "idle")) {
+		ret = mddev_lock(mddev);
+		if (ret)
+			return ret;
+
+		md_idle_sync_thread(mddev);
+		mddev_unlock(mddev);
+	}
+
+	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+	if (decipher_sync_action(mddev, mddev->recovery) != st_idle)
 		return -EBUSY;
 	else if (!strcasecmp(argv[0], "resync"))
 		; /* MD_RECOVERY_NEEDED set below */
-- 
2.43.0



