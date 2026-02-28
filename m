Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C050B36C9D8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302308; cv=none; b=m+HbIaW6U/hn62aR1CDOxlcX+Kg4s6XG+OMUClp3ZsPXqR9it7zl7n6EcHiiwiWSGaeOBcBoKj753Sr7oKd1uS5By2UjYDCW+BF7xXQB+CcICIfRbu+JK7v3Ps3pyUU80/LL43KFAX7nd9vIYql+kAVMvOQH7GLSMGykwg5H8g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302308; c=relaxed/simple;
	bh=ASxGM55k380/XefcxuwAOV3xmv07riC2A50EThmJLnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RSb1XbyIQNvCP5jx55PwLNfm603m+rgK3QTgIfW9d97uGMQ3m/GF7exyNAdTDB4uYfAoVI93jQLfAo5PdiG16KY53NX7z05DBF7aUKeXRGyw3sMWa2wcXQxoE0UAd8WmpLGehx+SabRBHJxudNpZyHKrBIkkvwzqHwI09lKqJ58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jJ8vYKsy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jJ8vYKsy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038C7C116D0;
	Sat, 28 Feb 2026 18:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302308;
	bh=ASxGM55k380/XefcxuwAOV3xmv07riC2A50EThmJLnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jJ8vYKsyd4G+gVfz2Dl/DR9N3R0ZnTOJrEzihrgq11ufxaZnvqCyVOP6tykXjCTXP
	 +Mkz/qZg3uH34kqSyhDS19nLJGYwKb9LdTK9sbxiPh1uERMmKdrji7FX3y7TV/AMZW
	 ugGgMda6gFcFo05ID5xNzyqRk/INfqSPziNdXZwl8WeF5/JcDKYjip0smoizLD5MAk
	 zDhVQZHjV8I27orqIxueABmKGAeCkmHjSaqAtXpUB0c57gC8Yvqps2neufaBA/qP1q
	 i7UHx01fiHxSMHZlTnLsQwHaixVWbHOjnglb+tjYaUpZL68WnW28pdXlQTXni0Bbod
	 VvSipTSOm0GkA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Govindarajulu Varadarajan <govind.varadar@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/232] ublk: Validate SQE128 flag before accessing the cmd
Date: Sat, 28 Feb 2026 13:07:57 -0500
Message-ID: <20260228181127.1592657-24-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Govindarajulu Varadarajan <govind.varadar@gmail.com>

[ Upstream commit da7e4b75e50c087d2031a92f6646eb90f7045a67 ]

ublk_ctrl_cmd_dump() accesses (header *)sqe->cmd before
IO_URING_F_SQE128 flag check. This could cause out of boundary memory
access.

Move the SQE128 flag check earlier in ublk_ctrl_uring_cmd() to return
-EINVAL immediately if the flag is not set.

Fixes: 71f28f3136af ("ublk_drv: add io_uring based userspace block driver")
Signed-off-by: Govindarajulu Varadarajan <govind.varadar@gmail.com>
Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 3a7c42f76d894..121b62f8bb0a2 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2010,10 +2010,10 @@ static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		return -EAGAIN;
 
-	ublk_ctrl_cmd_dump(cmd);
-
 	if (!(issue_flags & IO_URING_F_SQE128))
-		goto out;
+		return -EINVAL;
+
+	ublk_ctrl_cmd_dump(cmd);
 
 	ret = -EPERM;
 	if (!capable(CAP_SYS_ADMIN))
-- 
2.51.0

