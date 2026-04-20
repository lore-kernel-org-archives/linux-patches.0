Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4748F33A9C4;
	Mon, 20 Apr 2026 15:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700256; cv=none; b=nruJMWnkrDrb8Z+LXN6gbDVMgh2iPL6MZfblet1Zdrq+bo8PNyqaiVSUdvqRPJElS8X9soFi5wf69tMT2nGuBkF0MSifq3d1twYHnheNDfEZbpg1R1TdKyOn+QFPnGLAaI4vEFCJvkf+4dVDpNd5b5JtOoQh7kBEsvhNwwkkCyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700256; c=relaxed/simple;
	bh=FFJna9kXbl+8LIK7ceqUH1Mu3WTVtKFQyhRgzPSwfFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uCeDrtWuB7aCN5dgjIXJRn4m6MPwJ7FJQszQXjG4Vrj6BTMWLXfT0NYoIYdIHisl7Q0o+8uGg28KopMGmFJCVq3zePvWQcvIrWH9m6dfQBcRj+N5CqRU30/yPBJuiIS7L2kcYabcAOtifj8mg+Ywz4YRcdDaxIF+s3+DQ4pjauM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PJy20/yl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PJy20/yl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1BC6C19425;
	Mon, 20 Apr 2026 15:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700256;
	bh=FFJna9kXbl+8LIK7ceqUH1Mu3WTVtKFQyhRgzPSwfFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PJy20/ylvF9Z8ZaeAAMXekB3bjjsgyIu2S+sg4NdceeUWBSaRvoPRF04ZooZO6Cjt
	 b8FUO46TKmMHqQIUwXaaZTj70tJQoiCeV5UAy7IbZMAt6bTZhKVh7+uDZsuaRg1rHT
	 Kvb5+t0xNPaJixhbmKInGb6vS4ihDUHM0DejKpfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaoqiang Xiong <xxiong@redhat.com>,
	Michal Schmidt <mschmidt@redhat.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 100/220] ixgbevf: add missing negotiate_features op to Hyper-V ops table
Date: Mon, 20 Apr 2026 17:40:41 +0200
Message-ID: <20260420153937.636371495@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

From: Michal Schmidt <mschmidt@redhat.com>

[ Upstream commit 4821d563cd7f251ae728be1a6d04af82a294a5b9 ]

Commit a7075f501bd3 ("ixgbevf: fix mailbox API compatibility by
negotiating supported features") added the .negotiate_features callback
to ixgbe_mac_operations and populated it in ixgbevf_mac_ops, but forgot
to add it to ixgbevf_hv_mac_ops. This leaves the function pointer NULL
on Hyper-V VMs.

During probe, ixgbevf_negotiate_api() calls ixgbevf_set_features(),
which unconditionally dereferences hw->mac.ops.negotiate_features().
On Hyper-V this results in a NULL pointer dereference:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  [...]
  Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine [...]
  Workqueue: events work_for_cpu_fn
  RIP: 0010:0x0
  [...]
  Call Trace:
   ixgbevf_negotiate_api+0x66/0x160 [ixgbevf]
   ixgbevf_sw_init+0xe4/0x1f0 [ixgbevf]
   ixgbevf_probe+0x20f/0x4a0 [ixgbevf]
   local_pci_probe+0x50/0xa0
   work_for_cpu_fn+0x1a/0x30
   [...]

Add ixgbevf_hv_negotiate_features_vf() that returns -EOPNOTSUPP and
wire it into ixgbevf_hv_mac_ops. The caller already handles -EOPNOTSUPP
gracefully.

Fixes: a7075f501bd3 ("ixgbevf: fix mailbox API compatibility by negotiating supported features")
Reported-by: Xiaoqiang Xiong <xxiong@redhat.com>
Closes: https://issues.redhat.com/browse/RHEL-155455
Assisted-by: Claude:claude-4.6-opus-high Cursor
Tested-by: Xiaoqiang Xiong <xxiong@redhat.com>
Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbevf/vf.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/intel/ixgbevf/vf.c b/drivers/net/ethernet/intel/ixgbevf/vf.c
index b67b580f7f1c9..f6df86d124b9e 100644
--- a/drivers/net/ethernet/intel/ixgbevf/vf.c
+++ b/drivers/net/ethernet/intel/ixgbevf/vf.c
@@ -709,6 +709,12 @@ static int ixgbevf_negotiate_features_vf(struct ixgbe_hw *hw, u32 *pf_features)
 	return err;
 }
 
+static int ixgbevf_hv_negotiate_features_vf(struct ixgbe_hw *hw,
+					    u32 *pf_features)
+{
+	return -EOPNOTSUPP;
+}
+
 /**
  *  ixgbevf_set_vfta_vf - Set/Unset VLAN filter table address
  *  @hw: pointer to the HW structure
@@ -1142,6 +1148,7 @@ static const struct ixgbe_mac_operations ixgbevf_hv_mac_ops = {
 	.setup_link		= ixgbevf_setup_mac_link_vf,
 	.check_link		= ixgbevf_hv_check_mac_link_vf,
 	.negotiate_api_version	= ixgbevf_hv_negotiate_api_version_vf,
+	.negotiate_features	= ixgbevf_hv_negotiate_features_vf,
 	.set_rar		= ixgbevf_hv_set_rar_vf,
 	.update_mc_addr_list	= ixgbevf_hv_update_mc_addr_list_vf,
 	.update_xcast_mode	= ixgbevf_hv_update_xcast_mode,
-- 
2.53.0



