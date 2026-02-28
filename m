Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61533382D6
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301644; cv=none; b=FtbCcRe/EO5stddipfQdBzK3oUMG/+eHWCV2GcHHRjr9iIOwceNhUpHa8HZqQ/7AbELDmKW+GABJheqUfAk2kdJuZqkI1J5QH4YacPMlDLGB4eFxnqo4SjkyfbE5SFML0Ewqab9B5F+l+NgJ36QuxI/lZmqrh5cTC7nWCc21ygM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301644; c=relaxed/simple;
	bh=sV7crpFc42X6LVi+YaL47H/Urqys2mBVNHBa2O1EUBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aays6n/UrDIY2ku+54pjcl+hphCWd91yPjC1H4g4SsurtrAYUMyeBrFkLrWlfouobkOCdI9hxpZQ7661tfEA6vHxLte1gnBKbSgmtwTgwX7dqUYbi/eIdZcW01XT92SHpq0HrspSPX5MFxhTF2geBOLTT5711BqYTEPnBrdEHtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pdrheh2D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pdrheh2D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6B1C19425;
	Sat, 28 Feb 2026 18:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301644;
	bh=sV7crpFc42X6LVi+YaL47H/Urqys2mBVNHBa2O1EUBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pdrheh2DFzr5expX7RqjjC1fkO7xDkdTrO3Zes9aCz6cMIEjlEwT+XvkMX4KPBTXd
	 LfUzp3F8rJ14MyaErCdzZAJ64D4l0UKwYQIlC8+ObCc3R1nlKAoLc00hm198/tLmx/
	 mrIrQnh8X2y1PaddDcwX7f4CMscpt4m/slkPwM9hus8Dsll28NY0xT6cH7qzq9pl0u
	 jrYYniy9U9u0mI3bfwlFSwJ2RZ+MktVsCFLCx1whwTuqnsYaBg+4FgOeqIFYE+kt9y
	 7rgn5hWWWRTLUbsDcDwRv2TdsDKsLlexZ2OsW0SnFb9kkV4A13D2KXiFklDykLCPFY
	 RIVmwkcc3wQKQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Govindarajulu Varadarajan <govind.varadar@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 039/385] ublk: Validate SQE128 flag before accessing the cmd
Date: Sat, 28 Feb 2026 12:54:21 -0500
Message-ID: <20260228180011.1568201-39-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 2d46383e8d26b..c6a59f02944fc 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -3026,10 +3026,10 @@ static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		return -EAGAIN;
 
-	ublk_ctrl_cmd_dump(cmd);
-
 	if (!(issue_flags & IO_URING_F_SQE128))
-		goto out;
+		return -EINVAL;
+
+	ublk_ctrl_cmd_dump(cmd);
 
 	ret = ublk_check_cmd_op(cmd_op);
 	if (ret)
-- 
2.51.0

