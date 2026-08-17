Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8697442EEDD;
	Mon, 17 Aug 2026 14:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978377; cv=none; b=s0iJS7S8J4krX2n9JCaEXUWc3xVV3yN4OXk3DxqHOzNUdaFEKL7nqH4NDNWN80taZeAg22wZW77PmLHKJvJ3SPSRdc9C8EFOeudLhs1RlT2BSjAm3HtaowbylSv9YHHArtlJt85DWNhDuqQEunDIzv5oxMCeXFTKvFojbQcH8cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978377; c=relaxed/simple;
	bh=Gvwko+FHmdctRzOHTmv9qodpju/pWEp+dY65Mi3rMyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eNUowAwvcUMDjkeaiCYPKUUhB8aGYii9Uf2M3kxkXx22vHzyYy5hCzrP+fYaKz1BYLNF4d9W0hPFofEJKOxwcTL5s7uiHKo3aaLbsbSKTOkPN8Xm1rvciEIStOl8kTHssA2G4BluUBkOleossTTE7EVSg2VmiFjhPJ3RiUcqk3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i+d/oKzV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i+d/oKzV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D5F1F000E9;
	Mon, 17 Aug 2026 14:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978376;
	bh=fwkfuh4AU1MPoxEGR65t40SQ6qboY18TchpqzjWYrl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i+d/oKzV4UPCuXw6BqU+ypZx7HwxzJAX8x8LdEZdWX5fTEo4PGm1mPhJl+luBOQ3e
	 9anUaa/00OTmCUSoDWVDB1076zT8dUdcRvAVsF0x2Mielv4Ky8Nl6pB9Kxm5e0rtPS
	 ySaxRkgMA8fXUwo3Ioev3/kt01VlCulRu9YyBpBk=
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
Subject: [PATCH 6.6 016/156] net/smc: fix qentry overwrite for CONFIRM_LINK and ADD_LINK_CONT in smc_llc_event_handler()
Date: Mon, 17 Aug 2026 15:32:30 +0200
Message-ID: <20260817132535.273193370@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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
index 018ce8133b026..149d63cff667e 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -1918,7 +1918,8 @@ static void smc_llc_event_handler(struct smc_llc_qentry *qentry)
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



