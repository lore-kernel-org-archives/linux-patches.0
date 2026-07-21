Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAED40860A;
	Tue, 21 Jul 2026 18:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660049; cv=none; b=lmK5MGt9+G/+EKAB+5dkM1lusejwUx0mzV2GwOaHJJg/9SKd3qaLAahCFLIlGxto+9Tc94mXimjb7vNAiNnRR1zSE/T2uhlIAQ6PXMS7LpzRHwxTakRbSsHBd81sm2seiT1LRGTA2eq4oeYmp280OxHaUhHOGNNGC4DdaXyLoGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660049; c=relaxed/simple;
	bh=S6OYvaLvXsxcw6oMdpWt4jBOaCYMOj84sgNpZm5Fg3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dyCRKlz4xAeDyqxgcv/MqjyM9cWJDZxbxyZLGv10bKhzK4LkBGl3rIJ2Iq6HPPWrbV7/ZuM1Wl6SK3FPOpkxvVkeaftf9x95gtw6jwihZ0eXcTFP0+6vuB6M5DNDNle+rUXqjkCS/PFhPJ3Dq46hBfqWf1fI0t9ax2TSREm006Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jMrrxZnM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jMrrxZnM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366461F000E9;
	Tue, 21 Jul 2026 18:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660048;
	bh=liTDciA4AX68BrbXxef7pziDxfG2eAWhW/2XFcssFRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jMrrxZnM7kIdJi5FrUvrrCOC2mzDNB945EiedMmdZYv4OV5q8J4I2/ZF/6pvt7ERG
	 YRJL3NOSACNEiGNirhU1MVxJAaz8ESYzg2LSoQ+k1+3/FRi5aX/1ftEapi4Bv0Ctje
	 Y7/8WcvdlXZpmRxROOX8yB8rTKP+vlRMyRKFUjP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	Marco Crivellari <marco.crivellari@suse.com>,
	David Sterba <dsterba@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0779/2077] btrfs: Drop WQ_PERCPU from ordered_flags in btrfs_init_workqueues()
Date: Tue, 21 Jul 2026 17:07:32 +0200
Message-ID: <20260721152611.171866433@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit c7703f05d85f71153f5e241184397bc34da305e3 ]

After commit 21c05ca88a54 ("workqueue: Add warnings and ensure one among
WQ_PERCPU or WQ_UNBOUND is present"), there is a warning from the
btrfs-qgroup-rescan workqueue at run time:

  workqueue: btrfs-qgroup-rescan uses both WQ_PERCPU and WQ_UNBOUND. Dropped WQ_PERCPU, keeping WQ_UNBOUND.

WQ_PERCPU is included in ordered_flags after commit 69635d7f4b34 ("fs:
WQ_PERCPU added to alloc_workqueue users") and WQ_UNBOUND is set in
alloc_ordered_workqueue(), which btrfs_alloc_ordered_workqueue() calls.

Drop WQ_PERCPU from ordered_flags, as alloc_ordered_workqueue() notes
that only WQ_FREEZABLE and WQ_MEM_RECLAIM are meaningful.

Fixes: 69635d7f4b34 ("fs: WQ_PERCPU added to alloc_workqueue users")
Fixes: 21c05ca88a54 ("workqueue: Add warnings and ensure one among WQ_PERCPU or WQ_UNBOUND is present")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Breno Leitao <leitao@debian.org>
Acked-by: Marco Crivellari <marco.crivellari@suse.com>
Acked-by: David Sterba <dsterba@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c0a30bb213d7a0..ab92b35fa3cc10 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1928,7 +1928,7 @@ static int btrfs_init_workqueues(struct btrfs_fs_info *fs_info)
 {
 	u32 max_active = fs_info->thread_pool_size;
 	unsigned int flags = WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_UNBOUND;
-	unsigned int ordered_flags = WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_PERCPU;
+	unsigned int ordered_flags = WQ_MEM_RECLAIM | WQ_FREEZABLE;
 
 	fs_info->workers =
 		btrfs_alloc_workqueue(fs_info, "worker", flags, max_active, 16);
-- 
2.53.0



