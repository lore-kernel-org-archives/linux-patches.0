Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE6D224239;
	Tue,  8 Apr 2025 11:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111964; cv=none; b=bwOd8sXO+RdOCngLDEJmz1ffcvFx1GqqEwVmiH1ljaWXLOyPkZ90+taGCqU6Oau2YjQCzHSQ3dSM6sGA42obelw31dxwV2TaZhPKw1pxw0vulCKdXFTBwL9/pfLjZeIkDttfZNdbOFA3Rr/mAeHZDqtEGL7U+1XO+9BBhlZfajg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111964; c=relaxed/simple;
	bh=9Ymk4L7Q0S6KGGS0fB4XDXPPHQbD5ODvRvPvdJLu9qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ggcljNiCs1FK8fC6Lb7UtjM4n5flbujA0vrxUax/AoK5Sy7qy0Tk+4OOCxo+tN8rV+wcU7mXB3Gx/Hvg3U8KmeH0hXFekHqqk/cx13ugSoDV+s2oc1YLZ/kPoPu9EKYQ0+vvxXviSgJOTZL3ycRJskZx8c2jPbxf+zg3Jphq8OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BWM99u35; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BWM99u35"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A62C4CEE5;
	Tue,  8 Apr 2025 11:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111964;
	bh=9Ymk4L7Q0S6KGGS0fB4XDXPPHQbD5ODvRvPvdJLu9qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BWM99u35bAtVNsT5OfCONe1UPndZcXNXAqkduIaKa9xYNERK0wGr9KwURliLW1VnD
	 nKKjRErwM9PhB4cRQ5cyLZQBuutSBCMOAMJU4HBHHqMXziRXbYN5KrVYeaEgzEqYqE
	 DNsPhxsbhwbhXYiDA9iLHvd2Hig/9K5upvzE/FcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Davide Caratti <dcaratti@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 624/731] net: airoha: Fix ETS priomap validation
Date: Tue,  8 Apr 2025 12:48:41 +0200
Message-ID: <20250408104928.787989558@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 367579274f60cb23c570ae5348966ab51e1509a4 ]

ETS Qdisc schedules SP bands in a priority order assigning band-0 the
highest priority (band-0 > band-1 > .. > band-n) while EN7581 arranges
SP bands in a priority order assigning band-7 the highest priority
(band-7 > band-6, .. > band-n).
Fix priomap check in airoha_qdma_set_tx_ets_sched routine in order to
align ETS Qdisc and airoha_eth driver SP priority ordering.

Fixes: b56e4d660a96 ("net: airoha: Enforce ETS Qdisc priomap")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Davide Caratti <dcaratti@redhat.com>
Link: https://patch.msgid.link/20250331-airoha-ets-validate-priomap-v1-1-60a524488672@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/airoha_eth.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/airoha_eth.c b/drivers/net/ethernet/mediatek/airoha_eth.c
index 71975c490822b..0c244ea5244cc 100644
--- a/drivers/net/ethernet/mediatek/airoha_eth.c
+++ b/drivers/net/ethernet/mediatek/airoha_eth.c
@@ -2793,7 +2793,7 @@ static int airoha_qdma_set_tx_ets_sched(struct airoha_gdm_port *port,
 	struct tc_ets_qopt_offload_replace_params *p = &opt->replace_params;
 	enum tx_sched_mode mode = TC_SCH_SP;
 	u16 w[AIROHA_NUM_QOS_QUEUES] = {};
-	int i, nstrict = 0, nwrr, qidx;
+	int i, nstrict = 0;
 
 	if (p->bands > AIROHA_NUM_QOS_QUEUES)
 		return -EINVAL;
@@ -2811,17 +2811,17 @@ static int airoha_qdma_set_tx_ets_sched(struct airoha_gdm_port *port,
 	 * lowest priorities with respect to SP ones.
 	 * e.g: WRR0, WRR1, .., WRRm, SP0, SP1, .., SPn
 	 */
-	nwrr = p->bands - nstrict;
-	qidx = nstrict && nwrr ? nstrict : 0;
-	for (i = 1; i <= p->bands; i++) {
-		if (p->priomap[i % AIROHA_NUM_QOS_QUEUES] != qidx)
+	for (i = 0; i < nstrict; i++) {
+		if (p->priomap[p->bands - i - 1] != i)
 			return -EINVAL;
-
-		qidx = i == nwrr ? 0 : qidx + 1;
 	}
 
-	for (i = 0; i < nwrr; i++)
+	for (i = 0; i < p->bands - nstrict; i++) {
+		if (p->priomap[i] != nstrict + i)
+			return -EINVAL;
+
 		w[i] = p->weights[nstrict + i];
+	}
 
 	if (!nstrict)
 		mode = TC_SCH_WRR8;
-- 
2.39.5



