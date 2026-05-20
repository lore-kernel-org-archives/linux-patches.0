Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D0B36405A;
	Wed, 20 May 2026 17:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299139; cv=none; b=XpIwnJTn70dqYfqdpiMgCLk2osZLFUV6fVxcUdS3idxGb1jHR3T7a/JYb/uqvfwyfKiBWzhP4xk5sU9AofVjsdtfrM9VghytsIjgxgLxPRuqwIh1NT4WU0wjyD3o9aPCWY1cLnEXesdGKNwQ3Df1oVY2R/2Gojr+seDG/pLLjWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299139; c=relaxed/simple;
	bh=oIKsCJ6fkTjuo/hpDZcVLTdEc/3SSUsM18afczz+VOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h4fjbnb/hF1Wxm8BRARIopVSM5LFwS92BBKpvYuunKEjqyWA+TiiJTCG6MN5m7cEDDTJBo4k+NjFKSDueJxbKagWQ1UFO3KHGujWmpEK7eJUl1irI0fnVM1wtFOqxjTEb64O4GE8WpWxbxGqgh3uAkCmDVZlp5NcNCugaWYAsKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c9ckp9RL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c9ckp9RL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988851F000E9;
	Wed, 20 May 2026 17:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299138;
	bh=4J1ky6rgtQZZhD+jqFwHmVcgI5qfSg9AGZjHnRYrN4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c9ckp9RLxttUQVjDD2fgFfHsAWX4qv3AnE15GKR2liNtTmCF8mZAarmh8GNYGeTfL
	 mzwJ65YWrlxJe9Mu+TCmYnN92zGa82hsIzfldFVQAZy/8tLsDAeo1ykk3qxb9tOF89
	 H0ton5brV+IX3ZZKhan99y55CWjkTDGgsZl4nt8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Enju <kohei@enjuk.jp>,
	Simon Horman <horms@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 678/957] net: validate skb->napi_id in RX tracepoints
Date: Wed, 20 May 2026 18:19:21 +0200
Message-ID: <20260520162149.241440032@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Kohei Enju <kohei@enjuk.jp>

[ Upstream commit 3bfcf396081ace536733b454ff128d53116581e5 ]

Since commit 2bd82484bb4c ("xps: fix xps for stacked devices"),
skb->napi_id shares storage with sender_cpu. RX tracepoints using
net_dev_rx_verbose_template read skb->napi_id directly and can therefore
report sender_cpu values as if they were NAPI IDs.

For example, on the loopback path this can report 1 as napi_id, where 1
comes from raw_smp_processor_id() + 1 in the XPS path:

  # bpftrace -e 'tracepoint:net:netif_rx_entry{ print(args->napi_id); }'
  # taskset -c 0 ping -c 1 ::1

Report only valid NAPI IDs in these tracepoints and use 0 otherwise.

Fixes: 2bd82484bb4c ("xps: fix xps for stacked devices")
Signed-off-by: Kohei Enju <kohei@enjuk.jp>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://patch.msgid.link/20260420105427.162816-1-kohei@enjuk.jp
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/net.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/net.h b/include/trace/events/net.h
index d55162c12f90a..d3fe6acf85d28 100644
--- a/include/trace/events/net.h
+++ b/include/trace/events/net.h
@@ -10,6 +10,7 @@
 #include <linux/if_vlan.h>
 #include <linux/ip.h>
 #include <linux/tracepoint.h>
+#include <net/busy_poll.h>
 
 TRACE_EVENT(net_dev_start_xmit,
 
@@ -193,7 +194,8 @@ DECLARE_EVENT_CLASS(net_dev_rx_verbose_template,
 	TP_fast_assign(
 		__assign_str(name);
 #ifdef CONFIG_NET_RX_BUSY_POLL
-		__entry->napi_id = skb->napi_id;
+		__entry->napi_id = napi_id_valid(skb->napi_id) ?
+				   skb->napi_id : 0;
 #else
 		__entry->napi_id = 0;
 #endif
-- 
2.53.0



