Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FFC225DD08;
	Tue, 11 Mar 2025 15:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706756; cv=none; b=ReZGNO/nmwvMS+RBJ6ZROSQjSrLTFdVxFrgIRRHb1G3fg6V7gqyknmEntLkTj2ofu25gNZS4Kp9okA8iAtTm+PfINWMpEcNwLlM822d7CLfxPm64IXnqt0tun3qZggwQxa+KsbDT/TmDN6lt73fKTVWya56Xgv/BFTdkckFRFR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706756; c=relaxed/simple;
	bh=gEAUum8UlgNk8lwxb10X6EEv5N4cTGb9c2I1WCfTiro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SN+azObZOokGyK1hli6zP5qb4uJXRou68y5tHOS+YZmLgCSBifVSCOShlnXQNLdJEY1sFerMTCZWMhFAIfIMCp+u34LlgwsJXaLhRgG2xLv5I7xyWouA1FT9EcJv/RrGmBEVNDnLiVBFJXexacwmVRqvCW/oZ/ODVckIPj8fkow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kj0MziZS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kj0MziZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1833C4CEE9;
	Tue, 11 Mar 2025 15:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706756;
	bh=gEAUum8UlgNk8lwxb10X6EEv5N4cTGb9c2I1WCfTiro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kj0MziZS6dM10bGxETVjF4BU94zleZYVuvK0M5eqKgKGbkVq4H7DAU6v42O1Thh4R
	 fMMQeNChG88tLdQmDXm3m3Zdscdf1vXilGzKn3MzJBBhR+4/jkS8RUQoBUbMD0xCUf
	 dKZG1xrQs/BGNTuoW3oCSLpijTS2n49cZMExMyxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <mail@jakemoroni.com>,
	Igor Russkikh <irusskikh@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 157/462] net: atlantic: fix warning during hot unplug
Date: Tue, 11 Mar 2025 15:57:03 +0100
Message-ID: <20250311145804.548187195@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2d491efa11bdf..54aa84f06e403 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -1294,7 +1294,9 @@ void aq_nic_deinit(struct aq_nic_s *self, bool link_down)
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



