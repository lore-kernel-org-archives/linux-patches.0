Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970AC2F83CB;
	Tue, 12 Aug 2025 17:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020565; cv=none; b=Am96LVrc7rvrQ+XLuj4+2FbKNv1utnDyHOWJDqcDyZAzgh/a7+dp3D8sljXxCF/pXMUl+6v7ybk54StY9zDUt4OGzVJGuAt9A/wDskEf/GlLh5tXBKIgtK4qm6dut7+uMrllkVrq2DGSGQ5marlJwb74LcqHjaZVLQjBwknCn1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020565; c=relaxed/simple;
	bh=ewx15wlAUFN3Mrb/lR31kmKWembIsmaMusT7ZTwFXvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AuqCLUusUYVaAqwfcjXqLe1Ztw4McLqCC2WrdRhqxidXLgI+0jkTs62K5MDt9Xfl2NJG0EPRznS7j8sq4LaFqZC0EDYKEDN9iTWk893JDLT5NbY7kaYmhTR00sekmdRelQnGEy6vIyUK8bq2L4+lwf8JA6O4GZurad5RzX2dAD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cPSRTP33; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cPSRTP33"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09280C4CEF0;
	Tue, 12 Aug 2025 17:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020565;
	bh=ewx15wlAUFN3Mrb/lR31kmKWembIsmaMusT7ZTwFXvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cPSRTP33KtkyuubUQD91VahJcmpP4CdZZ9V8HYSfr8IP5+pOlVlwJnCQsEKST7Dqy
	 zgeFCySedYhHDeLRUDV3q/gxv88AOXB0la1+35fnwQ9ntUyPriy5LTZUwuwS/DygNQ
	 Y03nAD7EWUB/GmlEY/vZrCEKVxgkHrTANVpzIhGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 117/253] net_sched: act_ctinfo: use atomic64_t for three counters
Date: Tue, 12 Aug 2025 19:28:25 +0200
Message-ID: <20250812172953.690710521@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7275ad869f8e..34a1fb617a0f 100644
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -43,9 +43,9 @@ static void tcf_ctinfo_dscp_set(struct nf_conn *ct, struct tcf_ctinfo *ca,
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
@@ -56,9 +56,9 @@ static void tcf_ctinfo_dscp_set(struct nf_conn *ct, struct tcf_ctinfo *ca,
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
@@ -71,7 +71,7 @@ static void tcf_ctinfo_cpmark_set(struct nf_conn *ct, struct tcf_ctinfo *ca,
 				  struct tcf_ctinfo_params *cp,
 				  struct sk_buff *skb)
 {
-	ca->stats_cpmark_set++;
+	atomic64_inc(&ca->stats_cpmark_set);
 	skb->mark = READ_ONCE(ct->mark) & cp->cpmarkmask;
 }
 
@@ -321,15 +321,18 @@ static int tcf_ctinfo_dump(struct sk_buff *skb, struct tc_action *a,
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



