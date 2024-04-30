Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CF712B176;
	Tue, 30 Apr 2024 11:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475010; cv=none; b=slSyQpPD7ZYw5AJegprLMlaZa0hiqFyDwytY0At4NLcmhbyGW1mE3KEooFbfsrr/o53bN24PsUa7QU+sIK6exbp1oyq3kanXC7846V/WzHBWhzsmvHTzMtPP/5dtreldgmO1rJVxqcykvCaXXubMAD41bkYxltaRpvk6z0/EyYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475010; c=relaxed/simple;
	bh=FtXNeBQEry6jOlaQl5vsT6qI9XWPFD3A+K7Owkruiso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DGD60xD18LoarPYN4hEBYSol1v5mqvT7h7uYnRwmVctUC+Zzf5uFnkVMHfl8eZHcjMlwi0k0sgNbBCucOUWRl2LtkIHSjdXJJZt38JMplWASijMhRJFVhTWgzddAV4xSNl/4LyH2o1ey7KINglARBsxjc6hVOGK8FDUn5jcag6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wiLnBazX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wiLnBazX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3FC7C2BBFC;
	Tue, 30 Apr 2024 11:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475010;
	bh=FtXNeBQEry6jOlaQl5vsT6qI9XWPFD3A+K7Owkruiso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wiLnBazXPH71BUMpMgW2vYTGzJoI2W4vYnU3l1WmF5cw83kXZLyiy90fDIZc7sXhf
	 ml+sjTN8zy2yuNSfhYz08kbhmERN40YXcwYgrt32e2gg9eRJsNLCz7AODwNxMEJYos
	 qHiONqFkQtBAdRUKNVzrLUIZOXqB10qSREkyfXRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Mineri Bhange <minerix.bhange@intel.com>
Subject: [PATCH 5.10 104/138] iavf: Fix TC config comparison with existing adapter TC config
Date: Tue, 30 Apr 2024 12:39:49 +0200
Message-ID: <20240430103052.476098770@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b64801bc216bb..65259722a5728 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2642,6 +2642,34 @@ static void iavf_del_all_cloud_filters(struct iavf_adapter *adapter)
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
@@ -2698,7 +2726,7 @@ static int __iavf_setup_tc(struct net_device *netdev, void *type_data)
 		if (ret)
 			return ret;
 		/* Return if same TC config is requested */
-		if (adapter->num_tc == num_tc)
+		if (iavf_is_tc_config_same(adapter, &mqprio_qopt->qopt))
 			return 0;
 		adapter->num_tc = num_tc;
 
-- 
2.43.0



