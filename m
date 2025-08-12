Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6562F7461;
	Tue, 12 Aug 2025 17:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020224; cv=none; b=TOqq/FkLbO0PMHAqfJx1hRToFkkzt+PN0V5QGFJQTua58VfAJOhhI39RfvRWxkdsj/PUoM0Un8fCLA5yAAFz9uANg/ltGbv4dJalgf/SAWQnMc/VCnu3QWUH8HeyXUYYxd8XAdo38CSCj2ki/oB1Auc30qA3PSPYGUMuSRiXkGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020224; c=relaxed/simple;
	bh=WzVBrozgtd7aoSZBndOvdHZ/kyypxhEs2opxOl2dS4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DoXvbl/oSoszFrk/XcAggH++YdqLnDWJZ0yvGFp5nC0pCTQGj08e1oiTG2obG3KZI5sWONqknvfQS7PYrlP8CFqxgLaI5ViOlm2wU05wXh66VmIf1R7XWRbV2ad7zel9HfsWtIkrKdQJJqGaPRgaGjYdzquBcpOZAvwqnbbiK1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u9nGJx6Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u9nGJx6Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7D8C4CEF1;
	Tue, 12 Aug 2025 17:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020223;
	bh=WzVBrozgtd7aoSZBndOvdHZ/kyypxhEs2opxOl2dS4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u9nGJx6Zk9quhnD2z+qMZlZQmKLo03LRZCUxMIqkK5TY0DJAvnx65PVq+z7JitiE/
	 pRKSlDHYh47alyyGk4BGAOPTbNBFsxrqSxNPJyYh1BuKS6vDL0cqRoPDZbCsR4JPHA
	 P1UjfeorMVHINuWfKeHotDcyH2+JcXIwCsU1/m2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamie Bainbridge <jamie.bainbridge@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/253] i40e: When removing VF MAC filters, only check PF-set MAC
Date: Tue, 12 Aug 2025 19:26:44 +0200
Message-ID: <20250812172949.399860323@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7f8899a0ae80d..7cfcb16c30911 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -3076,10 +3076,10 @@ static int i40e_vc_del_mac_addr_msg(struct i40e_vf *vf, u8 *msg)
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



