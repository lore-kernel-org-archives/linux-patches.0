Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35252192F2;
	Tue,  8 Apr 2025 11:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112361; cv=none; b=PUWlbYGMt7VOMRqBt39G+nsUvJjvscjW3/xoQDyp84qI8IAUBMTIYkvI16zimUM2SvUEBJBXoJhS+khjYSmgCs3wilmPu9MJv9aW1NHiIq41fe9fcXNfjVQ8BiMPg8d/q6FgPRiRGEA/PAN8cyplyT0IlWrjE3LCzjVbs3fd4QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112361; c=relaxed/simple;
	bh=nRsw594Jnj8aWvQKvjluYBOfoWKSyPdvbewOGc/ULls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqS6fXc1cYYeM/oNa/lNRvZLqNGtG5FH0ikvsYLfNpO614bJ4Pq/wQfc/ycMK31jiXfZadgqFe2tyAkiI9j+Degs75+NSboFys47ndueSTutqKyv7RN/MgPFZ2NE0X0dLdUw+Cj3tSVF8zZk1wDAR9YMtPf0WICwzBCwphgEjQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E7lDN6jO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E7lDN6jO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6614CC4CEE5;
	Tue,  8 Apr 2025 11:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112361;
	bh=nRsw594Jnj8aWvQKvjluYBOfoWKSyPdvbewOGc/ULls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E7lDN6jOUxdHCP9k9ZmX4Me7OX7csw0XuUBBW3JFOyAF9Tozlp6XUbPzVUBAg5M/d
	 vqDb89xYxS1iGxuG9s5mnXDC9wQk8yHFR5Ct06XjywJ/gHEuEMF0i07yT2K9kLFgWS
	 yZsyp/Ijxns7/VIlc0KNvLS+I7kakgUj4kGQddxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Grzegorz Nitka <grzegorz.nitka@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 5.15 008/279] ice: fix memory leak in aRFS after reset
Date: Tue,  8 Apr 2025 12:46:31 +0200
Message-ID: <20250408104826.587685625@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Grzegorz Nitka <grzegorz.nitka@intel.com>

[ Upstream commit 23d97f18901ef5e4e264e3b1777fe65c760186b5 ]

Fix aRFS (accelerated Receive Flow Steering) structures memory leak by
adding a checker to verify if aRFS memory is already allocated while
configuring VSI. aRFS objects are allocated in two cases:
- as part of VSI initialization (at probe), and
- as part of reset handling

However, VSI reconfiguration executed during reset involves memory
allocation one more time, without prior releasing already allocated
resources. This led to the memory leak with the following signature:

[root@os-delivery ~]# cat /sys/kernel/debug/kmemleak
unreferenced object 0xff3c1ca7252e6000 (size 8192):
  comm "kworker/0:0", pid 8, jiffies 4296833052
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 0):
    [<ffffffff991ec485>] __kmalloc_cache_noprof+0x275/0x340
    [<ffffffffc0a6e06a>] ice_init_arfs+0x3a/0xe0 [ice]
    [<ffffffffc09f1027>] ice_vsi_cfg_def+0x607/0x850 [ice]
    [<ffffffffc09f244b>] ice_vsi_setup+0x5b/0x130 [ice]
    [<ffffffffc09c2131>] ice_init+0x1c1/0x460 [ice]
    [<ffffffffc09c64af>] ice_probe+0x2af/0x520 [ice]
    [<ffffffff994fbcd3>] local_pci_probe+0x43/0xa0
    [<ffffffff98f07103>] work_for_cpu_fn+0x13/0x20
    [<ffffffff98f0b6d9>] process_one_work+0x179/0x390
    [<ffffffff98f0c1e9>] worker_thread+0x239/0x340
    [<ffffffff98f14abc>] kthread+0xcc/0x100
    [<ffffffff98e45a6d>] ret_from_fork+0x2d/0x50
    [<ffffffff98e083ba>] ret_from_fork_asm+0x1a/0x30
    ...

Fixes: 28bf26724fdb ("ice: Implement aRFS")
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Grzegorz Nitka <grzegorz.nitka@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_arfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_arfs.c b/drivers/net/ethernet/intel/ice/ice_arfs.c
index 88d98c9e5f914..9cebae92364eb 100644
--- a/drivers/net/ethernet/intel/ice/ice_arfs.c
+++ b/drivers/net/ethernet/intel/ice/ice_arfs.c
@@ -510,7 +510,7 @@ void ice_init_arfs(struct ice_vsi *vsi)
 	struct hlist_head *arfs_fltr_list;
 	unsigned int i;
 
-	if (!vsi || vsi->type != ICE_VSI_PF)
+	if (!vsi || vsi->type != ICE_VSI_PF || ice_is_arfs_active(vsi))
 		return;
 
 	arfs_fltr_list = kzalloc(sizeof(*arfs_fltr_list) * ICE_MAX_ARFS_LIST,
-- 
2.39.5



