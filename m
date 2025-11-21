Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E420334DB64;
	Fri, 21 Nov 2025 13:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733273; cv=none; b=mEDVYUls7MdZlirvZhvhYH4V3o+V66BK4GerG93xq19VeLCk7sCOt4175Av5RC7SlR+DOYIpmLlAJeiQAssT9X9zWn6sqYorYpe3VTIDBqxa7yqGsJvkzePhcpTXQkKdFzxd/nCh0HhiRi3TG8fB6QQTpmCV9u42QKCxeIJNtcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733273; c=relaxed/simple;
	bh=e0HQfPRkCDc741I9UF+j9p9PycybgRukeeGTC7FCqcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EE3LX8giFLADPhzDVjQDd2M3bVVzCrINXxRu8hLBvhwgyd1xHcXdNN8uD2X+D4+lwmwySdYTUcsYR2HVgmlA6NPC6gXzBLkVdb54/ZLOq/jsPK14Gr01lnwE8uEO7HoV2V0YKRCBMLbV3aC4dJjHBjTHMcV9Y0JwanR7hrlQT4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V9Q8kIQ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V9Q8kIQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C83C4CEF1;
	Fri, 21 Nov 2025 13:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733272;
	bh=e0HQfPRkCDc741I9UF+j9p9PycybgRukeeGTC7FCqcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V9Q8kIQ2eYQpPo1Sz4fKB2Q6w1aKhmbkaMPARJaN3flfXccO35e0hhxd2Pk/F1hnV
	 3YY0domAruzMYge8zCtRiSyh/rSLSlCOvsiIw274TRvjAhnMmpiTwq+Gwno6p//5pq
	 44PM6U59T0u0ED78QTYqTX25Fug8OGGU3BvJf5LE=
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
Subject: [PATCH 6.6 411/529] net: sched: act_ife: initialize struct tc_ife to fix KMSAN kernel-infoleak
Date: Fri, 21 Nov 2025 14:11:50 +0100
Message-ID: <20251121130245.643221166@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Ranganath V N <vnranganath.20@gmail.com>

[ Upstream commit ce50039be49eea9b4cd8873ca6eccded1b4a130a ]

Fix a KMSAN kernel-infoleak detected  by the syzbot .

[net?] KMSAN: kernel-infoleak in __skb_datagram_iter

In tcf_ife_dump(), the variable 'opt' was partially initialized using a
designatied initializer. While the padding bytes are reamined
uninitialized. nla_put() copies the entire structure into a
netlink message, these uninitialized bytes leaked to userspace.

Initialize the structure with memset before assigning its fields
to ensure all members and padding are cleared prior to beign copied.

This change silences the KMSAN report and prevents potential information
leaks from the kernel memory.

This fix has been tested and validated by syzbot. This patch closes the
bug reported at the following syzkaller link and ensures no infoleak.

Reported-by: syzbot+0c85cae3350b7d486aee@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0c85cae3350b7d486aee
Tested-by: syzbot+0c85cae3350b7d486aee@syzkaller.appspotmail.com
Fixes: ef6980b6becb ("introduce IFE action")
Signed-off-by: Ranganath V N <vnranganath.20@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20251109091336.9277-3-vnranganath.20@gmail.com
Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_ife.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/sched/act_ife.c b/net/sched/act_ife.c
index bc7611b0744c4..431921204f660 100644
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -644,13 +644,15 @@ static int tcf_ife_dump(struct sk_buff *skb, struct tc_action *a, int bind,
 	unsigned char *b = skb_tail_pointer(skb);
 	struct tcf_ife_info *ife = to_ife(a);
 	struct tcf_ife_params *p;
-	struct tc_ife opt = {
-		.index = ife->tcf_index,
-		.refcnt = refcount_read(&ife->tcf_refcnt) - ref,
-		.bindcnt = atomic_read(&ife->tcf_bindcnt) - bind,
-	};
+	struct tc_ife opt;
 	struct tcf_t t;
 
+	memset(&opt, 0, sizeof(opt));
+
+	opt.index = ife->tcf_index,
+	opt.refcnt = refcount_read(&ife->tcf_refcnt) - ref,
+	opt.bindcnt = atomic_read(&ife->tcf_bindcnt) - bind,
+
 	spin_lock_bh(&ife->tcf_lock);
 	opt.action = ife->tcf_action;
 	p = rcu_dereference_protected(ife->params,
-- 
2.51.0



