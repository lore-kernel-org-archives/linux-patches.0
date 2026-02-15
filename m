Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A23F2F39B1;
	Sun, 15 Feb 2026 17:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771177288; cv=none; b=AlZv4A3gCRP+LHwt0WQWDAFknqbZI298nGQ0qnp9Mpk5ymv0uTBImiYwexa4kbM+EVd2lIWrhatDHAODjqfM6n0X9Vk8jrX5ketIjsHdyHkIc5a2XXCA/zkGOS2DsIkIlPPqkXdNA9ZXEcyFTfiuCTnMboqm2ALmN3kVpr8dsiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771177288; c=relaxed/simple;
	bh=nCrjXMjBoStVt4cijtk4i5RH7OleXvBYryvHaN3qCJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XNBeP6BhXZMihOjXsXAHSjY4sPI48HjhhoKd9oCXSBC3MeIl9AKgkXvP3KGagWT/dxmbKrXbdrx8zb8X0CvpwenJ5GdPIzpe/hZbTsNr17eGKXgo+VinyZLyhuJ+AYyNemvB7IW+0haKaMDJ5uVYS6ZgGMd6bAowKHXnrwD3OOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u9Vn4iGX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u9Vn4iGX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DADBC19423;
	Sun, 15 Feb 2026 17:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771177287;
	bh=nCrjXMjBoStVt4cijtk4i5RH7OleXvBYryvHaN3qCJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u9Vn4iGXzJ99+YBbPCmWa30J///fEDdrFYmHgj+85VB8JqjBshBA5H5muqwkc8l84
	 f6w37JxomNWFqDNx445NAgPdFVOLtZdeNlqVeU1pGfoktBAUj8fTd4O9WnN4MD1P8J
	 fAaoVqUdQeHs4dXeMhCzNwQUb4Nh/jJmQWwmFKGLzwUtFDa7RI9LZh+DB0cvKrEXyb
	 Rk41EFaBWJDDlJRnx3Gyzl5nias7SN24JRtiSBcywk1hA2342uRDsA0DoJ45ogkXle
	 eNNxT888yp89Zig56rusHr0ntHyaM/EVCCv+zp8VAGfTD2ybQ7Eq1eOY2/KNku3OwP
	 Z6hY/7VqNhNpQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Valentina Fernandez <valentina.fernandezalanis@microchip.com>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] mailbox: mchp-ipc-sbi: fix uninitialized symbol and other smatch warnings
Date: Sun, 15 Feb 2026 12:41:13 -0500
Message-ID: <20260215174120.2390402-5-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260215174120.2390402-1-sashal@kernel.org>
References: <20260215174120.2390402-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Valentina Fernandez <valentina.fernandezalanis@microchip.com>

[ Upstream commit bc4d17e495cd3b02bcb2e10f575763a5ff31f80b ]

Fix uninitialized symbol 'hartid' warning in mchp_ipc_cluster_aggr_isr()
by introducing a 'found' flag to track whether the IRQ matches any
online hart. If no match is found, return IRQ_NONE.

Also fix other smatch warnings by removing dead code in
mchp_ipc_startup() and by returning -ENODEV in dev_err_probe() if the
Microchip SBI extension is not found.

Fixes below smatch warnings:
drivers/mailbox/mailbox-mchp-ipc-sbi.c:187 mchp_ipc_cluster_aggr_isr() error: uninitialized symbol 'hartid'.
drivers/mailbox/mailbox-mchp-ipc-sbi.c:324 mchp_ipc_startup() warn: ignoring unreachable code.
drivers/mailbox/mailbox-mchp-ipc-sbi.c:422 mchp_ipc_probe() warn: passing zero to 'dev_err_probe'

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202512171533.CDLdScMY-lkp@intel.com/
Signed-off-by: Valentina Fernandez <valentina.fernandezalanis@microchip.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

So v6.14 is no longer a maintained stable tree (stopped at v6.14.11).
The relevant current stable tree would be v6.18.y.

### User Impact

This driver is for RISC-V Microchip Inter-processor Communication. While
it's a niche driver:
1. The uninitialized variable bug in the ISR is a real correctness issue
2. The `dev_err_probe` returning 0 on failure could cause unexpected
   behavior
