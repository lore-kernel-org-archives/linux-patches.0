Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD108471253;
	Tue, 21 Jul 2026 18:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658514; cv=none; b=CWDVNPamp8N7oZNCMd3AliXK5pzMiybkVDomCJD4PemeT8EoyiOqOl6z2FfIcbvlWr8fkB2thRxh1WJHB7dqgM6FA59wKRYL5rpJj2XB3Vg2wdlkxoddximYT+MFevMugXT6X6CWTjbZV2K6nfYKMVsbm5i4qRqiZjJlfsB7Sj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658514; c=relaxed/simple;
	bh=lCXWKCkZCeKIhyGAOcXN/zuf7J8O0ilYLb7REwAhraI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X7eToHd2BbNZGCIu+5VFEISq/FePc7XXI0SaL1ReD3oiTYGVqPPxmE6VKIAeS7/jTYU20Wfar1ZhZNBjQGRWuVQfuDgBFQChPrf8IzQzzO6DQ2FovNfW5bnkcXHuHP3KggSut8efNcx8ADXqetfKXVSdsPz34QZ5xgKeS0Gfpuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RXWl3pMb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RXWl3pMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F017E1F000E9;
	Tue, 21 Jul 2026 18:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658513;
	bh=Ybv0UY3K8FVHHp3CMPtFQbqBdEHOiJLrf4EdPYzrnb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RXWl3pMbgwnI7dO9ENf2hrYJ40PbFCbnOiZSYn0CfPf+U1jUC7zJFdzzjo/slJijp
	 SXv0CWn4vmcVFjiNTVjCTZ+hzrdQoR3P3ASNZDoGRn9krhenAjAQ+xNThd5DtWU+Mt
	 u84uU4KKszIIcwVppHCdIITCQ7fpCs8vi9wUD6is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>,
	Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
	Ao Wang <wangao@seu.edu.cn>,
	Xuewei Feng <fengxw06@126.com>,
	Qi Li <qli01@tsinghua.edu.cn>,
	Ke Xu <xuke@tsinghua.edu.cn>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 6.18 1173/1611] netfilter: ecache: fix inverted time_after() check
Date: Tue, 21 Jul 2026 17:21:29 +0200
Message-ID: <20260721152541.815071840@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>

commit b06163ce52ec0561f202fbfb9b08090cb61f512e upstream.

ecache_work_evict_list() redelivers DESTROY events for conntracks that
were moved to the per-netns dying_list after event delivery failed.  It
sets a 10ms deadline:

    stop = jiffies + ECACHE_MAX_JIFFIES

but then tests:

    time_after(stop, jiffies)

This condition is true while the deadline is still in the future, so the
worker returns STATE_RESTART after the first successful redelivery in the
usual case.  ecache_work() maps STATE_RESTART to delay 0, which turns the
redelivery path into one dying conntrack per workqueue dispatch and makes
the sent > 16 batching/cond_resched() path effectively unreachable.

A conntrack netlink listener whose receive queue is congested can make
DESTROY event delivery fail with -ENOBUFS.  With sustained conntrack
churn, entries then accumulate on the dying_list and are only drained at
the degraded one-entry-per-dispatch rate once delivery succeeds again,
wasting CPU on back-to-back workqueue reschedules and prolonging
conntrack memory/resource pressure.

In a KASAN QEMU test with CONFIG_NF_CONNTRACK_EVENTS=y and
nf_conntrack.enable_hooks=1, a congested DESTROY listener caused 8192
nf_ct_delete() calls to return false and move entries to the dying_list.
After closing the listener, the unfixed kernel needed 7670 ecache_work()
entries to destroy 7669 conntracks.  With this change, the same 8192
entries were destroyed by 2 ecache_work() entries.

Swap the comparison so the worker restarts only after the deadline has
expired.

Fixes: 2ed3bf188b33 ("netfilter: ecache: use dedicated list for event redelivery")
Cc: stable@vger.kernel.org
Reported-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reported-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Reported-by: Ao Wang <wangao@seu.edu.cn>
Reported-by: Xuewei Feng <fengxw06@126.com>
Reported-by: Qi Li <qli01@tsinghua.edu.cn>
Reported-by: Ke Xu <xuke@tsinghua.edu.cn>
Assisted-by: Claude-Code:GLM-5.2
Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_conntrack_ecache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -77,7 +77,7 @@ next:
 		hlist_nulls_del_rcu(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode);
 		hlist_nulls_add_head(&ct->tuplehash[IP_CT_DIR_REPLY].hnnode, &evicted_list);
 
-		if (time_after(stop, jiffies)) {
+		if (time_after(jiffies, stop)) {
 			ret = STATE_RESTART;
 			break;
 		}


