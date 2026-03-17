Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACDC3ED13D;
	Tue, 17 Mar 2026 16:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765700; cv=none; b=e+yOKiExUlj54CJTt/Y1ot2457NS0417SOy3FqakOvFqdGCx28793tMzCIZ5b+3wcFW+hymDZTGRgj7yXpKFcFPyLddSfwzWVL+KcZjATD33XVIaKuzmkwGVli0lmlCzJ3Q9ZcAO1L8GtK3qMRJpzqbvia7aUVfnQtW2ls7n3N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765700; c=relaxed/simple;
	bh=6gKGtY4mO33cbvDp4hdc7xyTwg37ConbnpIsPxy9wj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FvtGKbKp+TSLsXocqKG+PGvHbAZCCp3pRErlDydeGyYcyRVvIpjWQvhIia2Xf0OtLk3rug2Ngq9wq1i0OBZoVGwcqTCy3iiO77EBcEtUKFmWN4g153l75CHSXH200m3fa5c7hit6sMyJO0Ni3yoauyvLvbyrwsh8YIXV/ZlnWRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HBdsQCgW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HBdsQCgW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C47C4CEF7;
	Tue, 17 Mar 2026 16:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765699;
	bh=6gKGtY4mO33cbvDp4hdc7xyTwg37ConbnpIsPxy9wj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HBdsQCgWDsBdNmY1yOiz+5VxEaQVScwnD9Go7kOTa1NIrZfOo3mMbX/6NKSk21tZy
	 p3cTGOv1mH3jOdzC+wutZufmGXiZ1oD5c9wOWxamVrvObLd7xLnvXg47uroRFmS12j
	 7Rvy3+q5Ofv/YTjDi3IZZHnbcrsNylH5hEBh+GjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	syzbot+bb9127e278fa198e110c@syzkaller.appspotmail.com,
	Helen Koike <koike@igalia.com>,
	Phil Sutter <phil@nwl.cc>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 074/378] netfilter: nf_tables: Fix for duplicate device in netdev hooks
Date: Tue, 17 Mar 2026 17:30:31 +0100
Message-ID: <20260317163009.739590600@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit b7cdc5a97d02c943f4bdde4d5767ad0c13cad92b ]

When handling NETDEV_REGISTER notification, duplicate device
registration must be avoided since the device may have been added by
nft_netdev_hook_alloc() already when creating the hook.

Suggested-by: Florian Westphal <fw@strlen.de>
Reported-by: syzbot+bb9127e278fa198e110c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bb9127e278fa198e110c
Fixes: a331b78a5525 ("netfilter: nf_tables: Respect NETDEV_REGISTER events")
Tested-by: Helen Koike <koike@igalia.com>
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c    | 2 +-
 net/netfilter/nft_chain_filter.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a3865924a505d..c75c2379d30bd 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9675,7 +9675,7 @@ static int nft_flowtable_event(unsigned long event, struct net_device *dev,
 			break;
 		case NETDEV_REGISTER:
 			/* NOP if not matching or already registered */
-			if (!match || (changename && ops))
+			if (!match || ops)
 				continue;
 
 			ops = kzalloc(sizeof(struct nf_hook_ops),
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index b16185e9a6dd7..041426e3bdbf1 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -344,7 +344,7 @@ static int nft_netdev_event(unsigned long event, struct net_device *dev,
 			break;
 		case NETDEV_REGISTER:
 			/* NOP if not matching or already registered */
-			if (!match || (changename && ops))
+			if (!match || ops)
 				continue;
 
 			ops = kmemdup(&basechain->ops,
-- 
2.51.0



