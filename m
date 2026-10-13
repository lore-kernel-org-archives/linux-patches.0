Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703764EDCB8;
	Tue, 13 Oct 2026 12:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893532; cv=none; b=hcTjxaUcx10UrcPHzNp3PfFuNHU3PBnTeOWdKtxTts0J2vRhkSZ5KjJBWUTWFMLXNksHY2VjzRICHL3tH0R4dgfH0/baSRQmFmwkeUo3fvxnv8CizMp5REg7EUBJrSp8w9SclieEqRPnJTRVjsmBVY5FLEKpfclOF3b5Aueztew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893532; c=relaxed/simple;
	bh=FIUvNVf5foWo1Rkahr+0kNrcW4hNQFwEGEwOfpofW20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NfJ53RH9hCmY5+Yv3RhaoNEGBmkPEPzjo3yf7FjcZdbq3BC/00UT07XEXnx/72CaJvBqdyuotmoah/aw/KebA3A6lmveShEF9zBY22cKcV7AJ5TobfB3x1vDZckZag3Iy4U0g9DEWEljpgSNEW1zMiiurAOwELZc9/fQfNw7c40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WoAG6sCz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WoAG6sCz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3031F000FF;
	Tue, 13 Oct 2026 12:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893531;
	bh=7w7LJwp3qvqonh50lmWaURcSMFlWjCPZIQJF04pvcQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WoAG6sCz/5GTUkgAowpBiDsDxfeXTIHpllJNwpEnzIaHIen2uCLp6+UcinLUEDtyo
	 jtKHZoDjKS+L/LWQmT4o1BiHFrVFqhMagEBkmcKUQAE/W1wWMJW3rPUrI+J4aE6zul
	 ExY8F/We/gi5qWwqSczhMjhN5z+6j9IvPx++azHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Madhu Chittim <madhu.chittim@intel.com>,
	Emil Tantilov <emil.s.tantilov@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Simon Horman <horms@kernel.org>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 258/621] idpf: fix max_vport related crash on allocation error during init
Date: Tue, 13 Oct 2026 13:34:13 +0200
Message-ID: <20261013112926.984991305@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Emil Tantilov <emil.s.tantilov@intel.com>

[ Upstream commit 237f1f7653b8729169af11fae79f01b90d00b87e ]

Set adapter->max_vports only after successful allocation of vports, netdevs
and  vport_config buffers. This fixes possible crashes on reset or rmmod,
following failed allocation on init

[  305.981402] idpf 0000:83:00.0: enabling device (0100 -> 0102)
[  305.994464] idpf 0000:83:00.0: Device HW Reset initiated
[  320.416872] BUG: kernel NULL pointer dereference, address: 0000000000000000
[  320.416918] #PF: supervisor read access in kernel mode
[  320.416942] #PF: error_code(0x0000) - not-present page
[  320.416963] PGD 2099657067 P4D 0
[  320.416983] Oops: Oops: 0000 [#1] SMP NOPTI
...
[  320.417093] RIP: 0010:idpf_remove+0x118/0x200 [idpf]
[  320.417130] Code: 8b bb 98 09 00 00 e8 17 0f 5b e5 48 8b bb e8 08 00 00 e8 0b 0f 5b e5 66 83 bb 28 06 00 00 00 48 8b bb 20 06 00 00 74 49 31 ed <48> 8b 04 ef 48 85 c0 74 2f 48 8b 78 20 e8 66 58 91 e5 48 8b 83 20
[  320.417183] RSP: 0018:ff7322212903fdb8 EFLAGS: 00010246
[  320.417205] RAX: 0000000000000000 RBX: ff4463de40300000 RCX: ff7322212903fd4c
[  320.417228] RDX: 0000000000000001 RSI: ffffffffa7f7d100 RDI: 0000000000000000
[  320.417250] RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
[  320.417272] R10: 0000000000000001 R11: ff4463de3a638f58 R12: ff4463be89ac7000
[  320.417294] R13: ff4463be89ac7198 R14: ff4463be94fc7198 R15: ffffffffc0f10f20
[  320.417317] FS:  00007f963c0e6740(0000) GS:ff4463fdd65d8000(0000) knlGS:0000000000000000
[  320.417342] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  320.417362] CR2: 0000000000000000 CR3: 00000020ba674002 CR4: 0000000000773ef0
[  320.417385] PKRU: 55555554
[  320.417398] Call Trace:
[  320.417412]  <TASK>
[  320.417429]  pci_device_remove+0x42/0xb0
[  320.417459]  device_release_driver_internal+0x1a9/0x210
[  320.417492]  driver_detach+0x4b/0x90
[  320.417516]  bus_remove_driver+0x70/0x100
[  320.417539]  pci_unregister_driver+0x2e/0xb0
[  320.417564]  __do_sys_delete_module.constprop.0+0x190/0x2f0
[  320.417592]  ? kmem_cache_free+0x31e/0x550
[  320.417619]  ? lockdep_hardirqs_on_prepare+0xde/0x190
[  320.417644]  ? do_syscall_64+0x38/0x6b0
[  320.417665]  do_syscall_64+0xc8/0x6b0
[  320.417683]  ? clear_bhb_loop+0x30/0x80
[  320.417706]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  320.417727] RIP: 0033:0x7f963bb30beb

Fixes: 0fe45467a104 ("idpf: add create vport and netdev configuration")
Reviewed-by: Madhu Chittim <madhu.chittim@intel.com>
Signed-off-by: Emil Tantilov <emil.s.tantilov@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20260717185340.3595286-13-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
index 963ffb1b62cc2..5b22779f4dfac 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
@@ -3496,7 +3496,6 @@ int idpf_vc_core_init(struct idpf_adapter *adapter)
 
 	pci_sriov_set_totalvfs(adapter->pdev, idpf_get_max_vfs(adapter));
 	num_max_vports = idpf_get_max_vports(adapter);
-	adapter->max_vports = num_max_vports;
 	adapter->vports = kcalloc(num_max_vports, sizeof(*adapter->vports),
 				  GFP_KERNEL);
 	if (!adapter->vports)
@@ -3519,6 +3518,12 @@ int idpf_vc_core_init(struct idpf_adapter *adapter)
 		goto err_netdev_alloc;
 	}
 
+	/* Set max_vports only after vports, netdevs and vport_config buffers
+	 * are allocated to make sure max_vport bound loops don't end up
+	 * crashing, following allocation errors on init.
+	 */
+	adapter->max_vports = num_max_vports;
+
 	/* Start the mailbox task before requesting vectors. This will ensure
 	 * vector information response from mailbox is handled
 	 */
-- 
2.53.0



