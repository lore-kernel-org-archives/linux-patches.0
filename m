Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8091B1A8F80;
	Mon, 23 Dec 2024 16:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970641; cv=none; b=cSLVsrSkWZhDEZSUWoiGLGD6EB61C8xY5EWUNqiEw4oDhk2qJk2CBktWqR7Pw6u2unDK7KkepU8eNKZgATXYQcdE7XgrWSIIuhBrGchmWDKe0eN/50ONPoUJJFN9qZ8yC9xJdG15Eb1+sZsLpxBYxmwucF3LVeaI4UiOblgeZwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970641; c=relaxed/simple;
	bh=oQTTH0+QCqlzFhzbwQQ7+aWW2ga9iK+RWFQxBpZSzu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIojzNjwGN0/zLDvVwzr+TTjHTOU8S2euKxQ3oLt5oKHY3EC0NHsC2MS1EIPv/L4WYYPsk29rnXjNkAPBVqKzrETpJinJVoO0oiA32odywvNHvFt16iaToTb6/LJ1GV7aEUVYcRW69fj0mqeFvhF3dwXZbTzgh6Fd9Lji/GP0lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FLeqgPmu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FLeqgPmu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA830C4CED7;
	Mon, 23 Dec 2024 16:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970641;
	bh=oQTTH0+QCqlzFhzbwQQ7+aWW2ga9iK+RWFQxBpZSzu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FLeqgPmubLPQHr3SmazF2gAAt+WzblY3Yy295GLEoZXH8VKPdEKIIYxmNuwweFDud
	 OrX/xNm9lqKhPo03PbqOoIPYUdzNdZ4iZbKP3OTLA11yMaEnZ1T2rt4U8Ssv/5TOhq
	 nxXi6LvMksLvxpHJYkbUK7gLsqjEOhlhM1LqsJJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ea40e4294e58b0292f74@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Joe Damato <jdamato@fastly.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 25/83] netdevsim: prevent bad user input in nsim_dev_health_break_write()
Date: Mon, 23 Dec 2024 16:59:04 +0100
Message-ID: <20241223155354.609136115@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ee76746387f6233bdfa93d7406990f923641568f ]

If either a zero count or a large one is provided, kernel can crash.

Fixes: 82c93a87bf8b ("netdevsim: implement couple of testing devlink health reporters")
Reported-by: syzbot+ea40e4294e58b0292f74@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/675c6862.050a0220.37aaf.00b1.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Joe Damato <jdamato@fastly.com>
Link: https://patch.msgid.link/20241213172518.2415666-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netdevsim/health.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/netdevsim/health.c b/drivers/net/netdevsim/health.c
index aa77af4a68df..bc44462c70e2 100644
--- a/drivers/net/netdevsim/health.c
+++ b/drivers/net/netdevsim/health.c
@@ -203,6 +203,8 @@ static ssize_t nsim_dev_health_break_write(struct file *file,
 	char *break_msg;
 	int err;
 
+	if (count == 0 || count > PAGE_SIZE)
+		return -EINVAL;
 	break_msg = memdup_user_nul(data, count);
 	if (IS_ERR(break_msg))
 		return PTR_ERR(break_msg);
-- 
2.39.5



