Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7D124A066;
	Tue, 26 Aug 2025 13:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215752; cv=none; b=rZKg3/PMOtvEneBhiUOAlHMDBv99sGp4LHhYQjAgJmXXVF4F0WncOs4xFqnWA7nXoxT4VTC/mPylhrmYU5eTdOKkFy3oXYnBlXuYwXCaR59LHTS6a7cs9M5SxHb4eYHRobPm5NerJqRMuG0B+Ae6HQCgRDFOn5nevmXLt9NT3JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215752; c=relaxed/simple;
	bh=KNdjJSuTET4AJwH6f2ZEFqIqVEkIP5HyP/t2PzoDWhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZn5SaqToUwAJLxNNhGH8rxp2uWWobiZtlaK3ZAOqjeT08jTyLuKRt4wAyK6c2B+BW72PXKTOgLmc8c5EQv87KqaJFxTMeMJ1orY2dLv2b16uSVljHjzYNIXmdUVfG3/Ruesr5s7LQT5/VJf+BACpzaLq7WRE53xa9v/u/HagdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hHPLtlCp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hHPLtlCp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E371C4CEF1;
	Tue, 26 Aug 2025 13:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215752;
	bh=KNdjJSuTET4AJwH6f2ZEFqIqVEkIP5HyP/t2PzoDWhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hHPLtlCpsf/p2ETmENvojgwYcd5Z1dkp7su5XUj4MSTOqh6jeYGf+3fv/f0tWGU/5
	 AKV8GMixA/27xFDeVad1ijZ/u+bPo3iT9STTJ1SVV0HnHONu8/R7oaPqsyJihUn9Fd
	 g89yVZWjTZq6eURwAvY2U1KO5K3eGW23I34ViuWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 152/644] net_sched: act_ctinfo: use atomic64_t for three counters
Date: Tue, 26 Aug 2025 13:04:03 +0200
Message-ID: <20250826110950.252220660@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d300335b4e18672913dd792ff9f49e6cccf41d26 ]

Commit 21c167aa0ba9 ("net/sched: act_ctinfo: use percpu stats")
missed that stats_dscp_set, stats_dscp_error and stats_cpmark_set
might be written (and read) locklessly.

Use atomic64_t for these three fields, I doubt act_ctinfo is used
heavily on big SMP hosts anyway.

Fixes: 24ec483cec98 ("net: sched: Introduce act_ctinfo action")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Pedro Tammela <pctammela@mojatatu.com>
Link: https://patch.msgid.link/20250709090204.797558-6-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tc_act/tc_ctinfo.h |  6 +++---
 net/sched/act_ctinfo.c         | 19 +++++++++++--------
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/include/net/tc_act/tc_ctinfo.h b/include/net/tc_act/tc_ctinfo.h
index f071c1d70a25..a04bcac7adf4 100644
--- a/include/net/tc_act/tc_ctinfo.h
+++ b/include/net/tc_act/tc_ctinfo.h
@@ -18,9 +18,9 @@ struct tcf_ctinfo_params {
 struct tcf_ctinfo {
 	struct tc_action common;
 	struct tcf_ctinfo_params __rcu *params;
-	u64 stats_dscp_set;
-	u64 stats_dscp_error;
-	u64 stats_cpmark_set;
+	atomic64_t stats_dscp_set;
+	atomic64_t stats_dscp_error;
+	atomic64_t stats_cpmark_set;
 };
 
 enum {
diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
index 56e0a5eb6494..ddacd4fa442c 100644
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -44,9 +44,9 @@ static void tcf_ctinfo_dscp_set(struct nf_conn *ct, struct tcf_ctinfo *ca,
 				ipv4_change_dsfield(ip_hdr(skb),
 						    INET_ECN_MASK,
 						    newdscp);
-				ca->stats_dscp_set++;
+				atomic64_inc(&ca->stats_dscp_set);
 			} else {
-				ca->stats_dscp_error++;
+				atomic64_inc(&ca->stats_dscp_error);
 			}
 		}
 		break;
@@ -57,9 +57,9 @@ static void tcf_ctinfo_dscp_set(struct nf_conn *ct, struct tcf_ctinfo *ca,
 				ipv6_change_dsfield(ipv6_hdr(skb),
 						    INET_ECN_MASK,
 						    newdscp);
-				ca->stats_dscp_set++;
+				atomic64_inc(&ca->stats_dscp_set);
 			} else {
-				ca->stats_dscp_error++;
+				atomic64_inc(&ca->stats_dscp_error);
 			}
 		}
 		break;
@@ -72,7 +72,7 @@ static void tcf_ctinfo_cpmark_set(struct nf_conn *ct, struct tcf_ctinfo *ca,
 				  struct tcf_ctinfo_params *cp,
 				  struct sk_buff *skb)
 {
-	ca->stats_cpmark_set++;
+	atomic64_inc(&ca->stats_cpmark_set);
 	skb->mark = READ_ONCE(ct->mark) & cp->cpmarkmask;
 }
 
@@ -322,15 +322,18 @@ static int tcf_ctinfo_dump(struct sk_buff *skb, struct tc_action *a,
 	}
 
 	if (nla_put_u64_64bit(skb, TCA_CTINFO_STATS_DSCP_SET,
-			      ci->stats_dscp_set, TCA_CTINFO_PAD))
+			      atomic64_read(&ci->stats_dscp_set),
+			      TCA_CTINFO_PAD))
 		goto nla_put_failure;
 
 	if (nla_put_u64_64bit(skb, TCA_CTINFO_STATS_DSCP_ERROR,
-			      ci->stats_dscp_error, TCA_CTINFO_PAD))
+			      atomic64_read(&ci->stats_dscp_error),
+			      TCA_CTINFO_PAD))
 		goto nla_put_failure;
 
 	if (nla_put_u64_64bit(skb, TCA_CTINFO_STATS_CPMARK_SET,
-			      ci->stats_cpmark_set, TCA_CTINFO_PAD))
+			      atomic64_read(&ci->stats_cpmark_set),
+			      TCA_CTINFO_PAD))
 		goto nla_put_failure;
 
 	spin_unlock_bh(&ci->tcf_lock);
-- 
2.39.5



