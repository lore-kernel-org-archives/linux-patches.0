Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682374570E1;
	Mon, 31 Aug 2026 13:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183277; cv=none; b=rfHM8kYFNrpfLC81JN4n14kzDN2Wb2DWDFwZ9ZxaPlOC7k/2uiy14bYSh0WnIULAJvn9FhEhaD6OwXQxcgku/UFoJugabByJ1LsZolL2rAHU4xsXNIgBjvGRcyzrNvd4Kh3rLwziOUrFkk+ZmlxJK89nL1+0MayLNsmJB+ctiRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183277; c=relaxed/simple;
	bh=798TXL6Qfv9ozsqoBoJWSFI68cctDwsLUIh9jfj8MlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=irjV57rPT+WaVS1unY96rjOHUNQ0ghw6U0sOdEJqYI4TsXWD0Qku2UJp/dwxo/qIji6f58kLZ3Hm++n/HpyDsQmj7eMqla6aUwWdYLOga1JHl1xYMsPD5c14GeVcqyKtXPEoYEVCUoo03Q2JzoMdEA78cMiqEFGWqqcaNspfcoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dSCuRX4e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dSCuRX4e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF6F1F00A3D;
	Mon, 31 Aug 2026 13:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183276;
	bh=JT9VgRXy6JK7/MBZDGmFcB4tZPlpOXZQ+VpKGP9k2Lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dSCuRX4epxUFvaYepch1e7AOVIAgrfZiJlOYzb0xsxBbE4lgBcFXo9zr6t9QJJzVQ
	 OSL9KhrMP1pnw6aej3Ubs+huEOnlQcyVRGRFF6HlT2k1f90UiEBh6jYo5WQitOJgST
	 MjXwgNI/gbOGpyatMVrwKkquG8ZwYSl5ZxkA/UHhzElR1o+hLD4M6LPpIMz3FWI7ZM
	 mrOb7YdlRCn3UFZrp+r1JnitO/vQkH/R6uqPPveV2sKf7Cz8uNAaa4nxGKRYV1syx5
	 HF7CVPulVgGp53clzQ5qLvAqnX1/BAD6Lq5BdLXno5aYtcqV49OY/w+hXDHmtFzOZJ
	 pMM03KQe8YR3g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shawn Lin <shawn.lin@rock-chips.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	ulfh@kernel.org,
	linux-mmc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] mmc: core: Add validation for host-provided max_segs
Date: Mon, 31 Aug 2026 09:21:18 -0400
Message-ID: <20260831133314.4125787-50-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shawn Lin <shawn.lin@rock-chips.com>

[ Upstream commit 3e0483e93a8be320f70a1ff68d835f7f015af311 ]

The max_segs field is of type unsigned short, and if a host driver
sets an excessively large value, it may be truncated to zero. This
can cause mmc_alloc_sg() to call kmalloc_objs() with a zero size
allocation request, which leads to undefined behavior.

Under the SLUB allocator, kmalloc(0) returns a special pointer
(ZERO_SIZE_PTR). The subsequent 'if (sg)' check will evaluate to
true, and sg_init_table() will then attempt to access invalid memory,
resulting in a crash:

