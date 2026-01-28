Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175D02D8760;
	Wed, 28 Jan 2026 15:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614898; cv=none; b=LhixgDiF4apW+7OL7fXE90HDr1U80RCrV11gb1ZpVgC0cMQzzstyAoEtaI6bCKL4CpABJgLXHvfVf1qkc4+ttiHndrpFKyAKpBOYcVwJKWYupxZnpURrfBDvCXzggLxocwsdMc6+dhg4JJu1ytG2xsrN6PBBLYpMo1PF5AC/FIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614898; c=relaxed/simple;
	bh=04Olv0aTSh0UKzxMWUMD7+Kya46siArNJ89PTyr54S8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rd5lgCZ3yIf+UTcxp5QQ3Bdg8dJ9gFBfBw8FcAjlIuUBpc3Lsymxm5OUFgR+IJHugdpeT4mupEItWpodD2/O9PIxPMAkwr7X2jVQkvS2VrdyOoZWLAs9oangvBpsSXsjzs0ymAecffUiF7MekZ0tAiy2ZngDqbk85K8hQceIaoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r98708TG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r98708TG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F23C4CEF1;
	Wed, 28 Jan 2026 15:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614897;
	bh=04Olv0aTSh0UKzxMWUMD7+Kya46siArNJ89PTyr54S8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r98708TGRzXerH+he+kxvXRa7x1cJbYXDuAOPIB1YYrLeNhTUVDtE4PUvumJPYlZy
	 9ONSKrENcQOc2bn/2BYn5FHDL00B8PvaHqEGyPAVUy4BRXucCIVatIkYwy9eck1ivX
	 MxBgoJabHo25ZgqqGrymkh35l4BnNRn5MxKMqbsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Marcin Szycik <marcin.szycik@linux.intel.com>,
	Dave Ertman <david.m.ertman@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.12 020/169] ice: Avoid detrimental cleanup for bond during interface stop
Date: Wed, 28 Jan 2026 16:21:43 +0100
Message-ID: <20260128145334.745912103@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

From: Dave Ertman <david.m.ertman@intel.com>

[ Upstream commit a9d45c22ed120cdd15ff56d0a6e4700c46451901 ]

When the user issues an administrative down to an interface that is the
primary for an aggregate bond, the prune lists are being purged. This
breaks communication to the secondary interface, which shares a prune
list on the main switch block while bonded together.

For the primary interface of an aggregate, avoid deleting these prune
lists during stop, and since they are hardcoded to specific values for
the default vlan and QinQ vlans, the attempt to re-add them during the
up phase will quietly fail without any additional problem.

Fixes: 1e0f9881ef79 ("ice: Flesh out implementation of support for SRIOV on bonded interface")
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 25 ++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 8f8bdc3072ccc..4e022de9e4bbd 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3746,22 +3746,31 @@ int ice_vsi_add_vlan_zero(struct ice_vsi *vsi)
 int ice_vsi_del_vlan_zero(struct ice_vsi *vsi)
 {
 	struct ice_vsi_vlan_ops *vlan_ops = ice_get_compat_vsi_vlan_ops(vsi);
+	struct ice_pf *pf = vsi->back;
 	struct ice_vlan vlan;
 	int err;
 
-	vlan = ICE_VLAN(0, 0, 0);
-	err = vlan_ops->del_vlan(vsi, &vlan);
-	if (err && err != -EEXIST)
-		return err;
+	if (pf->lag && pf->lag->primary) {
+		dev_dbg(ice_pf_to_dev(pf), "Interface is primary in aggregate - not deleting prune list\n");
+	} else {
+		vlan = ICE_VLAN(0, 0, 0);
+		err = vlan_ops->del_vlan(vsi, &vlan);
+		if (err && err != -EEXIST)
+			return err;
+	}
 
 	/* in SVM both VLAN 0 filters are identical */
 	if (!ice_is_dvm_ena(&vsi->back->hw))
 		return 0;
 
-	vlan = ICE_VLAN(ETH_P_8021Q, 0, 0);
-	err = vlan_ops->del_vlan(vsi, &vlan);
-	if (err && err != -EEXIST)
-		return err;
+	if (pf->lag && pf->lag->primary) {
+		dev_dbg(ice_pf_to_dev(pf), "Interface is primary in aggregate - not deleting QinQ prune list\n");
+	} else {
+		vlan = ICE_VLAN(ETH_P_8021Q, 0, 0);
+		err = vlan_ops->del_vlan(vsi, &vlan);
+		if (err && err != -EEXIST)
+			return err;
+	}
 
 	/* when deleting the last VLAN filter, make sure to disable the VLAN
 	 * promisc mode so the filter isn't left by accident
-- 
2.51.0



