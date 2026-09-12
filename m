Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8D14BEE32;
	Sat, 12 Sep 2026 11:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212095; cv=none; b=azbp/Ld7LeOJHCMpqz6QKsmQ2SH0+tgzXNASXUm41aTy0wp/PkWuC4Ioa6tw174V0syrVZWO9XNZTlnNPzvQLLyT5YEuxpIriPo1nZPZc5Do8fg3hkbiWq+IkCcpi6PaDWlWNYOLfMfJVFm7KKjyZfWZlXHoXywSwiZjcEpMyvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212095; c=relaxed/simple;
	bh=thQSjUEkXan6MrctIcyZn9/Xyelcb28eVlSGVm2HUAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JEw8afcilpFUPKJvekgFLjUaUTqhBXhq+NwO+QWfKN+NTR2e65TDRHLaZLcmdqzdvtAdM/jqMa/EKMpZ32RsfWNdkFTja71uN87q5ffG23RXUaYABBVIbStl5Pp9o6SGU5jI6pKD78jz83C7li2O1ZzvwhT6fFdF55z9g+OBAAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1oreiSWS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1oreiSWS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCF491F000FF;
	Sat, 12 Sep 2026 11:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212094;
	bh=aYQ4iwJaNgsf17fwbhQxJzDNjkZCoHsCXImm8VmOMjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1oreiSWS9vpaD6qUOJ19Z4xW+5WkNqZdzIw+4EzXJyUCd2aWVFZtIiDCz/0mSPw8A
	 BuvGh5lOVAQ4twQAaqOn2yo9fA464CJVYQPzQDuKW7dpbaL9xys3HGkPXN4BeqA0ZB
	 CLq1zl2ab9wgwUMErkvISnYJ1allnlKG3WxQ3Tgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hidayath Khan <hidayath@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1365/1518] net/smc: free pending qentry in smc_llc_flow_stop() before memset
Date: Sat, 12 Sep 2026 08:58:54 +0200
Message-ID: <20260912065654.416088005@linuxfoundation.org>
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
index cfc027435e5c3..65cf07bb30d8d 100644
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



