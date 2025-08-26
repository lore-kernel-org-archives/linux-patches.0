Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBD029D26A;
	Tue, 26 Aug 2025 11:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208105; cv=none; b=A4joQLZxpb7vvUYIPBYlwMb0joGQgf3jm6B0GLSartuZp0VqFp09uUJgbJ+BNlcLZEKFq6ayYJ3ca77+NP6102VebXq4xcqqd6RJID3LKjj7cGCdqDG41jZ1HVLgo4BpZcgC2YqelIMPbWsr99wYifdBmQ82Z2/KAgJW4Fgu2Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208105; c=relaxed/simple;
	bh=K+hx8Mf/Yxamu6xGbt+x2Y6uWqZVBf4gugvzJXi8WnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WgqfkScAlKTEsTWNx2agQ4m/3R5iYkUaTeCfUG+IdIhBIflAj59BowFA+7qh4hJNYMK2Nd4yotHKmCt7Cm2pU593VwPT6aXzcFx60fZiKGNnK5gi3yax8gngVYrKkub+rA28wnHsjKIWULOO/tK/6RBdiI6ln9OchdumRNbg66o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lqAofdUD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lqAofdUD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EED5C4CEF1;
	Tue, 26 Aug 2025 11:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208105;
	bh=K+hx8Mf/Yxamu6xGbt+x2Y6uWqZVBf4gugvzJXi8WnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lqAofdUDy9CKSQ2rATNxgVXguVzYwUuPql7jWzPCDBRFbXvGpKHLeYLhqtaGiohlG
	 uxwxjm1GLdzkrQ6SYICWN3x3FfKglZwIxk2ounNEGbgCtE7Nx9sIthy7RIzcz2m3F2
	 TBTejLB1FN9i5qU7ZakOuIPutaXu0t/SYDQ7xNak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 439/457] net: airoha: ppe: Do not invalid PPE entries in case of SW hash collision
Date: Tue, 26 Aug 2025 13:12:03 +0200
Message-ID: <20250826110948.135823333@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 9f6b606b6b37e61427412708411e8e04b1a858e8 ]

SW hash computed by airoha_ppe_foe_get_entry_hash routine (used for
foe_flow hlist) can theoretically produce collisions between two
different HW PPE entries.
In airoha_ppe_foe_insert_entry() if the collision occurs we will mark
the second PPE entry in the list as stale (setting the hw hash to 0xffff).
Stale entries are no more updated in airoha_ppe_foe_flow_entry_update
routine and so they are removed by Netfilter.
Fix the problem not marking the second entry as stale in
airoha_ppe_foe_insert_entry routine if we have already inserted the
brand new entry in the PPE table and let Netfilter remove real stale
entries according to their timestamp.
Please note this is just a theoretical issue spotted reviewing the code
and not faced running the system.

Fixes: cd53f622611f9 ("net: airoha: Add L2 hw acceleration support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20250818-airoha-en7581-hash-collision-fix-v1-1-d190c4b53d1c@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_ppe.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_ppe.c b/drivers/net/ethernet/airoha/airoha_ppe.c
index 7832fe8fc202..af6e4d4c0ece 100644
--- a/drivers/net/ethernet/airoha/airoha_ppe.c
+++ b/drivers/net/ethernet/airoha/airoha_ppe.c
@@ -726,10 +726,8 @@ static void airoha_ppe_foe_insert_entry(struct airoha_ppe *ppe,
 			continue;
 		}
 
-		if (commit_done || !airoha_ppe_foe_compare_entry(e, hwe)) {
-			e->hash = 0xffff;
+		if (!airoha_ppe_foe_compare_entry(e, hwe))
 			continue;
-		}
 
 		airoha_ppe_foe_commit_entry(ppe, &e->data, hash);
 		commit_done = true;
-- 
2.50.1



