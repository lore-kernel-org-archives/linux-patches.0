Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6611D0493;
	Wed,  2 Oct 2024 13:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876659; cv=none; b=me5TZgcZvEX/sWsXRrYm9H0DZJHE5J5tC8/Ci5yeOfYMWFIToLl/p3BB3iCrzei8jAeIswLNTX5DXHR0mceOBVhCr63c4ABfneOMW16c/578f2axNwI/+SLuvdIlaPKbghNF0s679omjS3x5WdtWaPi/fgho2vcgqShDkXc2s4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876659; c=relaxed/simple;
	bh=jSFWvdN0819HI+1R5q7OeryA3o6r0HZK3N/UiDN3Le8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uNZ/zbJeIYom69ixVKaj/l43icEsISK4BFtRyCzr7g38DRe1RNHbc2fnFrOYdDJFr8ohLbj2jhGJgHD3JW0qH93+Ay/xk841oxjd/hg9RVnX88x0gmLUhpHzmoaWRAhvtVA8qkvXrdWzBsizK0JOuTDO+32q8NflywsYMG0tw7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OlkrStiJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OlkrStiJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA099C4CEC5;
	Wed,  2 Oct 2024 13:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876659;
	bh=jSFWvdN0819HI+1R5q7OeryA3o6r0HZK3N/UiDN3Le8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OlkrStiJdss0DNY62GMAggja8D4cB6Bwb+D0qWDqV9S8KAxQfpjY0jA6L89mw8cGL
	 LB4sbXPgMmy8G3OsRTU1G+xj15abFQsEKeUzh/sHLvvdV9C1k06wIzwSqMO0VuGXPO
	 zsJ+D6BbPnIGTV6G+3PUe5jnCiA7jwyubjKvg5rU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 492/695] netfilter: nf_tables: use rcu chain hook list iterator from netlink dump path
Date: Wed,  2 Oct 2024 14:58:10 +0200
Message-ID: <20241002125842.108417730@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 4ffcf5ca81c3b83180473eb0d3c010a1a7c6c4de ]

Lockless iteration over hook list is possible from netlink dump path,
use rcu variant to iterate over the hook list as is done with flowtable
hooks.

Fixes: b9703ed44ffb ("netfilter: nf_tables: support for adding new devices to an existing netdev chain")
Reported-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4ceb3e0798dee..02a8b863a151b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1847,7 +1847,7 @@ static int nft_dump_basechain_hook(struct sk_buff *skb, int family,
 		if (!hook_list)
 			hook_list = &basechain->hook_list;
 
-		list_for_each_entry(hook, hook_list, list) {
+		list_for_each_entry_rcu(hook, hook_list, list) {
 			if (!first)
 				first = hook;
 
-- 
2.43.0



