Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29AF47B439;
	Sat, 12 Sep 2026 12:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216465; cv=none; b=WTEIAcVY3Im33T8d+md1qb0KsltRwqc/2uRaONSdT+Urgh0MKi0zAANndAeA99Ku8md2HuYVgwwb2ogGnydMev1hm0+194lt9zD9DwXQCZCLqDwekepmE3e0G/WfZrvTctmBqsE6R3ZRP8PwJoky5/CzzUJg0ZCQXVWmirseYWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216465; c=relaxed/simple;
	bh=fw1k96F5GbDyNkuqsEWpmsllUegcXeMRhd0FCPk6DEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRdqJabzcDDk+y+GDzZckz+ooYfgJi38DQJ1eHh7HLHcrXvovBPW8HR5kgKB4KWF34rV9HHaAg43GwK5eTWLEWAQ+OjpKrrCYpZolvlmNHp1OxHy6jCRdKLdwDvG5YKjjk5GrQoWhgXUM6xNwqWFyUSlRhAYbj/6m/Vmwxzt8gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oicpYqwI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oicpYqwI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5DD51F000FF;
	Sat, 12 Sep 2026 12:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216464;
	bh=T3+Ju9AhDnjuT4riS7ewLUQpLxEKJxbYDKtx8Pmettw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oicpYqwIaDWEbiYMebdAx0+OjoIKdFKDC2uKHOIYcbuIGrM3UyaskqY2GQg6PJXwI
	 99BDkyYP1SfHg0widnVjb7C4GIEADHlyy1muRh8Cw7QOB+9h+G/Srb6dmx0QuNh/qT
	 B/3XAEcbL46inkGy9qgvdiT1HNK5uAqE7rQka1OY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0740/1376] md: ensure resync is prioritized over recovery
Date: Sat, 12 Sep 2026 08:52:46 +0200
Message-ID: <20260912065624.037726858@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Li Nan <linan122@huawei.com>

[ Upstream commit 4b10a3bc67c1232f76aa1e04778ca26d6c0ddf7f ]

If a new disk is added during resync, the resync process is interrupted,
and recovery is triggered, causing the previous resync to be lost. In
reality, disk addition should not terminate resync, fix it.

Steps to reproduce the issue:
  mdadm -CR /dev/md0 -l1 -n3 -x1 /dev/sd[abcd]
  mdadm --fail /dev/md0 /dev/sdc

Fixes: 24dd469d728d ("[PATCH] md: allow a manual resync with md")
Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/linux-raid/20250213131530.3698600-1-linan666@huaweicloud.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Stable-dep-of: a47431dfb353 ("md/raid5: protect lockless recovery_offset accesses during reshape")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 02bf5d37888b9..90fe53d5bd818 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9488,6 +9488,13 @@ static bool md_choose_sync_action(struct mddev *mddev, int *spares)
 		return true;
 	}
 
+	/* Check if resync is in progress. */
+	if (mddev->recovery_cp < MaxSector) {
+		set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
+		clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
+		return true;
+	}
+
 	/*
 	 * Remove any failed drives, then add spares if possible. Spares are
 	 * also removed and re-added, to allow the personality to fail the
@@ -9504,13 +9511,6 @@ static bool md_choose_sync_action(struct mddev *mddev, int *spares)
 		return true;
 	}
 
-	/* Check if recovery is in progress. */
-	if (mddev->recovery_cp < MaxSector) {
-		set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
-		clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
-		return true;
-	}
-
 	/* Delay to choose resync/check/repair in md_do_sync(). */
 	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
 		return true;
-- 
2.53.0



