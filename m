Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B000B27ECC
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rZW35uch"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3345C433C9;
	Mon, 16 Oct 2023 14:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697467724;
	bh=zUXHQOzCE0VzgbsN/gcqdeD1tw02PV0JSOqipHxttU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rZW35uchWbHSd8PAUY/j5lL5eWMUCbkfpsiDDXPCoMBiRJD31S17rFYsATdlRqtvn
	 REk+zbxl/hZUx8lBWnHsolQXzW0AMGqmigU1fyonmaL5/GAjwEM5fz5GY+XCnueEAZ
	 3x1iYbNMg4TNzxawiiUTwHM6yK4j6DhvR3BDnKzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 076/191] ixgbe: fix crash with empty VF macvlan list
Date: Mon, 16 Oct 2023 10:41:01 +0200
Message-ID: <20231016084017.179684208@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
index 29cc609880712..ea88ac04ab9ad 100644
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



