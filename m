Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCF7340A79
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301067; cv=none; b=STc17+xzAnrQHI2fQBNyRkDkbOdnHjnSupIQt0ljlFiPyP/Sc5gjjs2gchpX/krn+4N5D3gj1J1cv061xKfhu/kZv7qMY0wOzIY2bFjkJ25dAWpFKD0u7UKRFjKgHeAHk+zHDX7HAEPV/+pNgi7/7ScgOiXpzqlSlQBmpM3h7hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301067; c=relaxed/simple;
	bh=LyZ/27qtiTLH0I9CxW4AZjmAEqEIB2XWjddTJGCZlFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qboO6EYxYvvbjVKkxtw4WoC/XI7N+nZb9nXt6JobtL0z/gc7j6arEUaZE0DhF2JZvrDV+BzFc1EH6Y5/ok6GKt/Tl/Nbncht9MLQ7MW6Zy+3fEXEI34iAyXpcuyd0T/CyZNrbNDj0gbOdkyKV43SgzJfmRTKWQwieQaNCDKBKEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CKlwsqqm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CKlwsqqm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3EE5C19423;
	Sat, 28 Feb 2026 17:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301067;
	bh=LyZ/27qtiTLH0I9CxW4AZjmAEqEIB2XWjddTJGCZlFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CKlwsqqm0nPj7tHEIDqufxfnl5OQex1o65+UTkrw5nK1MJ7VN2HC15+mVnXowiFyq
	 Ykzh+tdYX7/lFTI3yT0hnrBfcwxwz+L7rztajUnC2TIpGeVe54CGAyQPd82CzosWwA
	 H5U5OwU2esZEY5pDuo9cglB/A6eDeez8gHWeKKHA8iRhVll9gBLNlI//fKUdNOSYr+
	 jJQFcOPnp4L8mFHCeBhWusn8b+8fx7CBYl3XzV/U5hnD0Y1PMukfdgS4Ipdhdd0Bcd
	 LnBIueGVooLR8T6k0b5jYYgfLoUV62JKAGueOu+uqJfsVt+Y0VK+ZlPz2IBV/vFEtv
	 cum/AkKz1u5zg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haotian Zhang <vulab@iscas.ac.cn>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 211/752] jfs: Add missing set_freezable() for freezable kthread
Date: Sat, 28 Feb 2026 12:38:42 -0500
Message-ID: <20260228174750.1542406-211-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit eb0cfcf265714b419cc3549895a00632e76732ae ]

The jfsIOWait() thread calls try_to_freeze() but lacks set_freezable(),
causing it to remain non-freezable by default. This prevents proper
freezing during system suspend.

Add set_freezable() to make the thread freezable as intended.

Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_logmgr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index b343c5ea11592..5b1c5da041630 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -2311,6 +2311,7 @@ int jfsIOWait(void *arg)
 {
 	struct lbuf *bp;
 
+	set_freezable();
 	do {
 		spin_lock_irq(&log_redrive_lock);
 		while ((bp = log_redrive_list)) {
-- 
2.51.0

