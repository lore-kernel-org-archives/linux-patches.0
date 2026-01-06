Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC34026E6F2;
	Tue,  6 Jan 2026 17:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720764; cv=none; b=mz4+uRr5f8AfI9vGGCjn/tMdD64u7AtQRX4KaCLKsqGyfAvcgVysIe4dfrkSdgpsYBixo9BkPW2t5RlvcmVeW1IXnct8rQjAH+FpRddJP3orkuDLxFGcvGsIY6VLWxHSQc3ns0oTV5mre4xmcfWXC/yEp1BQoR///UNUad2w1aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720764; c=relaxed/simple;
	bh=ot7H3TL/zRGwKAshhUmzUbfZUFWshln/kz9XTi/TIuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QsUO7zTmNJxAYwAJzUqH2+G/YaiFlJ+6WXcaN5o0WkLy5Pj+4Gd7dMGrwUnMVjJlDfvX7G52eF9K1nI49MjDekMO0riKSgV+W9C9LTj3szuth7IE3K6XdMOaWBtgK7iVUInqkho5vf61nnqJdV+xKGPRCvPYtOa7ylxLJ9dyAvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dWITg+zS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dWITg+zS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BCD2C116C6;
	Tue,  6 Jan 2026 17:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720763;
	bh=ot7H3TL/zRGwKAshhUmzUbfZUFWshln/kz9XTi/TIuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dWITg+zSkfA/LjI5sVf1oeYduv0Jhvtt1KtENqPY4dc/YIKIwrYXgbC3suuRSSiDe
	 Z4gwIAmDrqDocZYH+pNiqX/le7kjXc+KuJ4jZneBR3IvsWhoT9d9ToN5e5CX7OQvPT
	 pDJsGayXF7jdxKzpM6pDWGWxzfFLpqTArJ8DkiGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+881d65229ca4f9ae8c84@syzkaller.appspotmail.com,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Parav Pandit <parav@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 334/567] RDMA/core: always drop device refcount in ib_del_sub_device_and_put()
Date: Tue,  6 Jan 2026 18:01:56 +0100
Message-ID: <20260106170503.686277951@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index df2aa15a5bc9..bbc131737378 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2823,8 +2823,10 @@ int ib_del_sub_device_and_put(struct ib_device *sub)
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



