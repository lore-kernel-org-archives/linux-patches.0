Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE97419D084;
	Mon, 23 Jun 2025 21:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714838; cv=none; b=qdpBWnlcZrEQRg44yF6f9tpZHCDBpWRZB27nYPPp1AAJubWPvph28q14xHcy2ZFQSbqvjxkF8+mPZEQOIQmWJ2h9AyT7DYjn2Shl7oSfMNb/QUqcqihij+DHOsqkJYSfN2DOvqCCZBYBSD2sk85YCJWd7kuU5RP90Dowd8be9nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714838; c=relaxed/simple;
	bh=gqPQtsQn9g5neX26umufQZQqR+eqwj+TZFz/F91mFuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qJHbTd6NXFWuEqUjPGkPPMQal/uMPIapioNytRuVS6kQjugwbNfZ/ilHARW/Sq60BlSWP0Pa+w4ujIeXNgeYLb6WO9RVCoy45YwhVgGtx5ciy+Tn7AcgHgWom1a8FiFgM0wZqsbOAdFYgrMJdSbVCEm98f/8o7lubLjIPN4FXwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CiinTHi8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CiinTHi8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E9CC4CEEA;
	Mon, 23 Jun 2025 21:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714838;
	bh=gqPQtsQn9g5neX26umufQZQqR+eqwj+TZFz/F91mFuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CiinTHi8AkQ8tjRaP6fnUVVWyWvb6zWGSqoMIvbX4XfOH5/erxZCadYDur8n88sbi
	 exVPRZ46GPnc/blNq7TAm40S4MWwklW1vA6/ultoh0OVgI81RH4Y/RXBo/fROkTdiC
	 vgwEK1MQhWwwm7hadW49g/IxtFKS3CViogk0Bmws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Pacuszka <mateuszx.pacuszka@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Simon Horman <horms@kernel.org>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 184/290] ice: fix check for existing switch rule
Date: Mon, 23 Jun 2025 15:07:25 +0200
Message-ID: <20250623130632.409257442@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mateusz Pacuszka <mateuszx.pacuszka@intel.com>

[ Upstream commit a808691df39b52cd9db861b118e88e18b63e2299 ]

In case the rule already exists and another VSI wants to subscribe to it
new VSI list is being created and both VSIs are moved to it.
Currently, the check for already existing VSI with the same rule is done
based on fdw_id.hw_vsi_id, which applies only to LOOKUP_RX flag.
Change it to vsi_handle. This is software VSI ID, but it can be applied
here, because vsi_map itself is also based on it.

Additionally change return status in case the VSI already exists in the
VSI map to "Already exists". Such case should be handled by the caller.

Signed-off-by: Mateusz Pacuszka <mateuszx.pacuszka@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 19f730a68fa21..ac004ef1d724d 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -3024,7 +3024,7 @@ ice_add_update_vsi_list(struct ice_hw *hw,
 		u16 vsi_handle_arr[2];
 
 		/* A rule already exists with the new VSI being added */
-		if (cur_fltr->fwd_id.hw_vsi_id == new_fltr->fwd_id.hw_vsi_id)
+		if (cur_fltr->vsi_handle == new_fltr->vsi_handle)
 			return -EEXIST;
 
 		vsi_handle_arr[0] = cur_fltr->vsi_handle;
@@ -5991,7 +5991,7 @@ ice_adv_add_update_vsi_list(struct ice_hw *hw,
 
 		/* A rule already exists with the new VSI being added */
 		if (test_bit(vsi_handle, m_entry->vsi_list_info->vsi_map))
-			return 0;
+			return -EEXIST;
 
 		/* Update the previously created VSI list set with
 		 * the new VSI ID passed in
-- 
2.39.5



