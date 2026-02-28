Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F24833F38A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301129; cv=none; b=fkesMQzQ/QZji5yTMhNGT5GZSpv2LWcgghRJphB1FIc8Jxdd0uHk4n6lFpIotf81na3T2rd8vkxbUCR1NZ1Xjcqt4poKKFZQ6vPrIufxRaCkvlut6L0qEO55qdRkdekmMLuZONFY8p4pUPgxCqsnXgEwWLll7knd8jgj4uK1VCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301129; c=relaxed/simple;
	bh=7ozLu9srNkLFIb6bnDfwaHxmOfjHap/v3IqrRMFdmy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CBOX5qauy9kbGy2F6WMupydXsKYxfYvNXDKu8D0B8Eylup8cChhOj/Iy7FwAysWTbXL8ac+b+aGarZvqPgT4sQl6xWtMoboPmCpIAgyFnVgpH3QDD+qyPTY9A2ZY/u3aqk8IAKcv8IUelVanl2/7Mh8J028FNiWzv+643kXRAgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dZ08Epnj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dZ08Epnj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB902C19423;
	Sat, 28 Feb 2026 17:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301129;
	bh=7ozLu9srNkLFIb6bnDfwaHxmOfjHap/v3IqrRMFdmy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dZ08EpnjaRggBjfz2hUijilOTDml+w65DBt09wzDEetHgE3RCwLMiPqPE3Xe3mDuM
	 kilgoxFBVc190a6Axa7baIHm5fyxq3zh7LFZdWbg0wSfPnEe0cwQ9dPC7o5dw69iXc
	 0DQZtbXGn/ox0sS0ip4onHsLVPmLgoSt9SVEQeNoOJzB7D2UdLfqiUE2CXYvcVXYNF
	 uGsvllWSK2DTjghb3ZyRyt+2B6kc+GdcroGiJmqlDRgIK9oi8aPebxs9zQDGpyaIlc
	 g9KQn65JfZRgEYr0j0TcncdNqrqzflAggIyhHZmDiSsVTIDdLmYT2aJ3oH9kFglRSV
	 EzS76qSdS3/mg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 288/752] net/rds: Clear reconnect pending bit
Date: Sat, 28 Feb 2026 12:39:59 -0500
Message-ID: <20260228174750.1542406-288-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Håkon Bugge <haakon.bugge@oracle.com>

[ Upstream commit b89fc7c2523b2b0750d91840f4e52521270d70ed ]

When canceling the reconnect worker, care must be taken to reset the
reconnect-pending bit. If the reconnect worker has not yet been
scheduled before it is canceled, the reconnect-pending bit will stay
on forever.

Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Link: https://patch.msgid.link/20260203055723.1085751-6-achender@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/connection.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index ad8027e6f54ef..dbfea6fa11260 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -429,6 +429,8 @@ void rds_conn_shutdown(struct rds_conn_path *cp)
 	 * to the conn hash, so we never trigger a reconnect on this
 	 * conn - the reconnect is always triggered by the active peer. */
 	cancel_delayed_work_sync(&cp->cp_conn_w);
+
+	clear_bit(RDS_RECONNECT_PENDING, &cp->cp_flags);
 	rcu_read_lock();
 	if (!hlist_unhashed(&conn->c_hash_node)) {
 		rcu_read_unlock();
-- 
2.51.0

