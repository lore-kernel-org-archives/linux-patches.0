Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8A6227BA4;
	Mon,  2 Jun 2025 14:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875489; cv=none; b=A3QD7I5f3Q53v6QfB/Fj5EEFetJPoRipuhyWuCI3w38ee0b0rQhUE4N7y4tYYl7VNnnzxPN3IU5+GTB9CF0c9clgEo0+zIF5YvP19LQMJtN5JlVREiYrPeyFvJh3gVQOMXz0SHt4VqVaNSyxln7kRNIRDo+BFJCNDtSQL2Qw3DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875489; c=relaxed/simple;
	bh=VXpBokGVLs5g2KT+b3yzLvFYwvtGlgk8pP31jGgZ3tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A2piA6/h925xKTBdsZw6cFygBoFWpBvhDyq+9gtASykXDPBBWpDDKYpcOSbqjR5iXa6rS8jxaHCSmqB8WnvtAiw+rg+7QIH0+sSCC7BzRE8qndc9+lbf4hzB4dqUowTNZ9P5jx5sxCsGftSQZyG4vraxqgvF2wUvByvM/WgHDd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e8aiQH7k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e8aiQH7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48425C4CEEB;
	Mon,  2 Jun 2025 14:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875489;
	bh=VXpBokGVLs5g2KT+b3yzLvFYwvtGlgk8pP31jGgZ3tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e8aiQH7kX2u4hF0rq/juoHLPa+F2QIfAihCNOCMghHik24HhpZ65zYZnu4QXWa/ZX
	 o8Lqt1Q6C+J62KXw+orKYykh+CohuLpWXBvU/EFu4CUZ55g3mui2VX/JL0eUH8kBqd
	 WMBe3zb4M/TKjrxZSAMgXnjLbFEi15ded7osPe6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 150/270] netfilter: conntrack: Bound nf_conntrack sysctl writes
Date: Mon,  2 Jun 2025 15:47:15 +0200
Message-ID: <20250602134313.352048326@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>

[ Upstream commit 8b6861390ffee6b8ed78b9395e3776c16fec6579 ]

nf_conntrack_max and nf_conntrack_expect_max sysctls were authorized to
be written any negative value, which would then be stored in the
unsigned int variables nf_conntrack_max and nf_ct_expect_max variables.

While the do_proc_dointvec_conv function is supposed to limit writing
handled by proc_dointvec proc_handler to INT_MAX. Such a negative value
being written in an unsigned int leads to a very high value, exceeding
this limit.

Moreover, the nf_conntrack_expect_max sysctl documentation specifies the
minimum value is 1.

The proc_handlers have thus been updated to proc_dointvec_minmax in
order to specify the following write bounds :

* Bound nf_conntrack_max sysctl writings between SYSCTL_ZERO
  and SYSCTL_INT_MAX.

* Bound nf_conntrack_expect_max sysctl writings between SYSCTL_ONE
  and SYSCTL_INT_MAX as defined in the sysctl documentation.

With this patch applied, sysctl writes outside the defined in the bound
will thus lead to a write error :

```
sysctl -w net.netfilter.nf_conntrack_expect_max=-1
sysctl: setting key "net.netfilter.nf_conntrack_expect_max": Invalid argument
```

Signed-off-by: Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_standalone.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 8498bf27a3531..abf558868db11 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -613,7 +613,9 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.data		= &nf_conntrack_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_INT_MAX,
 	},
 	[NF_SYSCTL_CT_COUNT] = {
 		.procname	= "nf_conntrack_count",
@@ -652,7 +654,9 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.data		= &nf_ct_expect_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ONE,
+		.extra2		= SYSCTL_INT_MAX,
 	},
 	[NF_SYSCTL_CT_ACCT] = {
 		.procname	= "nf_conntrack_acct",
@@ -931,7 +935,9 @@ static struct ctl_table nf_ct_netfilter_table[] = {
 		.data		= &nf_conntrack_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_INT_MAX,
 	},
 	{ }
 };
-- 
2.39.5



