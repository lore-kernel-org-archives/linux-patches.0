Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8636111C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:20:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0233EC433C8;
	Mon, 28 Aug 2023 10:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218035;
	bh=RU8ST0BJ5dO2vciq63rbULuf2wEXcvwgzwBta/fQBwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=grUt83cCmruZwjPeb7Wv4fImlXUjc+xrb4HOllhk+Owopi+fFHcBF+bkEB0CQanb7
	 4eEpWtBBK72gdOJ/VdxDMFa5jtc6oHYMn0GShVAOKw8+Pv7VwZhAjMQYR62kmSQLRn
	 eT7dqdUbFx3/UIJ12Sh0bXYT3TvnPSNoK5av0gQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Staikov <andrii.staikov@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 042/129] i40e: fix potential NULL pointer dereferencing of pf->vf i40e_sync_vsi_filters()
Date: Mon, 28 Aug 2023 12:12:01 +0200
Message-ID: <20230828101158.771329322@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.383363777@linuxfoundation.org>
References: <20230828101157.383363777@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Staikov <andrii.staikov@intel.com>

[ Upstream commit 9525a3c38accd2e186f52443e35e633e296cc7f5 ]

Add check for pf->vf not being NULL before dereferencing
pf->vf[vsi->vf_id] in updating VSI filter sync.
Add a similar check before dereferencing !pf->vf[vsi->vf_id].trusted
in the condition for clearing promisc mode bit.

Fixes: c87c938f62d8 ("i40e: Add VF VLAN pruning")
Signed-off-by: Andrii Staikov <andrii.staikov@intel.com>
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index b847bd105b16e..5d21cb4ef6301 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -2615,7 +2615,7 @@ int i40e_sync_vsi_filters(struct i40e_vsi *vsi)
 			retval = i40e_correct_mac_vlan_filters
 				(vsi, &tmp_add_list, &tmp_del_list,
 				 vlan_filters);
-		else
+		else if (pf->vf)
 			retval = i40e_correct_vf_mac_vlan_filters
 				(vsi, &tmp_add_list, &tmp_del_list,
 				 vlan_filters, pf->vf[vsi->vf_id].trusted);
@@ -2788,7 +2788,8 @@ int i40e_sync_vsi_filters(struct i40e_vsi *vsi)
 	}
 
 	/* if the VF is not trusted do not do promisc */
-	if ((vsi->type == I40E_VSI_SRIOV) && !pf->vf[vsi->vf_id].trusted) {
+	if (vsi->type == I40E_VSI_SRIOV && pf->vf &&
+	    !pf->vf[vsi->vf_id].trusted) {
 		clear_bit(__I40E_VSI_OVERFLOW_PROMISC, vsi->state);
 		goto out;
 	}
-- 
2.40.1



