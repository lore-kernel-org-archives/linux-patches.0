Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5CDC2F7F19;
	Sat, 12 Sep 2026 09:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204799; cv=none; b=EP24OfSU0z/JMJoiYpoNDMXF3t5vXJVlPI3dbQ2yoeg0mDdje1iWXjTtjchg8w9pljBTut9aSJHJcyHmEUz4XlK4+H+JXg0XUmiFEPKZlnHXRpXKalPYQTt+5BEtcO6heMicbW+kMbjz4amwqW5gqBVc11gLoW2yhnH1JddoC6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204799; c=relaxed/simple;
	bh=QDgrSJNuDVj2TWg961PIrQPyO1S6MslU8gn40tV1NIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vE1WpWKRn7U+CcUuMkklwCuGbaQnwBU1ZNuiaalwKAYGiaslZekfDS8/X2xta+J8MlwMbB78aerCfMG/iY++UOIyqx0qZv6kyFlpskOhZMNQs6knxlkz1Qse3rcyaIEc0QcWBK51BxQjttrU46PvoypZXNSEdtJLueJTCn4Z66U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YLPpJnYL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YLPpJnYL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6631F000FF;
	Sat, 12 Sep 2026 09:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204798;
	bh=E+zJ66UdNmBVvfFmAb+0zqhp6iPJUASiy+3j/YcRzeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YLPpJnYL7ApoCDLIkg8lDLJ2W35ekVqjZHExUAU/oKSwTym0Y5Hqqr5IVd6mm+GSv
	 VSQrdLDol9qFU8XY/Ot1KlDoeOfvyiVSZxsV2eloWv1mZNTcuA+RnNUSaXEYA5KlFJ
	 e3pJxltmqf9Qv6kMSBuJHToNbdIN2xLVBcD1/fOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hidayath Khan <hidayath@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1685/1815] net/smc: free stashed qentry before overwrite in REQ_ADD_LINK to ADD_LINK transition
Date: Sat, 12 Sep 2026 08:57:15 +0200
Message-ID: <20260912065728.540375292@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mahanta Jambigi <mjambigi@linux.ibm.com>

[ Upstream commit 036322025d6e440cb75fc6fecbba9a16b271a2ae ]

When smc_llc_event_handler() transitions the local LLC flow from
SMC_LLC_FLOW_REQ_ADD_LINK to SMC_LLC_FLOW_ADD_LINK on arrival of an ADD_LINK
request, it calls smc_llc_flow_qentry_set() unconditionally:

	if (lgr->llc_flow_lcl.type == SMC_LLC_FLOW_REQ_ADD_LINK) {
		lgr->llc_flow_lcl.type = SMC_LLC_FLOW_ADD_LINK;
		smc_llc_flow_qentry_set(&lgr->llc_flow_lcl, qentry);
		...
	}

A CONFIRM_LINK or ADD_LINK_CONT arriving while flow->type is
SMC_LLC_FLOW_REQ_ADD_LINK is stashed into flow->qentry via the
SMC_LLC_CONFIRM_LINK / SMC_LLC_ADD_LINK_CONT handler (which stores into
flow->qentry for any non-NONE flow type).  When the subsequent ADD_LINK
arrives, the REQ_ADD_LINK branch overwrites flow->qentry with the new pointer
without first freeing the stashed allocation, leaking one kmalloc object.

The stashed entry has no consumer: smc_llc_wait() is only called from
llc_add_link_work, which is not yet scheduled while the flow type remains
REQ_ADD_LINK.  No waiter is sleeping on llc_msg_waiter at this point.
It is safe to unconditionally free any stashed qentry before
the overwrite.

Call smc_llc_flow_qentry_del() before smc_llc_flow_qentry_set() in the
REQ_ADD_LINK branch.  smc_llc_flow_qentry_del() already checks flow->qentry
before freeing, so the normal path where no entry is stashed is a no-op.

Fixes: b4ba4652b3f8 ("net/smc: extend LLC layer for SMC-Rv2")
Reviewed-by: Hidayath Khan <hidayath@linux.ibm.com>
Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
Link: https://patch.msgid.link/20260818073107.466506-1-mjambigi@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_llc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 481b0495b0d31..b3136a17dfa93 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -1945,6 +1945,8 @@ static void smc_llc_event_handler(struct smc_llc_qentry *qentry)
 			if (lgr->llc_flow_lcl.type ==
 					SMC_LLC_FLOW_REQ_ADD_LINK) {
 				/* server started add_link processing */
+				/* free any qentry stashed in REQ_ADD_LINK state */
+				smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
 				lgr->llc_flow_lcl.type = SMC_LLC_FLOW_ADD_LINK;
 				smc_llc_flow_qentry_set(&lgr->llc_flow_lcl,
 							qentry);
-- 
2.53.0



