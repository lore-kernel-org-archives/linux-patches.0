Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B0F3E0C4D;
	Wed, 30 Sep 2026 18:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793954; cv=none; b=E3ArY4RL7R89btvDU7GfJl+lrhb8opHZ4MjEImk0uWlmViHin1gDLrvYWDPRJX5kft95dXYgQ9pMVvbYmzSiqnXQg4JOR8OkIceVqJKhhFYFbSOGhedWN1MT1rHYqMrMLbYkD4V6ULsWL2vypEuvW2DuIWM+HyzvL6XJ23WiduA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793954; c=relaxed/simple;
	bh=ribmyLlJLK4Um7+0+P+W78EBj4pcVWoY+llfsBVhMAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pn/XwuNmaaStl0wVeqzsf3CFAZJFy4NSnn4Idfw1D+RRD7Nj6R/CX7/U1b6hAcWbVVRZqyodiRmT2GzWZZTfO6EnYnIqb2+kX00neW8YecibRltBWvDWIaP2akANq7I46z6gAPnDYunqC1kIcvcZsfFd9Tqb5qfq7gNMzIi9IzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v6eB7OSn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v6eB7OSn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15AA21F000FF;
	Wed, 30 Sep 2026 18:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793952;
	bh=PmwknbXCIAWN7Oj4kie1tarjBKjwkAVD77c2A7kJG4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v6eB7OSnhPbWFVf6exSAXElLGwy2qoa4qFcaLYvZxyhmxO+gP8PJurYxkzhs4D3W+
	 OpL/z/BJiE24BuaoZDkD0VrZ+TG6ij5wqY4qn8WMog8RlHxXxu8ah/2pSdcE4Byx+w
	 /PW5URfQTNZcYBEl92jqTYk6AbcL0ymeKKedZh5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0039/1193] mmc: core: Add validation for host-provided max_segs
Date: Wed, 30 Sep 2026 17:12:03 +0200
Message-ID: <20260930152435.154864455@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 drivers/mmc/core/queue.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/core/queue.c b/drivers/mmc/core/queue.c
index 9eed7562e2672..8bad6bd3eeea0 100644
--- a/drivers/mmc/core/queue.c
+++ b/drivers/mmc/core/queue.c
@@ -211,8 +211,14 @@ static int mmc_mq_init_request(struct blk_mq_tag_set *set, struct request *req,
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



