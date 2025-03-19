Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932D21E0B67;
	Wed, 19 Mar 2025 14:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395019; cv=none; b=al/BP42A5PifzorMCjJwQExiFa/WWpZdX0fLJQ+bIFYpKm80LNVOzpc7P+d5C67wSzwJp7B5JxXagWRnsPVSUNP78OHo4hLtGzFVlE5SVLpQca9Fi2SDoo4ffUlRBA28NCef5MyWuvEsOvPcAoLNLsLIjd4mgXPDFw8ahSGCBBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395019; c=relaxed/simple;
	bh=bMDeevO2dlKtNQuvs2UCnCdOohgc3gkM/duIyIwajEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gACsL2SppIsnb0WVodGDaNO0iyTikAtUsTOd7SiUzGIxIntDLuvncudawzXbDTIYYe52UzTJtETjfmCwIa4rQL/aZbT/q2fK9xDwFsJYdza2AESHTZbolo2fvf1yW2M89+csmoHsNwHmBUKuqeB8jtHKHl4NZmEc2pk8ADPUYQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=irTAKY3/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="irTAKY3/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66ACCC4CEE8;
	Wed, 19 Mar 2025 14:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395019;
	bh=bMDeevO2dlKtNQuvs2UCnCdOohgc3gkM/duIyIwajEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=irTAKY3/hKEQ+9kr79tPi4xubZB9hLbbgmBMz4sqw9uYfMHHj0TcUh8ybBDQ9XFvG
	 PtbEZ9ET7l4HexM5egURhqWRoU2lup8JZaBW97/Rivamp8ojOf2FBZGcGYkYJBNF2j
	 HDKCvpPN8hscyzL3uCYSDRf3ja5DTK6oNq6fxslY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Taehee Yoo <ap420073@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 032/231] eth: bnxt: do not use BNXT_VNIC_NTUPLE unconditionally in queue restart logic
Date: Wed, 19 Mar 2025 07:28:45 -0700
Message-ID: <20250319143027.607429242@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 661958552eda5bf64bfafb4821cbdded935f1f68 ]

When a queue is restarted, it sets MRU to 0 for stopping packet flow.
MRU variable is a member of vnic_info[], the first vnic_info is default
and the second is ntuple.
Only when ntuple is enabled(ethtool -K eth0 ntuple on), vnic_info for
ntuple is allocated in init logic.
The bp->nr_vnics indicates how many vnic_info are allocated.
However bnxt_queue_{start | stop}() accesses vnic_info[BNXT_VNIC_NTUPLE]
regardless of ntuple state.

Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Fixes: b9d2956e869c ("bnxt_en: stop packet flow during bnxt_queue_stop/start")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Link: https://patch.msgid.link/20250309134219.91670-4-ap420073@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index a476f9da40c27..442c85b3ea3f3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -15287,7 +15287,7 @@ static int bnxt_queue_start(struct net_device *dev, void *qmem, int idx)
 	cpr = &rxr->bnapi->cp_ring;
 	cpr->sw_stats->rx.rx_resets++;
 
-	for (i = 0; i <= BNXT_VNIC_NTUPLE; i++) {
+	for (i = 0; i <= bp->nr_vnics; i++) {
 		vnic = &bp->vnic_info[i];
 
 		rc = bnxt_hwrm_vnic_set_rss_p5(bp, vnic, true);
@@ -15315,7 +15315,7 @@ static int bnxt_queue_stop(struct net_device *dev, void *qmem, int idx)
 	struct bnxt_vnic_info *vnic;
 	int i;
 
-	for (i = 0; i <= BNXT_VNIC_NTUPLE; i++) {
+	for (i = 0; i <= bp->nr_vnics; i++) {
 		vnic = &bp->vnic_info[i];
 		vnic->mru = 0;
 		bnxt_hwrm_vnic_update(bp, vnic,
-- 
2.39.5



