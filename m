Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7899B3BA23E;
	Tue, 10 Mar 2026 11:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142134; cv=none; b=a1Y3vrS88vRlq2/xC0E2SfQytsJt1ldAQIj8/xBZGlq2r5gL+St8szotyjWmnIZ/JWbWOHytBQg6Oi2EvzXql8gM+BkjKp/WGC5imMTf0L9IomKRNRvaKWOUvVsw2FyoTFHFgNDwMOuS9MaKfHTPPnEeHw5YQTK/yESz6H3VRX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142134; c=relaxed/simple;
	bh=QccW6cyqKoTAs/xHLg87J6mZAwKWfrQURGqDAox24ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HhjxCP4Nm1AlnWeZV7hYIRJcMQqvnum/4I3guXrDzVjhL7nK5EIbTw17hqyCJp9DCSa0tHr9fBfP3je85Bhroj6a/vCRvOyVAuhzfLTxHmhFMhtlqLs3dhpxsEXXdG14HS46rERFjy5Z9Jl4h6ZCCnPD82vfPYNq3SS+XIqa4js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RDBg3PIA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RDBg3PIA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555ECC19423;
	Tue, 10 Mar 2026 11:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142134;
	bh=QccW6cyqKoTAs/xHLg87J6mZAwKWfrQURGqDAox24ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RDBg3PIA2qzj2QD+Ep5sJebpW3Priao8zlLJ/f/ieP0zvHvrYRLoAwY3EKRHBVBEg
	 C2mJ4+Mx40MPJYUj9mZd9MsWLaIi220C9uC/LAek0XPT++RJUD2ZLa9lP2eaAC7i9k
	 E5JgfeZh7wDIj7y5jbQrxSeN6XImdpOfDIJu5Akitnu/+knWa3nRfmAZzohoL1RDC+
	 8IuWMmZDrgLdaF/3Honc8gIq9ciBcq3UqNOdemgx649E13Bn7C5EMpPIE3NvxV9rjK
	 H9j07aSqKEdqlSizuYfa4S1zhITh3+AT6+QJIx97iMuLrOJWLQ7bQxGsjP18XP/bDG
	 e+UAegBUbdXiQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	intel-wired-lan@lists.osuosl.org,
	netdev@vger.kernel.org,
	Joe Damato <joe@dama.to>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 222/314] i40e: Fix preempt count leak in napi poll tracepoint
Date: Tue, 10 Mar 2026 07:18:01 -0400
Message-ID: <785978f2387f8e19eb824c7dd368ffa1fc09c513.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Thomas Gleixner <tglx@kernel.org>

[ Upstream commit 4b3d54a85bd37ebf2d9836f0d0de775c0ff21af9 ]

Using get_cpu() in the tracepoint assignment causes an obvious preempt
count leak because nothing invokes put_cpu() to undo it:

  softirq: huh, entered softirq 3 NET_RX with preempt_count 00000100, exited with 00000101?

This clearly has seen a lot of testing in the last 3+ years...

Use smp_processor_id() instead.

Fixes: 6d4d584a7ea8 ("i40e: Add i40e_napi_poll tracepoint")
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Cc: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org
Reviewed-by: Joe Damato <joe@dama.to>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_trace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_trace.h b/drivers/net/ethernet/intel/i40e/i40e_trace.h
index 759f3d1c4c8f0..dde0ccd789ed1 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_trace.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_trace.h
@@ -88,7 +88,7 @@ TRACE_EVENT(i40e_napi_poll,
 		__entry->rx_clean_complete = rx_clean_complete;
 		__entry->tx_clean_complete = tx_clean_complete;
 		__entry->irq_num = q->irq_num;
-		__entry->curr_cpu = get_cpu();
+		__entry->curr_cpu = smp_processor_id();
 		__assign_str(qname);
 		__assign_str(dev_name);
 		__assign_bitmask(irq_affinity, cpumask_bits(&q->affinity_mask),
-- 
2.51.0

