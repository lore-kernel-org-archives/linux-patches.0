Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23BD3451A3;
	Fri, 21 Nov 2025 13:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731809; cv=none; b=jHUrywriIYML35GCPrYuK94qUr2EZ3t9LNh/jl3uEwghuGMRA34mFiZT753XmZtsht9X7Hl5FjcFdaVPx23+pP7U1lrdgF8Hv89p+tr+gnUxCZxxY6im9icYLvqD3BHC2nNhQB+iYRTUMvr7zyht1nyrDmLzE8iBc70Aak/yfpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731809; c=relaxed/simple;
	bh=gAj7nqV32vVMZdq2Q4Uz568DMApcqFU+G9di+/1nzVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fFYyhMT3xVkoTqaMfeRO7ezLZvDorWlD5iL1gwX6teGF1CiBoXAwkfPfY8TnFxI2tEN2w7lk9HGQZBP2l49zHyMSGKKxWetLScig0yDx0DI9C5dSEzOBdYpj6e0dafyG6cMuS7Mz4y1VHpF/I1zPJZZ7U9D9C+mef3jnzjlq/Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dKtPyg+s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dKtPyg+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BBA1C4CEFB;
	Fri, 21 Nov 2025 13:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731809;
	bh=gAj7nqV32vVMZdq2Q4Uz568DMApcqFU+G9di+/1nzVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dKtPyg+si6GmmXUBMFSGNuq4gZMmRyJbRDFcBIvhGaBIlITsN+OWEQ67aLLBGjLt4
	 sKKGfyJ0NB5xW17pQhoeHBQ5gbxAvFVXv/yW+CHEStiJGtHFB1lmslIzDD2pysz6Mp
	 rrY1yAqkWEI/XH+Yc4y4VTvEQmu3123yauubSDCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0c85cae3350b7d486aee@syzkaller.appspotmail.com,
	Ranganath V N <vnranganath.20@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 054/185] net: sched: act_connmark: initialize struct tc_ife to fix kernel leak
Date: Fri, 21 Nov 2025 14:11:21 +0100
Message-ID: <20251121130145.826972345@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: Ranganath V N <vnranganath.20@gmail.com>

[ Upstream commit 62b656e43eaeae445a39cd8021a4f47065af4389 ]

In tcf_connmark_dump(), the variable 'opt' was partially initialized using a
designatied initializer. While the padding bytes are reamined
uninitialized. nla_put() copies the entire structure into a
netlink message, these uninitialized bytes leaked to userspace.

Initialize the structure with memset before assigning its fields
to ensure all members and padding are cleared prior to beign copied.

Reported-by: syzbot+0c85cae3350b7d486aee@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0c85cae3350b7d486aee
Tested-by: syzbot+0c85cae3350b7d486aee@syzkaller.appspotmail.com
Fixes: 22a5dc0e5e3e ("net: sched: Introduce connmark action")
Signed-off-by: Ranganath V N <vnranganath.20@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20251109091336.9277-2-vnranganath.20@gmail.com
Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_connmark.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
index 3e89927d71164..26ba8c2d20abf 100644
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -195,13 +195,15 @@ static inline int tcf_connmark_dump(struct sk_buff *skb, struct tc_action *a,
 	const struct tcf_connmark_info *ci = to_connmark(a);
 	unsigned char *b = skb_tail_pointer(skb);
 	const struct tcf_connmark_parms *parms;
-	struct tc_connmark opt = {
-		.index   = ci->tcf_index,
-		.refcnt  = refcount_read(&ci->tcf_refcnt) - ref,
-		.bindcnt = atomic_read(&ci->tcf_bindcnt) - bind,
-	};
+	struct tc_connmark opt;
 	struct tcf_t t;
 
+	memset(&opt, 0, sizeof(opt));
+
+	opt.index   = ci->tcf_index;
+	opt.refcnt  = refcount_read(&ci->tcf_refcnt) - ref;
+	opt.bindcnt = atomic_read(&ci->tcf_bindcnt) - bind;
+
 	rcu_read_lock();
 	parms = rcu_dereference(ci->parms);
 
-- 
2.51.0



