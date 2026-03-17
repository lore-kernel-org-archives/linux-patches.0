Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89692116F6;
	Tue, 17 Mar 2026 17:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767525; cv=none; b=AH9F/F0PXi2napEBfD5ZhP00HTgrvKvaui8OwQh4oiBv4O/UYi5EMMXWmmeI5eNkK8ZNL8m9PcXy7AuyGxZbPxgaaiJEYezkBfgb87kr/0BS5XhsaXNLYSBRzsn9mT0YuLwKLdIUNTJ82Kx9WNIM3KV2wXTX07CtHtCN6gB3Tvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767525; c=relaxed/simple;
	bh=2rnj1IcQ5lRqzw6UD8HCjLIJK+GxgpOIMzKiqEtF2yI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/uRXGD/HHXOOwYY7UlL8QIuNrhjeBCySRDfnF9jkQ3gt1Aj1dJBCJ9kcMefgP0l+yHFLEAU+cdLfGv7FXTTt15s2ZBpc4D7Is4TqpZjoi11jRjsYFUNM9vbc4RYlzZ5vFs2up6gnOUYy65ykiFytFoCE4qeQa7ez+jYoeOOebc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W5IhYdoJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W5IhYdoJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2799C4CEF7;
	Tue, 17 Mar 2026 17:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767525;
	bh=2rnj1IcQ5lRqzw6UD8HCjLIJK+GxgpOIMzKiqEtF2yI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W5IhYdoJYszA0N1bmdRGHEm9+EiQPpqWyzWYWa94yd7O7qfPjMp936p/fU+5Jnus0
	 F+VjQBUvGzTr2Y8gLNNuX192sfLWKMXNwQFwW7lBtr/T0GGLGPoIU8/Z3jXnq4FZGY
	 MGNivseDRpke1O5JjBo6WjgABJrERUieYUY/pp1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <tanyuan98@outlook.com>,
	Xin Liu <dstsmallbird@foxmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 072/333] netfilter: xt_IDLETIMER: reject rev0 reuse of ALARM timer labels
Date: Tue, 17 Mar 2026 17:31:41 +0100
Message-ID: <20260317163002.046453520@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Yuan Tan <tanyuan98@outlook.com>

[ Upstream commit 329f0b9b48ee6ab59d1ab72fef55fe8c6463a6cf ]

IDLETIMER revision 0 rules reuse existing timers by label and always call
mod_timer() on timer->timer.

If the label was created first by revision 1 with XT_IDLETIMER_ALARM,
the object uses alarm timer semantics and timer->timer is never initialized.
Reusing that object from revision 0 causes mod_timer() on an uninitialized
timer_list, triggering debugobjects warnings and possible panic when
panic_on_warn=1.

Fix this by rejecting revision 0 rule insertion when an existing timer with
the same label is of ALARM type.

Fixes: 68983a354a65 ("netfilter: xtables: Add snapshot of hardidletimer target")
Co-developed-by: Yifan Wu <yifanwucs@gmail.com>
Signed-off-by: Yifan Wu <yifanwucs@gmail.com>
Co-developed-by: Juefei Pu <tomapufckgml@gmail.com>
Signed-off-by: Juefei Pu <tomapufckgml@gmail.com>
Signed-off-by: Yuan Tan <tanyuan98@outlook.com>
Signed-off-by: Xin Liu <dstsmallbird@foxmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/xt_IDLETIMER.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index d73957592c9d9..bb7af92ac82a4 100644
--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -318,6 +318,12 @@ static int idletimer_tg_checkentry(const struct xt_tgchk_param *par)
 
 	info->timer = __idletimer_tg_find_by_label(info->label);
 	if (info->timer) {
+		if (info->timer->timer_type & XT_IDLETIMER_ALARM) {
+			pr_debug("Adding/Replacing rule with same label and different timer type is not allowed\n");
+			mutex_unlock(&list_mutex);
+			return -EINVAL;
+		}
+
 		info->timer->refcnt++;
 		mod_timer(&info->timer->timer,
 			  secs_to_jiffies(info->timeout) + jiffies);
-- 
2.51.0



