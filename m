Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951873DD51A;
	Sat, 12 Sep 2026 19:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240456; cv=none; b=TZZPGRa9zVuopBR8BbdXUhG0FJf9f5b1qWj1pimAJIQdzGHLGPJEM/sFWapRGlLkw3DLNia0zjJVgGw+GMoTJJxKdvLdj0UOrIwPV6Wo4gjHg3zZXKak7NO5CsVFg6vsDZmYNmcgqrvACNuNhJq2yjSAAts4n123rgiAwr5wWls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240456; c=relaxed/simple;
	bh=9mfdFuDDXNU3FtPSqTx/XhmnjO5DuoPooRu2xwa685w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nMteqRMyD6uLCoHKYnIX8jbOekXgqLFLUpOE7XgG1gothqBFX6zEeJWAS504CT/4YGCkFxl8DW5w1xCzZARDKRIO6ohOt99tWztetqJTSXFF9chHFJYwsTAwuXPjVTzUcoPCa0ohSBtMEy9qzVXBfczSZqGjeReL/lFXs8ccIWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DkxVHY2Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DkxVHY2Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B5C1F000FF;
	Sat, 12 Sep 2026 19:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240454;
	bh=PxeKGPst+dVd2/VpY2ZsHk3YS5PYY0g3vGoQkoqZCwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DkxVHY2QhTvTPn+L4z+uhita+qE5fRwhDf8yR+uILaNYxp3h9jZr2ohP7Bsb6vQEO
	 rHyW9a9NWWdO5/2J5M7MYkYJ8AaJh9+91GiJCYTLQoO6RlKfctnqhWv1BAGU3e4vtS
	 KXSkK1wqSWMRAQhf/fm1F0Mo31HzvJeLYB130bBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hidayath Khan <hidayath@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 873/935] net/smc: free pending qentry in smc_llc_flow_stop() before memset
Date: Sat, 12 Sep 2026 09:05:03 +0200
Message-ID: <20260912065546.840400026@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 572d02bfd3eda..e4d2abec8ec86 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -276,6 +276,7 @@ int smc_llc_flow_initiate(struct smc_link_group *lgr,
 void smc_llc_flow_stop(struct smc_link_group *lgr, struct smc_llc_flow *flow)
 {
 	spin_lock_bh(&lgr->llc_flow_lock);
+	smc_llc_flow_qentry_del(flow);
 	memset(flow, 0, sizeof(*flow));
 	flow->type = SMC_LLC_FLOW_NONE;
 	spin_unlock_bh(&lgr->llc_flow_lock);
-- 
2.53.0



