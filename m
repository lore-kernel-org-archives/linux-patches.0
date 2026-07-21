Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBFED438FEE;
	Tue, 21 Jul 2026 21:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668309; cv=none; b=d6UCcvUSXqEyQN4fWLGxNmRlAYyo0Iuh/qLIAL7L4ua+CwtwXI+KqKcCb/gBu34GztqELGUMvFY8TBOyZ9hmlZw604C/Xj9sHWII3GI1S3I+ICObFWTR5hJ+B3Wm7NrawSvLrY8cYItgmXDkqasswPhjNUUAOQ81egcvbfCKBFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668309; c=relaxed/simple;
	bh=fp/O+z+T7EAI2OWvYzp6of1ErWjjq1mrRMTqi/v/Zaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxEiRbAfNC1Zm6JcErLc5EVZNa7wyi6JyJAihfJIYP8XZAc4uMiD9DRlfFbcCh5aGXvDxt/GGiW1GbHKImyo9aLsD7+nQ6jUDScr19c2CAwSs3sI2t86EQyEMF0uK+wtQzwr+ZbQILLx1btijRFlTknmsfRalygspBQsP5+08Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bNKen4DV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bNKen4DV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D49E1F000E9;
	Tue, 21 Jul 2026 21:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668308;
	bh=wjzIo7d8HiwZ5+4CpiFqM2UJ+RWh20W756EQCGgBp4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bNKen4DVsPap4vdkr/+sQKaA4FJjUzt2ryQ0K96zRxB80DQpnawVCX4t84G5y91Ix
	 gfQfqDCvD8GDRB0L14OH0y8r+tM32KIaVlCY4p/u3HyBodZ5kGPdgnR8vPmbBiJ55G
	 i5D2AdgGZBkfHNXPXVJkll6tYw1QQm4+0bkahXWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratham Gupta <pratham36gupta@gmail.com>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 6.1 0127/1067] netfilter: ctnetlink: use nf_ct_exp_net() in expectation dump
Date: Tue, 21 Jul 2026 17:12:08 +0200
Message-ID: <20260721152427.434009875@linuxfoundation.org>
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
@@ -3152,7 +3152,7 @@ restart:
 			if (l3proto && exp->tuple.src.l3num != l3proto)
 				continue;
 
-			if (!net_eq(nf_ct_net(exp->master), net))
+			if (!net_eq(nf_ct_exp_net(exp), net))
 				continue;
 
 			if (cb->args[1]) {


