Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754BD1EA99;
	Mon,  4 Mar 2024 21:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587552; cv=none; b=H8Bu+qsnhn4Uje60sZEgJwGHbUOnCNLlkEjJMiyma73sxGt+Ss6VlrzZ+CRwNbpzm6uVgHqC2wOJjSD3C5vMXBHOrNjEnijN93+YKQLDO8vlfFWP7VlySllcBOwGNKiem2KxbJ+OkZE/83YHe1YZlb18pY+qzLxqOscr7LkwpVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587552; c=relaxed/simple;
	bh=Mcv7kytQKct3XwjdI+f1PNwB4OlYj64ZGI4sJwsMEDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lMatYNxFUn2O5pJmzbZBecsR/o93GxcOlsPIAeM/smjMsaxQwaaFiHDBSgZOSpZpdJMFnn7gMsbcH2stv9ak/sgjnAjxrtsd10f2af6Y3SHAM2MwQLLRkW0Z+mTP175CoyQQkywXJzS9utjEQK3sCtFHrYKKX5zexZLkVcvgvd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hXl7jQhK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hXl7jQhK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8565C433F1;
	Mon,  4 Mar 2024 21:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587552;
	bh=Mcv7kytQKct3XwjdI+f1PNwB4OlYj64ZGI4sJwsMEDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hXl7jQhK+mWSydOIghFBKD5Y6RoUeDhCE4DsmPxCGLZfJLz/vnh9GBIU6j11sV0B4
	 Wq2G7HyG+qthdM3ceJ7JBHTmg1of7kVtZ/AlhXUVMwXwAVtODowWMxYwUDSiHdS4nW
	 dBpfzIRNXh7GOJQpL2YfMisJxSI6r4iwMKtZyrSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunjian Wang <wangyunjian@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 02/16] tun: Fix xdp_rxq_infos queue_index when detaching
Date: Mon,  4 Mar 2024 21:23:23 +0000
Message-ID: <20240304211534.415017993@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211534.328737119@linuxfoundation.org>
References: <20240304211534.328737119@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunjian Wang <wangyunjian@huawei.com>

[ Upstream commit 2a770cdc4382b457ca3d43d03f0f0064f905a0d0 ]

When a queue(tfile) is detached, we only update tfile's queue_index,
but do not update xdp_rxq_info's queue_index. This patch fixes it.

Fixes: 8bf5c4ee1889 ("tun: setup xdp_rxq_info")
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
Link: https://lore.kernel.org/r/1708398727-46308-1-git-send-email-wangyunjian@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 055664a26f7a8..625525275539a 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -729,6 +729,7 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
 				   tun->tfiles[tun->numqueues - 1]);
 		ntfile = rtnl_dereference(tun->tfiles[index]);
 		ntfile->queue_index = index;
+		ntfile->xdp_rxq.queue_index = index;
 		rcu_assign_pointer(tun->tfiles[tun->numqueues - 1],
 				   NULL);
 
-- 
2.43.0



