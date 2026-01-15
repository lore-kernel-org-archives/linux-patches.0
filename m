Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272C3396B75;
	Thu, 15 Jan 2026 16:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496271; cv=none; b=HGWg9Ok/mDXA2R49qxzQ6oXYtL2sHsK9QbDQzx7fXzJrFoqADvl6HO7Q6i8wH5ZuhTbZFFJ6+RF+2mDdoRBRgs0uPhQzrdEnFMfg8n5xPY2l6iCthbFFmoWEbXnIrfoocRcO44Su5EOQ/CSwgrfehAIVKKfzayEdzPR3X0Y7lUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496271; c=relaxed/simple;
	bh=5FxrCWyc3JrtzUCkWvLqSJtQVbsmFPMg29BvGWcoCGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jTUtv1wF2u4L00S6kHhKqQEBCR23pkzdcfgQ+aVEm8hEnpFMvZSHIoSuSSyoXBi3+qBHq/UTo90sIrfAAoVqN4UVAYrASGXeh4xHeMB0mDyhICc81Ua9AK8OntaERbVXVwzncIX93GrdXpUYltdJXDjj60ID99mist3cUvAZ3HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=doJhtmzw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="doJhtmzw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0BAC116D0;
	Thu, 15 Jan 2026 16:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496270;
	bh=5FxrCWyc3JrtzUCkWvLqSJtQVbsmFPMg29BvGWcoCGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=doJhtmzwjbjYb3cyLBsuPRavGJcLzih7rN5dj5/e8YtvPQY50h1rAmZhALj4HoTBD
	 UirDqlf1DOhATKB1DTF7KOrO9NRUSxVjDB0i+LjHYZxxUMK0ymIzRnogxvnXtdbiQE
	 1HPHVrXMqVzJxf7/AQsGMYXcMVHLzU30M7d7utT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Madhu Chittim <madhu.chittim@intel.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Krishneil Singh <krishneil.k.singh@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 136/181] idpf: fix aux device unplugging when rdma is not supported by vport
Date: Thu, 15 Jan 2026 17:47:53 +0100
Message-ID: <20260115164207.229557181@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Larysa Zaremba <larysa.zaremba@intel.com>

[ Upstream commit 4648fb2f2e7210c53b85220ee07d42d1e4bae3f9 ]

If vport flags do not contain VIRTCHNL2_VPORT_ENABLE_RDMA, driver does not
allocate vdev_info for this vport. This leads to kernel NULL pointer
dereference in idpf_idc_vport_dev_down(), which references vdev_info for
every vport regardless.

Check, if vdev_info was ever allocated before unplugging aux device.

Fixes: be91128c579c ("idpf: implement RDMA vport auxiliary dev create, init, and destroy")
Reviewed-by: Madhu Chittim <madhu.chittim@intel.com>
Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Krishneil Singh <krishneil.k.singh@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_idc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_idc.c b/drivers/net/ethernet/intel/idpf/idpf_idc.c
index 7e20a07e98e53..6dad0593f7f22 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_idc.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_idc.c
@@ -322,7 +322,7 @@ static void idpf_idc_vport_dev_down(struct idpf_adapter *adapter)
 	for (i = 0; i < adapter->num_alloc_vports; i++) {
 		struct idpf_vport *vport = adapter->vports[i];
 
-		if (!vport)
+		if (!vport || !vport->vdev_info)
 			continue;
 
 		idpf_unplug_aux_dev(vport->vdev_info->adev);
-- 
2.51.0



