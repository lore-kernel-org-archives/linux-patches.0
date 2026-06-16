Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E47332E13B;
	Tue, 16 Jun 2026 18:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635889; cv=none; b=VVR0F3BOIKXG4UCOjOL0/7rWip5xjhpEzJuDusOnZndq5evF+/tP1mDGOa2kWfJJo5nFOUfhTA+OW44D+QvbIDe67ozm1g/TwWWUP1MWV5K1USEd1Fp0BYgAyg4/RVlQcnJJy+yR3G6lkGw5kaCnUVKdx33BxUMIho1uXPZLGC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635889; c=relaxed/simple;
	bh=iMVJMcMDjrftob5qVg+MlE50qbpCeWpGu5pAadcPeRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+Ly530WqW0MQCHwaq40fGPXmDYAnC4GnjkofH3KPPAyYtYPv+wnDWykDeoDHk1kp40b8/SdTeKruEx3qsDU0GNfsrh5c6U0j8ItTIODtJ4KQgIWCe+/M45UwqfJgChBY3LRuuPSMwoSX5FFTBXyx1F9ALINTznhdgFxa1lqFFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TZru+7w4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TZru+7w4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A6F1F00A3A;
	Tue, 16 Jun 2026 18:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635886;
	bh=ctIhuwKMx/fVdJDfyvUGhvIxvoH/X9sQry3esgCFOrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TZru+7w4wlek//F7iYl6g+IF82Vo4x6pP2HAh5H732i9LfvjkKCsl2qNevHs6hFfJ
	 mV1LjCZkpXv6xMeDEg4HXZhlqqQxqqkFfpLvjoStwrW1crxvFGoCl1ksD18mALZkfg
	 le/IW9LO9WdiIxOQydvu/HgwnE/vpVxjaHWgb2w0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 135/342] netfilter: conntrack_irc: fix possible out-of-bounds read
Date: Tue, 16 Jun 2026 20:27:11 +0530
Message-ID: <20260616145054.480151376@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 65b5b05fe38d37..24533bee001b7d 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -199,7 +199,7 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 			if (parse_dcc(data, data_limit, &dcc_ip,
 				       &dcc_port, &addr_beg_p, &addr_end_p)) {
 				pr_debug("unable to parse dcc command\n");
-				continue;
+				goto out;
 			}
 
 			pr_debug("DCC bound ip/port: %pI4:%u\n",
@@ -213,7 +213,7 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 				net_warn_ratelimited("Forged DCC command from %pI4: %pI4:%u\n",
 						     &tuple->src.u3.ip,
 						     &dcc_ip, dcc_port);
-				continue;
+				goto out;
 			}
 
 			exp = nf_ct_expect_alloc(ct);
-- 
2.53.0



