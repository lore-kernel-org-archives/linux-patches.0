Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F695604BE;
	Tue, 13 Feb 2024 17:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845827; cv=none; b=tDFTObOXwzC0DrcuN+301Plw681PGpva07bsK7jYhOInLhglXB9r51XglDlt0KsRgP1+7NknUHSUXy0R9RTxLqzyc7227QtJH4DFlJYVqUmfaEsZpapUyaM5OXQeU1gTUNgr9tUsQSCPsKqM9yDPJayGc3VhAjEM4CxV5pwQK1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845827; c=relaxed/simple;
	bh=wi0ybuNIRtHdt5O7igK9h0NpZ91HscJEuqHXDsNI5Ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hyv01OpcvDrKBdC0fNlD5caI9E+Qbje2UyjBYn7fcWQHU4C8bj5GoPGb5nMW5p52vTXIDnu79SInUqNtmWcELSaszrHhuROe08ROCiIN+tSXCMLrbjbU1mQe59CcKuAzPDQcKNY8GdjKWvK8rVf9d756SMbNOAqvsX9m8Jx1tFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j97bRjVg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j97bRjVg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85BD8C433C7;
	Tue, 13 Feb 2024 17:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845826;
	bh=wi0ybuNIRtHdt5O7igK9h0NpZ91HscJEuqHXDsNI5Ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j97bRjVg2RWT2azgvGvA8MrsDX79SLiY6X9AQAlQu7TS61m5p7x9QDxNwoj2VjYQW
	 J6+ZkCT8VAtltbQW1sAW638isdVjL1EKsGwIVhoQjAhygCmqrTp4ZkV0ZTPsB2+Izs
	 ryyPy9F51pfV+/zzBb47LNqPPxS38p6MOtEoJ4JI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	l.6diay@passmail.com,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 068/124] netfilter: nfnetlink_queue: un-break NF_REPEAT
Date: Tue, 13 Feb 2024 18:21:30 +0100
Message-ID: <20240213171855.727010003@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit f82777e8ce6c039cdcacbcf1eb8619b99a20c06d ]

Only override userspace verdict if the ct hook returns something
other than ACCEPT.

Else, this replaces NF_REPEAT (run all hooks again) with NF_ACCEPT
(move to next hook).

Fixes: 6291b3a67ad5 ("netfilter: conntrack: convert nf_conntrack_update to netfilter verdicts")
Reported-by: l.6diay@passmail.com
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_queue.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 171d1f52d3dd..5cf38fc0a366 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -232,18 +232,25 @@ static void nfqnl_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	if (verdict == NF_ACCEPT ||
 	    verdict == NF_REPEAT ||
 	    verdict == NF_STOP) {
+		unsigned int ct_verdict = verdict;
+
 		rcu_read_lock();
 		ct_hook = rcu_dereference(nf_ct_hook);
 		if (ct_hook)
-			verdict = ct_hook->update(entry->state.net, entry->skb);
+			ct_verdict = ct_hook->update(entry->state.net, entry->skb);
 		rcu_read_unlock();
 
-		switch (verdict & NF_VERDICT_MASK) {
+		switch (ct_verdict & NF_VERDICT_MASK) {
+		case NF_ACCEPT:
+			/* follow userspace verdict, could be REPEAT */
+			break;
 		case NF_STOLEN:
 			nf_queue_entry_free(entry);
 			return;
+		default:
+			verdict = ct_verdict & NF_VERDICT_MASK;
+			break;
 		}
-
 	}
 	nf_reinject(entry, verdict);
 }
-- 
2.43.0



