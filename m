Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A067417A2E8;
	Mon, 10 Mar 2025 18:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629704; cv=none; b=XYZIF1eTJSkq1L0+FdUSWy7wKvToG4BXvuqj7WNnlq3dRh6jgt0J3BP5Ba82JtTvxGUrzH7x6OTWhSqsoL1twR9Ka0FYfVMRjWRwEuHVt9KJlaZDLuEeFnorUvg0IR5VOrY0FvpCb8QFUYkxWzgXqi7eR0iKB5iAjIh5hCJZkCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629704; c=relaxed/simple;
	bh=qK7tm43rx/bO8fj4yDdZ/koBqsVfK3Ud44h6+scw9vM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=koeTX1wtE4jXEUo6opPP6wjMlt+nG+z9IMWwchywRMUWTuyV9oRaQ3x/FfXwBhAWa6PJWIDbrrKmz9bzwAhmihcB5OGqojssQVbkPCnUj6J7tamv67XJ0mCL2rV33PYBY+ZK2tcL0WmZwVZS5VEn9YVyZYELL64xWfqwXmhX5sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HBbYIGYO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HBbYIGYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29FC1C4CEE5;
	Mon, 10 Mar 2025 18:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629704;
	bh=qK7tm43rx/bO8fj4yDdZ/koBqsVfK3Ud44h6+scw9vM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HBbYIGYO+LN5JlIR4ossTs3oqB3mus2ZtauNNMGHvW1hUQgItBHS6bp+RPiNb47c5
	 R+48/nuac7g7NanuJ7ky7M5EPU8z9S7TEee1Hxl4+ucMJ4SPqfn/Smnv669WHdztpp
	 xMHuxfn5e7ckNnfzF7vhpk/y6Kco7EmVHSCdkKEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Marshall <hubcap@omnibond.com>,
	syzbot+fc519d7875f2d9186c1f@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 354/620] orangefs: fix a oob in orangefs_debug_write
Date: Mon, 10 Mar 2025 18:03:20 +0100
Message-ID: <20250310170559.584311100@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Marshall <hubcap@omnibond.com>

[ Upstream commit f7c848431632598ff9bce57a659db6af60d75b39 ]

I got a syzbot report: slab-out-of-bounds Read in
orangefs_debug_write... several people suggested fixes,
I tested Al Viro's suggestion and made this patch.

Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Reported-by: syzbot+fc519d7875f2d9186c1f@syzkaller.appspotmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/orangefs/orangefs-debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/orangefs/orangefs-debugfs.c b/fs/orangefs/orangefs-debugfs.c
index 1b508f5433846..fa41db0884880 100644
--- a/fs/orangefs/orangefs-debugfs.c
+++ b/fs/orangefs/orangefs-debugfs.c
@@ -393,9 +393,9 @@ static ssize_t orangefs_debug_write(struct file *file,
 	 * Thwart users who try to jamb a ridiculous number
 	 * of bytes into the debug file...
 	 */
-	if (count > ORANGEFS_MAX_DEBUG_STRING_LEN + 1) {
+	if (count > ORANGEFS_MAX_DEBUG_STRING_LEN) {
 		silly = count;
-		count = ORANGEFS_MAX_DEBUG_STRING_LEN + 1;
+		count = ORANGEFS_MAX_DEBUG_STRING_LEN;
 	}
 
 	buf = kzalloc(ORANGEFS_MAX_DEBUG_STRING_LEN, GFP_KERNEL);
-- 
2.39.5



