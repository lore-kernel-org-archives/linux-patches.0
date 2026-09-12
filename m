Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6C94BEE52;
	Sat, 12 Sep 2026 16:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231871; cv=none; b=JBkQa9CQ3vx/oSnJjiVXSgnpK2hSiS2esvdKRWRv21+bObqhHgxKGcLcBevT28R5VbWLkMZFzh9DIPlvNTdLsnOYAcS788Omy7ka/SS5IkN8CbOgJSp3XHtZo+/uJilH0WHjuWgwJXENef1atoJPNBagNGSyzlcstv6PxSjjZ+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231871; c=relaxed/simple;
	bh=Ksd4VAd+vO7fBfcR34svJBNjMXXgqumJ1MpebHL0v2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B+RGssKIm0xQWjt5P7nv17ExIMlIZTPHTVCIMGtXW5dtVw7x34vmUATkfu8DWrewehYNLS+U61jWw+OfTj5J8b+8Ufv+79cBD7cZKxHge5R6bjwuxlLQuMW498sBbpr5juRrAfMO4egoXFu+j+1izXY5scl/lsFUO5tOaaSlU94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jq8McvWX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jq8McvWX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF57B1F000FF;
	Sat, 12 Sep 2026 16:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231870;
	bh=P/9fqpZTJRnHEXKK8avd7W03eDfjiNFnQsDXiqWPopY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jq8McvWXzW5Plzf8Ai1NXWEgq3FL1M7ZQ9SE6m+cLvRz7LB5+346X6cdIadOLff+g
	 S94eYOupzdnV5T2jyQFCAQKJtSn/zHSDA8e37TROI7F5g/AXClKvFBWE8Re81A/4RZ
	 UvA5auloJc0BdCdvHVYcYiMFDpjB0ikCAYif9kHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hidayath Khan <hidayath@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1086/1191] net/smc: free pending qentry in smc_llc_flow_stop() before memset
Date: Sat, 12 Sep 2026 09:03:34 +0200
Message-ID: <20260912065612.556596525@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mahanta Jambigi <mjambigi@linux.ibm.com>

[ Upstream commit 5ee0ceddc7785c6dcf4a8107fef01f0414a354f4 ]

smc_llc_flow_stop() resets a flow struct with a blind memset:

	spin_lock_bh(&lgr->llc_flow_lock);
	memset(flow, 0, sizeof(*flow));
	flow->type = SMC_LLC_FLOW_NONE;
	spin_unlock_bh(&lgr->llc_flow_lock);

If flow->qentry is non-NULL at this point the pointer is overwritten without the
allocation being freed, leaking one kmalloc object.

A late-arriving duplicate CONFIRM_LINK or ADD_LINK_CONT message can set
flow->qentry after the legitimate message has been consumed by the waiter via
smc_llc_flow_qentry_clr() (which NULLs the pointer but leaves flow->type
non-zero) but before the flow completes and smc_llc_flow_stop() runs.  In that
window the duplicate is stashed into flow->qentry, and then lost when
smc_llc_flow_stop() zeros the struct.

Call smc_llc_flow_qentry_del() inside the lock before the memset.
smc_llc_flow_qentry_del() already checks flow->qentry before freeing, so the
normal case where no entry is pending is a no-op.

Fixes: 555da9af827d ("net/smc: add event-based llc_flow framework")
Reviewed-by: Hidayath Khan <hidayath@linux.ibm.com>
Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
Link: https://patch.msgid.link/20260818073943.1108383-1-mjambigi@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_llc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index ec2e60b091f30..9ffb880e313f3 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -321,6 +321,7 @@ int smc_llc_flow_initiate(struct smc_link_group *lgr,
 void smc_llc_flow_stop(struct smc_link_group *lgr, struct smc_llc_flow *flow)
 {
 	spin_lock_bh(&lgr->llc_flow_lock);
+	smc_llc_flow_qentry_del(flow);
 	memset(flow, 0, sizeof(*flow));
 	flow->type = SMC_LLC_FLOW_NONE;
 	spin_unlock_bh(&lgr->llc_flow_lock);
-- 
2.53.0



