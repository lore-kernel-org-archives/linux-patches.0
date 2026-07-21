Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252FC471252;
	Tue, 21 Jul 2026 19:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661051; cv=none; b=L6rWXcGyQ62VEWi7o563v8s+2Nf8IhJz1WiawhNbPP5shGuaOyT8H7DI74s9iKEsFk2PW3pTNxzg5PtEPUPlf5kt/MRF/ux3F06M2AOMj29kMB3X9biUKLMQ7bCjeLXyiEM8aCSOMUfu7a6u+flNrd+IyF7YUykZYrII31axNBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661051; c=relaxed/simple;
	bh=kHQmCtOfjwXHd7ujpxGm/A/gqbpYwzcj9ZxJSnPhrtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F7nlnwVx8zd38e9AmntrdEPPVhAJLdmjPPnOXewzZTgo5V4eNOeCdFbM5L7cQzj6Iq8QZ8c4v7O68GTPYt1b8iB6s0FJ4j9ewPKUeY8U0AI2782HqnOV9cG515BwlgEGVbR6wdTinq0zgGguHmuMwqngBxwWAG6G8qV+3Y0YGvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ca39WIig; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ca39WIig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858571F000E9;
	Tue, 21 Jul 2026 19:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661050;
	bh=PVhNT681PD7ZrdN+csofKvUPKmBMflfiN5dJaitvHrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ca39WIigTKQi9J5eWu/bxYpAH+P6o0k70aTOg10M/uBhsFo/HRVv4la+b+vgtWIGp
	 jlRd+Pg/jkWg7m9lokGYRMuV05aRrEHzxxoxl2Z4k+Jr3TLUUprRELr4WnZVxJpbBx
	 /NQTNhg7tzQ7/y7rrT/63Gib4uX4X1mqSaDgZTwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhaoJinming <zhaojinming@uniontech.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 7.1 1213/2077] ice: dpll: fix memory leak in ice_dpll_init_info error paths
Date: Tue, 21 Jul 2026 17:14:46 +0200
Message-ID: <20260721152621.426192701@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ZhaoJinming <zhaojinming@uniontech.com>

[ Upstream commit 20da495f2df0fd4adc435d3d621366e8c807539c ]

Several error return paths in ice_dpll_init_info() directly return
without freeing previously allocated resources, causing memory leaks:

- When de->input_prio allocation fails, d->inputs is leaked
- When dp->input_prio allocation fails, d->inputs and de->input_prio
  are leaked
- When ice_get_cgu_rclk_pin_info() fails, all previously allocated
  inputs/outputs/input_prio are leaked
- When ice_dpll_init_pins_info(RCLK_INPUT) fails, same resources
  are leaked

Fix this by jumping to the deinit_info label which properly calls
ice_dpll_deinit_info() to free all allocated resources.

Fixes: d7999f5ea64b ("ice: implement dpll interface to control cgu")
Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_dpll.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dpll.c b/drivers/net/ethernet/intel/ice/ice_dpll.c
index ff5053abb854b6..5f6f29142e3013 100644
--- a/drivers/net/ethernet/intel/ice/ice_dpll.c
+++ b/drivers/net/ethernet/intel/ice/ice_dpll.c
@@ -4347,12 +4347,16 @@ static int ice_dpll_init_info(struct ice_pf *pf, bool cgu)
 
 	alloc_size = sizeof(*de->input_prio) * d->num_inputs;
 	de->input_prio = kzalloc(alloc_size, GFP_KERNEL);
-	if (!de->input_prio)
-		return -ENOMEM;
+	if (!de->input_prio) {
+		ret = -ENOMEM;
+		goto deinit_info;
+	}
 
 	dp->input_prio = kzalloc(alloc_size, GFP_KERNEL);
-	if (!dp->input_prio)
-		return -ENOMEM;
+	if (!dp->input_prio) {
+		ret = -ENOMEM;
+		goto deinit_info;
+	}
 
 	ret = ice_dpll_init_pins_info(pf, ICE_DPLL_PIN_TYPE_INPUT);
 	if (ret)
@@ -4377,12 +4381,12 @@ static int ice_dpll_init_info(struct ice_pf *pf, bool cgu)
 	ret = ice_get_cgu_rclk_pin_info(&pf->hw, &d->base_rclk_idx,
 					&pf->dplls.rclk.num_parents);
 	if (ret)
-		return ret;
+		goto deinit_info;
 	for (i = 0; i < pf->dplls.rclk.num_parents; i++)
 		pf->dplls.rclk.parent_idx[i] = d->base_rclk_idx + i;
 	ret = ice_dpll_init_pins_info(pf, ICE_DPLL_PIN_TYPE_RCLK_INPUT);
 	if (ret)
-		return ret;
+		goto deinit_info;
 	de->mode = DPLL_MODE_AUTOMATIC;
 	dp->mode = DPLL_MODE_AUTOMATIC;
 
-- 
2.53.0