3. All three fixes are straightforward and low-risk

### Verification

- **git log** confirmed the file was introduced in commit
  `e4b1d67e71419` (v6.14-rc1)
- **git tag --contains** confirmed the file first appeared in v6.14
- **git show f7c330a8c83c9** confirmed a dependency on a prior fix that
  changed indexing from hartid to cpuid
- **git tag** confirmed v6.14 is no longer actively maintained (stopped
  at v6.14.11); v6.18.y is the relevant current stable tree
- The uninitialized variable bug is verified by reading the original
  code: if `for_each_online_cpu` loop doesn't find a matching IRQ,
  `hartid` is used uninitialized at line 187
- The `dev_err_probe` bug is verified: when `sbi_probe_extension`
  returns 0, passing 0 to `dev_err_probe` returns 0 (success), causing
  probe to incorrectly succeed
- The dead code is verified: the switch statement either returns 0 or
  gotos to error cleanup, making code after it unreachable

### Assessment

This commit fixes real bugs:
1. An uninitialized variable in an interrupt handler (potential
   undefined behavior / crash)
2. An incorrect probe success path when hardware support is missing
3. Dead code removal (minor cleanup)

The fixes are small, well-contained, and low-risk. They fix genuine bugs
in a driver that exists only in v6.14+. The commit has a dependency on
`f7c330a8c83c9` which would also need to be backported.

While the bugs are real, this is a very niche RISC-V mailbox driver
(Microchip IPC over SBI). The fixes are appropriate for stable if the
prerequisite commit is also included. The uninitialized variable and
incorrect probe return value are both correctness bugs worth fixing.

**YES**

 drivers/mailbox/mailbox-mchp-ipc-sbi.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/mailbox/mailbox-mchp-ipc-sbi.c b/drivers/mailbox/mailbox-mchp-ipc-sbi.c
index d444491a584e8..b87bf2fb4b9b9 100644
--- a/drivers/mailbox/mailbox-mchp-ipc-sbi.c
+++ b/drivers/mailbox/mailbox-mchp-ipc-sbi.c
@@ -174,17 +174,21 @@ static irqreturn_t mchp_ipc_cluster_aggr_isr(int irq, void *data)
 	struct mchp_ipc_msg ipc_msg;
 	struct mchp_ipc_status status_msg;
 	int ret;
-	unsigned long hartid;
 	u32 i, chan_index, chan_id;
+	bool found = false;
 
 	/* Find out the hart that originated the irq */
 	for_each_online_cpu(i) {
-		hartid = cpuid_to_hartid_map(i);
-		if (irq == ipc->cluster_cfg[i].irq)
+		if (irq == ipc->cluster_cfg[i].irq) {
+			found = true;
 			break;
+		}
 	}
 
-	status_msg.cluster = hartid;
+	if (unlikely(!found))
+		return IRQ_NONE;
+
+	status_msg.cluster = cpuid_to_hartid_map(i);
 	memcpy(ipc->cluster_cfg[i].buf_base, &status_msg, sizeof(struct mchp_ipc_status));
 
 	ret = mchp_ipc_sbi_send(SBI_EXT_IPC_STATUS, ipc->cluster_cfg[i].buf_base_addr);
@@ -321,13 +325,6 @@ static int mchp_ipc_startup(struct mbox_chan *chan)
 		goto fail_free_buf_msg_rx;
 	}
 
-	if (ret) {
-		dev_err(ipc->dev, "failed to register interrupt(s)\n");
-		goto fail_free_buf_msg_rx;
-	}
-
-	return ret;
-
 fail_free_buf_msg_rx:
 	kfree(chan_info->msg_buf_rx);
 fail_free_buf_msg_tx:
@@ -419,7 +416,7 @@ static int mchp_ipc_probe(struct platform_device *pdev)
 
 	ret = sbi_probe_extension(SBI_EXT_MICROCHIP_TECHNOLOGY);
 	if (ret <= 0)
-		return dev_err_probe(dev, ret, "Microchip SBI extension not detected\n");
+		return dev_err_probe(dev, -ENODEV, "Microchip SBI extension not detected\n");
 
 	ipc = devm_kzalloc(dev, sizeof(*ipc), GFP_KERNEL);
 	if (!ipc)
-- 
2.51.0

