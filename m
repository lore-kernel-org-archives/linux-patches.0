Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8185B3CB57A;
	Sat, 17 Oct 2026 17:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258428; cv=none; b=DSwowSR8r/ju46wSsDnfScVzLBIjsH3bZEk3fQnFW+E5krH3+S2iI0+RMRjiYJ05eh+0JRR0hL4bSuiiSJPDCbeREGzYxGvjsE9jBznant3l5/RFyXOVGxNhByI5ZMadygdteAf1Z5MYghE/ZrBBfjbKr9QAS0nNdP4uWilirzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258428; c=relaxed/simple;
	bh=GZeAfmPxS3dvRjx00480h+70FFjeon6jtYeyEGwhMPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YtnXZ87KNwf0vu8Rx0gqzd+6wjg0DZqK2SLC5gBbBa/J58qDQoNm4ADY528RnXvq24wrgejGNmzfQWVlr/Ceu/lDSoe4HTQBxjmMzq2PejhBeopOc1xTRC1DSu1AGeUzMG8ejSP+jKF/jXWR5g99gIpQhDHAb16F5JvtXqqpUYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ul2eC4ZI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ul2eC4ZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92631F000C4;
	Sat, 17 Oct 2026 17:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258427;
	bh=2voDbs/498Srl2L/VjTSdXSFBqTMZFeMH+21haEWWXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ul2eC4ZIOi4C6wLib43Ni1G9mcwKJUg6eZLITTPmxTt/naBuuIiDJ3oRnLoJfVNVS
	 300OC2kxyaEmzESfO01+SQlxmeYJnyEFdGzBtHh/vCZpK1YfyZsqMckb7hwgnYtlw5
	 1VXILAAaGq58+R8EZpo00hcFJ/GL6HYkMLd+G+zI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0844/1674] md: add new helpers to suspend/resume and lock/unlock array
Date: Sat, 17 Oct 2026 17:51:56 +0200
Message-ID: <20261017160452.790614467@linuxfoundation.org>
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

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit f45461e24febab5c2ba8f331e9eb109bb59cbdc1 ]

The new helpers suspend the array first and then lock the array,

Prepare to refactor from:

mddev_lock/lock_nointr
mddev_suspend
...
mddev_resuem
mddev_lock

With:

mddev_suspend_and_lock/lock_nointr
...
mddev_unlock_and_resume

After all the use cases is refactored, mddev_suspend/resume() will be
removed.

And mddev_suspend_and_lock() will also replace mddev_lock() for the case
that the array will be reconfigured, in order to synchronize with io to
prevent problems in many corner cases.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20231010151958.145896-6-yukuai1@huaweicloud.com
Stable-dep-of: 2cc583653bbe ("md: suspend array while updating raid_disks via sysfs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.h | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index a487e5c0648b5..a2e480ad3861e 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -869,6 +869,33 @@ static inline void mddev_check_write_zeroes(struct mddev *mddev, struct bio *bio
 		mddev->queue->limits.max_write_zeroes_sectors = 0;
 }
 
+static inline int mddev_suspend_and_lock(struct mddev *mddev)
+{
+	int ret;
+
+	ret = __mddev_suspend(mddev, true);
+	if (ret)
+		return ret;
+
+	ret = mddev_lock(mddev);
+	if (ret)
+		__mddev_resume(mddev);
+
+	return ret;
+}
+
+static inline void mddev_suspend_and_lock_nointr(struct mddev *mddev)
+{
+	__mddev_suspend(mddev, false);
+	mutex_lock(&mddev->reconfig_mutex);
+}
+
+static inline void mddev_unlock_and_resume(struct mddev *mddev)
+{
+	mddev_unlock(mddev);
+	__mddev_resume(mddev);
+}
+
 struct mdu_array_info_s;
 struct mdu_disk_info_s;
 
-- 
2.53.0



