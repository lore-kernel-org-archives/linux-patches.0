Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6AB2EAE6;
	Mon, 23 Dec 2024 16:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969730; cv=none; b=YVRqtWc+ZqxKwXOPJJvbRy77WwRFMY+4DSm9juOV1HJiOjtypv4j8GsWLEZg90b5O5UFGnRBS/ks/E0fvzLu5FzHwPGa3sR6HK/e46jg5DSt+2wIBbmF1PTJSF1TMY9Mq3kR3AJqIVflG9lTnJEXNDUvkEYdmcJtHm0coN4Ut2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969730; c=relaxed/simple;
	bh=Rlmf66jLn65sBIM9IWvLJwGjmMsC94Y/cc9zhnn+Mig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rn3GwJnYofmdf/yj+Iprw2P8fi716rgq1MO9z2fO0kpSstxt92wZEReN2uuk+mjnMYTfL+p7hw7fV7r9m5SxIK3kFzPFAEkQipMoeMjT0O95r2C3S3YbKEwrIZKkpaHC9jhAIL458vYtHdcx7eV3aCnfdDR2vILldwSXNAezVzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q5c2anjC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q5c2anjC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E177CC4CED3;
	Mon, 23 Dec 2024 16:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969730;
	bh=Rlmf66jLn65sBIM9IWvLJwGjmMsC94Y/cc9zhnn+Mig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q5c2anjCNLM9KJIjISwZFLlwT+xbhSyBfx2w3OqEsZU9J7VjVsaVU21COXAM57/L1
	 bXGGeKAAqlcrjlzPtPojhdmVvjtrd2LNh0qjOOvstZh4bQxyCdzaMUBr5NhUTlM6Fh
	 dIW684mIRTlj+4urCzZiK+MyqgEUsnS/pLQduRY8=
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
Subject: [PATCH 6.12 038/160] netdevsim: prevent bad user input in nsim_dev_health_break_write()
Date: Mon, 23 Dec 2024 16:57:29 +0100
Message-ID: <20241223155410.148397005@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 70e8bdf34be9..688f05316b5e 100644
--- a/drivers/net/netdevsim/health.c
+++ b/drivers/net/netdevsim/health.c
@@ -149,6 +149,8 @@ static ssize_t nsim_dev_health_break_write(struct file *file,
 	char *break_msg;
 	int err;
 
+	if (count == 0 || count > PAGE_SIZE)
+		return -EINVAL;
 	break_msg = memdup_user_nul(data, count);
 	if (IS_ERR(break_msg))
 		return PTR_ERR(break_msg);
-- 
2.39.5



