Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578EB15E84
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RzKwozFE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFFF1C433C7;
	Mon, 23 Oct 2023 11:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060635;
	bh=8al8DVcCkR0DSPD6IV5QoHM6wA1lpF4myrOQIo6ehXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RzKwozFEeRCozNgmaYRk7A6o+JoMNT822+EMxkt2G6vMymglmMhxOXVMsNabms2tf
	 W+I7rNIplPfQRNZdB6mlsU2gYzEOc1fW3QQloHrhhRRqnoBHeEQr74o4NmriUfvxgr
	 kkEhi7ZHvjmdWTK0udg/KRXM8CLlSzmFPvIRSqCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 015/123] ixgbe: fix crash with empty VF macvlan list
Date: Mon, 23 Oct 2023 12:56:13 +0200
Message-ID: <20231023104818.256801580@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104817.691299567@linuxfoundation.org>
References: <20231023104817.691299567@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 7b5add9af567c44e12196107f0fe106e194034fd ]

The adapter->vf_mvs.l list needs to be initialized even if the list is
empty.  Otherwise it will lead to crashes.

Fixes: a1cbb15c1397 ("ixgbe: Add macvlan support for VF")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Link: https://lore.kernel.org/r/ZSADNdIw8zFx1xw2@kadam
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
index 0e73e3b1af19a..a3b1295415665 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
@@ -28,6 +28,9 @@ static inline void ixgbe_alloc_vf_macvlans(struct ixgbe_adapter *adapter,
 	struct vf_macvlans *mv_list;
 	int num_vf_macvlans, i;
 
+	/* Initialize list of VF macvlans */
+	INIT_LIST_HEAD(&adapter->vf_mvs.l);
+
 	num_vf_macvlans = hw->mac.num_rar_entries -
 			  (IXGBE_MAX_PF_MACVLANS + 1 + num_vfs);
 	if (!num_vf_macvlans)
@@ -36,8 +39,6 @@ static inline void ixgbe_alloc_vf_macvlans(struct ixgbe_adapter *adapter,
 	mv_list = kcalloc(num_vf_macvlans, sizeof(struct vf_macvlans),
 			  GFP_KERNEL);
 	if (mv_list) {
-		/* Initialize list of VF macvlans */
-		INIT_LIST_HEAD(&adapter->vf_mvs.l);
 		for (i = 0; i < num_vf_macvlans; i++) {
 			mv_list[i].vf = -1;
 			mv_list[i].free = true;
-- 
2.40.1



