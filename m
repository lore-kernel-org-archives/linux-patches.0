Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9957E3EE1D8;
	Tue, 17 Mar 2026 16:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765764; cv=none; b=aF98xasAPXF179MeASI98+V0O3GvMi20Cwn3mS54i4m5xwqemRNYvWAUQgW7r2k+YZn7wcvSxaYH+mbs8ILVdfIs45XNCFouFIQveY4knKu2lmf49ISObubKJZDxZJEx2509YgVtVSWerMEjdYczPW2xDGqrphFh1iLmQ17Nhlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765764; c=relaxed/simple;
	bh=jfaIziGwpZjobJtpeXrbP2Xb6VNi0N/qM9/wpf6vzcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JyNv8lPUqNETWz1UA82xczwnuyBxeeLECuOS8xQTaXviy3Y9HMRkMd0wsyWgZ2AY9+VXjjnuGaf71JkpEYqjCdNfCuz6el/lQ32By3QssTrLXS2gnxqrJJbmrLw/yJufzPIBPmXSrpjPgBUkxw/Fm6Ti85289zqAtQHwZ9S3kU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UNy979Qz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UNy979Qz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4892C4CEF7;
	Tue, 17 Mar 2026 16:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765764;
	bh=jfaIziGwpZjobJtpeXrbP2Xb6VNi0N/qM9/wpf6vzcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UNy979Qz+FWlNuUA9+bE/6lA7vJjWpnqnltgG6s2f2A4CVeHlLvh1MaYaf/t9nFFb
	 aX3UQOZdH54qeI3cO2Foj4BTs4yicGY1A0sTSZpZ2HueexTdrDEa4YQlhTkwsE+mky
	 J24kAos49uwDiKeUHQnF8YirWiHzSyhpx6DbbZI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <nikolay@nvidia.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.19 088/378] drivers: net: ice: fix devlink parameters get without irdma
Date: Tue, 17 Mar 2026 17:30:45 +0100
Message-ID: <20260317163010.252760925@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 2ef39cc70c21d..7de749d3f0479 100644
--- a/drivers/net/ethernet/intel/ice/devlink/devlink.c
+++ b/drivers/net/ethernet/intel/ice/devlink/devlink.c
@@ -1360,7 +1360,7 @@ ice_devlink_enable_roce_get(struct devlink *devlink, u32 id,
 
 	cdev = pf->cdev_info;
 	if (!cdev)
-		return -ENODEV;
+		return -EOPNOTSUPP;
 
 	ctx->val.vbool = !!(cdev->rdma_protocol & IIDC_RDMA_PROTOCOL_ROCEV2);
 
@@ -1427,7 +1427,7 @@ ice_devlink_enable_iw_get(struct devlink *devlink, u32 id,
 
 	cdev = pf->cdev_info;
 	if (!cdev)
-		return -ENODEV;
+		return -EOPNOTSUPP;
 
 	ctx->val.vbool = !!(cdev->rdma_protocol & IIDC_RDMA_PROTOCOL_IWARP);
 
-- 
2.51.0



