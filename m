Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B7D27D766;
	Tue, 27 May 2025 17:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368552; cv=none; b=uO0AI+goS3O05b9Z5ZyeHIdt4zwxehRhubw2DzpuzWDz2/kKUODb+Thc+MEmgr9JgmwgUX++A5QYeQao0vzZaiQlScPj+SF6Sf9d84A2LU3W3L6nK3qWXODTSrJkWaATzP/2+cA8U/LaxEIvCpdJUgp5DI/lEwqAPsLl3kw1p7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368552; c=relaxed/simple;
	bh=w7HxG+rDTGakMkFukq9qEmRZ3h/Zb0CUV5xCKMuyXSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ARJ2zTpGU53j4C0fT4ZJMWoZ5hUiFvX3ynB3sn3JVnbmG4XHAxeCk1Qp93KYYenVOaPdhp0VRm465sQbTIeV8RgZWTsgGqnZNuCevAE7nuoakiSaA/PupbjIbCE7bss+3or9ldBs6kXFWCmsa5+bC9jBBhnZaGP44/lNRdT7tqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=08OCmPCv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="08OCmPCv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B943BC4CEE9;
	Tue, 27 May 2025 17:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368552;
	bh=w7HxG+rDTGakMkFukq9qEmRZ3h/Zb0CUV5xCKMuyXSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=08OCmPCvAGmkabIOXETiBBL2G8Tr98A4d7PTc9sjnkwgkLT12Yxz2oiFhiLAa7MLI
	 7YFXNV4FU8xGRgMzn4qFDrF4uHKKtOUAGA6sRV6enxeeu3B1dB6nUhngAOEXdTIkZJ
	 u0JoZFXTiSuWmEmp5v3zFfpujsC+CG6lyvF9hXFg=
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
Subject: [PATCH 6.14 712/783] idpf: fix idpf_vport_splitq_napi_poll()
Date: Tue, 27 May 2025 18:28:29 +0200
Message-ID: <20250527162542.109731533@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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
index 977741c414980..60b2e034c0348 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
@@ -4031,6 +4031,14 @@ static int idpf_vport_splitq_napi_poll(struct napi_struct *napi, int budget)
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
@@ -4041,15 +4049,7 @@ static int idpf_vport_splitq_napi_poll(struct napi_struct *napi, int budget)
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



