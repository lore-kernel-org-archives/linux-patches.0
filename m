Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6F34778E;
	Mon,  1 Apr 2024 15:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986864; cv=none; b=RzvYvnbrZw44XSM9fLvc4I388kSUxyNwmyoBvvXxjlolkWYwqGD4RZZ1TjHsr0Xquu3AFpDgOo/QEGvcHAzh0cqb6pF/ITVv3AFpgX5A5AoYhAjTGKtGLvnrikzWB+Gkl0p3tGyvmD7PQltw/mdZfQUfCEx8IuKJ1OZfx13Lxfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986864; c=relaxed/simple;
	bh=0ZaJQ7zQ7e2onwqbVnA5XetXYmAKqDJiiN/jRchhMV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KS4DFBwTTHTsKCepFkBx1NF3zYbDKmtSDoFH658BMTrWqooYUl32yg4ohu4xCv0PJOE9tzhUz9G9tt51JCBcu6j+8EuL20ugZScHmv/1aaWRkdRdscEcn+Zp5ZvAFSGbMWogFQykuCvzr2IgTNZdlOqIGt10xtWLbdjcoy84Cm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oIoCWj0b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oIoCWj0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58249C433C7;
	Mon,  1 Apr 2024 15:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986863;
	bh=0ZaJQ7zQ7e2onwqbVnA5XetXYmAKqDJiiN/jRchhMV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oIoCWj0byBUjuCDxoQM3pGLZBu6+R7LFCWLLfNLPgWNmjVqtL62Pk1R/OYP1yGtoa
	 jr56DDcmsnzRFNBQGvctIL7eWD6HGaHI39QAscVrHt2zhHYjE+RrF2sDDBKfLOgNPf
	 FoIWnAWFSc7EofsAOYyRHqlbjhYKF5mZCAwEPr7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Xiao Ni <xni@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 110/399] dm-raid: add a new helper prepare_suspend() in md_personality
Date: Mon,  1 Apr 2024 17:41:16 +0200
Message-ID: <20240401152552.472738893@linuxfoundation.org>
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

[ Upstream commit 5625ff8b72b0e5c13b0fc1fc1f198155af45f729 ]

There are no functional changes for now, prepare to fix a deadlock for
dm-raid456.

Cc: stable@vger.kernel.org # v6.7+
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Xiao Ni <xni@redhat.com>
Acked-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20240305072306.2562024-8-yukuai1@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-raid.c | 18 ++++++++++++++++++
 drivers/md/md.h      |  1 +
 2 files changed, 19 insertions(+)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 8d38cdb221453..b8f5304ca00d1 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3803,6 +3803,23 @@ static void raid_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	blk_limits_io_opt(limits, chunk_size_bytes * mddev_data_stripes(rs));
 }
 
+static void raid_presuspend(struct dm_target *ti)
+{
+	struct raid_set *rs = ti->private;
+	struct mddev *mddev = &rs->md;
+
+	if (!reshape_interrupted(mddev))
+		return;
+
+	/*
+	 * For raid456, if reshape is interrupted, IO across reshape position
+	 * will never make progress, while caller will wait for IO to be done.
+	 * Inform raid456 to handle those IO to prevent deadlock.
+	 */
+	if (mddev->pers && mddev->pers->prepare_suspend)
+		mddev->pers->prepare_suspend(mddev);
+}
+
 static void raid_postsuspend(struct dm_target *ti)
 {
 	struct raid_set *rs = ti->private;
@@ -4087,6 +4104,7 @@ static struct target_type raid_target = {
 	.message = raid_message,
 	.iterate_devices = raid_iterate_devices,
 	.io_hints = raid_io_hints,
+	.presuspend = raid_presuspend,
 	.postsuspend = raid_postsuspend,
 	.preresume = raid_preresume,
 	.resume = raid_resume,
diff --git a/drivers/md/md.h b/drivers/md/md.h
index ea0fd76c17e75..24261f9b676d5 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -649,6 +649,7 @@ struct md_personality
 	int (*start_reshape) (struct mddev *mddev);
 	void (*finish_reshape) (struct mddev *mddev);
 	void (*update_reshape_pos) (struct mddev *mddev);
+	void (*prepare_suspend) (struct mddev *mddev);
 	/* quiesce suspends or resumes internal processing.
 	 * 1 - stop new actions and wait for action io to complete
 	 * 0 - return to normal behaviour
-- 
2.43.0



