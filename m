Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B309C145348;
	Mon,  6 Jan 2025 15:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178549; cv=none; b=L0RKi8NBlm7pJ9whvqfl7eUTfIssNoQ4RU7q3dA4yDohLvw3OCwX51WRuXKm5/saeFE801BMqoAf6sqJ353AUqkiKLdLmgyQGnGyXaCuxWcPx/Lr47Y7pjNSBRDSVqrvTei03wrFhTguXc//1XJhCEcW57BdeEqBTUDGOe7AzsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178549; c=relaxed/simple;
	bh=AcSGX/39iJhpwWoHClaVE811VTIdtTgBFXjL9u9R0xA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AsPfZLFDa+KTWEetRCNidPIra3hcTXka9rSEMOuzmcnw6rvFpBO4pq7DFETKcvah68D+bAUWdFtdDIm6pGRoP8v+IRR6XIRGImVHHLiCP9u7JpFBSD9Ptbd33vSYJ61A22EPBoZXajYNfQdcaGLxRXWYehM/FYtFxXZviTiHvAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fnRS1Dhk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fnRS1Dhk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4A0C4CED2;
	Mon,  6 Jan 2025 15:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178549;
	bh=AcSGX/39iJhpwWoHClaVE811VTIdtTgBFXjL9u9R0xA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fnRS1DhkrMlkjCqGlMY2fyNO/foFqAtZaS+t+G+6t/ma656gZR370b5i/TdMjVkT3
	 TJOXLMPhgZXSiwxjuHuiLxS0EloaRUSLDOWiWLp49wLSbjN8YoBfdwpXXOhq8z8+jo
	 S29f8z7X8IoeYjtlQySWm4MZpXX1BifFSv1rBRXw=
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
Subject: [PATCH 5.15 017/168] netdevsim: prevent bad user input in nsim_dev_health_break_write()
Date: Mon,  6 Jan 2025 16:15:25 +0100
Message-ID: <20250106151139.113581416@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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



