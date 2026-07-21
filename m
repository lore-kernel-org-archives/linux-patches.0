Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63986471439;
	Tue, 21 Jul 2026 19:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662918; cv=none; b=Jm+pNeQYNynT4qpJNFSkxl4iiY3O3gRWVEuI0N43XR0QGgoUiCfi9/CmtkoRtbPM7N4NIkuwSjN9ZXSmIPWG3kSnhRZdM25wrKKS5eJuPJ8trMpKB5jHkuhUDPIrlefuFB4Ix3vapRTGrEiK8N+6jWefpWJ20qVMAWoxEnpw3PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662918; c=relaxed/simple;
	bh=hTNvUjf9C6Htdh4yXMVf/psbIPCZIYZfrkqtrwv43Sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iVfuXpZwegqifg4QemS7gwc1BQiD8YG7jK522ZtQzzkTOGTeXt2lMmPMOhhMNng8AjXniE4MZVSr3tiM5BnAjtYepqahGAjDQjpULZgBpBiP/oF0qyeEatUyE14ONrk8XNOS9kcJMQJvIuuzU06tlgCAWOqXmL1OAgaMzn9+eaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O2zxJMmc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O2zxJMmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD901F000E9;
	Tue, 21 Jul 2026 19:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662917;
	bh=ryV+IPh4q15PZXwanKwhYvC7AMeqqb0JV8yaGsqlkCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O2zxJMmc+pKMKHL0sojg4O98R1ie4xuBlDAfnkupmjJ9j0Pl2zAC8akC8PC/qrdT6
	 UomNUoGRSSrfK2YhXLDblUZhkFoWkg4gmDKgYKQFJKshh2CnOSpT3ctLlyTP0lZTGw
	 1A339vYvPyRwE8MXT2jh8yn3sdYY8jKtYqX8HWfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawid Osuchowski <dawid.osuchowski@linux.intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Simon Horman <horms@kernel.org>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0626/1276] ice: fix FDIR CTRL VSI resource leak in ice_reset_all_vfs()
Date: Tue, 21 Jul 2026 17:17:49 +0200
Message-ID: <20260721152500.117524043@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>

[ Upstream commit ebbe8868cf473f698e0fbaf436d2618b2bcda806 ]

Resetting all VFs causes resource leak on VFs with FDIR filters
enabled as CTRL VSIs are only invalidated and not freed. Fix by using
ice_vf_ctrl_vsi_release() instead of ice_vf_ctrl_invalidate_vsi() which
aligns behavior with the ice_reset_vf() function.

Reproduction:
  echo 1 > /sys/class/net/$pf/device/sriov_numvfs
  ethtool -N $vf flow-type ether proto 0x9000 action 0
  echo 1 > /sys/class/net/$pf/device/reset

Fixes: da62c5ff9dcd ("ice: Add support for per VF ctrl VSI enabling")
Signed-off-by: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_vf_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index 5267b08011fcf8..afa9e7ce463763 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -800,7 +800,7 @@ void ice_reset_all_vfs(struct ice_pf *pf)
 		 * setup only when VF creates its first FDIR rule.
 		 */
 		if (vf->ctrl_vsi_idx != ICE_NO_VSI)
-			ice_vf_ctrl_invalidate_vsi(vf);
+			ice_vf_ctrl_vsi_release(vf);
 
 		ice_vf_pre_vsi_rebuild(vf);
 		if (ice_vf_rebuild_vsi(vf)) {
-- 
2.53.0



