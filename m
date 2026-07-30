Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37FD456E0F;
	Thu, 30 Jul 2026 15:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425194; cv=none; b=NUcRGXnpQU7wua4EtWz5Khy9a85It2ArEfaEhLQaE//NrtTUk4GYZHyPGZ1ysdFeJEK3Sr3G5F+ExbBCCMBd7qV4jJI/44lw/+Tx+X6MM8YiKoz/+lHdz48NpCmDYJN1Mwe4EaVZrPCEtsMkm/W6dVqVlijpNJJi0T2ryQbgg90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425194; c=relaxed/simple;
	bh=pxoB+0LSX9syxkeCkaOYCxDDohvvLudOd7l9DKuSlhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KKcyhyGSXSeN5qDpGSOsX0Y2UQCjd9RDzAbjgDRFceryUO+7J2N+Gx8XsWpc/6OsO0iYLZOg14UqFJZHpJzgccvPvMjahXMRIuLnzJS5NFY79TC4oKBsRUQdP/e/KIbOaZvTeb9/v7pGGk+lp2xkeya6pc+ckJ9QrNk7cQm0+yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GCTBO2mc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GCTBO2mc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526C81F000E9;
	Thu, 30 Jul 2026 15:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425192;
	bh=z8wXuvw4nyOoPy/gp7JuNnAbm2zvlgbGTWYSWqjApbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GCTBO2mcUJeTSUiPDwlB13m5zHC76DtOI5v9pIsExTC1y84+wwnn1uXeoa1sai8td
	 2A21EnQOaWHHUWHrvwV0Ysi9v+Uiz1TwxWNLWP1CCnDhjv9V7DfruD1rOa4+yxD624
	 pQDRPB7HuqIVEx/3MAleJpGvWOBp7V+P/pDSsvPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 657/675] octeontx2-af: validate body pcifunc in rvu_mbox_handler_rep_event_notify
Date: Thu, 30 Jul 2026 16:16:27 +0200
Message-ID: <20260730141459.112292399@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit 2156a29aecfffa2eb7c558255690084efbe9f3b0 ]

rvu_mbox_handler_rep_event_notify() in drivers/net/ethernet/marvell/
octeontx2/af/rvu_rep.c queues a sender-controlled REP_EVENT_NOTIFY
request body verbatim, and rvu_rep_up_notify() then forwards
event->pcifunc (the nested body field, distinct from the
AF-normalised header pcifunc) into rvu_get_pfvf(), rvu_get_pf() and
the AF->PF mailbox device index without any bounds check.

A VF attached to a PF that has been put into switchdev
representor mode reaches this path: the VF mailbox handler
otx2_pfvf_mbox_handler() forwards every message id including
MBOX_MSG_REP_EVENT_NOTIFY to AF without an allowlist, and the AF
dispatcher rewrites only msg->pcifunc, leaving struct
rep_event::pcifunc attacker-controlled.  The sibling
rvu_mbox_handler_esw_cfg() refuses requests whose header pcifunc
is not rvu->rep_pcifunc; this handler has no equivalent gate.

An out-of-range body pcifunc selects an &rvu->pf[]/&rvu->hwvf[]
element past the allocated array and, for RVU_EVENT_MAC_ADDR_CHANGE,
turns into a six-byte attacker-chosen OOB ether_addr_copy() target
inside the queued worker; KASAN reports a slab-out-of-bounds write
in rvu_rep_wq_handler.

Reject malformed requests at the handler entry by gating on
is_pf_func_valid(), which is already the canonical PF/VF range check
in this driver; expose it via rvu.h so callers in rvu_rep.c can use
it instead of open-coding the same range arithmetic.

Fixes: b8fea84a0468 ("octeontx2-pf: Add support to sync link state between representor and VFs")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Link: https://patch.msgid.link/20260520154157.1439319-1-michael.bommarito@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 8cdcf3d2caac ("octeontx2-af: cn10k: restrict VF LMTLINE sharing to its own PF")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c     |    2 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h     |    1 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu_rep.c |    8 ++++++++
 3 files changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -435,7 +435,7 @@ struct rvu_pfvf *rvu_get_pfvf(struct rvu
 		return &rvu->pf[rvu_get_pf(rvu->pdev, pcifunc)];
 }
 
-static bool is_pf_func_valid(struct rvu *rvu, u16 pcifunc)
+bool is_pf_func_valid(struct rvu *rvu, u16 pcifunc)
 {
 	int pf, vf, nvfs;
 	u64 cfg;
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -900,6 +900,7 @@ u16 rvu_get_rsrc_mapcount(struct rvu_pfv
 struct rvu_pfvf *rvu_get_pfvf(struct rvu *rvu, int pcifunc);
 void rvu_get_pf_numvfs(struct rvu *rvu, int pf, int *numvfs, int *hwvf);
 bool is_block_implemented(struct rvu_hwinfo *hw, int blkaddr);
+bool is_pf_func_valid(struct rvu *rvu, u16 pcifunc);
 bool is_pffunc_map_valid(struct rvu *rvu, u16 pcifunc, int blktype);
 int rvu_get_lf(struct rvu *rvu, struct rvu_block *block, u16 pcifunc, u16 slot);
 int rvu_lf_reset(struct rvu *rvu, struct rvu_block *block, int lf);
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_rep.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_rep.c
@@ -97,6 +97,14 @@ int rvu_mbox_handler_rep_event_notify(st
 {
 	struct rep_evtq_ent *qentry;
 
+	/* The mailbox dispatcher normalises only the header pcifunc; the
+	 * nested struct rep_event::pcifunc body field is sender-controlled
+	 * and is later used by rvu_rep_up_notify() to index rvu->pf[] /
+	 * rvu->hwvf[].  Reject out-of-range body selectors before queueing.
+	 */
+	if (!is_pf_func_valid(rvu, req->pcifunc))
+		return -EINVAL;
+
 	qentry = kmalloc(sizeof(*qentry), GFP_ATOMIC);
 	if (!qentry)
 		return -ENOMEM;


