Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D223A0E85;
	Sat, 17 Oct 2026 16:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255089; cv=none; b=H84mgT4cagtA9eekJsRZNkGODvI+pjYiwX354VmkGF1GbJ8Wv9SfjwxQr8rcqCZR8qcZR2cH9zV6MwBbXOqQ9AOi+4Se1IipZd6RmfEeFbj5U7Tss8NeEUpyjTEGX15Cl9QYtbe8zWcvnu8FvD6BRy8jsunYiR097/vckiwTU/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255089; c=relaxed/simple;
	bh=YMiqn81tH9ufk8Vz/HgCqXbQ/rcsr/ly+acJ6or0oyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tBQ9gcMP0g5syNNRlUal20fo+LccpWiAXHEpEnC6WFk6+4h0r0Uj5vX0FIdm893bhif5EFCsQyaxV9eE7NU1usM5MpRXffQm8xJlILrBbGDixRmD5dgz88/k5NB+E3LzL6mjHLiSRxF2i999CMnKAosQNzh9l0XdKsHsxDwsI/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ckh2ka2z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ckh2ka2z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A271F000C4;
	Sat, 17 Oct 2026 16:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255088;
	bh=bqT3GcoyoETUV15fIw6an33/uZmXmeszs76Ok+5BoJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ckh2ka2zGAs3Ls1qKhr39NKlh+k8bT29Z6dVED93IA+5ynieNPch3Ehfhn7nZX/d2
	 E6A8UrR983DO9jf7eUdx5NYPjjmoAnGXWNB49G22CmjCFPZa82smSq/W4Tn5CQV7y5
	 M7/cBkU8vP6goozLpQVKUNLaiOd8Nb5dgBegUM90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <tom.leiming@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 662/869] ublk: check import_ubuf() return value
Date: Sat, 17 Oct 2026 17:58:23 +0200
Message-ID: <20261017160053.970532086@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Caleb Sander Mateos <csander@purestorage.com>

[ Upstream commit 3831568792af75b6523fa93bb91560e29189cf55 ]

import_ubuf() can fail if the address range (provided by the userspace
ublk server) is outside the allowed user address space. Return that 0
bytes were copied if import_ubuf() fails rather than passing an
uninitialized struct iov_iter to ublk_copy_user_pages().

Fixes: 981f95a571e3 ("ublk: cleanup ublk_copy_user_pages")
Reported-by: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Link: https://patch.msgid.link/20260729171041.45061-2-csander@purestorage.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index bd0b2046981e4..7fd286d8aadb2 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -915,7 +915,10 @@ static int ublk_map_io(const struct ublk_queue *ubq, const struct request *req,
 		struct iov_iter iter;
 		const int dir = ITER_DEST;
 
-		import_ubuf(dir, u64_to_user_ptr(io->addr), rq_bytes, &iter);
+		if (import_ubuf(dir, u64_to_user_ptr(io->addr), rq_bytes,
+				&iter) < 0)
+			return 0;
+
 		return ublk_copy_user_pages(req, 0, &iter, dir);
 	}
 	return rq_bytes;
@@ -936,7 +939,10 @@ static int ublk_unmap_io(const struct ublk_queue *ubq,
 
 		WARN_ON_ONCE(io->res > rq_bytes);
 
-		import_ubuf(dir, u64_to_user_ptr(io->addr), io->res, &iter);
+		if (import_ubuf(dir, u64_to_user_ptr(io->addr), io->res,
+				&iter) < 0)
+			return 0;
+
 		return ublk_copy_user_pages(req, 0, &iter, dir);
 	}
 	return rq_bytes;
-- 
2.53.0



