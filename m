Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F57032ED2A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301938; cv=none; b=kn4Yc8F1yeN387jHcvF/hHUCP/eCTqVcx4zgla/MZnLemsOBZBOExkVu1UeyFYHR0Pcp0pBE4V+YOB8jzowuhoPs4OE8gZEkNktQsPMt5rCblZJ0FkP+YhD2rdUFKhuQeV9BZM/VZhdAKVm+DCnvELXOeczenrIgQsV9e8sKi04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301938; c=relaxed/simple;
	bh=Y6vRaIeFTcNI7GBuu/SIBOAW/fegqR3HMKnvdXOwACA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BNHMYfZO5mb5mTBkxKc2Xj7MgOMUalT8tUW42pIkmSRPk/8XGAzvUB3DqlQOq3uFloUAgYiN4MKcCbKnieXr5BbBShAx4+UuVGfJkIlS84drrnCzWiZXH/u8byZaZl5Y2gJ5uF4BUjy9lMlI6Ole3hnmjFWfmHJeGrA1vwZHzfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LdPC7AKJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LdPC7AKJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E0C3C19424;
	Sat, 28 Feb 2026 18:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301937;
	bh=Y6vRaIeFTcNI7GBuu/SIBOAW/fegqR3HMKnvdXOwACA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LdPC7AKJs3LSVA3bbAnS2YgE7+BRuKscVt3yP1aygkSP+dRdlMnEVlq89jT09NRRg
	 QhCOwamKkySoC6rSWkL/PGe5mu+5ccNykhWslQ/Xy/vcVnADPAOd03AU5yQM0EDv4U
	 hpunJLxENKcw3gnJBDwVU88PyKwIboQx8s3OUixR6VefY9d4ol8Ej3sPsE90M2xAJ3
	 72kFZjfnl6geKJrZ3oC3jMFrz1lA//89MhHHO7ooHgu9rBk0HcFvsFgskCKtwACLfi
	 KtjUP31xpkTEgSgRyrhijLUaamYKSYjm4bXF1rln/GnsPJGzFhKc7/r04wQMjD4DDb
	 1z8HMzB5kY2uQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Allison Henderson <achender@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 374/385] net/rds: rds_sendmsg should not discard payload_len
Date: Sat, 28 Feb 2026 12:59:56 -0500
Message-ID: <20260228180011.1568201-374-sashal@kernel.org>
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

From: Allison Henderson <achender@kernel.org>

[ Upstream commit da29e453dcb3aa7cabead7915f5f945d0add3a52 ]

Commit 3db6e0d172c9 ("rds: use RCU to synchronize work-enqueue with
connection teardown") modifies rds_sendmsg to avoid enqueueing work
while a tear down is in progress. However, it also changed the return
value of rds_sendmsg to that of rds_send_xmit instead of the
payload_len. This means the user may incorrectly receive errno values
when it should have simply received a payload of 0 while the peer
attempts a reconnections.  So this patch corrects the teardown handling
code to only use the out error path in that case, thus restoring the
original payload_len return value.

Fixes: 3db6e0d172c9 ("rds: use RCU to synchronize work-enqueue with connection teardown")
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20260213035409.1963391-1-achender@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/send.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/rds/send.c b/net/rds/send.c
index 09a2801106549..4a24ee9c22d7c 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -1382,9 +1382,11 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 		else
 			queue_delayed_work(rds_wq, &cpath->cp_send_w, 1);
 		rcu_read_unlock();
+
+		if (ret)
+			goto out;
 	}
-	if (ret)
-		goto out;
+
 	rds_message_put(rm);
 
 	for (ind = 0; ind < vct.indx; ind++)
-- 
2.51.0

