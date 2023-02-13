Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E1A8F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:54:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA32C433D2;
	Mon, 13 Feb 2023 14:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300044;
	bh=Aa87QOCEVQyGu9ULvRSOCTUeB1XZjsoZhqgUtes0NCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ajzkQPT2hsAX7yXLgrBT/bNxvGQ/NmSoZLeBPLNp7IOfw9xGIvkEBiHyPmclhR/P2
	 +It2SPae7QeeaChQ633ovk5POQt9178Ej1fjW2jNWy0SM7NM3ysjHNbQ+ZrwL3cLQG
	 grQBiKUNPsxCle9ZbOg93X3sy97q5bhPwS45A6kE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 042/114] ice: switch: fix potential memleak in ice_add_adv_recipe()
Date: Mon, 13 Feb 2023 15:47:57 +0100
Message-Id: <20230213144744.314696886@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit 4a606ce68426c88ff2563382b33cc34f3485fe57 ]

When ice_add_special_words() fails, the 'rm' is not released, which will
lead to a memory leak. Fix this up by going to 'err_unroll' label.

Compile tested only.

Fixes: 8b032a55c1bd ("ice: low level support for tunnels")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 9b762f7972ce5..61f844d225123 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -5420,7 +5420,7 @@ ice_add_adv_recipe(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 	 */
 	status = ice_add_special_words(rinfo, lkup_exts, ice_is_dvm_ena(hw));
 	if (status)
-		goto err_free_lkup_exts;
+		goto err_unroll;
 
 	/* Group match words into recipes using preferred recipe grouping
 	 * criteria.
-- 
2.39.0



