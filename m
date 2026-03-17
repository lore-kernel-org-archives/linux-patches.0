Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBAC30CDA2;
	Tue, 17 Mar 2026 17:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767409; cv=none; b=IDG8rPQlCmDaLKZ8oc+ue/C2a1IT5uq/Ognjl4z/W5LZYtxYsFEUpMN0AAUjerxxwaotfXsNFRDDJlqMN7AC9TeSmRsJcXGu1jB8wdVqwbI2ZpaIcmJ0CNhODJRFSiExvDx0xsdkaT+3aFlhnVHsfv2ZOmXT9/TvSggC9O6DTiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767409; c=relaxed/simple;
	bh=YQl/6XMgB8CdJpYQzzmO2YLdqNJVFoo5LPVHsFbubrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P/UKQATECq+2gR+rIUbRrW6auk7hGeWKE3Ob2KdddjnF5F6fcPeyU9HFFL9aBiQLc4v9UieeI4sTOMG1tMIsd+1V213SWssfi5SGzmu0odnLwVHdgA0yGsxh6WjKgEDhPfHt1Y6PT3SBBG4F+DkevHQ8ANG7ypHuHp+/uy1P5c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dYH49pg1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dYH49pg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6332AC4CEF7;
	Tue, 17 Mar 2026 17:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767408;
	bh=YQl/6XMgB8CdJpYQzzmO2YLdqNJVFoo5LPVHsFbubrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dYH49pg1GrtOtzODJN5ui4oNxeFd4wzHQhBdbp7Dn7J/fZluqioyeZuESyDznJpIZ
	 iE47RXLLFN+GjsRv5sr2JGMtBx56zxDc7zxQVlC7vATHBzwmO7SO9x8O4LXBfH1lBD
	 CPHCiY4PzoLb3Sw12z1Js2eVUGuLqo7w9P6P0nW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <nikolay@nvidia.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.18 081/333] drivers: net: ice: fix devlink parameters get without irdma
Date: Tue, 17 Mar 2026 17:31:50 +0100
Message-ID: <20260317163002.379717978@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Nikolay Aleksandrov <nikolay@nvidia.com>

[ Upstream commit bd98c6204d1195973b1760fe45860863deb6200c ]

If CONFIG_IRDMA isn't enabled but there are ice NICs in the system, the
driver will prevent full devlink dev param show dump because its rdma get
callbacks return ENODEV and stop the dump. For example:
 $ devlink dev param show
 pci/0000:82:00.0:
   name msix_vec_per_pf_max type generic
     values:
       cmode driverinit value 2
   name msix_vec_per_pf_min type generic
     values:
       cmode driverinit value 2
 kernel answers: No such device

Returning EOPNOTSUPP allows the dump to continue so we can see all devices'
devlink parameters.

Fixes: c24a65b6a27c ("iidc/ice/irdma: Update IDC to support multiple consumers")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/devlink/devlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/devlink/devlink.c b/drivers/net/ethernet/intel/ice/devlink/devlink.c
index ac071c5b4ce38..862ff1cdd46d6 100644
--- a/drivers/net/ethernet/intel/ice/devlink/devlink.c
+++ b/drivers/net/ethernet/intel/ice/devlink/devlink.c
@@ -1357,7 +1357,7 @@ ice_devlink_enable_roce_get(struct devlink *devlink, u32 id,
 
 	cdev = pf->cdev_info;
 	if (!cdev)
-		return -ENODEV;
+		return -EOPNOTSUPP;
 
 	ctx->val.vbool = !!(cdev->rdma_protocol & IIDC_RDMA_PROTOCOL_ROCEV2);
 
@@ -1423,7 +1423,7 @@ ice_devlink_enable_iw_get(struct devlink *devlink, u32 id,
 
 	cdev = pf->cdev_info;
 	if (!cdev)
-		return -ENODEV;
+		return -EOPNOTSUPP;
 
 	ctx->val.vbool = !!(cdev->rdma_protocol & IIDC_RDMA_PROTOCOL_IWARP);
 
-- 
2.51.0



