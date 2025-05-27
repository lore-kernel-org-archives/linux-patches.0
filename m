Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6034E19E967;
	Tue, 27 May 2025 17:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366016; cv=none; b=OpLsNfAT8vu4RsN6/P+rUO4NzTZDOLBcAz0OVuradv0hofLmWhi5ECnABZgniz2VoIf8Ow4r8IB6qeyEBCJre6HxhhThspxRSULE9+KQPC/iPbDBm/DZZlcMRdyBCHXM1y9Xh8mD9WAqv2gUMz5o2InG7WytyGxK5ER0e4jk+YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366016; c=relaxed/simple;
	bh=cVpk9yTMB8XnhsiqtgKHuI2qqy+eSvzbR+gIiVyHKwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GMus+7187TxUjpcLxJ9xFJ+Pi8e4Xhvc+ruKP75vDr+egTVcRGkqMrX1jNZoyCewyC6GcfHZ7XaPnQ5M4SV+E/Y51QAhQuWVYULJKpn/R0z7MC1OIy7GOhzNkTcf1vpFZ5kViGs1I6d29/Vl1qIr5SGcX1beexNluj51BBSPWjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OStIBxIB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OStIBxIB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF8C2C4CEE9;
	Tue, 27 May 2025 17:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366016;
	bh=cVpk9yTMB8XnhsiqtgKHuI2qqy+eSvzbR+gIiVyHKwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OStIBxIB5Udo86cavVKMEGyacAePccxrbJ9/ustyJaPGnolM+8NPUGMcI//MetvuY
	 F1QSowyylcy6JbUsEe+hXVeYBzuwqPDGWu0UuyMCX21WkJA1x1AenYQG1IIIDjX9JZ
	 IcWuqB5YJTtxVBYfsD9qRuOnZfWLEDIwgFntqyjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Newman <peternewman@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Joshua Hay <joshua.a.hay@intel.com>,
	Alan Brady <alan.brady@intel.com>,
	Madhu Chittim <madhu.chittim@intel.com>,
	Phani Burra <phani.r.burra@intel.com>,
	Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 563/626] idpf: fix idpf_vport_splitq_napi_poll()
Date: Tue, 27 May 2025 18:27:36 +0200
Message-ID: <20250527162507.845583180@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 407e0efdf8baf1672876d5948b75049860a93e59 ]

idpf_vport_splitq_napi_poll() can incorrectly return @budget
after napi_complete_done() has been called.

This violates NAPI rules, because after napi_complete_done(),
current thread lost napi ownership.

Move the test against POLL_MODE before the napi_complete_done().

Fixes: c2d548cad150 ("idpf: add TX splitq napi poll support")
Reported-by: Peter Newman <peternewman@google.com>
Closes: https://lore.kernel.org/netdev/20250520121908.1805732-1-edumazet@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Joshua Hay <joshua.a.hay@intel.com>
Cc: Alan Brady <alan.brady@intel.com>
Cc: Madhu Chittim <madhu.chittim@intel.com>
Cc: Phani Burra <phani.r.burra@intel.com>
Cc: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Link: https://patch.msgid.link/20250520124030.1983936-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_txrx.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.c b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
index afc902ae4763e..623bf17f87f9c 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
@@ -4022,6 +4022,14 @@ static int idpf_vport_splitq_napi_poll(struct napi_struct *napi, int budget)
 		return budget;
 	}
 
+	/* Switch to poll mode in the tear-down path after sending disable
+	 * queues virtchnl message, as the interrupts will be disabled after
+	 * that.
+	 */
+	if (unlikely(q_vector->num_txq && idpf_queue_has(POLL_MODE,
+							 q_vector->tx[0])))
+		return budget;
+
 	work_done = min_t(int, work_done, budget - 1);
 
 	/* Exit the polling mode, but don't re-enable interrupts if stack might
@@ -4032,15 +4040,7 @@ static int idpf_vport_splitq_napi_poll(struct napi_struct *napi, int budget)
 	else
 		idpf_vport_intr_set_wb_on_itr(q_vector);
 
-	/* Switch to poll mode in the tear-down path after sending disable
-	 * queues virtchnl message, as the interrupts will be disabled after
-	 * that
-	 */
-	if (unlikely(q_vector->num_txq && idpf_queue_has(POLL_MODE,
-							 q_vector->tx[0])))
-		return budget;
-	else
-		return work_done;
+	return work_done;
 }
 
 /**
-- 
2.39.5



