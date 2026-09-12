Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661DE2F531B;
	Sat, 12 Sep 2026 15:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226101; cv=none; b=mm8yZ/NS4noYXG3loaXcD8D7Wn5DdlEWZ+UYurkANNBa6Ae82Kz49cRqc1X/QJk/491l9lSgvm9hTljyELEOmzJRTl7PRPQOjAIG5JuM9pkI5AF9nlP8+0NH/1BSVj44N48zwbJit9vU+V4rgv4Oq8RumW5juA2/Xp76e/yVXHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226101; c=relaxed/simple;
	bh=pKkn6BsDpI2fLUD6PhZl7MffhSnqc2ITmVGTroPnrLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mz7nn7D+QapmEuszEHZx+mW1Y+/D86vNkD9pVvVCI0WLNMnwrsEntp9tEVjO3BdzkyBTMjBchi6zSSmPlthJrsF0RH1YlssdIMX9BYzqzfh+R4Fe/aa37pIZBUr6U2o2iwzzYYv8iCQBuA2dzhTtEVanX1eW0kA1fl2oj3/TbuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rRAgy1CK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rRAgy1CK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0651A1F000FF;
	Sat, 12 Sep 2026 15:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226100;
	bh=NZ1fVU/mO29roPUwdtdnpc9NWrR37JNFFpSES0iow2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rRAgy1CK9BI/jUoBspeZFMlQPMxdod2e16FpUV0Ipx7N1NyQdQmNSLMwfnEv7LsGa
	 jrV1LI86b4rba+tQG7S/VKiD0Tfw5a0+tucnTHd77TpeOEjo03CNQpkzASeMTp6ys2
	 V2HcEl44PF80syLA3Hxa+qXbLiq5KkGUtqXfbtq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hidayath Khan <hidayath@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1334/1424] net/smc: free stashed qentry before overwrite in REQ_ADD_LINK to ADD_LINK transition
Date: Sat, 12 Sep 2026 09:02:46 +0200
Message-ID: <20260912065637.133393925@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 149d63cff667e..924dbd38e879c 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -1902,6 +1902,8 @@ static void smc_llc_event_handler(struct smc_llc_qentry *qentry)
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



