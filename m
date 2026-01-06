Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8108A3612C7;
	Tue,  6 Jan 2026 17:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721789; cv=none; b=O7AqOPUV5u4kLgNghKfzj+qimtYMH5BITwDdK+UidvOYcDAvkvLzFQi37IpPS5d523gYcIq3rFiYNpztUq+NgbK3aIYDBurdqt3cX5R2B53a8CEYAcLZvoYjiBXio9qbFQ5ReC+LANYy4e14yhcNeki6HvrWkGQxxBMxJHIUCHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721789; c=relaxed/simple;
	bh=TOutcNPsYixcm4KYvSRdJBgcQunEdbwd3SeeKQ/xQM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m86t4Fz1hwF9UdBKZs5JTb4xqY5wlByHvmptPB/MbJHTWjilzOxe4LWc9JXJHR81th+/lJnGAHSnN4rXuNAlaKkEAWEzQ4x5c4assYleZz18MlJjsYETaD0pp/fxKZQhphOPCHrpxDAIobTgiwHWsWfThITU7rujXlp7RExA69k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hQUlAVe/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hQUlAVe/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94033C116C6;
	Tue,  6 Jan 2026 17:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721789;
	bh=TOutcNPsYixcm4KYvSRdJBgcQunEdbwd3SeeKQ/xQM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hQUlAVe/O1raYbcOg7A0SAFI+KjmCZ/OHcINmOwzuo5p+4EFr7l4sZbhM14+JI5J9
	 lRBZP0RQ+nH8CrSLK7E8k0LbrEYEN1WBy99ObH/Ng9zl1v5UrXKZAMI0NLp+eRgrD2
	 +OO+T0oRzGtdsWXUoivMojFE7B4PF+J3WxYz9+0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+881d65229ca4f9ae8c84@syzkaller.appspotmail.com,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Parav Pandit <parav@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 072/312] RDMA/core: always drop device refcount in ib_del_sub_device_and_put()
Date: Tue,  6 Jan 2026 18:02:26 +0100
Message-ID: <20260106170550.453061639@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit fa3c411d21ebc26ffd175c7256c37cefa35020aa ]

Since nldev_deldev() (introduced by commit 060c642b2ab8 ("RDMA/nldev: Add
support to add/delete a sub IB device through netlink") grabs a reference
using ib_device_get_by_index() before calling ib_del_sub_device_and_put(),
we need to drop that reference before returning -EOPNOTSUPP error.

Reported-by: syzbot+881d65229ca4f9ae8c84@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=881d65229ca4f9ae8c84
Fixes: bca51197620a ("RDMA/core: Support IB sub device with type "SMI"")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Link: https://patch.msgid.link/80749a85-cbe2-460c-8451-42516013f9fa@I-love.SAKURA.ne.jp
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/device.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index b4f3c835844a..e3ba236d7c09 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2881,8 +2881,10 @@ int ib_del_sub_device_and_put(struct ib_device *sub)
 {
 	struct ib_device *parent = sub->parent;
 
-	if (!parent)
+	if (!parent) {
+		ib_device_put(sub);
 		return -EOPNOTSUPP;
+	}
 
 	mutex_lock(&parent->subdev_lock);
 	list_del(&sub->subdev_list);
-- 
2.51.0



