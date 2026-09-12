Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1093F356A0D;
	Sat, 12 Sep 2026 11:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212091; cv=none; b=riBVISRnhE5jxY4/SHFE9pf5y1zEV02CfuFmS4xqRVlqpEmoCAwksM6dElhgJ0SE9aKFxZzb8ywA7m32NXOraiP5ywJbf5WPXSynR6a9VQ+bSjfshg31A7gZdZUa1wkpcmcZLxNfyGF76Hs6jSjEntuPFKImrBghqDf9JgTPu4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212091; c=relaxed/simple;
	bh=UGbV4/w/1gk/FFpYalxsTGOlfL4cfnF3KyDKWfX14DQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=agvskg78ZxLRK0IvxA6yt+WbgcxkJs74FpQa760WBw7asz/sqDLdIR8HGmlke8it7P6r+nNe/idLAvwgQaIB4X1GsVsdotrGhQD8/YHtoPYffpVDwO4+yPs/Tjbo4IIrhRKj6bLWsKHeX2lw6dX8cLJZhCmSa9PNj4xooqZiwrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ADbiTTQX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ADbiTTQX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8DC71F0089A;
	Sat, 12 Sep 2026 11:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212090;
	bh=pmo2AfE1w8uEQEs7FgK3lE23EU/Ca81aYqBbLVkti/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ADbiTTQXO0CxLXRHaHxcdsvBs16s8ePIecUGenJ2LpM/Bc9/VqPJ0xEyycTUCTVTN
	 9gp21DxtMSBdbsFALoggqpj4aJQ4UZPX/i48qJZwfu6Vv6HVP89dnw4f8pEwGQxh+9
	 zPBNCo4Nh8VBS2kF+8srbFJYvslLuzw1GKJvZ3qQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hidayath Khan <hidayath@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1364/1518] net/smc: free stashed qentry before overwrite in REQ_ADD_LINK to ADD_LINK transition
Date: Sat, 12 Sep 2026 08:58:53 +0200
Message-ID: <20260912065654.392904357@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 51937265203c8..cfc027435e5c3 100644
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



