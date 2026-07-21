Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D38F35C69B;
	Tue, 21 Jul 2026 21:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669075; cv=none; b=QkFIn0cYUyfTtNWoINlL7/Q6W7aHmM7EvhEwx/U5zvUSx92Z3Rq+8LpP3wwV7G7Au91wCC4fRN/sxvT5DysGIMBVxzA+w+D1tLZqxmAX6TU3grL0DGizUhg0NmqyG6AXD2gUq2cXcDX7oqogsmAWCnizvvEj5ySKD3MH6Z/i4uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669075; c=relaxed/simple;
	bh=m4Rvd1lGBVLvGbxxW5N8F1uWb60JXnmOBEVGQSACcoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cHxa/u0ZQN1Gg1yoU5Nw3OVBuczgesuNZQHlN4txkXirdNd2yKUdtOBkFUohfHnZ0tAegK1/ULVeeKDWcIVxNTIjwc/NWAktiyjxeBTIOWgTdyqtpiGIOP4cB90BN1YqgbHIfyeDJPNYohYiF0xTEUgWLb6brg9c729p1X1YBpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DMC/4o0l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DMC/4o0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9ABC1F000E9;
	Tue, 21 Jul 2026 21:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669074;
	bh=dGmGbXhztTstsXWY3Vf25iqndG0sGPhvIMrci/ZMt60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DMC/4o0lR1XxKKKtg04UVWwfQYclubVyptuAMm7Uvol99BB9W9YKzcscMcWdACcjT
	 FMJ/tiwe/ugbLNLKg6l99BZoM9ZnuBZH6ZGKsBv6UHTHypDweApfvhS8aZ6XiQgfz0
	 180ri3o22gMSCFU4hRbGY+dh443BiSGi49y5F7xE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Ginger <ginger.jzllee@gmail.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0380/1067] ocfs2: fix race between ocfs2_control_install_private() and ocfs2_control_release()
Date: Tue, 21 Jul 2026 17:16:21 +0200
Message-ID: <20260721152433.126728118@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit 57dcfd9049d497c31151787a0696d59f0a98f8e6 ]

Move atomic_inc(&ocfs2_control_opened) and the handshake state update
inside ocfs2_control_lock to close a race window where
ocfs2_control_release() can observe ocfs2_control_opened dropping to zero
(resetting ocfs2_control_this_node and running_proto) while
ocfs2_control_install_private() is about to bump the counter and mark the
connection valid.

Link: https://lore.kernel.org/20260601121618.1263346-1-joseph.qi@linux.alibaba.com
Fixes: 3cfd4ab6b6b4 ("ocfs2: Add the local node id to the handshake.")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reported-by: Ginger <ginger.jzllee@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/stack_user.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index e28905e58bd6a0..895ab1222fc3e0 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -326,18 +326,14 @@ static int ocfs2_control_install_private(struct file *file)
 		ocfs2_control_this_node = p->op_this_node;
 		running_proto.pv_major = p->op_proto.pv_major;
 		running_proto.pv_minor = p->op_proto.pv_minor;
-	}
-
-out_unlock:
-	mutex_unlock(&ocfs2_control_lock);
-
-	if (!rc && set_p) {
-		/* We set the global values successfully */
 		atomic_inc(&ocfs2_control_opened);
 		ocfs2_control_set_handshake_state(file,
 					OCFS2_CONTROL_HANDSHAKE_VALID);
 	}
 
+out_unlock:
+	mutex_unlock(&ocfs2_control_lock);
+
 	return rc;
 }
 
-- 
2.53.0



