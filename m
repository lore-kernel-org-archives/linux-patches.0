Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43C8388E7C;
	Sat, 12 Sep 2026 15:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226107; cv=none; b=byzm3EjZLfH63kJbwMw12NI6VdaSlmZUnSWZTkDgSrvpNuecVHNIeMnSW0vSszrbioWcuOr6+Q+t9mQAgXpgWigrAMjrSMYlXbg6PoaBZiXksZd/pcG1gneIm7x/IqSIu8wWhnYTBwOBDc9AwSs+qiKmDJixSTlMNDoUuz45ioc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226107; c=relaxed/simple;
	bh=LItgXbBOe2tX9bFwrvgCr3rmoQ/EA7/ud0Ix9WPNvFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BGI4Ewdt4dVjU6NjTMLMTLfagzbTx6ANhq8zhyo71cT0ePFeVYMZS6/O7Z4SMQVWrRCj83bdd+cSMJedrvADmeNysHh2+VCZFkZWz/HWrym0Rp1KshT5Wj2Ppv1seLM3thaQxNStSqO/3Sm96noKiCqfVHrkiGt3DyzvAenFF5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zkf0gOys; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zkf0gOys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573511F000FF;
	Sat, 12 Sep 2026 15:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226105;
	bh=NDVv1XeR36VaW+8mQzwChtc+uZFlpcHnws8PpDX3b90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zkf0gOyssvDy0OVrGtZT/TL1K9W5NIJOJZEdA1CsMJKW1xl2ewkMiGbYoMJ1Rl7Mz
	 Ev0l0XwDKlfJU1GkYKbB5krVNTKr2P1FIHv136vXwZpes0p2k4HK36Pk8YjbtZ2TbS
	 accVf3pyzLm1WG/clafQDiEJKbck7LKaWW64Ez6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hidayath Khan <hidayath@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1335/1424] net/smc: free pending qentry in smc_llc_flow_stop() before memset
Date: Sat, 12 Sep 2026 09:02:47 +0200
Message-ID: <20260912065637.155536611@linuxfoundation.org>
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
index 924dbd38e879c..1932983ef7636 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -320,6 +320,7 @@ int smc_llc_flow_initiate(struct smc_link_group *lgr,
 void smc_llc_flow_stop(struct smc_link_group *lgr, struct smc_llc_flow *flow)
 {
 	spin_lock_bh(&lgr->llc_flow_lock);
+	smc_llc_flow_qentry_del(flow);
 	memset(flow, 0, sizeof(*flow));
 	flow->type = SMC_LLC_FLOW_NONE;
 	spin_unlock_bh(&lgr->llc_flow_lock);
-- 
2.53.0



