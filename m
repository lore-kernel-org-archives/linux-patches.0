Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926DF1BC073;
	Tue, 27 Aug 2024 15:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772430; cv=none; b=VoIW7YEQdVXUtIwbfrxihbwqDny5Jr6xcahYJNK0K2VsjLhVG0FXvy/Q2J1Xgje4Fg19+6NQmi7O9kjGP2XWBoE8IAt/zKzzgzzrJrGMUzh0czrXJlSQ7J0vUOTY9tMylyRCvjlXpknmA7Qrkh3rSHFXCBSv4zvJYeGhz+c+4SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772430; c=relaxed/simple;
	bh=2FHDmnpD2MLNdv5npRsy2N1ezFvqUOeK6KKfr71LfqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OHuu5AHmqSLmdAzfwmJNd0drLSh7qj+wc1gjVb2OT3QrKaK6Qwz55UFMEppNJUN/TCa/p/DTeYV9h6ZTBSB0+Y4dBfxBMkRGglz1k50l+NlJN4TsvilQq2tUparydLHErLEOfcFgurREabyVZSXUe3gsXQikSFa0UXfQBKAeqao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vvaOJ1MI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vvaOJ1MI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA4DC4DE18;
	Tue, 27 Aug 2024 15:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772429;
	bh=2FHDmnpD2MLNdv5npRsy2N1ezFvqUOeK6KKfr71LfqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vvaOJ1MIEbGevUDc0CKOIGAoQTP7eql2l3Lzh7ZUgZcWBMj5dsbuzq5jxpuNgchOm
	 gbqwgSnICJT/gIN5ZE+/5deVqQWf1WTa0eCmdMHDsSf1WStrQRjIE73DkEO+Y5hr0X
	 tExyuvCdVnOLfAZShcEJ7S826smTgwuKs5d3B6sA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 213/321] dm suspend: return -ERESTARTSYS instead of -EINTR
Date: Tue, 27 Aug 2024 16:38:41 +0200
Message-ID: <20240827143846.341131453@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 1e1fd567d32fcf7544c6e09e0e5bc6c650da6e23 ]

This commit changes device mapper, so that it returns -ERESTARTSYS
instead of -EINTR when it is interrupted by a signal (so that the ioctl
can be restarted).

The manpage signal(7) says that the ioctl function should be restarted if
the signal was handled with SA_RESTART.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 29270f6f272f6..ddd44a7f79dbf 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2511,7 +2511,7 @@ static int dm_wait_for_bios_completion(struct mapped_device *md, unsigned int ta
 			break;
 
 		if (signal_pending_state(task_state, current)) {
-			r = -EINTR;
+			r = -ERESTARTSYS;
 			break;
 		}
 
@@ -2536,7 +2536,7 @@ static int dm_wait_for_completion(struct mapped_device *md, unsigned int task_st
 			break;
 
 		if (signal_pending_state(task_state, current)) {
-			r = -EINTR;
+			r = -ERESTARTSYS;
 			break;
 		}
 
-- 
2.43.0



