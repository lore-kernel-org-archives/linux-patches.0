Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9AE81F76CA;
	Tue,  3 Dec 2024 16:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241939; cv=none; b=nBrZeLMLMUpeOPtGNz50q+tD+YKXlu8MgtIMCwbKvUBKPHL26JtyUktfW8pt48tdr/7yoSG1sbpRV0vYmWsh/YQEBHgK6E2g7tS1UV2/Iglrw+oiNK05KrNpFCVunDcvqIG+yhel35sfHrxD7qEU65y12cktztrwiLd36edogws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241939; c=relaxed/simple;
	bh=GXQyigtIEO/UC06iLbKlALXsDNvBYrcqzz+OrRQKMW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=goQJKp/8+HFPZrg9P7LwuG5TS6YdxFhQpaMH8E8GXAD5KB+c+lA1lbOikfsB+SvtGmzxu5eO3VXkDcVhLGIkfltBM+TAs5sOQ6WPXiszW+YE3LABzzs7rZQYLeLbErEbjgSkrW5GndE3BcP/PgETWUdm3+dxhXTW8gYp3y4dA7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=snK9ve29; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="snK9ve29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 202E3C4CECF;
	Tue,  3 Dec 2024 16:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241939;
	bh=GXQyigtIEO/UC06iLbKlALXsDNvBYrcqzz+OrRQKMW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=snK9ve29zrddIpyZyvwSbW9lYZZqFplw/NncnbfZjM37Ba93YZUEOoj1YRFLsqQQP
	 eK18onnu3ujyrf9yQieXMAJQXMhYnxwcdGq0BWmYKTqSqGgHH8M5rtQAduARYrr237
	 cE09Ko5kfk/YrnVx/wyeiQ54qkuI3MkGW5rWJV2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+332fe1e67018625f63c9@syzkaller.appspotmail.com,
	James Chapman <jchapman@katalix.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 561/826] net/l2tp: fix warning in l2tp_exit_net found by syzbot
Date: Tue,  3 Dec 2024 15:44:48 +0100
Message-ID: <20241203144805.628587912@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Chapman <jchapman@katalix.com>

[ Upstream commit 5d066766c5f1252f98ff859265bcd1a5b52ac46c ]

In l2tp's net exit handler, we check that an IDR is empty before
destroying it:

	WARN_ON_ONCE(!idr_is_empty(&pn->l2tp_tunnel_idr));
	idr_destroy(&pn->l2tp_tunnel_idr);

By forcing memory allocation failures in idr_alloc_32, syzbot is able
to provoke a condition where idr_is_empty returns false despite there
being no items in the IDR. This turns out to be because the radix tree
of the IDR contains only internal radix-tree nodes and it is this that
causes idr_is_empty to return false. The internal nodes are cleaned by
idr_destroy.

Use idr_for_each to check that the IDR is empty instead of
idr_is_empty to avoid the problem.

Reported-by: syzbot+332fe1e67018625f63c9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=332fe1e67018625f63c9
Fixes: 73d33bd063c4 ("l2tp: avoid using drain_workqueue in l2tp_pre_exit_net")
Signed-off-by: James Chapman <jchapman@katalix.com>
Link: https://patch.msgid.link/20241118140411.1582555-1-jchapman@katalix.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/l2tp/l2tp_core.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 3eec23ac5ab10..369a2f2e459cd 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1870,15 +1870,31 @@ static __net_exit void l2tp_pre_exit_net(struct net *net)
 	}
 }
 
+static int l2tp_idr_item_unexpected(int id, void *p, void *data)
+{
+	const char *idr_name = data;
+
+	pr_err("l2tp: %s IDR not empty at net %d exit\n", idr_name, id);
+	WARN_ON_ONCE(1);
+	return 1;
+}
+
 static __net_exit void l2tp_exit_net(struct net *net)
 {
 	struct l2tp_net *pn = l2tp_pernet(net);
 
-	WARN_ON_ONCE(!idr_is_empty(&pn->l2tp_v2_session_idr));
+	/* Our per-net IDRs should be empty. Check that is so, to
+	 * help catch cleanup races or refcnt leaks.
+	 */
+	idr_for_each(&pn->l2tp_v2_session_idr, l2tp_idr_item_unexpected,
+		     "v2_session");
+	idr_for_each(&pn->l2tp_v3_session_idr, l2tp_idr_item_unexpected,
+		     "v3_session");
+	idr_for_each(&pn->l2tp_tunnel_idr, l2tp_idr_item_unexpected,
+		     "tunnel");
+
 	idr_destroy(&pn->l2tp_v2_session_idr);
-	WARN_ON_ONCE(!idr_is_empty(&pn->l2tp_v3_session_idr));
 	idr_destroy(&pn->l2tp_v3_session_idr);
-	WARN_ON_ONCE(!idr_is_empty(&pn->l2tp_tunnel_idr));
 	idr_destroy(&pn->l2tp_tunnel_idr);
 }
 
-- 
2.43.0



