Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC958801;
	Tue, 30 Apr 2024 11:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475423; cv=none; b=idgYq7RMnDD/pmCU0bpZbxFO6pJiHkgEIL4bfarRFdyNz62SGzwU5kwSHi64IX9iWdvzfUpTX3f1kcUqXCedOEOJu+jyo79PSbw7IhpnMHRJxAg7B/KFl11VhvZKZOIsiZeEFWSXoWFchhr/FuNAzwPbsPhLQtG/CkpvgGLSKyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475423; c=relaxed/simple;
	bh=t4CeHmxFjfc44fTGwl9Cil+nVJcw6ajgL1eAJff4ejQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l4NTJ7NYqtqBX/ye9JuuItl7QHQ9F7AKlxaTmF0b20WUh9XORR93CW+CBUAIu/zGfmEszblSD1u/JilifsbHDgkBOY3s6RcWQIXblvEbkrD3MYzaKuuJQLMvYzqle2GF+Sv2vlrQybCZjb6/0fFnQ4nu+qN1nRFTJF9LnZaep1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NDxztt55; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDxztt55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FBA8C2BBFC;
	Tue, 30 Apr 2024 11:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475423;
	bh=t4CeHmxFjfc44fTGwl9Cil+nVJcw6ajgL1eAJff4ejQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NDxztt550J/lk0lC+Ax6CHQomUhtngMC1qWRAggf9bXzCxRjVE2SaljQcq7pD3xEh
	 1DURIoCfIvKNARNLuIgdUHuBURNJPLyTC9nGyQKEqXbtRaXEdCXzyfuPt1VT9/nTQx
	 PRJLq6L/n2svIjno41HAsBxgR3zhEZycuS7I//3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Mineri Bhange <minerix.bhange@intel.com>
Subject: [PATCH 6.6 091/186] iavf: Fix TC config comparison with existing adapter TC config
Date: Tue, 30 Apr 2024 12:39:03 +0200
Message-ID: <20240430103100.674547008@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

From: Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>

[ Upstream commit 54976cf58d6168b8d15cebb395069f23b2f34b31 ]

Same number of TCs doesn't imply that underlying TC configs are
same. The config could be different due to difference in number
of queues in each TC. Add utility function to determine if TC
configs are same.

Fixes: d5b33d024496 ("i40evf: add ndo_setup_tc callback to i40evf")
Signed-off-by: Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
Tested-by: Mineri Bhange <minerix.bhange@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://lore.kernel.org/r/20240423182723.740401-4-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 30 ++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 257865647c865..ce0b919995264 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3574,6 +3574,34 @@ static void iavf_del_all_cloud_filters(struct iavf_adapter *adapter)
 	spin_unlock_bh(&adapter->cloud_filter_list_lock);
 }
 
+/**
+ * iavf_is_tc_config_same - Compare the mqprio TC config with the
+ * TC config already configured on this adapter.
+ * @adapter: board private structure
+ * @mqprio_qopt: TC config received from kernel.
+ *
+ * This function compares the TC config received from the kernel
+ * with the config already configured on the adapter.
+ *
+ * Return: True if configuration is same, false otherwise.
+ **/
+static bool iavf_is_tc_config_same(struct iavf_adapter *adapter,
+				   struct tc_mqprio_qopt *mqprio_qopt)
+{
+	struct virtchnl_channel_info *ch = &adapter->ch_config.ch_info[0];
+	int i;
+
+	if (adapter->num_tc != mqprio_qopt->num_tc)
+		return false;
+
+	for (i = 0; i < adapter->num_tc; i++) {
+		if (ch[i].count != mqprio_qopt->count[i] ||
+		    ch[i].offset != mqprio_qopt->offset[i])
+			return false;
+	}
+	return true;
+}
+
 /**
  * __iavf_setup_tc - configure multiple traffic classes
  * @netdev: network interface device structure
@@ -3631,7 +3659,7 @@ static int __iavf_setup_tc(struct net_device *netdev, void *type_data)
 		if (ret)
 			return ret;
 		/* Return if same TC config is requested */
-		if (adapter->num_tc == num_tc)
+		if (iavf_is_tc_config_same(adapter, &mqprio_qopt->qopt))
 			return 0;
 		adapter->num_tc = num_tc;
 
-- 
2.43.0



