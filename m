Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5BBF3DB92
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RLx6IJJX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D82DC433C7;
	Wed, 15 Nov 2023 19:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076856;
	bh=OL3VTPAD0gAsAg2ghrUiIKGu3fbSHMUdLp8JpwtgPKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RLx6IJJXz0rlxCtuxOqRFQsWSXfM2vz18L7jckcxGb7PHVJvCW+KmaOVWbbuFJiv5
	 B1xH+ohLQ6NnmDUX4EC5rRtOe40uKuRPyvterESpyeIDS5FupnRtWCx0ZOPlKe9A9P
	 Xs3vAtwEZk34A/SAJyHs1d4lhsYosz2XNvApbKyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Staikov <andrii.staikov@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/603] i40e: fix potential memory leaks in i40e_remove()
Date: Wed, 15 Nov 2023 14:09:52 -0500
Message-ID: <20231115191616.443776471@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Staikov <andrii.staikov@intel.com>

[ Upstream commit 5ca636d927a106780451d957734f02589b972e2b ]

Instead of freeing memory of a single VSI, make sure
the memory for all VSIs is cleared before releasing VSIs.
Add releasing of their resources in a loop with the iteration
number equal to the number of allocated VSIs.

Fixes: 41c445ff0f48 ("i40e: main driver core")
Signed-off-by: Andrii Staikov <andrii.staikov@intel.com>
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index de7fd43dc11c8..00ca2b88165cb 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -16320,11 +16320,15 @@ static void i40e_remove(struct pci_dev *pdev)
 			i40e_switch_branch_release(pf->veb[i]);
 	}
 
-	/* Now we can shutdown the PF's VSI, just before we kill
+	/* Now we can shutdown the PF's VSIs, just before we kill
 	 * adminq and hmc.
 	 */
-	if (pf->vsi[pf->lan_vsi])
-		i40e_vsi_release(pf->vsi[pf->lan_vsi]);
+	for (i = pf->num_alloc_vsi; i--;)
+		if (pf->vsi[i]) {
+			i40e_vsi_close(pf->vsi[i]);
+			i40e_vsi_release(pf->vsi[i]);
+			pf->vsi[i] = NULL;
+		}
 
 	i40e_cloud_filter_exit(pf);
 
-- 
2.42.0



