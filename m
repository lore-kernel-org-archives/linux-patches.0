Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5601684BE;
	Fri, 13 Feb 2026 13:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770991044; cv=none; b=sgMRH1SJL4+0EqapcGisKsM9H7EpY/x3sqHxUyT2nuN5t6fnjziP43knjRfH1A9V+VZ3AHN2uHk8bwbLdfvyJ+M3oR036ZZu5puy1lufjdycd0aa0B7m9rP/bhV1b7b/PEBXqcwmG61pydrY29UeBGsUdoBDZ4FUCIprotPi0Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770991044; c=relaxed/simple;
	bh=F/wH1B1CESFls62gnoqSC38o3M9OCFj1Xt0Wmq5ozvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RJ/qqfkii0PZuTXctsBabxTaaEmXA3bQgBRlJE8kfLCskaTx37TH9Y9EIFgMyBWlMzSJR0hr8lArS8fRESk7cnTXx6QS+aU+RoDqUG5lVWWl70wb1iYk1zBhHgejoVKO22yqEDhqsIdCcDa1tf1wMMW0bpLguPxeOLdx3xDrmnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u+uAzZT6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+uAzZT6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F2BC116C6;
	Fri, 13 Feb 2026 13:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770991044;
	bh=F/wH1B1CESFls62gnoqSC38o3M9OCFj1Xt0Wmq5ozvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u+uAzZT6yDdbGAFfYxhyylmV5MDXK2xfjfqO/VF9YqjI8t+e+R/zi2jwTRC4IVDT/
	 Sgy7Tdn6LYXoxcDm5W/oENwY81pdDRZsRI+CAlkAXZEAiZl9HL+DHKjvNdYI5REMB/
	 /R3OTOC3X15QC2vbJiyjxg2InZyXrcABzfviaSaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	syzbot+5498a510ff9de39d37da@syzkaller.appspotmail.com,
	Eulgyu Kim <eulgyukim@snu.ac.kr>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 24/25] mptcp: fix race in mptcp_pm_nl_flush_addrs_doit()
Date: Fri, 13 Feb 2026 14:48:50 +0100
Message-ID: <20260213134704.760568317@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134703.882698935@linuxfoundation.org>
References: <20260213134703.882698935@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

commit e2a9eeb69f7d4ca4cf4c70463af77664fdb6ab1d upstream.

syzbot and Eulgyu Kim reported crashes in mptcp_pm_nl_get_local_id()
and/or mptcp_pm_nl_is_backup()

Root cause is list_splice_init() in mptcp_pm_nl_flush_addrs_doit()
which is not RCU ready.

list_splice_init_rcu() can not be called here while holding pernet->lock
spinlock.

Many thanks to Eulgyu Kim for providing a repro and testing our patches.

Fixes: 141694df6573 ("mptcp: remove address when netlink flushes addrs")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot+5498a510ff9de39d37da@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6970a46d.a00a0220.3ad28e.5cf0.GAE@google.com/T/
Reported-by: Eulgyu Kim <eulgyukim@snu.ac.kr>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/611
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260124-net-mptcp-race_nl_flush_addrs-v3-1-b2dc1b613e9d@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Conflicts because the code has been moved from pm_netlink.c to
  pm_kernel.c later on in commit 8617e85e04bd ("mptcp: pm: split
  in-kernel PM specific code"). The same modifications can be applied
  in pm_netlink.c with one exception, because 'pernet->local_addr_list'
  has been renamed to 'pernet->endp_list' in commit 35e71e43a56d
  ("mptcp: pm: in-kernel: rename 'local_addr_list' to 'endp_list'"). The
  previous name is then still being used in this version.
  Also, another conflict is caused by commit 7bcf4d8022f9 ("mptcp: pm:
  rename helpers linked to 'flush'") which is not in this version:
  mptcp_nl_remove_addrs_list() has been renamed to
  mptcp_nl_flush_addrs_list(). The previous name has then been kept. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1859,16 +1859,26 @@ static void __reset_counters(struct pm_n
 static int mptcp_nl_cmd_flush_addrs(struct sk_buff *skb, struct genl_info *info)
 {
 	struct pm_nl_pernet *pernet = genl_info_pm_nl(info);
-	LIST_HEAD(free_list);
+	struct list_head free_list;
 
 	spin_lock_bh(&pernet->lock);
-	list_splice_init(&pernet->local_addr_list, &free_list);
+	free_list = pernet->local_addr_list;
+	INIT_LIST_HEAD_RCU(&pernet->local_addr_list);
 	__reset_counters(pernet);
 	pernet->next_id = 1;
 	bitmap_zero(pernet->id_bitmap, MPTCP_PM_MAX_ADDR_ID + 1);
 	spin_unlock_bh(&pernet->lock);
-	mptcp_nl_remove_addrs_list(sock_net(skb->sk), &free_list);
+
+	if (free_list.next == &pernet->local_addr_list)
+		return 0;
+
 	synchronize_rcu();
+
+	/* Adjust the pointers to free_list instead of pernet->local_addr_list */
+	free_list.prev->next = &free_list;
+	free_list.next->prev = &free_list;
+
+	mptcp_nl_remove_addrs_list(sock_net(skb->sk), &free_list);
 	__flush_addrs(&free_list);
 	return 0;
 }


