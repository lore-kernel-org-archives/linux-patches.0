Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E1F293C4D;
	Wed, 30 Jul 2025 09:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868245; cv=none; b=TopoyBxwJ6YT4wkslO5lRtKd+zLZdpCrDALVdWSDsDGXd5/k7r/7KoGAAs7DhC+t6G929auIRwu3uzzWTDmywe1Dx+PeyrRRHg6YFELiLzGfDc0xUWy2TDi/mdcvh6hLd3hRJ2dJ9t4qleIA037O8m/g7DihecqAZ/b1MaKnLnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868245; c=relaxed/simple;
	bh=4CIh8/t0jIp/8V8vIL7YjgfO+MaKriKzQcILfiWc0bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=foJ/8Rdi2ZpUNB/aJeqe2yMBfy3FMg3Wd7YhqjU19y8Zo5smKaEH2aYxqTX+KmukzupwPldyp5aG+hE+PK7D2CmhcssIGeHX9Twv5b2IExfmuoXjiNPr7HWX0DKGud/QcYVZqOd+IrbjzJlGZbOc8q19ZGRNrOXNjlPX3taboQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S6Os0BHA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S6Os0BHA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 340B6C4CEF8;
	Wed, 30 Jul 2025 09:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868245;
	bh=4CIh8/t0jIp/8V8vIL7YjgfO+MaKriKzQcILfiWc0bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S6Os0BHAxia2qy93Vp3uw4P84KhCvwv0e/oUb0bxDVtsT0S1P71Ubnm/lgd0B7/GK
	 sdivYegHF5hr9fmso3UQZqyyMRkHTX9ZQLcjgpvPcm/ayn8+OXQw3ZDK/4RvYo1Mtz
	 VLBfBgUGlAOrc4JhBUoZnSmh6T7zXUYndti6Bvks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamie Bainbridge <jamie.bainbridge@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 16/76] i40e: When removing VF MAC filters, only check PF-set MAC
Date: Wed, 30 Jul 2025 11:35:09 +0200
Message-ID: <20250730093227.482415813@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
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

From: Jamie Bainbridge <jamie.bainbridge@gmail.com>

[ Upstream commit 5a0df02999dbe838c3feed54b1d59e9445f68b89 ]

When the PF is processing an Admin Queue message to delete a VF's MACs
from the MAC filter, we currently check if the PF set the MAC and if
the VF is trusted.

This results in undesirable behaviour, where if a trusted VF with a
PF-set MAC sets itself down (which sends an AQ message to delete the
VF's MAC filters) then the VF MAC is erased from the interface.

This results in the VF losing its PF-set MAC which should not happen.

There is no need to check for trust at all, because an untrusted VF
cannot change its own MAC. The only check needed is whether the PF set
the MAC. If the PF set the MAC, then don't erase the MAC on link-down.

Resolve this by changing the deletion check only for PF-set MAC.

(the out-of-tree driver has also intentionally removed the check for VF
trust here with OOT driver version 2.26.8, this changes the Linux kernel
driver behaviour and comment to match the OOT driver behaviour)

Fixes: ea2a1cfc3b201 ("i40e: Fix VF MAC filter removal")
Signed-off-by: Jamie Bainbridge <jamie.bainbridge@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index b233ae45d89c2..6d7a4f2c3a49b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -3143,10 +3143,10 @@ static int i40e_vc_del_mac_addr_msg(struct i40e_vf *vf, u8 *msg)
 		const u8 *addr = al->list[i].addr;
 
 		/* Allow to delete VF primary MAC only if it was not set
-		 * administratively by PF or if VF is trusted.
+		 * administratively by PF.
 		 */
 		if (ether_addr_equal(addr, vf->default_lan_addr.addr)) {
-			if (i40e_can_vf_change_mac(vf))
+			if (!vf->pf_set_mac)
 				was_unimac_deleted = true;
 			else
 				continue;
-- 
2.39.5



