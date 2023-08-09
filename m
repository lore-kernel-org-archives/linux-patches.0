Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9512C17AAD
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:36:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14011C433C8;
	Wed,  9 Aug 2023 11:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580974;
	bh=z4/aH9rd4K50BJT2fAGCi41QNFlfi7cpvrumgPVSEfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WM/rmCpbuRfJ5AfdeIWBKOqsRoKzeJf0dz59h2OEsgSRDjVLIM/ZyU4F55Al4UnoC
	 WSpMwCKwubCbu1K1BI8maP49oZKbaSvy/HE2qQHhkW+1FojJaJvJ98KbOYRd1MwQLU
	 HG5OMNZTDPa9lb7uqcLDUhQJPxCjCmiVwWq/34fI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/201] dm raid: protect md_stop() with reconfig_mutex
Date: Wed,  9 Aug 2023 12:41:03 +0200
Message-ID: <20230809103645.878771006@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103643.799166053@linuxfoundation.org>
References: <20230809103643.799166053@linuxfoundation.org>
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

[ Upstream commit 7d5fff8982a2199d49ec067818af7d84d4f95ca0 ]

__md_stop_writes() and __md_stop() will modify many fields that are
protected by 'reconfig_mutex', and all the callers will grab
'reconfig_mutex' except for md_stop().

Also, update md_stop() to make certain 'reconfig_mutex' is held using
lockdep_assert_held().

Fixes: 9d09e663d550 ("dm: raid456 basic support")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-raid.c | 4 +++-
 drivers/md/md.c      | 2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index f3a489b1b6e9a..140bdf2a6ee11 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3305,8 +3305,8 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	return 0;
 
 bad_unlock:
-	mddev_unlock(&rs->md);
 	md_stop(&rs->md);
+	mddev_unlock(&rs->md);
 bad:
 	raid_set_free(rs);
 
@@ -3317,7 +3317,9 @@ static void raid_dtr(struct dm_target *ti)
 {
 	struct raid_set *rs = ti->private;
 
+	mddev_lock_nointr(&rs->md);
 	md_stop(&rs->md);
+	mddev_unlock(&rs->md);
 	raid_set_free(rs);
 }
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index ae0a857d6076a..6efe49f7bdf5e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6316,6 +6316,8 @@ static void __md_stop(struct mddev *mddev)
 
 void md_stop(struct mddev *mddev)
 {
+	lockdep_assert_held(&mddev->reconfig_mutex);
+
 	/* stop the array and free an attached data structures.
 	 * This is called from dm-raid
 	 */
-- 
2.40.1



