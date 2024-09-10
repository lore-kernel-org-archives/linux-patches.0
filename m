Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21BC514D431;
	Tue, 10 Sep 2024 09:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961776; cv=none; b=E8UUPQKV8/8iYJlb69XTW0QxtCNZ+0xSDAoegAtBup4TN58t6MEHuz6CMBoNeIHdGnwCXnlNrYZEenADMbFVwEYqdobHKpj1kHPGvK0mNy5Pq2BZDunae2OF0UisXwbuxw5OQjSF36ZO8GcRDdyPGCaZXrOsKA7NgrgJMVYLdf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961776; c=relaxed/simple;
	bh=mIUvPkmJKkbqdW4YahusDiTAzy6xW6UdKZZa9QcFOsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e8GxGmf7JbzS+h8N6MJnC/C+5+l4S39BoGV8uHH+qt4V9+FXF0uBqijS6upbvuNVhP8thyyEtCiEO+PoJ6sVsJ9kpygl+RYU6zWt/aB7ppSzLX+gh7OHR3tcZKqd9Mq5wjOgc94hjCBD1DhPo6h48X3Dh2BxHfKjMDx+7B9PNU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IBMPmBKn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IBMPmBKn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D714C4CEC3;
	Tue, 10 Sep 2024 09:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961776;
	bh=mIUvPkmJKkbqdW4YahusDiTAzy6xW6UdKZZa9QcFOsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IBMPmBKnQsexf7YgPsxNGQ6j0FsQBwoQrKyfc5XOSEMFOxyTIkdZcyeZJ0X5I1QW/
	 tRsCKffNLGh6tfE95RzxnZd4FnHFsVmGlMBVst43ZtmllD0Dqoc8y3vPS9XlzJ5PqD
	 L3j5Ji66a8tHEPoNhYptw9OXSN+oODkQU6Za0hbU=
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
Subject: [PATCH 6.10 184/375] ice: check ICE_VSI_DOWN under rtnl_lock when preparing for reset
Date: Tue, 10 Sep 2024 11:29:41 +0200
Message-ID: <20240910092628.669867206@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3e772c014ae3..7076a7738864 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2672,8 +2672,7 @@ int ice_ena_vsi(struct ice_vsi *vsi, bool locked)
  */
 void ice_dis_vsi(struct ice_vsi *vsi, bool locked)
 {
-	if (test_bit(ICE_VSI_DOWN, vsi->state))
-		return;
+	bool already_down = test_bit(ICE_VSI_DOWN, vsi->state);
 
 	set_bit(ICE_VSI_NEEDS_RESTART, vsi->state);
 
@@ -2681,15 +2680,16 @@ void ice_dis_vsi(struct ice_vsi *vsi, bool locked)
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



