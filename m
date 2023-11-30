Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB03482CB;
	Thu, 30 Nov 2023 16:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JdC2HZuE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8B7C433C7;
	Thu, 30 Nov 2023 16:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361498;
	bh=q8YEab1jaU7sw/H76vmcmWtmwN4kMCmxz804ReXbZ8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JdC2HZuEhLz0A/QBws37B1Az3AJPbf8iNh3VsgEzJoX+SJ81auHjopRXDFyAVmQbb
	 T3QCTnJ3qHFb5EAJB82tvdGkftBqYR4shh6pJ8UQzSWDbMEB7blmPyUSXNSA2HTGDO
	 l9AzbaS0WGGrFIUsw5GZoVwUPQzEuFOVY5g3UOzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Ivan Vecera <ivecera@redhat.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/112] i40e: Fix adding unsupported cloud filters
Date: Thu, 30 Nov 2023 16:21:33 +0000
Message-ID: <20231130162141.770594090@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit 4e20655e503e3a478cd1682bf25e3202dd823da8 ]

If a VF tries to add unsupported cloud filter through virtchnl
then i40e_add_del_cloud_filter(_big_buf) returns -ENOTSUPP but
this error code is stored in 'ret' instead of 'aq_ret' that
is used as error code sent back to VF. In this scenario where
one of the mentioned functions fails the value of 'aq_ret'
is zero so the VF will incorrectly receive a 'success'.

Use 'aq_ret' to store return value and remove 'ret' local
variable. Additionally fix the issue when filter allocation
fails, in this case no notification is sent back to the VF.

Fixes: e284fc280473 ("i40e: Add and delete cloud filter")
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://lore.kernel.org/r/20231121211338.3348677-1-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/intel/i40e/i40e_virtchnl_pf.c   | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index d3d6415553ed6..4441b00297f47 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -3842,7 +3842,7 @@ static int i40e_vc_add_cloud_filter(struct i40e_vf *vf, u8 *msg)
 	struct i40e_pf *pf = vf->pf;
 	struct i40e_vsi *vsi = NULL;
 	int aq_ret = 0;
-	int i, ret;
+	int i;
 
 	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = -EINVAL;
@@ -3866,8 +3866,10 @@ static int i40e_vc_add_cloud_filter(struct i40e_vf *vf, u8 *msg)
 	}
 
 	cfilter = kzalloc(sizeof(*cfilter), GFP_KERNEL);
-	if (!cfilter)
-		return -ENOMEM;
+	if (!cfilter) {
+		aq_ret = -ENOMEM;
+		goto err_out;
+	}
 
 	/* parse destination mac address */
 	for (i = 0; i < ETH_ALEN; i++)
@@ -3915,13 +3917,13 @@ static int i40e_vc_add_cloud_filter(struct i40e_vf *vf, u8 *msg)
 
 	/* Adding cloud filter programmed as TC filter */
 	if (tcf.dst_port)
-		ret = i40e_add_del_cloud_filter_big_buf(vsi, cfilter, true);
+		aq_ret = i40e_add_del_cloud_filter_big_buf(vsi, cfilter, true);
 	else
-		ret = i40e_add_del_cloud_filter(vsi, cfilter, true);
-	if (ret) {
+		aq_ret = i40e_add_del_cloud_filter(vsi, cfilter, true);
+	if (aq_ret) {
 		dev_err(&pf->pdev->dev,
 			"VF %d: Failed to add cloud filter, err %pe aq_err %s\n",
-			vf->vf_id, ERR_PTR(ret),
+			vf->vf_id, ERR_PTR(aq_ret),
 			i40e_aq_str(&pf->hw, pf->hw.aq.asq_last_status));
 		goto err_free;
 	}
-- 
2.42.0



