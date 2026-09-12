Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C4123A562;
	Sat, 12 Sep 2026 16:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232340; cv=none; b=E/C+8rnrQFH4W0H60FQIoi0RzwfEFEPlkhqiJexVpkIymdHGT+2LK0XAs1Gr7urIotSerkNRU7RYN4SPyua2sZjGQ+oX/2gpGh/zwii9l2zoLIUiB6OO07VibunuDadkfNXTASiPeuQcUEInPfkIv/hMsGKJY60CIhN62cCJzUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232340; c=relaxed/simple;
	bh=SFyWTMRkOML5rWpuOZSFugXIpJtRA1HDXaKOwWsZaoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pwn3SPytI2ADWOOtESkBnUfldZ0QLQpY1vk0ciKY1SwYWj2JpuOdIJOXYYD1rtrCmULxtzHyzuzxVt6fXhSkf7uhoE3oa8nzlOcDGwmrinlGrJ176KSMzj+mIiFvYqyuFR6d14VZR7tKoFNp9Fe20cVTF4+wEBdufWtQp1S65pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZEjJ70xk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZEjJ70xk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0ECF1F000FF;
	Sat, 12 Sep 2026 16:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232338;
	bh=G0eAGunLWOWoAFv7r4aHx7CiJkngQjM/vwemDD4I8RM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZEjJ70xkKL3w98zmROEv2iETPYnr2bsXwW9UlLEKuUB/vZ1sIPslgfn8NoGofVzBt
	 JU3Ke7SC3ZsR6JtpNV65ik0OmDQskwP5KDcVbOUYtAgA0TxOn03V/D9g9wiXby/6FI
	 nPXX5KHijLayXLuZUg00oXb3og78aIx+J6rpfRPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuriy Havrylyuk <yhavry@gmail.com>,
	Sven Peter <sven@kernel.org>,
	Nick Chan <towinchenmi@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1181/1191] nvme-apple: Reset q->sq_tail during queue init
Date: Sat, 12 Sep 2026 09:05:09 +0200
Message-ID: <20260912065614.665588963@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nick Chan <towinchenmi@gmail.com>

[ Upstream commit a6ab75639e23169a741b0b2e12191fd8acb32c73 ]

Fixes a "duplicate tag error for tag 0" firmware crash during controller
reset while setting up a  queue on Apple A11 / T8015 caused by stale
entries in the submission queue due to an invalid sq_tail offset after
reset.

Fixes: 04d8ecf37b5e ("nvme: apple: Add Apple A11 support")
Cc: stable@vger.kernel.org
Suggested-by: Yuriy Havrylyuk <yhavry@gmail.com>
Reviewed-by: Sven Peter <sven@kernel.org>
Signed-off-by: Nick Chan <towinchenmi@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/apple.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index 060f80c5ebeda..e46048b755d17 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -1009,6 +1009,7 @@ static void apple_nvme_init_queue(struct apple_nvme_queue *q)
 	unsigned int depth = apple_nvme_queue_depth(q);
 	struct apple_nvme *anv = queue_to_apple_nvme(q);
 
+	q->sq_tail = 0;
 	q->cq_head = 0;
 	q->cq_phase = 1;
 	if (anv->hw->has_lsq_nvmmu)
-- 
2.53.0



