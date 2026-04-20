Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7763CA493;
	Mon, 20 Apr 2026 13:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691062; cv=none; b=G0FWXme8s2cArReHWbEcvfYs/tOO7faxmsEB/acHiKU803qSjlWJ5g5+DA1Z+8ioJcVSx66zOknrYPhFua2PPFRE5PXVZjpCj4jMDyck0SYT/pOdUX0MM9CbmlDZYy4VhdckmujR/86gYXxw8uG+w5eIaQFLRrWEZBAD3cZu+X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691062; c=relaxed/simple;
	bh=4LhA/ekNF8VXPZGUFStEsaW/fv1Qg6XXQYP6qjgZg58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cHA1d6Cd1odZpgyA7Wutt9yRHiXDhYanT2/cbHJbXyejyXUEhxSCcIPn6WbuiNxxHuTGCb1/oQBL5uVlbwBuHlt67si5390AJLNo5o5vw3nGKpfqssWactTLrKz+6X6Bz3Wvj/BrMWIzwxXdidRNTGpVP1vKl44pK5dUgOSjAn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AgmK4vFk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AgmK4vFk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D991C19425;
	Mon, 20 Apr 2026 13:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691062;
	bh=4LhA/ekNF8VXPZGUFStEsaW/fv1Qg6XXQYP6qjgZg58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AgmK4vFkIFGogVR4TpJXId5vvBMf1kMk3ORgcPC3jF2T/Y1qFjTFF2QCrVFbPxxFR
	 GMjJe/uF4j0uW6aSKQ5DnszLjj+iIYn3ETrH22r+7Sox3HGtCojR2MIA69bniWpOJg
	 JSyCqGyEzUvFVnUXFrLcatoI7788YRbM6o+2nVb2t07vhdSiGd7YlvJnxMIubSyPjZ
	 CsPGMaNNycjWUlc2XTiQDSzYyW+hUObTi3FP69hW8/0JkZMeT+bTe6YyaKP6PX50Qq
	 /y8tYXcPBaTbYImMnA4CbGvVSUb3vrFeeiqb/+0hAKOF7TlkyvLU6ESwI3nD94Rbmy
	 wYJwszyUKyEpQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Michal Schmidt <mschmidt@redhat.com>,
	Xiaoqiang Xiong <xxiong@redhat.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	przemyslaw.kitszel@intel.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	jacob.e.keller@intel.com,
	jedrzej.jagielski@intel.com,
	intel-wired-lan@lists.osuosl.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ixgbevf: add missing negotiate_features op to Hyper-V ops table
Date: Mon, 20 Apr 2026 09:08:57 -0400
Message-ID: <20260420131539.986432-71-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

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

