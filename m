Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F814B0492;
	Mon, 17 Aug 2026 13:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973998; cv=none; b=O6P2McWOwu2ZF7Z9txZEIbh++41G/C8UvcZaNs5cg2hEywu3buBe4IQPn+sdRQ+GpM28OTkYcAK6JNCZsKmJYNiGtDzOta2CO0ThJdcgee//hflYDI2fgb8SBHbOthryPPhrsBi315fANrjWMq5UW4AE/xxT4GDESqIW0lFgN7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973998; c=relaxed/simple;
	bh=jxxEmfR/qEv6MOqA3UKkXozNOCoGtorDbaylQKBS13o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rUnmFuSBnUJhultZrUpGjLJYkgQwZXNaORBJc2UdRV6ne2Rrzp0b/ZfWLTkiidU/S3r2RE4pRcxkCzuW6TI5fRQFelj22xI9FdMXGJwOMEo+zA6O5mdF3SHSlQyXFR0JGe/j5/Zi2m4b2gZcB7al+dkZHJPNs+08Qxf7QcXqY4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oQNtTeT4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oQNtTeT4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862991F000E9;
	Mon, 17 Aug 2026 13:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786973997;
	bh=R5fM0eYvp6TrtGPTI+S5qBfPuRIHsB2vsvDGRhPdEhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oQNtTeT4VQUOlFm2OCwUuwpA/gsLeXpNUGbuWNd8wzfkG+c2YGzzahBYcangEqdqb
	 0pGhmEt6aYMq6RG4sG7WovOgJVZ2W45mNx5Rsb1dxSk0ter57FepTh3fdKpDBVOVmJ
	 icTTIsqkVF3UuYUzGRA7pSRunTkyf99d9YSQL7D4=
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
Subject: [PATCH 7.1 054/271] net/smc: fix qentry overwrite for CONFIRM_LINK and ADD_LINK_CONT in smc_llc_event_handler()
Date: Mon, 17 Aug 2026 15:29:39 +0200
Message-ID: <20260817132538.965415828@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 954b2ff1815c2..aa6d83af55eda 100644
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



