Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9996118E05
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PG0kb1UL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15D92C433C8;
	Mon,  9 Oct 2023 13:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858264;
	bh=UxvuRHfGbY/uxqtZZrRhTIuvl1zevkGPU9glo6hF0PE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PG0kb1ULp+AbDSn4sufWrujETT1A5G7xIK3A8FOrf5/hSB6Dp3thfwid9Ys3xCBt4
	 6DpWGA1s5s8TP12VokcSrv9KOcmWDmAtwB8otF1l85IUYMiIwn6JazJcTpCpVJfFk5
	 iwCK7XYJDsN7APWfrPwOs+XcGDbKgVcpZB82MRu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Assmann <sassmann@kpanic.de>,
	Konrad Jankowski <konrad0.jankowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.4 067/131] i40e: improve locking of mac_filter_hash
Date: Mon,  9 Oct 2023 15:01:47 +0200
Message-ID: <20231009130118.345051867@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130116.329529591@linuxfoundation.org>
References: <20231009130116.329529591@linuxfoundation.org>
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

From: Stefan Assmann <sassmann@kpanic.de>

[ Upstream commit 8b4b06919fd66caf49fdf4fe59f9d6312cf7956d ]

i40e_config_vf_promiscuous_mode() calls
i40e_getnum_vf_vsi_vlan_filters() without acquiring the
mac_filter_hash_lock spinlock.

This is unsafe because mac_filter_hash may get altered in another thread
while i40e_getnum_vf_vsi_vlan_filters() traverses the hashes.

Simply adding the spinlock in i40e_getnum_vf_vsi_vlan_filters() is not
possible as it already gets called in i40e_get_vlan_list_sync() with the
spinlock held. Therefore adding a wrapper that acquires the spinlock and
call the correct function where appropriate.

Fixes: 37d318d7805f ("i40e: Remove scheduling while atomic possibility")
Fix-suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 23 ++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 1a3017e5f44c1..291ee55b125f8 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1117,12 +1117,12 @@ static int i40e_quiesce_vf_pci(struct i40e_vf *vf)
 }
 
 /**
- * i40e_getnum_vf_vsi_vlan_filters
+ * __i40e_getnum_vf_vsi_vlan_filters
  * @vsi: pointer to the vsi
  *
  * called to get the number of VLANs offloaded on this VF
  **/
-static int i40e_getnum_vf_vsi_vlan_filters(struct i40e_vsi *vsi)
+static int __i40e_getnum_vf_vsi_vlan_filters(struct i40e_vsi *vsi)
 {
 	struct i40e_mac_filter *f;
 	int num_vlans = 0, bkt;
@@ -1135,6 +1135,23 @@ static int i40e_getnum_vf_vsi_vlan_filters(struct i40e_vsi *vsi)
 	return num_vlans;
 }
 
+/**
+ * i40e_getnum_vf_vsi_vlan_filters
+ * @vsi: pointer to the vsi
+ *
+ * wrapper for __i40e_getnum_vf_vsi_vlan_filters() with spinlock held
+ **/
+static int i40e_getnum_vf_vsi_vlan_filters(struct i40e_vsi *vsi)
+{
+	int num_vlans;
+
+	spin_lock_bh(&vsi->mac_filter_hash_lock);
+	num_vlans = __i40e_getnum_vf_vsi_vlan_filters(vsi);
+	spin_unlock_bh(&vsi->mac_filter_hash_lock);
+
+	return num_vlans;
+}
+
 /**
  * i40e_get_vlan_list_sync
  * @vsi: pointer to the VSI
@@ -1152,7 +1169,7 @@ static void i40e_get_vlan_list_sync(struct i40e_vsi *vsi, int *num_vlans,
 	int bkt;
 
 	spin_lock_bh(&vsi->mac_filter_hash_lock);
-	*num_vlans = i40e_getnum_vf_vsi_vlan_filters(vsi);
+	*num_vlans = __i40e_getnum_vf_vsi_vlan_filters(vsi);
 	*vlan_list = kcalloc(*num_vlans, sizeof(**vlan_list), GFP_ATOMIC);
 	if (!(*vlan_list))
 		goto err;
-- 
2.40.1



