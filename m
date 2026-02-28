Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C72437524F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302637; cv=none; b=YwSoryvumYq5O/tnPV4dOcuSilgmFHW35XtUC8ub0fVcQ9GLKS4erP5A3RT5fKkN22EyvwbwlS4l+DjgQ9dtUOd+DWj8UGtl93S/gS8/g8FjjIYLj6whFto6R3n8CZeUNGrTa213yh+0uBROs0bDhDZjZyaehVqdE9tWZ555XPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302637; c=relaxed/simple;
	bh=rREs2BS59hyc6Q43XGA3HAssKVarVw9KylKxLDEHd4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FyaSbOvPWn+0oQ1oO49iVM4gbPdI5q+cOZEthYj/goR0CGFws+ObCVuUTq7OvLix/ntlmxVuhLxgn5CER61Gc2BnpbBQiJQnzUazV/ccKbH8wa2iad60LqKc7N7Gu4o0TzeuZoagU8w/AWVU0BbrDaq/+gxx2ijjVOdUeNUMrq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D2iGYIL0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D2iGYIL0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0EEC19423;
	Sat, 28 Feb 2026 18:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302637;
	bh=rREs2BS59hyc6Q43XGA3HAssKVarVw9KylKxLDEHd4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D2iGYIL0QnXNukL0Jl98AUTA0NchgH0+aITFE6Tn1vAhQs3w6GbU8mEG/hNFalJ3k
	 RdgnxL5uTwqCC2cmAvfBnvbknrVxVswgP8cIR9ZOXuR6XX/hKRnq2INWDtkr9F63l0
	 sVrBT1uQ520C07J7wnqa1f1wg6jkicLye+pB1ks1IkIvJdezWq0TJbB5Cn2WAentRw
	 FFJXNpi7aduXF4KXI0QPNooyUnbGLKR2WtXQ3w5hAb+0oD8HG/ocI1ucTTMFa+mA9w
	 EEcLXaGkxiHpJ5K5wnGL+o1RSjDJCsVx9Tu52fWhiepz7a4SSvcYNWoP1hi75oFb3O
	 n6/UibjG89Z6A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Allison Henderson <achender@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 158/164] net/rds: rds_sendmsg should not discard payload_len
Date: Sat, 28 Feb 2026 13:14:57 -0500
Message-ID: <20260228181505.1600663-158-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 85c27d9aa33a3..9a23f8f2bcfa7 100644
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

