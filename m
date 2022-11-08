Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D20A15CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:10:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D576FC433C1;
	Tue,  8 Nov 2022 14:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916601;
	bh=UIaTYxepIp12ZTOuZjz0sGry1CP0ZxQe34KHErzcZUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FymfcH6tMmZKr7niAIC84KlXL5iwvKtKscgk1hObJHBKE2Tm0PBFZXYmTrVTRjbrX
	 H5/YQDzKbQmqGNygzvb0+3GDlXPperKH5VX7ke3Wr/1HLQdJkhi3PIflHsY+pzyP80
	 rlUf4PKcRptUwlGljoy08rfjrfg1qHXsRrqYGTII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Child <nnac123@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 056/197] ibmvnic: Free rwi on reset success
Date: Tue,  8 Nov 2022 14:38:14 +0100
Message-Id: <20221108133357.366695050@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nick Child <nnac123@linux.ibm.com>

[ Upstream commit d6dd2fe71153f0ff748bf188bd4af076fe09a0a6 ]

Free the rwi structure in the event that the last rwi in the list
processed successfully. The logic in commit 4f408e1fa6e1 ("ibmvnic:
retry reset if there are no other resets") introduces an issue that
results in a 32 byte memory leak whenever the last rwi in the list
gets processed.

Fixes: 4f408e1fa6e1 ("ibmvnic: retry reset if there are no other resets")
Signed-off-by: Nick Child <nnac123@linux.ibm.com>
Link: https://lore.kernel.org/r/20221031150642.13356-1-nnac123@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 5ab7c0f81e9a..e6b141536879 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3007,19 +3007,19 @@ static void __ibmvnic_reset(struct work_struct *work)
 		rwi = get_next_rwi(adapter);
 
 		/*
-		 * If there is another reset queued, free the previous rwi
-		 * and process the new reset even if previous reset failed
-		 * (the previous reset could have failed because of a fail
-		 * over for instance, so process the fail over).
-		 *
 		 * If there are no resets queued and the previous reset failed,
 		 * the adapter would be in an undefined state. So retry the
 		 * previous reset as a hard reset.
+		 *
+		 * Else, free the previous rwi and, if there is another reset
+		 * queued, process the new reset even if previous reset failed
+		 * (the previous reset could have failed because of a fail
+		 * over for instance, so process the fail over).
 		 */
-		if (rwi)
-			kfree(tmprwi);
-		else if (rc)
+		if (!rwi && rc)
 			rwi = tmprwi;
+		else
+			kfree(tmprwi);
 
 		if (rwi && (rwi->reset_reason == VNIC_RESET_FAILOVER ||
 			    rwi->reset_reason == VNIC_RESET_MOBILITY || rc))
-- 
2.35.1



