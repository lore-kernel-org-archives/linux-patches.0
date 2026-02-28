Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32DC347FDF
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302475; cv=none; b=iJePP+CZWajhVyXyVN4HwH95tBUPXb/dTc7w+gSL7zU5Qy9Ed7w4bhB9RuG2v/J4+yxU9bOc4lHYMfKluurbeQE2T+pyaqsJBrzeMggRgLUPCThcWfptwvBMEo8J1E41usGHyDx52skigsWku28AJzGk/6v2+3bnoD6FMCC6Pbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302475; c=relaxed/simple;
	bh=M/LrrY29crVFr3aFoHT0QElgwB3MU6tjN5dXqsQ/gEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nCaZNqIq0jVk2EWD2VMYrWddQzlf5X/81SF0yj9w2BqUEIgQXO9daLw0Fyq/7681bsI9U9/AH98f0YGGGWcsU7smHTtUopzjHDBNsBTyZc6WH6ZKhUKPGr0uX0CSdZn54ubhozE9PajBquT3DNy6e7YKgq0VXTmqZKOY065nTHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ub25y03X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ub25y03X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A918C19423;
	Sat, 28 Feb 2026 18:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302475;
	bh=M/LrrY29crVFr3aFoHT0QElgwB3MU6tjN5dXqsQ/gEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ub25y03XDRR383TGzFQYev1hzDJJeoCwgGMFVWJA485SjNm6pIFJXetomiReMlXSp
	 JCeouBXSRSEvjnsXjsL7JkURW/bJ5eOr5i42ghmdi30mFA8igw5qHjgag8IqvwXxxO
	 E6nNxwdT696sR8Yzo7/36OgdT3ZsuzmY+b8h2oJH0jlrOaMOY4YfhkAbVkBvtDyehy
	 RFXkqiY+BJZPJM4u/nixbxsWc4vfezpqrXXOuD7nIChKACa1QL2x0xurTDDd3rXtP4
	 SgTnDj0lGADScy2slpNgHXw/DQhcW1uLgI/Qr4LsEKve07MzFbMT+bizVmkF9LDw0u
	 eijMWP6FDIb/g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Allison Henderson <achender@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 221/232] net/rds: rds_sendmsg should not discard payload_len
Date: Sat, 28 Feb 2026 13:11:14 -0500
Message-ID: <20260228181127.1592657-221-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 0005fb43f2dfa..8aa06f7e4640c 100644
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

