Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3A346AEC5;
	Tue, 16 Jun 2026 16:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626536; cv=none; b=OPAdYmZPwWMhtZMkpqvJ9id/kipiieP5TNShL+Ak3AU5BPfOLL/AmBfuWmNJRkZ5OgMPsq2eXcNlyyRq8I64DbbLn+3cYSTuRsw1f7S6VQ+XlSd17xZlZyAiHgdOon3zXzL7yqg4T7rf0WoVOuRtTd/rP7VK7k6bJb/KfJndwds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626536; c=relaxed/simple;
	bh=stF2eU7DDswUNksRyAIrvK/EGkBgDNsarnQxAW1eJT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aRICjhZwDn7S34OOR4i0+aFPziJyQ+VzJnnqUihxPZquqiK4eYO157mVy2meNDH37bHFBNWug5VpKglYHSE9ntoO3O9t6umd5AoIoljOWMadw9huzZlsygpnCaitMiI5O1/ODJbqkoVy0bUk+Zn9vuBU2xjBoQvJ22d74kv40lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c6sBNHBQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c6sBNHBQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 516FD1F000E9;
	Tue, 16 Jun 2026 16:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626535;
	bh=txchOgev8LmnxHbOTrlzlyuvyD+x/d/l93cJKmanGS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c6sBNHBQFCSx8uqvxTfFQgS35jYhQsFSWrBMByrE24fVePDNIEMkBp5IQWCMFxCVh
	 qjj+UdvpvlFnxlG/FaiXkxI8AlEsB3P0VDbl9g8CKRQnm1ZCt3WlWeWVmkC5wu6Wt0
	 EBeWIHtw8VrLFTOLTP9mJ/LxeDGrQKhIiw4W99gI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 021/261] netfilter: conntrack_irc: fix possible out-of-bounds read
Date: Tue, 16 Jun 2026 20:27:39 +0530
Message-ID: <20260616145045.983847447@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 66eba0ffce3b7e11449946b4cbbef8ea36112f56 ]

When parsing fails after we've matched the command string we
should bail out instead of trying to match a different command.

This helper should be deprecated, given prevalence of TLS I doubt it has
any relevance in 2026.

Fixes: 869f37d8e48f ("[NETFILTER]: nf_conntrack/nf_nat: add IRC helper port")
Closes: https://sashiko.dev/#/patchset/20260525182924.28456-1-fw%40strlen.de
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_irc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 5703846bea3b69..0f50ea92ced9df 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -208,7 +208,7 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 			if (parse_dcc(data, data_limit, &dcc_ip,
 				       &dcc_port, &addr_beg_p, &addr_end_p)) {
 				pr_debug("unable to parse dcc command\n");
-				continue;
+				goto out;
 			}
 
 			pr_debug("DCC bound ip/port: %pI4:%u\n",
@@ -222,7 +222,7 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 				net_warn_ratelimited("Forged DCC command from %pI4: %pI4:%u\n",
 						     &tuple->src.u3.ip,
 						     &dcc_ip, dcc_port);
-				continue;
+				goto out;
 			}
 
 			exp = nf_ct_expect_alloc(ct);
-- 
2.53.0



