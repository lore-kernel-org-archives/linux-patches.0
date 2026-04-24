Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485113AC00;
	Fri, 24 Apr 2026 13:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037629; cv=none; b=hpaGyYXunw4vNfy9nyLIGfyzpWg5gq3dHfyZApNY6uN4VtuH7Sf/VrF0kx5FOi4fZ/z4MntUqB+x4qnCDIP6MXlNhEup1Sag2XJzN+EHxTosl7ptL5jdGsro5a4+mH5/fs3Ml6sgOlPNLhHqizRRuIMe9y7nMrfB4JMM8MGKd8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037629; c=relaxed/simple;
	bh=uN9wkP2NMTZl8dUJeVkmNzAKqmoFUjJMg5aVe7kZURo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UNdYpOMs7zsMSRtT4OC1RWgzFdBwpwEAX+vHuaR4RKZ8p8FaKFktIrryR1OYRlbaB1eK3810AC21ep5+QAtWtKkSfMGKzGH3diQMVTJe+I8oJ1bQUIE0a0i9Ko5HNGNH/AXTPntLLjyN8Au83w/YwwmjJJg7GAqcnG1Dcq/cRns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VhvlYUqG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VhvlYUqG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFF6C19425;
	Fri, 24 Apr 2026 13:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037629;
	bh=uN9wkP2NMTZl8dUJeVkmNzAKqmoFUjJMg5aVe7kZURo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VhvlYUqGs88CGPRszW5LiIB/jnhChw2FnK7ItqdrlFCHlGTG4yx6Tw36P5WALqLmr
	 yFvxtDXnZLPPsqfz9FmRyIcXVrwpQw22phaXJnMdgCIf6MMNd9/XvCZBFnCahiYMaO
	 6ELfqqkzWX2Py2kyrh1yoUlI7R/yQ25LSM9zofPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 001/166] RDMA/irdma: Fix double free related to rereg_user_mr
Date: Fri, 24 Apr 2026 15:28:35 +0200
Message-ID: <20260424132533.100238278@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit 29a3edd7004bb635d299fb9bc6f0ea4ef13ed5a2 ]

If IB_MR_REREG_TRANS is set during rereg_user_mr, the
umem will be released and a new one will be allocated
in irdma_rereg_mr_trans. If any step of irdma_rereg_mr_trans
fails after the new umem is allocated, it releases the umem,
but does not set iwmr->region to NULL. The problem is that
this failure is propagated to the user, who will then call
ibv_dereg_mr (as they should). Then, the dereg_mr path will
see a non-NULL umem and attempt to call ib_umem_release again.

Fix this by setting iwmr->region to NULL after ib_umem_release.

Fixed: 5ac388db27c4 ("RDMA/irdma: Add support to re-register a memory region")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
Link: https://patch.msgid.link/20260227152743.1183388-1-jmoroni@google.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 532b36b25e919..a18b249fe550e 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -3209,6 +3209,7 @@ static int irdma_rereg_mr_trans(struct irdma_mr *iwmr, u64 start, u64 len,
 
 err:
 	ib_umem_release(region);
+	iwmr->region = NULL;
 	return err;
 }
 
-- 
2.53.0



