Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247EA22B8DF;
	Tue, 21 Jul 2026 18:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658260; cv=none; b=bhb5f7PdpPIaFEWm8isgBV5qR/Qf97fGi8MFhRjKDP8qkbZkFLFT3NF24IkoGG8zf/yqPFSVHQAjfoTbl1NQIZRtUNy1wQwU8aQCCPmc7wapjyAvxwZ2thiagJFN+xnXUThAjwM//ZXsI4sM1cgYYIsKkb5fjsxEI0h+piuNgaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658260; c=relaxed/simple;
	bh=IKKG2bYUHvP6DIjLTOtllXWzalhVISA21QIOZ9/Jods=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hN5qG+sVJtFtwUL3NEH7bIllDIdhgoFuPfJuHCF98ECbsv0DMrOlNqOr7hRk0oXuWU7GPwgv4EAgx9tfAJGZQVPsdMDrjaj7NR66x9AjONfCjJPitQEXDaLf8l6zDu01U1zkB+xqYSH6wkPF1PbPo4Y1/dy+hCl6ZMGwlLenzYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pqf2lT8d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pqf2lT8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B5041F00A3D;
	Tue, 21 Jul 2026 18:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658259;
	bh=DPU9Y/Oc8uOTwVI2D/4g3W4Rxsrzaj/qUAhutQlQHUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pqf2lT8dTqP37n/7A90i1dDf+8nGfbT0IKByX+W2RnScCvBVAqrRfdnpZ/l51rVSr
	 BbXeBY694kKivXsuFNj5YYOe/Dsondu0NztKjXkUquyWKIBJpQq0ThE7BkQ3f6a/8s
	 mEdpMQoN+frFADFGV414wJFlevVbAJPcLRvx2+wQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuyang Huang <yuyanghuang@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1077/1611] ipv4: igmp: annotate data-races around timer-related fields
Date: Tue, 21 Jul 2026 17:19:53 +0200
Message-ID: <20260721152539.634475491@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuyang Huang <yuyanghuang@google.com>

[ Upstream commit 3289d17b7a1321e103b8aec4ad82675c03c4764f ]

/proc/net/igmp walks the multicast list locklessly under RCU and reads
timer-related fields (im->tm_running, im->reporter, im->timer.expires)
to print the timer state of multicast memberships. Concurrently, these
fields are modified under im->lock spinlock in timer management paths
(igmp_stop_timer(), igmp_start_timer(), and igmp_timer_expire()). Fix this
intentional lockless snapshot by annotating the lockless reads with
READ_ONCE() and the updates with WRITE_ONCE().

Signed-off-by: Yuyang Huang <yuyanghuang@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260605014318.3890804-3-yuyanghuang@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 3546deaa0c30 ("ipv4: igmp: Fix potential memory leaks in igmp_mod_timer() and igmp_stop_timer()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/igmp.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 980f6fa77a6bbc..d8993d8285a546 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -207,8 +207,8 @@ static void igmp_stop_timer(struct ip_mc_list *im)
 	spin_lock_bh(&im->lock);
 	if (timer_delete(&im->timer))
 		refcount_dec(&im->refcnt);
-	im->tm_running = 0;
-	im->reporter = 0;
+	WRITE_ONCE(im->tm_running, 0);
+	WRITE_ONCE(im->reporter, 0);
 	im->unsolicit_count = 0;
 	spin_unlock_bh(&im->lock);
 }
@@ -218,7 +218,7 @@ static void igmp_start_timer(struct ip_mc_list *im, int max_delay)
 {
 	int tv = get_random_u32_below(max_delay);
 
-	im->tm_running = 1;
+	WRITE_ONCE(im->tm_running, 1);
 	if (refcount_inc_not_zero(&im->refcnt)) {
 		if (mod_timer(&im->timer, jiffies + tv + 2))
 			ip_ma_put(im);
@@ -258,7 +258,7 @@ static void igmp_mod_timer(struct ip_mc_list *im, int max_delay)
 	if (timer_delete(&im->timer)) {
 		if ((long)(im->timer.expires-jiffies) < max_delay) {
 			add_timer(&im->timer);
-			im->tm_running = 1;
+			WRITE_ONCE(im->tm_running, 1);
 			spin_unlock_bh(&im->lock);
 			return;
 		}
@@ -848,12 +848,12 @@ static void igmp_timer_expire(struct timer_list *t)
 	struct in_device *in_dev = im->interface;
 
 	spin_lock(&im->lock);
-	im->tm_running = 0;
+	WRITE_ONCE(im->tm_running, 0);
 
 	if (im->unsolicit_count && --im->unsolicit_count)
 		igmp_start_timer(im, unsolicited_report_interval(in_dev));
 
-	im->reporter = 1;
+	WRITE_ONCE(im->reporter, 1);
 	spin_unlock(&im->lock);
 
 	if (IGMP_V1_SEEN(in_dev))
@@ -1315,7 +1315,7 @@ static void __igmp_group_dropped(struct ip_mc_list *im, gfp_t gfp)
 	    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 		return;
 
-	reporter = im->reporter;
+	reporter = READ_ONCE(im->reporter);
 	igmp_stop_timer(im);
 
 	if (!in_dev->dead) {
@@ -2953,6 +2953,7 @@ static int igmp_mc_seq_show(struct seq_file *seq, void *v)
 		struct ip_mc_list *im = v;
 		struct igmp_mc_iter_state *state = igmp_mc_seq_private(seq);
 		char   *querier;
+		int tm_running;
 		long delta;
 
 #ifdef CONFIG_IP_MULTICAST
@@ -2968,13 +2969,14 @@ static int igmp_mc_seq_show(struct seq_file *seq, void *v)
 				   state->dev->ifindex, state->dev->name, state->in_dev->mc_count, querier);
 		}
 
-		delta = im->timer.expires - jiffies;
+		tm_running = READ_ONCE(im->tm_running);
+		delta = READ_ONCE(im->timer.expires) - jiffies;
 		seq_printf(seq,
 			   "\t\t\t\t%08X %5d %d:%08lX\t\t%d\n",
 			   im->multiaddr, READ_ONCE(im->users),
-			   im->tm_running,
-			   im->tm_running ? jiffies_delta_to_clock_t(delta) : 0,
-			   im->reporter);
+			   tm_running,
+			   tm_running ? jiffies_delta_to_clock_t(delta) : 0,
+			   READ_ONCE(im->reporter));
 	}
 	return 0;
 }
-- 
2.53.0



