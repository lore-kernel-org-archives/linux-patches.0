Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5376435AC20
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302769; cv=none; b=Cjwyv7J6wpXeA+iIC132dIiLVyR0SqTHir4CYsniSSc7970OAM6P/C6IAlz1+zEKHOrcJKtzHbJgl9BWTicru8P6ZGAuLkvAmOE59mP3NQC2gH0IuPAH/aJtN5TMTt1s5VGwkvC0G4raRj62Mw73cxU6vHrDN5jWy/v7Dyd2rvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302769; c=relaxed/simple;
	bh=mIHCDE+qDDTaRlB96J22S7xRcCI0c1uCYmUudVAwpnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ej6gpKe0G/OwwJM20RB99WGCDzpCCDl92XvS3iSHxEA6WwXqobMG7W9NKOT+xU2MgVFMJewnSfhg+pfNXTr8bNRWvXTvYhuJ4VkTYxdV4CsvVzJ6pAwZ//uGb9KP7DZ5DXEFzwmZLIqL8bRL2J2Zr0MJ5VLDGu8Rk/UIybi6FZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pwIU4o/E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pwIU4o/E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A35D7C2BCB4;
	Sat, 28 Feb 2026 18:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302769;
	bh=mIHCDE+qDDTaRlB96J22S7xRcCI0c1uCYmUudVAwpnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pwIU4o/E/2viBM0aUNrUMlLt2eotT3mXreS6ZLhppWINu6wwdDY0A9553izDnwnaL
	 gR13JHJ8Ng5i42sXFOZbmetI64hs8xXhVpjRRQkCiHvF5QSfFPT0bDcs5ySdUoPatw
	 EuRVMD1sUE04mS/e9qWT4l84Fr/IhD5PMLs/JCy8ML2f8X7pcSiZ5cfEhSSBG5RyxP
	 6K80zPJjdaFsR9NVKCc7eJueCjgc5KpKttAQV5nFxWKA0KvpfkK2jbEK/iq9aGAH+X
	 iRtqDSd6iTzG7+fe2aU5bnIA/AfwkAn01JSlP2gf+n4z2m3IEbexYEv9subtClXlzO
	 ncQGPiOMksLew==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Allison Henderson <achender@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 141/147] net/rds: rds_sendmsg should not discard payload_len
Date: Sat, 28 Feb 2026 13:17:29 -0500
Message-ID: <20260228181736.1605592-141-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index 1923eaa91e939..131c59cd5abb0 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -1383,9 +1383,11 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
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

