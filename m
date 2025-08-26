Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402923093BA;
	Tue, 26 Aug 2025 11:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208046; cv=none; b=tmTKf38mZ1VBJ/QNaaUXuMJF6P9zmDTyc1V8HuAKtNDLk7oUes7EdF2q6LWhfuEz5XKEtmnzo9lsVTWv2AyVJ2RDXJlVy3yU2WA0+si6ZlLxxCTtSfgJaLATpr7aSahKpfNZBroyzjoskSwK2ct1/3eQNWfVPuxuSm9MbL2ynMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208046; c=relaxed/simple;
	bh=nUfO/4sM6pzkEdxw1r4fnsczKnElt5o/172FhEMtFi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dD6czi+J+/+Nr4EhUmB+JgmLAZLq7zvAXSeaSjwgtz7gh0qCRyq4QJB0mbAFFUwnCguzdMvAPiVkvmfNrj6krp6t1SixetwyUkf3n+2sOaZsTrqSU0rg1Vhrc8xYSWlXQ1hUcxXHL5jUhOhbCp70Yyt0CgCN2/MnnSusiJ+wUcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ytph8qbn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ytph8qbn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D7BC4CEF1;
	Tue, 26 Aug 2025 11:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208045;
	bh=nUfO/4sM6pzkEdxw1r4fnsczKnElt5o/172FhEMtFi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ytph8qbns8IhCuEeOINEVmiW25rqK0D9g9hk5NRqAOWfXmbYMWJN9ixVQ81XoaEts
	 q640iJz3RXpbLtQaTRfSvhiwDQZ8w76k39QfFv+G0ieP0uiciJSgxAgk+ZaB83DH5u
	 sFYb77F+GZ+IdNInXim3aEqD6QUH68yrkmeaTliA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Qixing <zhengqixing@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 385/457] md: add helper rdev_needs_recovery()
Date: Tue, 26 Aug 2025 13:11:09 +0200
Message-ID: <20250826110946.813615792@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Qixing <zhengqixing@huawei.com>

[ Upstream commit cb0780ad4333040a98e10f014b593ef738a3f31e ]

Add a helper for checking if an rdev needs recovery.

Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
Link: https://lore.kernel.org/linux-raid/20250816002534.1754356-2-zhengqixing@huaweicloud.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Stable-dep-of: b7ee30f0efd1 ("md: fix sync_action incorrect display during resync")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 80470bcf4383..0348b5f3adc5 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4822,6 +4822,15 @@ metadata_store(struct mddev *mddev, const char *buf, size_t len)
 static struct md_sysfs_entry md_metadata =
 __ATTR_PREALLOC(metadata_version, S_IRUGO|S_IWUSR, metadata_show, metadata_store);
 
+static bool rdev_needs_recovery(struct md_rdev *rdev, sector_t sectors)
+{
+	return rdev->raid_disk >= 0 &&
+	       !test_bit(Journal, &rdev->flags) &&
+	       !test_bit(Faulty, &rdev->flags) &&
+	       !test_bit(In_sync, &rdev->flags) &&
+	       rdev->recovery_offset < sectors;
+}
+
 enum sync_action md_sync_action(struct mddev *mddev)
 {
 	unsigned long recovery = mddev->recovery;
@@ -8959,11 +8968,7 @@ static sector_t md_sync_position(struct mddev *mddev, enum sync_action action)
 		start = MaxSector;
 		rcu_read_lock();
 		rdev_for_each_rcu(rdev, mddev)
-			if (rdev->raid_disk >= 0 &&
-			    !test_bit(Journal, &rdev->flags) &&
-			    !test_bit(Faulty, &rdev->flags) &&
-			    !test_bit(In_sync, &rdev->flags) &&
-			    rdev->recovery_offset < start)
+			if (rdev_needs_recovery(rdev, start))
 				start = rdev->recovery_offset;
 		rcu_read_unlock();
 
@@ -9322,12 +9327,8 @@ void md_do_sync(struct md_thread *thread)
 			    test_bit(MD_RECOVERY_RECOVER, &mddev->recovery)) {
 				rcu_read_lock();
 				rdev_for_each_rcu(rdev, mddev)
-					if (rdev->raid_disk >= 0 &&
-					    mddev->delta_disks >= 0 &&
-					    !test_bit(Journal, &rdev->flags) &&
-					    !test_bit(Faulty, &rdev->flags) &&
-					    !test_bit(In_sync, &rdev->flags) &&
-					    rdev->recovery_offset < mddev->curr_resync)
+					if (mddev->delta_disks >= 0 &&
+					    rdev_needs_recovery(rdev, mddev->curr_resync))
 						rdev->recovery_offset = mddev->curr_resync;
 				rcu_read_unlock();
 			}
-- 
2.50.1



