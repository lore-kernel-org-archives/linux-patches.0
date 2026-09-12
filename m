Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A7B3E4C61;
	Sat, 12 Sep 2026 09:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204804; cv=none; b=uZe6ynaHGW1YYvDTfIQ4JqU6dZUjU20AQSaN1EkfdKle3iYMu+y1IGeoQ8aLcHrA2570bHl3DUSKl2jkdpL7DiD0JBpW3ZU4Ag0DPJkpkAecmDbKRf/4L+uuSD6dO0T7qINwtnOYpg8qtSy+8jeYQf7TTtegLfLDSzyuQ4SC834=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204804; c=relaxed/simple;
	bh=Z2TSmb+16ThQukLYixjxQfK3PIaCh4mw4zxClfwSQow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BW/BlMBypgXSU4ak49YY5SNoj3NaqfZhRZ2+3na4jixF9bdYhntjQHtl2uFwrxeDtCz8KqWLqg+z89OiZ4coknttY15KmwVAbnzUYv4gRpDtEAsQfLUFeYw2EF81OxQQvprLeaYLrud8phPyiWAilrC5az8ozjXKvGDE1T7UIT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uS8bjPS8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uS8bjPS8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58EA11F000FF;
	Sat, 12 Sep 2026 09:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204803;
	bh=ua+xWaq9CsrayLDpZN7pQykvYXX3MW6mviHc5Q4o6BU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uS8bjPS8fD0oUmI9YS7uWaQ+UTUPdmLUSYKTErzagKUzHTynB8H0t8arMmNzJ81jk
	 rXWnivbhkMY303ty7kVme9iOmFEomThFTX1ai63EcC2J3UMjQdAiJ0MErPZCmCp84u
	 Z7Ql/tqVUNiKd/sUMf0XEurL1BKtG3UiAt2R7YR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hidayath Khan <hidayath@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1686/1815] net/smc: free pending qentry in smc_llc_flow_stop() before memset
Date: Sat, 12 Sep 2026 08:57:16 +0200
Message-ID: <20260912065728.564395386@linuxfoundation.org>
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
index b3136a17dfa93..c9ccd8480369c 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -341,6 +341,7 @@ int smc_llc_flow_initiate(struct smc_link_group *lgr,
 void smc_llc_flow_stop(struct smc_link_group *lgr, struct smc_llc_flow *flow)
 {
 	spin_lock_bh(&lgr->llc_flow_lock);
+	smc_llc_flow_qentry_del(flow);
 	memset(flow, 0, sizeof(*flow));
 	flow->type = SMC_LLC_FLOW_NONE;
 	spin_unlock_bh(&lgr->llc_flow_lock);
-- 
2.53.0



