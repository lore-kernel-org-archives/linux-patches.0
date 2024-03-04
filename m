Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECEA10A35;
	Mon,  4 Mar 2024 21:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588617; cv=none; b=m+kltkr3yO04oGC3hS6k4r8qV/bcjQsZ15KLCwdoPw6ps+raEKrqT1yGTkrEmKKCihs+dgouCUdbYNuZZGrqt1GOa5p6dPvnLCddU/ciZjzQjOjvU4Kz56Tefv4V+g5wciIdWvzTDNtMy1r4asSEywWz8nLTG/2+e5sBHBPf4SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588617; c=relaxed/simple;
	bh=X5W4Vy5vmNj8/XcR3hHA+DA5OkOO0MKXA0AbSQBe0P8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fo2/Zdzu28iZfc1zQzneGhpRcMkVeKI3MVbAL+TSpWT8xOSL6PkZHZS2IUG5s4Phcj83Qzjc6Qlr0CTspvfgjZGGZppAaZq5KXy+QEhkRBSgKPEW8zyJW7bJCB1RFyXknJMB0c8wKdqEPLO1wXW8gTL5e1TBMxYpqF45OrRXDkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2sp2OUJF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2sp2OUJF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0959C433F1;
	Mon,  4 Mar 2024 21:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588617;
	bh=X5W4Vy5vmNj8/XcR3hHA+DA5OkOO0MKXA0AbSQBe0P8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2sp2OUJFq47pRVuP8sKocsVHLN4e37VdP1qWN9HaA/Bb7LDEU5ds3yn43jvtJDAwn
	 K3sRL1vviWXJcSqv0C0EWvwgrNCAqjuufDLFRu7K7b+UdN8jK7UgzJXvhZQbYml9di
	 7nxE2U2KklQuVqZYTL5/muIjc4c8BZ8+WWdqTfn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunjian Wang <wangyunjian@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 032/215] tun: Fix xdp_rxq_infos queue_index when detaching
Date: Mon,  4 Mar 2024 21:21:35 +0000
Message-ID: <20240304211558.009490281@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 367255bb44cdc..922d6f16d99d1 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -653,6 +653,7 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
 				   tun->tfiles[tun->numqueues - 1]);
 		ntfile = rtnl_dereference(tun->tfiles[index]);
 		ntfile->queue_index = index;
+		ntfile->xdp_rxq.queue_index = index;
 		rcu_assign_pointer(tun->tfiles[tun->numqueues - 1],
 				   NULL);
 
-- 
2.43.0



