Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6718737DE97;
	Tue, 21 Jul 2026 18:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657876; cv=none; b=DHN/XV7HcdDCGljTK1/+86rEZY6jfVIx8Kmik4bX8JEH63qo/U/Xt0Uxznt8njzQ/z1o0bnMNDbKlVNzqNT4FktDjbBOVUlz7LP/HQKYPYdAj1eXKNGQsvKNjUJLvFwxaGbTSPT1P+vurXmPsTOKP5qBokBO1ZbuM/V7/I6/0Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657876; c=relaxed/simple;
	bh=kbWuZHZufrmhF5ZKMJakYwtggplEbSf9D10/hx3d2VQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KYROM4X73nH5xJmPNZo41UHCDEORgKRvBJJ9PAIT+0YEWy/eurso+XW6KLeFAhyYyNdq/W5cFWTd0TUZAW6jGpfuwMC6aoSJks3l/UQVC4JOb8U6lqtRMtCyifMW9OpIPnrqLFhsqqHQ8UNAuOR27WIuxJNjC1ZT2+DLInL/ayc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kd2rLR7P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kd2rLR7P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F76B1F00A3E;
	Tue, 21 Jul 2026 18:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657870;
	bh=nXFvns+41E/6825R33pW617mNqARcnZ3+LGripVyTE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kd2rLR7PsSE5mBq51WF6Lb3nnQdsNd45rYmZJK+IJAN+DWPyHbuXk+CJnjlhEBHrs
	 7RxDbLN9lzkhUNXnYkGYIVjIo4XnE4oUiklbqQ0mnRrx449jptJwdaa2Cu35BXauD6
	 Md8bOLhyvfRPg90inFWAccHdCHhMy8vZuaLYb15M=
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
Subject: [PATCH 6.18 0885/1611] ice: fix FDIR CTRL VSI resource leak in ice_reset_all_vfs()
Date: Tue, 21 Jul 2026 17:16:41 +0200
Message-ID: <20260721152535.297260339@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e53a1e4247cb12..4f86412a9c0c3a 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -801,7 +801,7 @@ void ice_reset_all_vfs(struct ice_pf *pf)
 		 * setup only when VF creates its first FDIR rule.
 		 */
 		if (vf->ctrl_vsi_idx != ICE_NO_VSI)
-			ice_vf_ctrl_invalidate_vsi(vf);
+			ice_vf_ctrl_vsi_release(vf);
 
 		ice_vf_pre_vsi_rebuild(vf);
 		if (ice_vf_rebuild_vsi(vf)) {
-- 
2.53.0



