Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC326146D40;
	Mon,  6 Jan 2025 15:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178133; cv=none; b=sWZvK6G3p1yJ59DXYi3VU0c7s8NhyQWLQBu8AemJT9n6Non3imw+S3dIKGZ8zGbE+Rc1j7K1c1GSNvcaG2jmciU+Aa0u+ULbrE4SVgLAL8gwU1TfQh605f9ORvlk2nb4Klu/8Biz/Hc4h9RP9L0jqcCx811G19Q/aoU42miQvjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178133; c=relaxed/simple;
	bh=AZjbOWTy4+TWmIPF7wDqQeF/Xx5fMVVZKGRasbHCs2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fS4W+CEV5fHu/bVRMe7IrX1Jm0pnJLd3kCRAZX8oH07f17N9tzGzfBiccIFhpmwf+pqo7O1R6Hx33B13tnD01GfdKQ3JcYPtmr4FD2h58S5c1seOJp/zD+pYrqgwI1sxLBRYo3ufEElfH/K4LS+6qA7nAb1cTCuw0O2QgDpzmv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b9Lee43a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b9Lee43a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B025C4CED2;
	Mon,  6 Jan 2025 15:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178132;
	bh=AZjbOWTy4+TWmIPF7wDqQeF/Xx5fMVVZKGRasbHCs2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b9Lee43aECBWonW1ZKwLy+zDNRWF9v2HSqXzREy2ZERrdIsl1qdi1DO28pyqcZCTq
	 1aLYlICwVwPW3Lx8ddYlK1X05feIhq4fVH25kymD4NF9hvLzZLfbY9t3Xj2WY9SAif
	 HEXswBWujwZ+Sms1th9gIHmMUiAvVl7ruemBiRac=
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
Subject: [PATCH 5.10 016/138] netdevsim: prevent bad user input in nsim_dev_health_break_write()
Date: Mon,  6 Jan 2025 16:15:40 +0100
Message-ID: <20250106151133.833077935@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 04aebdf85747..c9306506b741 100644
--- a/drivers/net/netdevsim/health.c
+++ b/drivers/net/netdevsim/health.c
@@ -235,6 +235,8 @@ static ssize_t nsim_dev_health_break_write(struct file *file,
 	char *break_msg;
 	int err;
 
+	if (count == 0 || count > PAGE_SIZE)
+		return -EINVAL;
 	break_msg = memdup_user_nul(data, count);
 	if (IS_ERR(break_msg))
 		return PTR_ERR(break_msg);
-- 
2.39.5



