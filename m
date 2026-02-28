Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE5338F629
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302144; cv=none; b=qIIQcc76HJwjQTHIsaMWlM5YgMI9r8/7CJ6iJgpe0pJLdyZ2e9bsjtXn6N6IWqDGskgIYRjoN0xLj2Of/rrU9SoieCid08lEGCV2V6xU2ugN27ZyKW2UPRp/DhwF1kxxU+kDnRRRsq/wEuPOu3nVkouCuDSQ5e06li0pHEeKvxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302144; c=relaxed/simple;
	bh=6wuZXygYBjMa9s6MYDOjhkrnDI9raqsA+0nHrYYqmRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JH1wtOZZj5+YXydLjB+8HyZJBjRHgkdBBaenxuTgcZ4i41Pg28GW3koAZhUsjhphxCE0WqmAzlr3Cmh1Y3AnH2ORN9ijKEhfnsQdzNrSCa6cmiJ1lGrYYkQVC4vL3tdmC/EUP6vo8EWqtxcCppCCuLSWV1odkisqumIqYseA5ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X/ptkhmv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X/ptkhmv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B16C19424;
	Sat, 28 Feb 2026 18:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302144;
	bh=6wuZXygYBjMa9s6MYDOjhkrnDI9raqsA+0nHrYYqmRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X/ptkhmv1s/2ZXOpjzThhXZfdRWrxy30CTELFYyYk+LhydZFOZ9Fr4HYJNlFzTM3G
	 YwE6q2fJq9cd9zn/NrUA9xSLrt+pEW4Sqx0w4UPBqwRBdm/Xyi7oDxrKiT7ALnVpAS
	 AJV98YxdKqeWH2NcM1uS3JFWnNc6W3NzZYvOAnpRxrLKdpL2oE52dbjhvQiwK+oC61
	 C9HVqejo5P1S+w6d6yBJ6PCUwh9ZefoebMhmsrxSUO1QKBazzJ7GTm5evQRPjd8WlZ
	 uAcW/1R7kCwYbN6CMUfMar3fwrN54NM0UiImgBHx9LBscRmRLk8pq2ebtULnymw6i8
	 mKtdeMbfZRVGA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ondrej Mosnacek <omosnace@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <serge@hallyn.com>,
	Eric Biederman <ebiederm@xmission.com>,
	Alexey Gladkov <legion@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 138/283] ucount: check for CAP_SYS_RESOURCE using ns_capable_noaudit()
Date: Sat, 28 Feb 2026 13:04:40 -0500
Message-ID: <20260228180709.1583486-138-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ondrej Mosnacek <omosnace@redhat.com>

[ Upstream commit 0895a000e4fff9e950a7894210db45973e485c35 ]

The user.* sysctls implement the ctl_table_root::permissions hook and they
override the file access mode based on the CAP_SYS_RESOURCE capability (at
most rwx if capable, at most r-- if not).  The capability is being checked
unconditionally, so if an LSM denies the capability, an audit record may
be logged even when access is in fact granted.

Given the logic in the set_permissions() function in kernel/ucount.c and
the unfortunate way the permission checking is implemented, it doesn't
seem viable to avoid false positive denials by deferring the capability
check.  Thus, do the same as in net_ctl_permissions() (net/sysctl_net.c) -
switch from ns_capable() to ns_capable_noaudit(), so that the check never
logs an audit record.

Link: https://lkml.kernel.org/r/20260122140745.239428-1-omosnace@redhat.com
Fixes: dbec28460a89 ("userns: Add per user namespace sysctls.")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Reviewed-by: Paul Moore <paul@paul-moore.com>
Acked-by: Serge Hallyn <serge@hallyn.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Alexey Gladkov <legion@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/ucount.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/ucount.c b/kernel/ucount.c
index a7fd89693bd2a..44ede7a6b805a 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -45,7 +45,7 @@ static int set_permissions(struct ctl_table_header *head,
 	int mode;
 
 	/* Allow users with CAP_SYS_RESOURCE unrestrained access */
-	if (ns_capable(user_ns, CAP_SYS_RESOURCE))
+	if (ns_capable_noaudit(user_ns, CAP_SYS_RESOURCE))
 		mode = (table->mode & S_IRWXU) >> 6;
 	else
 	/* Allow all others at most read-only access */
-- 
2.51.0

