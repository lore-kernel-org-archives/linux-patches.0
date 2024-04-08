Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B3485631;
	Mon,  8 Apr 2024 13:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582702; cv=none; b=Yh1c8gBdMn5OJZ872juHokmJ3ko/SjvHMnDC1IQkypDstKpjKVPJPcrFY328hvosRjJ59Y12MpUOfl527S3sdDgcjaPE1XDbxt+eBSds9NS9ZAk+fIkOBdukJIG41Qtm4HW+WMP3Q8N1ZH5ZWkD1vj0R/Z/NkgMxH5gqsJ5hYYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582702; c=relaxed/simple;
	bh=UASRQWEEHny6bZL1oAcOqbpCEpWsk2ys30o5Wzh7PJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FDZdjld7E7eghS7GVGZdJZ9jmJxN7n79S3mNVTYSLZaPn18g07q4JJiLiURqqVh9L+EHpW7Ki7MFjTze8RWN6jNYv5AdeiDmOIGyQZPjisiRw1EnmHeKjRdJXeUR+Qq7f1pAvVZZvk40LfBgFZJL/48hE5fl8Y8mt08HWLBlDjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ToOte288; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ToOte288"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E75C433F1;
	Mon,  8 Apr 2024 13:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582702;
	bh=UASRQWEEHny6bZL1oAcOqbpCEpWsk2ys30o5Wzh7PJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ToOte288v1jqgt7y7Zwx0gtpwwrdGYucUCKofc3dCMcZzGU9m8kNyXVzeeu5RG58l
	 bzMDQJOohHUtqfSaFYQVaUNH+rjve3f6uMcN2a0yuxpTHHjF+BOlgB+ZFBcW4vrkCA
	 +NJdwnM+7jkT0SVyT7WyDmYWh4lclPS0sw2pGj1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Oros <poros@redhat.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.6 114/252] ice: fix enabling RX VLAN filtering
Date: Mon,  8 Apr 2024 14:56:53 +0200
Message-ID: <20240408125310.173745693@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

From: Petr Oros <poros@redhat.com>

commit 8edfc7a40e3300fc6c5fa7a3228a24d5bcd86ba5 upstream.

ice_port_vlan_on/off() was introduced in commit 2946204b3fa8 ("ice:
implement bridge port vlan"). But ice_port_vlan_on() incorrectly assigns
ena_rx_filtering to inner_vlan_ops in DVM mode.
This causes an error when rx_filtering cannot be enabled in legacy mode.

Reproducer:
 echo 1 > /sys/class/net/$PF/device/sriov_numvfs
 ip link set $PF vf 0 spoofchk off trust on vlan 3
dmesg:
 ice 0000:41:00.0: failed to enable Rx VLAN filtering for VF 0 VSI 9 during VF rebuild, error -95

Fixes: 2946204b3fa8 ("ice: implement bridge port vlan")
Signed-off-by: Petr Oros <poros@redhat.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../ethernet/intel/ice/ice_vf_vsi_vlan_ops.c   | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c b/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c
index 80dc4bcdd3a4..b3e1bdcb80f8 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c
@@ -26,24 +26,22 @@ static void ice_port_vlan_on(struct ice_vsi *vsi)
 	struct ice_vsi_vlan_ops *vlan_ops;
 	struct ice_pf *pf = vsi->back;
 
+	/* setup inner VLAN ops */
+	vlan_ops = &vsi->inner_vlan_ops;
+
 	if (ice_is_dvm_ena(&pf->hw)) {
-		vlan_ops = &vsi->outer_vlan_ops;
-
-		/* setup outer VLAN ops */
-		vlan_ops->set_port_vlan = ice_vsi_set_outer_port_vlan;
-		vlan_ops->clear_port_vlan = ice_vsi_clear_outer_port_vlan;
-
-		/* setup inner VLAN ops */
-		vlan_ops = &vsi->inner_vlan_ops;
 		vlan_ops->add_vlan = noop_vlan_arg;
 		vlan_ops->del_vlan = noop_vlan_arg;
 		vlan_ops->ena_stripping = ice_vsi_ena_inner_stripping;
 		vlan_ops->dis_stripping = ice_vsi_dis_inner_stripping;
 		vlan_ops->ena_insertion = ice_vsi_ena_inner_insertion;
 		vlan_ops->dis_insertion = ice_vsi_dis_inner_insertion;
-	} else {
-		vlan_ops = &vsi->inner_vlan_ops;
 
+		/* setup outer VLAN ops */
+		vlan_ops = &vsi->outer_vlan_ops;
+		vlan_ops->set_port_vlan = ice_vsi_set_outer_port_vlan;
+		vlan_ops->clear_port_vlan = ice_vsi_clear_outer_port_vlan;
+	} else {
 		vlan_ops->set_port_vlan = ice_vsi_set_inner_port_vlan;
 		vlan_ops->clear_port_vlan = ice_vsi_clear_inner_port_vlan;
 	}
-- 
2.44.0



