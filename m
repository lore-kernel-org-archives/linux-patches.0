Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467502DA76C;
	Tue, 21 Jul 2026 20:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665078; cv=none; b=rXTjQhLKJ5qPHTb/3cxSzN+/2sK6Oo+/InDYgGpAkmjxZf/VsCdshRwmK98QA/2emzxQlkO+bqz6DF9IXMKvldOREUBESoXHbUMFFV9DRWBSaMzaXiiGy3M+7c4oyNhsFMagMDGsXMCjAkuTDl1gclyuZMD61pi+B7mqsPk1qv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665078; c=relaxed/simple;
	bh=Q0Zk0IR0TkI9P+CJ2xqX3xWIZtega5If6iw+/hoMCBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E2JG7b8dOqgt0hOr82FX1ZROW3g7X2qY7v+F1Qm30QbR/ioCOScmK4Ljocwel7/cGogj7Jr6/uh6LwodJBb9KPUvBhzFWmSCNhqwj3oOB6RapGBc6YGqUI+L136T5nVM1FeIez7ZMV/I0FmCXp15r2sveklCuBsxPShmo9u3i+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ADcN+EuZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ADcN+EuZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1091F000E9;
	Tue, 21 Jul 2026 20:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665077;
	bh=zaRKP4k/u9udsWEkxaXiZbwl61g2olLhpV65aLuhR1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ADcN+EuZ+NK5++rJ5YsnmTTGJLNNCCCgaSENlaWs9wLZwtMuv2m11TqTrJsOH5Xfn
	 /cqtUYIwGnPJlzb6l4JLTyfXBklfHIFw/+PDWeNbFvkdr5S8/6BqCiOTUMtumtrx0g
	 wjKrBkChMTKlxu/pwBxBcqbaBtEPwy+GKu73tJEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratham Gupta <pratham36gupta@gmail.com>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 6.6 0167/1266] netfilter: ctnetlink: use nf_ct_exp_net() in expectation dump
Date: Tue, 21 Jul 2026 17:10:04 +0200
Message-ID: <20260721152445.542426829@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Pratham Gupta <pratham36gupta@gmail.com>

commit a7f57320bbbc67e347bf5fff4b4a9bab980d5956 upstream.

Commit 02a3231b6d82 ("netfilter: nf_conntrack_expect: store netns and zone in expectation")
introduced exp->net so RCU-only expectation paths no longer need to
dereference exp->master for netns lookups.

Commit 3db5647984de ("netfilter: nf_conntrack_expect: skip expectations in other netns via proc")
updated the proc path accordingly, but ctnetlink_exp_dump_table() still
compares against nf_ct_net(exp->master).

Use nf_ct_exp_net(exp) here as well so the netlink dump path matches
the rest of the March 2026 expectation netns/RCU cleanup.

Fixes: 02a3231b6d82 ("netfilter: nf_conntrack_expect: store netns and zone in expectation")
Cc: stable@vger.kernel.org
Signed-off-by: Pratham Gupta <pratham36gupta@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_conntrack_netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3148,7 +3148,7 @@ restart:
 			if (l3proto && exp->tuple.src.l3num != l3proto)
 				continue;
 
-			if (!net_eq(nf_ct_net(exp->master), net))
+			if (!net_eq(nf_ct_exp_net(exp), net))
 				continue;
 
 			if (cb->args[1]) {


