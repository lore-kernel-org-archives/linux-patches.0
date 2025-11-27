Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413AC332EA0;
	Thu, 27 Nov 2025 15:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255799; cv=none; b=olt2liydplsbpmnIzdDo60+mCymPOodwtd6KZbSu1PQqQ9T9Xpreh/bEILql+wGIHNbchaCxPVcH1bJbnJ88qxWH2cSfJvzzkqD43jdUWzDLfDwUmJCmkzNIeMajTZqv+DzjqGN1Vs1M3ZaJFLcqEZA+2Qve9IWlETzQem21iy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255799; c=relaxed/simple;
	bh=LOqvnwOXnH2B7GM6SZPcf8yN1FHfDWBOVq4JctB+uJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UTONNRZLxMQ9cWyIlgEdPc36xcqT58q6NyWH0J634zqi/4mQ0fZ3itbzui/0kgMzMb11CNkhxTaBn/8ji2PHNtZ6V95oUAeeecE1T2YA5e+W/sKuQt7fQV0+Ohk1cAIvm0YsqGoDmS40st6Fy+5+b3q17/q3eijJ/NiFm7OMNGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xx9XHzCk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xx9XHzCk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0543C4CEF8;
	Thu, 27 Nov 2025 15:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255799;
	bh=LOqvnwOXnH2B7GM6SZPcf8yN1FHfDWBOVq4JctB+uJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xx9XHzCkBur7Vr4/sB1LhiqfntPigTw1JgWs80GPkcoOgHIHekPcXZI/nz42QbBoN
	 8WLKQngSZ5z0wOLXFmy4Qh1UnV4ezh1KMaHCN9Y6yC0iToTFifgzKRCvcS+vhSbbDG
	 7Tw0QcM6tsxMupIzQsoR/odkHXOctLM7+D5nbl1M=
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
Subject: [PATCH 6.17 118/175] idpf: fix possible vport_config NULL pointer deref in remove
Date: Thu, 27 Nov 2025 15:46:11 +0100
Message-ID: <20251127144047.269081531@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index dfe9126f1f4ab..1088cbbcf9487 100644
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



