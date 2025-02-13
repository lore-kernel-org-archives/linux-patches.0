Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839361946C7;
	Thu, 13 Feb 2025 15:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460407; cv=none; b=Rq5971z1UVS+jbwjmJqs3177KuqnCRlzGpXfCt+WWK4u2ngl9riSvIUUCkpXaOR9uiAYbaAB3EMrnyi/+WB6ZJG4JeBziBYc1O9Pz7iVjler7mtjnZuriLVL2tMykR3V2c8mn/NDvx6aDs5O43dG/e2vxZaj6/YWhbrThkrDHpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460407; c=relaxed/simple;
	bh=1ZeQak/eAiLDVtZ/kCix3cPh6gbju3t8v5DfFmP66eA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eNEIUfsEyGB/7tzQQKEHNhsNSsDLyn/HqeruL4/qPU+qDy/x7fIBRMJ8+/xaaraiHLK1dxLsD3GLPQC2hqjUx8hUiCzhMRZjXFFDLeu+HEfYhty3nQ+9X7z1ooC16Y1suO9QBZgO+bHFh8G17r29cS8tO+MKZnRkViOBr00EtWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bIBqIbjt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bIBqIbjt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F8FC4CED1;
	Thu, 13 Feb 2025 15:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460407;
	bh=1ZeQak/eAiLDVtZ/kCix3cPh6gbju3t8v5DfFmP66eA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bIBqIbjt5vEdISM6nHvFhEoS5bEB4VHKJQSraaQ8rzfKwDFSKmdP8qVyqAd3lbisA
	 fQbwuZc8387sgebM2tUqgoimNpAv3qwyL796s0FGA+B+2YGr/nGY8ev1KzUiJ1drgN
	 ygIR5M+/Y098BkGkqIcNcWXS0M8d9IoDt2l7rC5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <mail@jakemoroni.com>,
	Igor Russkikh <irusskikh@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 072/273] net: atlantic: fix warning during hot unplug
Date: Thu, 13 Feb 2025 15:27:24 +0100
Message-ID: <20250213142410.196423425@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Moroni <mail@jakemoroni.com>

[ Upstream commit 028676bb189ed6d1b550a0fc570a9d695b6acfd3 ]

Firmware deinitialization performs MMIO accesses which are not
necessary if the device has already been removed. In some cases,
these accesses happen via readx_poll_timeout_atomic which ends up
timing out, resulting in a warning at hw_atl2_utils_fw.c:112:

[  104.595913] Call Trace:
[  104.595915]  <TASK>
[  104.595918]  ? show_regs+0x6c/0x80
[  104.595923]  ? __warn+0x8d/0x150
[  104.595925]  ? aq_a2_fw_deinit+0xcf/0xe0 [atlantic]
[  104.595934]  ? report_bug+0x182/0x1b0
[  104.595938]  ? handle_bug+0x6e/0xb0
[  104.595940]  ? exc_invalid_op+0x18/0x80
[  104.595942]  ? asm_exc_invalid_op+0x1b/0x20
[  104.595944]  ? aq_a2_fw_deinit+0xcf/0xe0 [atlantic]
[  104.595952]  ? aq_a2_fw_deinit+0xcf/0xe0 [atlantic]
[  104.595959]  aq_nic_deinit.part.0+0xbd/0xf0 [atlantic]
[  104.595964]  aq_nic_deinit+0x17/0x30 [atlantic]
[  104.595970]  aq_ndev_close+0x2b/0x40 [atlantic]
[  104.595975]  __dev_close_many+0xad/0x160
[  104.595978]  dev_close_many+0x99/0x170
[  104.595979]  unregister_netdevice_many_notify+0x18b/0xb20
[  104.595981]  ? __call_rcu_common+0xcd/0x700
[  104.595984]  unregister_netdevice_queue+0xc6/0x110
[  104.595986]  unregister_netdev+0x1c/0x30
[  104.595988]  aq_pci_remove+0xb1/0xc0 [atlantic]

Fix this by skipping firmware deinitialization altogether if the
PCI device is no longer present.

Tested with an AQC113 attached via Thunderbolt by performing
repeated unplug cycles while traffic was running via iperf.

Fixes: 97bde5c4f909 ("net: ethernet: aquantia: Support for NIC-specific code")
Signed-off-by: Jacob Moroni <mail@jakemoroni.com>
Reviewed-by: Igor Russkikh <irusskikh@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250203143604.24930-3-mail@jakemoroni.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index d6d6d5d37ff3e..c9b0d57696a48 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -1441,7 +1441,9 @@ void aq_nic_deinit(struct aq_nic_s *self, bool link_down)
 	aq_ptp_ring_free(self);
 	aq_ptp_free(self);
 
-	if (likely(self->aq_fw_ops->deinit) && link_down) {
+	/* May be invoked during hot unplug. */
+	if (pci_device_is_present(self->pdev) &&
+	    likely(self->aq_fw_ops->deinit) && link_down) {
 		mutex_lock(&self->fwreq_mutex);
 		self->aq_fw_ops->deinit(self->aq_hw);
 		mutex_unlock(&self->fwreq_mutex);
-- 
2.39.5



