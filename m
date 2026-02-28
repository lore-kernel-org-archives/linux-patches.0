Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3D333A713
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302258; cv=none; b=IlD3s5VMXLD34y+GdUp+lFZ2WadGhPa1rIyfAyjLBBx1jjEP7VTAeRALT9styvhHjia/yW/upzsvDPbtIshKzlSUhvepCLsDdPeDD4IW+UOhEqSG40388ss15ArmTQQ2DkdfhDKTIjKtxN9tsEks6QyzKe0qukvxJOu/eJBJV6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302258; c=relaxed/simple;
	bh=Y6vRaIeFTcNI7GBuu/SIBOAW/fegqR3HMKnvdXOwACA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gvQifw1VnZJQdgdMnrinFkX2VBdD4dbzOB5iYZXcFzY+1CaoH/XO+vJHcw/SqKjMVTSGRzjj67/yYYWsGUP77r8H18BmVlmuOQ0YlttSU/zHlKfRUtObzL9eMf7dP9YBfgsJ1wOFBqKaaU8pTP0duBiBlcABmE+pUcgIWoFT7wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MzYpBHGb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MzYpBHGb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288DFC116D0;
	Sat, 28 Feb 2026 18:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302258;
	bh=Y6vRaIeFTcNI7GBuu/SIBOAW/fegqR3HMKnvdXOwACA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MzYpBHGb4Y2NIFSyHvwYpYOqyqdRC1YO3MoER27BlcjBYdKK4JZwmaGHDmUxR5LRo
	 czgVGu7GPfX00J6946r1/mMANfKOj4jGzcD4LNrqGpcUXBQtk+P3SsPi3IH0j6IFpg
	 B9t9AqckhND0TMGhAehk62MZub+4unjNoJaz7oK0dsgT7EPPD3gl1dspQ+PPMeWs/d
	 GcWve2pOozi9vpuJsuaHlYWccYR8QOMYfDNj/cFPtYFzgzpgXLNfRyj6fQjGTo+i2+
	 fULHd44TuWSwwduYroiJz/SHG0hDERNTCwsLpo6iWW0+Yr3HMnm2vVmYGHoSRPToyd
	 aKgZ+qJ2jXC8w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Allison Henderson <achender@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 273/283] net/rds: rds_sendmsg should not discard payload_len
Date: Sat, 28 Feb 2026 13:06:55 -0500
Message-ID: <20260228180709.1583486-273-sashal@kernel.org>
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

