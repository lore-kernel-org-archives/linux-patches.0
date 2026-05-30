Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306F23B6359;
	Sat, 30 May 2026 17:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162753; cv=none; b=SinE2oIe2JwUMZZnCQc3dRvbIHTBxL1U6VftblbOl+aa0gRxuRUpJgPQca48XYRngw/50Ydk1gZQ7xHZzjTy0ZRhwK+rLMr24Wb00OWIaU6VMHD303mtse1j/3gaUZBX10xm4MZwaYqI7LnN7kxgaECSNOCXQVz5SkJuENXheLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162753; c=relaxed/simple;
	bh=iTWjfo8ZUCJSJWnPVpA63wOOt+YRETywmvAzaP3GUAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I383HhN+k4yQMg03iXi8iY8C59iJ7m6bVb/GiaQA9bzvqruuock7zrB0uq5ZSVWcbefiVCMuGrfbFF7naIelhmqO7F//7hyrBN8XeCfsSbfqIPhq1mkGL5p3E3Q230mAdlikRxksRnmX7gcldh+sA9WPHbBnA0CJXtl1JB5Ws0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1VCunKts; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1VCunKts"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0CA1F00893;
	Sat, 30 May 2026 17:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162750;
	bh=hdz0vCWMaUSAbpH0n13nJG+OGyeDNHukItoSH1oKpgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1VCunKtsohinMFw6fS3O1KIIsG0NotuEoQPtGHnCy3Cekm5+2VDwNuf8E3zzZcYR+
	 XcOm5133hnofdMlbUto4DsFXgd6e11EJqE7PCIgtXWSqRcYXwq+lZOatN1odmvs/Y6
	 JMpDifAhM1pAAOiegWgqasnLciHH5SXkpj1XtiFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Yuhang Zheng <z1652074432@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/776] netfilter: xt_multiport: validate range encoding in checkentry
Date: Sat, 30 May 2026 17:55:49 +0200
Message-ID: <20260530160241.191010797@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ren Wei <n05ec@lzu.edu.cn>

[ Upstream commit ff64c5bfef12461df8450e0f50bb693b5269c720 ]

ports_match_v1() treats any non-zero pflags entry as the start of a
port range and unconditionally consumes the next ports[] element as
the range end.

The checkentry path currently validates protocol, flags and count, but
it does not validate the range encoding itself. As a result, malformed
rules can mark the last slot as a range start or place two range starts
back to back, leaving ports_match_v1() to step past the last valid
ports[] element while interpreting the rule.

Reject malformed multiport v1 rules in checkentry by validating that
each range start has a following element and that the following element
is not itself marked as another range start.

Fixes: a89ecb6a2ef7 ("[NETFILTER]: x_tables: unify IPv4/IPv6 multiport match")
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Co-developed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Yuan Tan <yuantan098@gmail.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Tested-by: Yuhang Zheng <z1652074432@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/xt_multiport.c | 34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
index 44a00f5acde8a..a1691ff405d3c 100644
--- a/net/netfilter/xt_multiport.c
+++ b/net/netfilter/xt_multiport.c
@@ -105,6 +105,28 @@ multiport_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	return ports_match_v1(multiinfo, ntohs(pptr[0]), ntohs(pptr[1]));
 }
 
+static bool
+multiport_valid_ranges(const struct xt_multiport_v1 *multiinfo)
+{
+	unsigned int i;
+
+	for (i = 0; i < multiinfo->count; i++) {
+		if (!multiinfo->pflags[i])
+			continue;
+
+		if (++i >= multiinfo->count)
+			return false;
+
+		if (multiinfo->pflags[i])
+			return false;
+
+		if (multiinfo->ports[i - 1] > multiinfo->ports[i])
+			return false;
+	}
+
+	return true;
+}
+
 static inline bool
 check(u_int16_t proto,
       u_int8_t ip_invflags,
@@ -127,8 +149,10 @@ static int multiport_mt_check(const struct xt_mtchk_param *par)
 	const struct ipt_ip *ip = par->entryinfo;
 	const struct xt_multiport_v1 *multiinfo = par->matchinfo;
 
-	return check(ip->proto, ip->invflags, multiinfo->flags,
-		     multiinfo->count) ? 0 : -EINVAL;
+	if (!check(ip->proto, ip->invflags, multiinfo->flags, multiinfo->count))
+		return -EINVAL;
+
+	return multiport_valid_ranges(multiinfo) ? 0 : -EINVAL;
 }
 
 static int multiport_mt6_check(const struct xt_mtchk_param *par)
@@ -136,8 +160,10 @@ static int multiport_mt6_check(const struct xt_mtchk_param *par)
 	const struct ip6t_ip6 *ip = par->entryinfo;
 	const struct xt_multiport_v1 *multiinfo = par->matchinfo;
 
-	return check(ip->proto, ip->invflags, multiinfo->flags,
-		     multiinfo->count) ? 0 : -EINVAL;
+	if (!check(ip->proto, ip->invflags, multiinfo->flags, multiinfo->count))
+		return -EINVAL;
+
+	return multiport_valid_ranges(multiinfo) ? 0 : -EINVAL;
 }
 
 static struct xt_match multiport_mt_reg[] __read_mostly = {
-- 
2.53.0



