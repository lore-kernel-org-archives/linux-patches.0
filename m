Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87ECEAF1;
	Wed,  4 Jun 2025 00:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998671; cv=none; b=mHzVlq916hyKLw3fVez63V1ujLaXnLykQ8iYHzzkq4IL0/BsHJRnQTDLh7+GMXZ3tgzfWG8VbYiTUHBfRxQRMFScShtGh6LCcp0m4i9RFgE69RHM603BYlkuPhTluM/WKgRhIeqJOvoRveH208LOiGDC1J9cAMpGV8eXQNKJlkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998671; c=relaxed/simple;
	bh=VOskIawmz63rzZgMZyJuPGA76+FjpaLrKK1ZK3SjF3M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pxbkefb4a0FDEhUSqI3LSnVkr5lfSJ4+lB5xVX0rja5gvxhl8ZlCnaArg1uLeRjIqmEbM2eyzLyOt3Iwcyeir1j6EKW9mMrQi3bkM8c1369RsjtpoE9l8lqk5J7wWT9TLB9MNHsBJXcUB69SzDW+EsTKjLvrB0SjlRuwUHwk6EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kd9wVGMD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kd9wVGMD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A41C4CEED;
	Wed,  4 Jun 2025 00:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998670;
	bh=VOskIawmz63rzZgMZyJuPGA76+FjpaLrKK1ZK3SjF3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kd9wVGMD2dVRDX7b8kppA1a4LrG1GaAcYtPHZLM8bHWI4mZH4R46tvrE/Gcf2PEWM
	 baEYTFTZ9icejOtd9LCQT00U0q4mFbM4CvXlEJ4lqqoUjHCAgRxjtm/A3lekMtx/CI
	 EMZet4OvQjBlJVO5a4qfwQc59xjHHXZnGxdWjq0G6M0nIMIFZNpQpNgCDEWfb2qw1/
	 Zfq1+R2UTOB0NISkCgdySqfzrN8/ugVGSxYHIYX7OSnyGwySOVtcfjD+I8N9oqt4ja
	 qz9yPNvK0wmOL9JFNXr85jT/jKGRw1egRIWqltIm0IcJJCPU0LRZewmu+tymVfq1Zc
	 QP+OqDOpV+zHw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	yedidya.ben.shimol@intel.com
Subject: [PATCH AUTOSEL 6.14 068/108] wifi: iwlwifi: pcie: make sure to lock rxq->read
Date: Tue,  3 Jun 2025 20:54:51 -0400
Message-Id: <20250604005531.4178547-68-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005531.4178547-1-sashal@kernel.org>
References: <20250604005531.4178547-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 1cc2c48c4af81bed5ddbe9f2c9d6e20fa163acf9 ]

rxq->read is accessed without the rxq->lock in a few places,
Make sure to have the lock there.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Tested-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20250424153620.73725f207aaa.I1a3e4b6c5fd370e029fdacfcdc9ee335788afa98@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Based on my analysis of the commit and the surrounding code, here is my
assessment: ## YES This commit should be backported to stable kernel
trees. ### Analysis: **1. Race Condition Fix:** The commit fixes a clear
race condition where `rxq->read` is accessed without proper locking in
two functions: - `iwl_dbgfs_rx_queue_read()` - a debugfs read function -
`iwl_trans_pcie_dump_data()` - a function that calculates buffer sizes
for error dumps **2. Specific Code Changes:** - In
`iwl_dbgfs_rx_queue_read()`, the commit adds `spin_lock_bh(&rxq->lock)`
before accessing `rxq->read` and `spin_unlock_bh(&rxq->lock)` after
finishing with all rxq fields - In `iwl_trans_pcie_dump_data()`, it adds
the same locking around the calculation `num_rbs = (num_rbs - rxq->read)
& RX_QUEUE_MASK` **3. Why This Needs Backporting:** **Race Condition
Impact:** Looking at the rx.c code, `rxq->read` is modified in the hot
path interrupt handling code (`iwl_pcie_irq_rx_handler`) under
`spin_lock(&rxq->lock)`. The unlocked access in the debugfs and dump
functions can lead to: - Reading inconsistent values during updates -
Potential crashes if the read occurs during structure modifications -
Incorrect debug information or dump calculations **Similarity to
Backported Commits:** This follows the exact same pattern as Similar
Commit #1 and #3, which were both marked as "YES" for backporting. Both
dealt with missing locking for shared data structures in the iwlwifi
driver. **4. Backport Criteria Assessment:** - ✅ **Fixes a bug affecting
users:** Race conditions can cause system instability - ✅ **Small and
contained fix:** Only adds proper locking, minimal code change - ✅ **No
major architectural changes:** Just adds missing synchronization - ✅
**Minimal risk of regression:** Standard locking pattern already used
elsewhere - ✅ **Confined to iwlwifi subsystem:** Changes are local to
Intel WiFi driver **5. Risk Assessment:** The fix is extremely low risk
- it simply adds the missing locking that should have been there
originally. The locking pattern (`spin_lock_bh`/`spin_unlock_bh`) is
already used extensively throughout the same file for protecting rxq
access. This is a textbook stable tree candidate: it fixes a real
concurrency bug with minimal, safe code changes that follow existing
patterns in the codebase.

 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 102a6123bba0e..4cc7a2e5746d2 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2942,6 +2942,8 @@ static ssize_t iwl_dbgfs_rx_queue_read(struct file *file,
 	for (i = 0; i < trans->num_rx_queues && pos < bufsz; i++) {
 		struct iwl_rxq *rxq = &trans_pcie->rxq[i];
 
+		spin_lock_bh(&rxq->lock);
+
 		pos += scnprintf(buf + pos, bufsz - pos, "queue#: %2d\n",
 				 i);
 		pos += scnprintf(buf + pos, bufsz - pos, "\tread: %u\n",
@@ -2962,6 +2964,7 @@ static ssize_t iwl_dbgfs_rx_queue_read(struct file *file,
 			pos += scnprintf(buf + pos, bufsz - pos,
 					 "\tclosed_rb_num: Not Allocated\n");
 		}
+		spin_unlock_bh(&rxq->lock);
 	}
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 	kfree(buf);
@@ -3662,8 +3665,11 @@ iwl_trans_pcie_dump_data(struct iwl_trans *trans, u32 dump_mask,
 		/* Dump RBs is supported only for pre-9000 devices (1 queue) */
 		struct iwl_rxq *rxq = &trans_pcie->rxq[0];
 		/* RBs */
+		spin_lock_bh(&rxq->lock);
 		num_rbs = iwl_get_closed_rb_stts(trans, rxq);
 		num_rbs = (num_rbs - rxq->read) & RX_QUEUE_MASK;
+		spin_unlock_bh(&rxq->lock);
+
 		len += num_rbs * (sizeof(*data) +
 				  sizeof(struct iwl_fw_error_dump_rb) +
 				  (PAGE_SIZE << trans_pcie->rx_page_order));
-- 
2.39.5

