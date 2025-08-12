Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1AB63F9D2;
	Tue, 12 Aug 2025 18:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022357; cv=none; b=d6LeX+an5aUm0I1AnZEfLZHvJ72pRIEq3GDD4hhfSzGR4iNr9wYz3pEEEwdryxz6iBUUXa8h7NEf9xDS1HL2l9PtPVYw+/RfNaqFryVKsSPexTtpoNQp4ahVY5LPoospD4PnQ03Q/KX2PO84PwJO4KprB4FXZJIvh3eI6d0Iva0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022357; c=relaxed/simple;
	bh=8Ib3wOASbtgv7DeW+1YXgPvcjyF1jpIc+pImcMkWqEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDvz3yrm3k+jhzEyUYybwHleUBRGLmXdZ+3yeLZdbImMBFBrpPcP/xtf5dLmwDMzUuZtMkP2/8TZjF+3vTpmNWdmjpS7XFFFbapdbOBDzKKvPVii/09KAe0fTEH1DwI37n9+taPsPoBRlY9JYJ1/yDB5DMNDgKR+Lgr0wpdL3sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jrd1a5Wp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jrd1a5Wp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528D0C4CEF0;
	Tue, 12 Aug 2025 18:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022356;
	bh=8Ib3wOASbtgv7DeW+1YXgPvcjyF1jpIc+pImcMkWqEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jrd1a5WpkkKtnZEYu40em6fWP81B71vw12ZLfFKOQOLhZ9stBFCB2AmkuVIslDrGK
	 NvmeV+zRG/N5OY3GD2fv4naUxq+fBFKyQsntsAu4wY6JPuKssKNYiI6NOqXrBaAYax
	 i1oV7wB5KHU/+jUC5zsvQeiYNU35M8tC3vZ9TMo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 104/369] net_sched: act_ctinfo: use atomic64_t for three counters
Date: Tue, 12 Aug 2025 19:26:41 +0200
Message-ID: <20250812173018.686928607@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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
index 5dd41a012110..ae571bfe84c7 100644
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
 
@@ -323,15 +323,18 @@ static int tcf_ctinfo_dump(struct sk_buff *skb, struct tc_action *a,
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



