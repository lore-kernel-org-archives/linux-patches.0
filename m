Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0978E194A67;
	Tue, 27 May 2025 16:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364808; cv=none; b=ZpcDOpt4gfHprl3ezvl+/tekjj3HiWGec9wd5dLX8eV6g6mc1J+b9daAWQyQsthjo+BZ7Cmdqkna/IXJ8yVt/EluRcESx1+ZFtXcrQechncZa2X2rxJh4suwhthzRWGMNguiF9dkAQNatOo0JyoaS1+ndXDgKBz/pN5G+e6gIpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364808; c=relaxed/simple;
	bh=DJQaJzwQTvsHW7zPw05vDZHKvIWvRTXHUroF97KWl8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KR1iHHKMOWZa1QZV5tnb+fTtD+3M8cE3cdWZde3FUWCwFzypvQmso4fdXvTE00+bnKw0pjFI9ncw03PoB8/X1JvKk72ABAZFR8aEUnTZMk+Au9++BzZ21K1DINT23yXG8REM+N0oITsFvMdTrhHbZWbMhmxcu73EFYAlr6Z9YVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bpwGcJjK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bpwGcJjK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF7BC4CEE9;
	Tue, 27 May 2025 16:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364807;
	bh=DJQaJzwQTvsHW7zPw05vDZHKvIWvRTXHUroF97KWl8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bpwGcJjKspzuE+0oT26C6sv22YZVKeJdTkeoTWbm5rIZbdzJPsJkJTLFBixkOasde
	 xah/TT6gjjSeztk0WKgMdIo/30zz9pOGyHaKLPhQb+cxfV4ewO8Zkaqrjq8io6CU3H
	 nKNePy3jh6Wf6xMWv6St3hk7L7CYp/bCqMblR27c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 172/626] netfilter: conntrack: Bound nf_conntrack sysctl writes
Date: Tue, 27 May 2025 18:21:05 +0200
Message-ID: <20250527162452.007080577@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7d4f0fa8b609d..3ea60ff7a6a49 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -619,7 +619,9 @@ static struct ctl_table nf_ct_sysctl_table[] = {
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
@@ -655,7 +657,9 @@ static struct ctl_table nf_ct_sysctl_table[] = {
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
@@ -948,7 +952,9 @@ static struct ctl_table nf_ct_netfilter_table[] = {
 		.data		= &nf_conntrack_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_INT_MAX,
 	},
 };
 
-- 
2.39.5