dwmmc_rockchip 2a310000.mmc: Successfully tuned phase to 133
mmc1: new UHS-I speed SDR104 SDHC card at address aaaa
Unable to handle kernel paging request at virtual address 0000001ffffffff0
Mem abort info:
ESR = 0x0000000096000004
EC = 0x25: DABT (current EL), IL = 32 bits
SET = 0, FnV = 0
EA = 0, S1PTW = 0
FSC = 0x04: level 0 translation fault
Data abort info:
ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
CM = 0, WnR = 0, TnD = 0, TagAccess = 0
GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
user pgtable: 4k pages, 48-bit VAs, pgdp=0000000102c88000
[0000001ffffffff0] pgd=0000000000000000, p4d=0000000000000000
Internal error: Oops: 0000000096000004 [#1] SMP
Modules linked in:
CPU: 2 UID: 0 PID: 102 Comm: kworker/2:1 Not tainted 7.0.0-rc6-next-20260331-00013-g4d93c25963c5-dirty #80 PREEMPT
Hardware name: Rockchip RK3576 EVB V10 Board (DT)
Workqueue: events_freezable mmc_rescan
pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : sg_init_table+0x2c/0x50
lr : sg_init_table+0x24/0x50
sp : ffff8000837db710
x29: ffff8000837db710 x28: 000000000000c000 x27: 0000000000000300
x26: 0000000000000000 x25: 0000000000000040 x24: ffff0000c46a0000
x23: 0000000000000000 x22: ffff0000c0c73c00 x21: 0000000000000010
x20: 0000000000000010 x19: 0000000000000000 x18: 000000000000002c
x17: 0000000000000000 x16: 0000000000000001 x15: 0000000000000000
x14: 0000000000000400 x13: ffff8000837dc000 x12: 0000000000000000
x11: ffff0000c0c73ca0 x10: 0000000000000040 x9 : 459ec1f0abbdbb00
x8 : 0000001fffffffe0 x7 : 0000000000000000 x6 : 000000000000003f
x5 : 0000000000035579 x4 : 0000000000000901 x3 : 0000000000000000
x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000010
Call trace:
sg_init_table+0x2c/0x50 (P)
mmc_mq_init_request+0x64/0x90
blk_mq_alloc_map_and_rqs+0x3ac/0x480
blk_mq_alloc_set_map_and_rqs+0x98/0x1e0
blk_mq_alloc_tag_set+0x1c0/0x290
mmc_init_queue+0x120/0x370
mmc_blk_alloc_req+0x150/0x420

To prevent this, add a validation check in mmc_mq_init_request() to
detect when sg_len (derived from max_segs) is zero. If sg_len is zero,
we return an error and print an error message, allowing host driver
developers to identify and fix incorrect max_segs configuration.

This is a defensive measure that ensures the MMC core fails gracefully
when host drivers provide invalid max_segs values, rather than crashing
with a page fault.

Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background git lookups finished and match the earlier analysis:

- **Fix commit** `064155c261550` ("mmc: core: Add validation for host-
  provided max_segs") is in the repo but **not** in the current 6.18.43
  tree (`v6.18.43-1-gc7f0dac02d232`). The vulnerable code is still
  present in `drivers/mmc/core/queue.c`.
- **History searches** for `mmc_mq_init_request` and `can_dma_map_merge`
  only hit merge commits in this shallow stable checkout; tag checks
  already showed both symbols exist back to at least v6.6/v6.12.

**Verdict for 6.18.43: YES** — small defensive fix that turns a kernel
oops (zero `max_segs` → `ZERO_SIZE_PTR` → fault in `sg_init_table`) into
a graceful `-EINVAL` during MMC block device init.

 drivers/mmc/core/queue.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/core/queue.c b/drivers/mmc/core/queue.c
index eb1053d8cae72..eb25a0825adcf 100644
--- a/drivers/mmc/core/queue.c
+++ b/drivers/mmc/core/queue.c
@@ -214,8 +214,14 @@ static int mmc_mq_init_request(struct blk_mq_tag_set *set, struct request *req,
 	struct mmc_queue *mq = set->driver_data;
 	struct mmc_card *card = mq->card;
 	struct mmc_host *host = card->host;
+	u16 sg_len = mmc_get_max_segments(host);
 
-	mq_rq->sg = mmc_alloc_sg(mmc_get_max_segments(host), GFP_KERNEL);
+	if (!sg_len) {
+		dev_err(mmc_dev(host), "Wrong max_segs assigned\n");
+		return -EINVAL;
+	}
+
+	mq_rq->sg = mmc_alloc_sg(sg_len, GFP_KERNEL);
 	if (!mq_rq->sg)
 		return -ENOMEM;
 
-- 
2.53.0

