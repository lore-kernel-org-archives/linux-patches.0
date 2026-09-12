Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1211F1534;
	Sat, 12 Sep 2026 08:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201630; cv=none; b=qhcUmNKicVlSUF4QONEB8VLEbYxLwOAq8K0IWqIAmPREf3TW9+XXM8FgbAKqAZuI2tvHCvUwSeaf2BxCSCYuhsO+QAo1Z5CoKwlGg9J1iPCfnMv4RoGqfXh4HddNjPgcw99pJWUbHtKuLoEJg3FsSaqMmVylKKNZjYgGcqiBepM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201630; c=relaxed/simple;
	bh=S0YgL8qdbdfT/pWDuar7t9cL8L/DbNfGU0gObLAbgXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BKMHdoxgZC6PSB+UcCQRgAdXOSag0hLrjmK3Dz6TrxrULghPfWtsPmBrO3jjTBBvfinCpKn7B0jBNFsbKTWAaxBdAT2pv4NHnp0/2+AgqY5I3XdIr5aCOCYUTUMovobD80Pt9gOSFXErs+aTY8IiW+t1Q2FOqR5LP9GXacuxtqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P2wqS/41; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P2wqS/41"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E5A1F000FF;
	Sat, 12 Sep 2026 08:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201629;
	bh=IjXIGz6nbVakFVdhV/KBWN9uzbrSsi9BIyBz/tyv2Uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P2wqS/41ZEPJ1jADl/U1pizNBB20wD5Wy5HOcSF/1JC5MkF7fjwciqov6srIUFXec
	 d0JnNoIw+Lo7zyzCRfuMqMBgu1pWB8prLvqPNcfK1+dCvmY4gssDnAdIrfpAEwuY/H
	 mksogkE6Ltwoi8VPNycJlWEZSchJDR8MY1VTjqr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <tom.leiming@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1034/1815] ublk: check import_ubuf() return value
Date: Sat, 12 Sep 2026 08:46:24 +0200
Message-ID: <20260912065713.292766600@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 037e08cb97ce0..6d6fffdfa439e 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1475,7 +1475,10 @@ static unsigned int ublk_map_io(const struct ublk_queue *ubq,
 		struct iov_iter iter;
 		const int dir = ITER_DEST;
 
-		import_ubuf(dir, u64_to_user_ptr(io->buf.addr), rq_bytes, &iter);
+		if (import_ubuf(dir, u64_to_user_ptr(io->buf.addr), rq_bytes,
+				&iter) < 0)
+			return 0;
+
 		return ublk_copy_user_pages(req, 0, &iter, dir);
 	}
 	return rq_bytes;
@@ -1496,7 +1499,10 @@ static unsigned int ublk_unmap_io(bool need_map,
 
 		WARN_ON_ONCE(io->res > rq_bytes);
 
-		import_ubuf(dir, u64_to_user_ptr(io->buf.addr), io->res, &iter);
+		if (import_ubuf(dir, u64_to_user_ptr(io->buf.addr), io->res,
+				&iter) < 0)
+			return 0;
+
 		return ublk_copy_user_pages(req, 0, &iter, dir);
 	}
 	return rq_bytes;
-- 
2.53.0



