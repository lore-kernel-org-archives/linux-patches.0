Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF28330B1F;
	Thu, 27 Nov 2025 14:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255284; cv=none; b=qi+dHI+xEMT9mQd4vqysrona6QvwzYNIV2WpZkGqMJ1ebRqbReCz2f16vqqLr/Ow5jhKQzRuFLcuXz30mOZFATgO2SmVQWmHkjzTypVJ+IqMO/ZFLCFjMaz70Fh29X9dy8E5B6aVC8/seRCgaB1XU76cFvW+nJ5OcfkS3klzL+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255284; c=relaxed/simple;
	bh=uTcDtxkdck1ej0qoWtCRt2E/EzHIlTuTYXwV0SmmFP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RKZ+RJuQiHiVqj3LqftZAnnkZkFHGYqDAF80h93NYpeoxoZU5c6ABgaP4NBszqL9UKS1o6f5kXqtaHPzlU9451Ny28+f2T9dtgc7d+96OD9WlhrZY8U2EcEtr9BXYzuN3esdKVd1A0nCmCtQxu9Oi9f3WF7MS7K8Q0yLC85Djaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ubN69VXr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ubN69VXr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3243C116D0;
	Thu, 27 Nov 2025 14:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255284;
	bh=uTcDtxkdck1ej0qoWtCRt2E/EzHIlTuTYXwV0SmmFP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ubN69VXrQtxL35rFdChn7aNZG66kdaCmNzenT7AXnt/QpFKzx0+O/ZnyQCpdHSilp
	 rzcgGSrA+MS+cxomUsvpnG/9aVtENlTTUFetBkj0o1mR+ZA0AyuZNVI8cuGRRoq84h
	 5d5FZfsFO17Gh7BhoZ/tzAl8OAIqkeu1f/dfTOmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Tantilov <emil.s.tantilov@intel.com>,
	Chittim Madhu <madhu.chittim@intel.com>,
	Simon Horman <horms@kernel.org>,
	Samuel Salin <Samuel.salin@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 072/112] idpf: fix possible vport_config NULL pointer deref in remove
Date: Thu, 27 Nov 2025 15:46:14 +0100
Message-ID: <20251127144035.475843975@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

From: Emil Tantilov <emil.s.tantilov@intel.com>

[ Upstream commit 118082368c2b6ddefe6cb607efc312285148f044 ]

Attempting to remove the driver will cause a crash in cases where
the vport failed to initialize. Following trace is from an instance where
the driver failed during an attempt to create a VF:
[ 1661.543624] idpf 0000:84:00.7: Device HW Reset initiated
[ 1722.923726] idpf 0000:84:00.7: Transaction timed-out (op:1 cookie:2900 vc_op:1 salt:29 timeout:60000ms)
[ 1723.353263] BUG: kernel NULL pointer dereference, address: 0000000000000028
...
[ 1723.358472] RIP: 0010:idpf_remove+0x11c/0x200 [idpf]
...
[ 1723.364973] Call Trace:
[ 1723.365475]  <TASK>
[ 1723.365972]  pci_device_remove+0x42/0xb0
[ 1723.366481]  device_release_driver_internal+0x1a9/0x210
[ 1723.366987]  pci_stop_bus_device+0x6d/0x90
[ 1723.367488]  pci_stop_and_remove_bus_device+0x12/0x20
[ 1723.367971]  pci_iov_remove_virtfn+0xbd/0x120
[ 1723.368309]  sriov_disable+0x34/0xe0
[ 1723.368643]  idpf_sriov_configure+0x58/0x140 [idpf]
[ 1723.368982]  sriov_numvfs_store+0xda/0x1c0

Avoid the NULL pointer dereference by adding NULL pointer check for
vport_config[i], before freeing user_config.q_coalesce.

Fixes: e1e3fec3e34b ("idpf: preserve coalescing settings across resets")
Signed-off-by: Emil Tantilov <emil.s.tantilov@intel.com>
Reviewed-by: Chittim Madhu <madhu.chittim@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_main.c b/drivers/net/ethernet/intel/idpf/idpf_main.c
index 4c48a1a6aab0d..d7a7b0c5f1b8d 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_main.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_main.c
@@ -62,6 +62,8 @@ static void idpf_remove(struct pci_dev *pdev)
 	destroy_workqueue(adapter->vc_event_wq);
 
 	for (i = 0; i < adapter->max_vports; i++) {
+		if (!adapter->vport_config[i])
+			continue;
 		kfree(adapter->vport_config[i]->user_config.q_coalesce);
 		kfree(adapter->vport_config[i]);
 		adapter->vport_config[i] = NULL;
-- 
2.51.0



