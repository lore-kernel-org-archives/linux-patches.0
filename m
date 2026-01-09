Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019AC33372B;
	Fri,  9 Jan 2026 12:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961911; cv=none; b=KdXf9hEef+KD/wSZfunjATSGUBt4LeNEm+IppEOm7ajlGmvdqGI4FBYPLePFInptVsKS3/z5srCEVcArzF6gMgXGRNMH2o/Ygig4A5AqykrlnxvuC9EtHFGUN9QYCfGkQhuDoqC9jqcQEr/0uqbu/3j5xH6j+QdB5Urjp3IR0h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961911; c=relaxed/simple;
	bh=DqWX3epzI1ARJ7PBKIu92xLpzuWBHe3D8jl+VMVyvUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OE8dTIA+X4KP5qxylEvV1KJY8H+nF1VFMCMSIkF48uFpn7SXJxAYvOEdF38pe2JrkdQkRujCgBYN0Fnjtg8mCJ7IBZE0Pv2J2ttrzNwidVp5Y7TrrWw3+Ix/ayrLJQRiogZ0IP0Polr0Is3y769KWH4e58Vx3dtCdIw3clxMXJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zqaXkEoR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zqaXkEoR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F930C4CEF1;
	Fri,  9 Jan 2026 12:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961910;
	bh=DqWX3epzI1ARJ7PBKIu92xLpzuWBHe3D8jl+VMVyvUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zqaXkEoR0D1u5QRGK/kkBFlwFPZCyCbHn4zZfPKPb3S7BWUekLtPujcXVsF/ter2x
	 9vp8fSVUTP12vIe3C8GIuxGFqFcXu5C0cuecQAf3UWsH6RccE8XzA/1/Oz1oJVol1e
	 Bpcwp6SeWALMBCkzD6mq4ITgRNzWKDASNVpG8lPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 180/634] md: export md_is_rdwr() and is_md_suspended()
Date: Fri,  9 Jan 2026 12:37:38 +0100
Message-ID: <20260109112124.215109288@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 431e61257d631157e1d374f1368febf37aa59f7c ]

The two apis will be used later to fix a deadlock in raid456, there are
no functional changes.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20230512015610.821290-4-yukuai1@huaweicloud.com
Stable-dep-of: a913d1f6a7f6 ("md/raid5: fix IO hang when array is broken with IO inflight")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 16 ----------------
 drivers/md/md.h | 17 +++++++++++++++++
 2 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index a9fcfcbc2d110..fa1f487eb0300 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -93,18 +93,6 @@ static int remove_and_add_spares(struct mddev *mddev,
 				 struct md_rdev *this);
 static void mddev_detach(struct mddev *mddev);
 
-enum md_ro_state {
-	MD_RDWR,
-	MD_RDONLY,
-	MD_AUTO_READ,
-	MD_MAX_STATE
-};
-
-static bool md_is_rdwr(struct mddev *mddev)
-{
-	return (mddev->ro == MD_RDWR);
-}
-
 /*
  * Default number of read corrections we'll attempt on an rdev
  * before ejecting it from the array. We divide the read error
@@ -380,10 +368,6 @@ EXPORT_SYMBOL_GPL(md_new_event);
 static LIST_HEAD(all_mddevs);
 static DEFINE_SPINLOCK(all_mddevs_lock);
 
-static bool is_md_suspended(struct mddev *mddev)
-{
-	return percpu_ref_is_dying(&mddev->active_io);
-}
 /* Rather than calling directly into the personality make_request function,
  * IO requests come here first so that we can check if the device is
  * being suspended pending a reconfiguration.
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 1fda5e139beb0..1d048976e7432 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -555,6 +555,23 @@ enum recovery_flags {
 	MD_RESYNCING_REMOTE,	/* remote node is running resync thread */
 };
 
+enum md_ro_state {
+	MD_RDWR,
+	MD_RDONLY,
+	MD_AUTO_READ,
+	MD_MAX_STATE
+};
+
+static inline bool md_is_rdwr(struct mddev *mddev)
+{
+	return (mddev->ro == MD_RDWR);
+}
+
+static inline bool is_md_suspended(struct mddev *mddev)
+{
+	return percpu_ref_is_dying(&mddev->active_io);
+}
+
 static inline int __must_check mddev_lock(struct mddev *mddev)
 {
 	return mutex_lock_interruptible(&mddev->reconfig_mutex);
-- 
2.51.0



