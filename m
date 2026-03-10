Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B929B2BF3E2;
	Tue, 10 Mar 2026 11:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141190; cv=none; b=rZPPBF0zSczom0gQHwwXrsOsTzzEwPlkwYZOg+Ffi32OVB0Yotws1XIIufXXlZxhRLv8jG+R+9XQnoezaG3h2Ji0pa/xnTSVSVg8mUclaPGCp316HqOBiRPZ86NKkapp68YhyjlwvgrHq6Ua8f3MO9yidjJx+7xWtkehj7tbc5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141190; c=relaxed/simple;
	bh=mlQ7wq4cT2Sy37F+WntUNQO4KaMSxv1m+wkku500wfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BdGnq2GjFz4ILYu5Yg2FZeDtIeTNQkmLcGPGinuranKKapn04By/McY78NZREg62KABNydrj3R1jtrDbYTHfK0VJVguWf6izt0kXAtJkcP/OweNGr96bPFg2v41txZQec2dhsWaxXU9J0Acb4l4+F4MZR5hCTL+xU/QPMoUO4XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QT6qFjL3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QT6qFjL3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4F8C2BC86;
	Tue, 10 Mar 2026 11:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141190;
	bh=mlQ7wq4cT2Sy37F+WntUNQO4KaMSxv1m+wkku500wfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QT6qFjL3wi09ZPVGi/3xibfWEvQR24dtiGJGbCVUjE0gN914RFXQ7yJVjjp+8swgw
	 GjnVlbGaJvY3y1nqdq/cWgO8H5gHXgoeNM6EEiNe+RPGrapdjwMkHTSiVbv//Ndg4M
	 4AsyA49sVCxItmyDkB2Ytx0aFn1zgL8b0ClsgGFAbzjYTsOSLxWzCswXNVi8uA564p
	 zEpSXI+HecZZkI6s3D7eNeP0DIP00U/8ULCgzjlk2kQZpx3oiX8HmzgE1z1Q60RUtf
	 AJuIs231x3SbK4AJrCp2eZ0E1UQPYZh7HFChhokZEqwYbPNpO06aP5hG1hie/P9EmH
	 9xyDNeIq3Sugw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Li Li <boolli@google.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 192/311] idpf: increment completion queue next_to_clean in sw marker wait routine
Date: Tue, 10 Mar 2026 07:03:59 -0400
Message-ID: <6ea1332dd3e3f17800b9257a661f08a37c85445a.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Li Li <boolli@google.com>

[ Upstream commit 712896ac4bce38a965a1c175f6e7804ed0381334 ]

Currently, in idpf_wait_for_sw_marker_completion(), when an
IDPF_TXD_COMPLT_SW_MARKER packet is found, the routine breaks out of
the for loop and does not increment the next_to_clean counter. This
causes the subsequent NAPI polls to run into the same
IDPF_TXD_COMPLT_SW_MARKER packet again and print out the following:

    [   23.261341] idpf 0000:05:00.0 eth1: Unknown TX completion type: 5

Instead, we should increment next_to_clean regardless when an
IDPF_TXD_COMPLT_SW_MARKER packet is found.

Tested: with the patch applied, we do not see the errors above from NAPI
polls anymore.

Fixes: 9d39447051a0 ("idpf: remove SW marker handling from NAPI")
Signed-off-by: Li Li <boolli@google.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_txrx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.c b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
index f58f616d87fc4..c558bb9c4dcbb 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
@@ -2326,7 +2326,7 @@ void idpf_wait_for_sw_marker_completion(const struct idpf_tx_queue *txq)
 
 	do {
 		struct idpf_splitq_4b_tx_compl_desc *tx_desc;
-		struct idpf_tx_queue *target;
+		struct idpf_tx_queue *target = NULL;
 		u32 ctype_gen, id;
 
 		tx_desc = flow ? &complq->comp[ntc].common :
@@ -2346,14 +2346,14 @@ void idpf_wait_for_sw_marker_completion(const struct idpf_tx_queue *txq)
 		target = complq->txq_grp->txqs[id];
 
 		idpf_queue_clear(SW_MARKER, target);
-		if (target == txq)
-			break;
 
 next:
 		if (unlikely(++ntc == complq->desc_count)) {
 			ntc = 0;
 			gen_flag = !gen_flag;
 		}
+		if (target == txq)
+			break;
 	} while (time_before(jiffies, timeout));
 
 	idpf_queue_assign(GEN_CHK, complq, gen_flag);
-- 
2.51.0

