Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C8F1C4ED4;
	Tue, 27 Aug 2024 15:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771567; cv=none; b=TzB377mGzyF1hyRVFUKDQJogkpqdgUUnEvrG3LPSmliy41x1ucgF6acZRIXOGaCQlHojgM2lKgP8WJqKlDFptFS9LNJgJ0/p78KR5SN6N1jJxkpwUmdHd12NmQDASUS5wKoVQlj04p8reFcxkXvMpYPVSCm9axnjmZTXkD6Ce9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771567; c=relaxed/simple;
	bh=OShEwELeqrRA+/vjLcKebScmKCAoVgH5vnkt0B3y6/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eo3QpkoAZ+PTrrZNaPMRbtho2sLwKfB0tIt2CB3l/krT6+PpeMTGcWJ5sEF+IEDDGin7fgZf5d6MdEatCfICXg++2zpPZsVXnppddNWP8KXuFRB75N0PcYUXNP0K9FtZQFC7yF6sI3zc66tIAbkca730pIiFpvoxBIBb9XsBc6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tf9vt+aU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tf9vt+aU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24732C6104A;
	Tue, 27 Aug 2024 15:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771567;
	bh=OShEwELeqrRA+/vjLcKebScmKCAoVgH5vnkt0B3y6/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tf9vt+aULZerJlqIBM2gVjTOyUvKwTUlXtn52GO4ce5jL6Ozj/il/5VGfpaoI0v/P
	 XM4r4oCMA/JjIOKskOy3BISWNq67M49GGGxdK3LQAoEAu2lYaN8pgGrny9DASVKiPn
	 Rxg3dxyyOjDve/jgbQSRURRVXzg3HsjRPnKqMziw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 200/273] workqueue: Fix UBSAN subtraction overflow error in shift_and_mask()
Date: Tue, 27 Aug 2024 16:38:44 +0200
Message-ID: <20240827143841.021166201@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will@kernel.org>

[ Upstream commit 38f7e14519d39cf524ddc02d4caee9b337dad703 ]

UBSAN reports the following 'subtraction overflow' error when booting
in a virtual machine on Android:

 | Internal error: UBSAN: integer subtraction overflow: 00000000f2005515 [#1] PREEMPT SMP
 | Modules linked in:
 | CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.10.0-00006-g3cbe9e5abd46-dirty #4
 | Hardware name: linux,dummy-virt (DT)
 | pstate: 600000c5 (nZCv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
 | pc : cancel_delayed_work+0x34/0x44
 | lr : cancel_delayed_work+0x2c/0x44
 | sp : ffff80008002ba60
 | x29: ffff80008002ba60 x28: 0000000000000000 x27: 0000000000000000
 | x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
 | x23: 0000000000000000 x22: 0000000000000000 x21: ffff1f65014cd3c0
 | x20: ffffc0e84c9d0da0 x19: ffffc0e84cab3558 x18: ffff800080009058
 | x17: 00000000247ee1f8 x16: 00000000247ee1f8 x15: 00000000bdcb279d
 | x14: 0000000000000001 x13: 0000000000000075 x12: 00000a0000000000
 | x11: ffff1f6501499018 x10: 00984901651fffff x9 : ffff5e7cc35af000
 | x8 : 0000000000000001 x7 : 3d4d455453595342 x6 : 000000004e514553
 | x5 : ffff1f6501499265 x4 : ffff1f650ff60b10 x3 : 0000000000000620
 | x2 : ffff80008002ba78 x1 : 0000000000000000 x0 : 0000000000000000
 | Call trace:
 |  cancel_delayed_work+0x34/0x44
 |  deferred_probe_extend_timeout+0x20/0x70
 |  driver_register+0xa8/0x110
 |  __platform_driver_register+0x28/0x3c
 |  syscon_init+0x24/0x38
 |  do_one_initcall+0xe4/0x338
 |  do_initcall_level+0xac/0x178
 |  do_initcalls+0x5c/0xa0
 |  do_basic_setup+0x20/0x30
 |  kernel_init_freeable+0x8c/0xf8
 |  kernel_init+0x28/0x1b4
 |  ret_from_fork+0x10/0x20
 | Code: f9000fbf 97fffa2f 39400268 37100048 (d42aa2a0)
 | ---[ end trace 0000000000000000 ]---
 | Kernel panic - not syncing: UBSAN: integer subtraction overflow: Fatal exception

This is due to shift_and_mask() using a signed immediate to construct
the mask and being called with a shift of 31 (WORK_OFFQ_POOL_SHIFT) so
that it ends up decrementing from INT_MIN.

Use an unsigned constant '1U' to generate the mask in shift_and_mask().

Cc: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Fixes: 1211f3b21c2a ("workqueue: Preserve OFFQ bits in cancel[_sync] paths")
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f98247ec99c20..c8687c0ab3645 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -896,7 +896,7 @@ static struct worker_pool *get_work_pool(struct work_struct *work)
 
 static unsigned long shift_and_mask(unsigned long v, u32 shift, u32 bits)
 {
-	return (v >> shift) & ((1 << bits) - 1);
+	return (v >> shift) & ((1U << bits) - 1);
 }
 
 static void work_offqd_unpack(struct work_offq_data *offqd, unsigned long data)
-- 
2.43.0



