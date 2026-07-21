Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C0537757D;
	Tue, 21 Jul 2026 21:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669715; cv=none; b=qj00mJFHOFYbup8Eib+i1RM1nd/eGv/fvHLHZbbhuNnzL9g0brDZlzFqQ2dGSr/ouEUSGmar+zYpIcewZYtzBqZo9I2XIK7aT+bVi+77U/iUSb9OaDpem/8z74FLCLqOludE+4HEop4MPdvJtHGt+ar4IYIh3aYnMn6KSDysKuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669715; c=relaxed/simple;
	bh=EXeehKe0H743TDKK6/4QX6A8rczhVh9P2AQuiulb3Tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UePxTcxynAeuCJT4DHnUOEi9RgUCBRKDGfBXxgibbpPipyCaNh5z7YGymFoMpz+wO3BOOweONHytAjhgyAryiKM5Rak7ZIErH2nw0N9FQ/1k5C/ABGuR2WPOrI8FYAS9e+gT0hmtYqJRlCQyzVoEMF25VZQNpCulrBKJjV/FFKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iBxXHaQA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iBxXHaQA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9831F000E9;
	Tue, 21 Jul 2026 21:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669714;
	bh=4F6KKisNul1Ljl3LegwoVJeOzHcPxwQrZrYrvn7KCOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iBxXHaQAKjzj4/6SfWBPwtrojAyaqbTOmtUupIR7rTZGWrPHbXapnqzuAuOAGJHdl
	 zuWfUNjj7ZMNmRTPACo3FUYm+V3DjxEfVUgzFz44Qt2DCpNeqFVhQyxusVtbbwrVt7
	 yUHi2jW1bGsbHCbsz01oaTap0qoTSxmUNapI/ANQ=
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
Subject: [PATCH 6.1 0616/1067] ice: fix FDIR CTRL VSI resource leak in ice_reset_all_vfs()
Date: Tue, 21 Jul 2026 17:20:17 +0200
Message-ID: <20260721152438.379113201@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7be59008ea1a51..b1cc6f7a2e62b5 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -506,7 +506,7 @@ void ice_reset_all_vfs(struct ice_pf *pf)
 		 * setup only when VF creates its first FDIR rule.
 		 */
 		if (vf->ctrl_vsi_idx != ICE_NO_VSI)
-			ice_vf_ctrl_invalidate_vsi(vf);
+			ice_vf_ctrl_vsi_release(vf);
 
 		ice_vf_pre_vsi_rebuild(vf);
 		if (ice_vf_rebuild_vsi(vf)) {
-- 
2.53.0



