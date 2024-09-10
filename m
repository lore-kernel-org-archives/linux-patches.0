Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB68187FF9;
	Tue, 10 Sep 2024 10:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963637; cv=none; b=sr2WSAvLNQrYhmT9ASEgf0xDNX/DDViWxdUqXuUnx0+gNQB/Mf2aps/N0FO63rcdVyEhxd41ufCh9KtoyLyVTyeYH9GP37t+23KXVYoMvgulwfCkVRfpnfNzqt0Bx1VQb9hZn7CcWhVNBHYAvuq0ky4WusCCoGlb9dy/MTV07Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963637; c=relaxed/simple;
	bh=euk6ySpsWDE4NNeY0POJX5A2xgY7qAIxoSXsaBo6PIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eHblR5NXpORyDi1sxdFdZRs5263m3Aw5+mQSyHCeO0Hbk4ZXM45gK2Ocgbga+3gBKYMR2+EGgLOHxw8AJmBcloLX5372k3GaJ9ZZmmKh6LLkh0ZnoMD0z3B0GqQvX9QK384MIrdm6QC5hpAmjVhnMshxeXL37pW/PMMKR+1SdrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qpOSRLxu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qpOSRLxu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664CEC4CEC3;
	Tue, 10 Sep 2024 10:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963637;
	bh=euk6ySpsWDE4NNeY0POJX5A2xgY7qAIxoSXsaBo6PIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qpOSRLxuuCyoC0payKF7xgVyp8/Kb1ykEi02zl9ophiPF5E1xJC83l1lSNEwVZiBA
	 TXMyoTbFiLJZbBaXxd00rPndDNYFzEH9RatxZeRiHgJXmEheazu7N+HkOuiB9kG8nK
	 /+thoLoGtt99WksP4Po3VlxVj28a0hXHCsd2bQXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Chandan Kumar Rout <chandanx.rout@intel.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 126/214] ice: check ICE_VSI_DOWN under rtnl_lock when preparing for reset
Date: Tue, 10 Sep 2024 11:32:28 +0200
Message-ID: <20240910092603.901543995@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larysa Zaremba <larysa.zaremba@intel.com>

[ Upstream commit d8c40b9d3a6cef61eb5a0c58c34a3090ea938d89 ]

Consider the following scenario:

.ndo_bpf()		| ice_prepare_for_reset()		|
________________________|_______________________________________|
rtnl_lock()		|					|
ice_down()		|					|
			| test_bit(ICE_VSI_DOWN) - true		|
			| ice_dis_vsi() returns			|
ice_up()		|					|
			| proceeds to rebuild a running VSI	|

.ndo_bpf() is not the only rtnl-locked callback that toggles the interface
to apply new configuration. Another example is .set_channels().

To avoid the race condition above, act only after reading ICE_VSI_DOWN
under rtnl_lock.

Fixes: 0f9d5027a749 ("ice: Refactor VSI allocation, deletion and rebuild flow")
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com>
Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 8c0ee9a8ff86..8a00864ead7c 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2751,8 +2751,7 @@ int ice_ena_vsi(struct ice_vsi *vsi, bool locked)
  */
 void ice_dis_vsi(struct ice_vsi *vsi, bool locked)
 {
-	if (test_bit(ICE_VSI_DOWN, vsi->state))
-		return;
+	bool already_down = test_bit(ICE_VSI_DOWN, vsi->state);
 
 	set_bit(ICE_VSI_NEEDS_RESTART, vsi->state);
 
@@ -2760,15 +2759,16 @@ void ice_dis_vsi(struct ice_vsi *vsi, bool locked)
 		if (netif_running(vsi->netdev)) {
 			if (!locked)
 				rtnl_lock();
-
-			ice_vsi_close(vsi);
+			already_down = test_bit(ICE_VSI_DOWN, vsi->state);
+			if (!already_down)
+				ice_vsi_close(vsi);
 
 			if (!locked)
 				rtnl_unlock();
-		} else {
+		} else if (!already_down) {
 			ice_vsi_close(vsi);
 		}
-	} else if (vsi->type == ICE_VSI_CTRL) {
+	} else if (vsi->type == ICE_VSI_CTRL && !already_down) {
 		ice_vsi_close(vsi);
 	}
 }
-- 
2.43.0



