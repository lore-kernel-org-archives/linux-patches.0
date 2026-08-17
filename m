Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A44E3DB33F;
	Mon, 17 Aug 2026 13:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974775; cv=none; b=VKDbBjp1AAqUJpOJF4DX2VEj6Oz7787Xpg4D9tAKT0CjSOYqX8eHbt5FNXbDEGit0lbRVzk4F7Jskdvfz5lnt7pNoxYQSoZl8T7Z7pr56Z6ZquR4kUP5+ym65XAy9hGqtzEbOdqChXS3C4ljuiOPUX5K5fnN8WXSJcDJJVy5MB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974775; c=relaxed/simple;
	bh=dR9ggaxZNngWHvFRbL0sr7vGAsaHUB0VgI++Clnitms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=srytEkLpVC80Z0wl2++YD24y+6gZmII/gnLvxkkVpKWxmhmgZQX+I3MdjZ8LIEOtya7T/cIK9oI+jhBooITq1tl/iEvLzQcE282M6MEjHzrboarrlqeTByBdH95G/qX0y0Gb22JNWc0UeTkj26OYl2NUvlTpWkSvxrh2/uhvgwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oYik824P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oYik824P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B16591F00A3E;
	Mon, 17 Aug 2026 13:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974764;
	bh=yw9dX/t2XUCrM+Shfh2vIDS/zLmGmcodNhVuC9iYt/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oYik824PNI9XxxgEmfjQwo+HydmqCemSidfQYuNTRJwWH0JAQA2CDW2CPxRBOCwPc
	 KGerBtri/ofkDuNpk4Wm/zmSvQTuhNOxoIWYt48NiHzrlnNUe9ZfA428xtwu+0mj6k
	 IWG3S44SP5n+8bcJqnJud9AFPGRJeULBHPRuexC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Hidayath Khan <hidayath@linux.ibm.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 046/250] net/smc: fix qentry overwrite for CONFIRM_LINK and ADD_LINK_CONT in smc_llc_event_handler()
Date: Mon, 17 Aug 2026 15:30:07 +0200
Message-ID: <20260817132538.335233742@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

[ Upstream commit 976245094925bab9bc39366b2e9ab44ffcde61d0 ]

The SMC_LLC_CONFIRM_LINK / SMC_LLC_ADD_LINK_CONT branch in
smc_llc_event_handler() stores an incoming qentry into the local LLC flow
without first checking whether a qentry is already pending. If a malicious or
buggy peer sends a second CONFIRM_LINK or ADD_LINK_CONT request while a flow is
active and flow->qentry is already set, smc_llc_flow_qentry_set() overwrites the
pointer without freeing the previous allocation, leaking one kmalloc-96 object
per spurious message.

The sibling SMC_LLC_DELETE_LINK branch already has the correct !flow->qentry
guard. Apply the same guard to the CONFIRM_LINK/ADD_LINK_CONT branch so that a
duplicate message when qentry is already occupied falls through to break and is
freed by the kfree(qentry) at the out: label, rather than silently leaking the
existing allocation.

The response direction (smc_llc_rx_response()) is unaffected: it already guards
with flow->qentry at the equivalent site and drops duplicate responses
correctly.

Fixes: 0fb0b02bd6fd ("net/smc: adapt SMC client code to use the LLC flow")
Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
Reviewed-by: Hidayath Khan <hidayath@linux.ibm.com>
Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
Link: https://patch.msgid.link/20260729130153.970800-1-mjambigi@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_llc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index f865c58c3aa77..28873ec06e3c1 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -1927,7 +1927,8 @@ static void smc_llc_event_handler(struct smc_llc_qentry *qentry)
 		return;
 	case SMC_LLC_CONFIRM_LINK:
 	case SMC_LLC_ADD_LINK_CONT:
-		if (lgr->llc_flow_lcl.type != SMC_LLC_FLOW_NONE) {
+		if (lgr->llc_flow_lcl.type != SMC_LLC_FLOW_NONE &&
+		    !lgr->llc_flow_lcl.qentry) {
 			/* a flow is waiting for this message */
 			smc_llc_flow_qentry_set(&lgr->llc_flow_lcl, qentry);
 			wake_up(&lgr->llc_msg_waiter);
-- 
2.53.0



