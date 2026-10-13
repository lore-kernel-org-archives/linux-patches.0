Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFA23AFD03;
	Tue, 13 Oct 2026 11:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892534; cv=none; b=RJUqeNtmAVZNPyITDh2YqIpJnywxI6t+oDzdjVddpZUtrIF/N3LDWJjATh5qM61/0QZYFDzHy/FUYSXf+Z+boyTxqLsVOe59CBw3RqzqdSNW3IkVUMR3+Wei/RzHRmHdqsNLfhBXqn6NYLuWBG2kqaB4qvDNXK7m5LVyspScQ4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892534; c=relaxed/simple;
	bh=8wKREZSAL5g5tUFaKLWWNHlzEfcwu6coj38pcDSKrH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dbfu4as/waJN5vVHM+gfqBsPGgHSkW5PrMuStdybAhxAo2cK0IQYd5ugaEF9mRw5MKrU/YijXCw16QsJTsJfYVd11vgPB+ElIqOH3nxKrflgxbKbAmEe7/qR0wGDVNi0VP+4950DHa3rMWp7W0uNxPJffZCaNiYgj5VI8dnoEFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iTuOHN+U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iTuOHN+U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2941F000FF;
	Tue, 13 Oct 2026 11:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892533;
	bh=V26QKUmzKzsnSdWnCj16O4JYcjajOPkav8B1/L3f6to=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iTuOHN+Uts83Uz5iUvCEvm6R6ryOTx5h0i1PycYCALgZ+RUTsA2BVbdxTP/D/LWbs
	 AdHCECIbwhVkz9iT6aNUDOd4iuTykAT1/nHzuk9XevIBWsIuEME6SsYrOjdB2Z8BAP
	 BacJzglYRINbKiJOz0BpeawrW6Q4Ed16EhwGg1TM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 204/281] bonding: fix the program leak when XDP is replaced
Date: Tue, 13 Oct 2026 13:38:40 +0200
Message-ID: <20261013112900.113254115@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 184b5ddf82d45d6f75cc83719a2e453392512bd2 ]

We need to release the reference on the old BPF prog, whether
we are going to no-prog, or replacing the prog with another.

Spotted by AI while running tests for the propagation series
(leaked programs were accumulating). Selftest will come in
the net-next series to avoid conflicts.

Fixes: 9e2ee5c7e7c3 ("net, bonding: Add XDP support to the bonding driver")
Fixes: 6d5f1ef83868 ("bonding: Fix negative jump label count on nested bonding")
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://patch.msgid.link/20261001012639.298690-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 34c5bbbed9aee..507d655eca21e 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -5738,12 +5738,12 @@ static int bond_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 			bpf_prog_inc(prog);
 	}
 
-	if (prog) {
+	if (prog && !old_prog)
 		static_branch_inc(&bpf_master_redirect_enabled_key);
-	} else if (old_prog) {
-		bpf_prog_put(old_prog);
+	else if (!prog && old_prog)
 		static_branch_dec(&bpf_master_redirect_enabled_key);
-	}
+	if (old_prog)
+		bpf_prog_put(old_prog);
 
 	return 0;
 
-- 
2.53.0



