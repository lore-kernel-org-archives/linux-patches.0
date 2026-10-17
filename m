Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD2B3B3884;
	Sat, 17 Oct 2026 18:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260099; cv=none; b=EqT3KS0SCIXKf3C9HX8BVIHUMN4cMm1DR3azPYBJLHNX7I6SgDDbVOzogprKM7dOvt760JnL0pBEB6l5YgyRxYwOC24cqsCS5wIDUaFHOkl2hDJoNhuIlMviv1+tcSeLRbNNfkMi/+cfaqnAJZ5drAlYFP+pILdZdgh1iFzsM0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260099; c=relaxed/simple;
	bh=4f4hRJ32we/PpkyxOgFDRADiIJZ1K+s69cAiFqF7zFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oXEMLlZssl/YHfjDQtiBZNPcsmOJ+eFMgmkQDv1rdJ5VkzLQpKVdFvIJbSCjGkOm/Jsyv/REtgzigXp/syXpdAL2BSJKCBgOIskAYT/fgXL5wQSm/mhuIErzSVMTZVIgRPck31eKSjtP7VIIEt8Nf6DfvNUfVFpZdyK0X6VAucE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I72Usdqp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I72Usdqp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6901F000C4;
	Sat, 17 Oct 2026 18:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260098;
	bh=aeTC5ZGcnMt+apW2zsuu6zG+UUBPiG1I00YDJaVYtMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I72UsdqpbZNqltTHidbkmuG+Yo+Z2+rmyfdbCB1RRn8UndULFmHXfvL9AoKIrfDBU
	 DGFDDt38wXmTmpssl+0rS26izEPmuboWFtoRQeFbIMV5UgvWWxT3pg9coeHn1+i5F1
	 MYfaLPsVj5gpuR/LXZWZcTgZ2lE17tEfbVxK9G3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <tom.leiming@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1433/1674] ublk: check import_ubuf() return value
Date: Sat, 17 Oct 2026 18:01:45 +0200
Message-ID: <20261017160507.966629060@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
 drivers/block/ublk_drv.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index c39eab406978e..ad1156e36d8aa 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -938,8 +938,9 @@ static int ublk_map_io(const struct ublk_queue *ubq, const struct request *req,
 		struct iovec iov;
 		const int dir = ITER_DEST;
 
-		import_single_range(dir, u64_to_user_ptr(io->addr), rq_bytes,
-				&iov, &iter);
+		if (import_single_range(dir, u64_to_user_ptr(io->addr), rq_bytes,
+				&iov, &iter) < 0)
+			return 0;
 
 		return ublk_copy_user_pages(req, 0, &iter, dir);
 	}
@@ -962,8 +963,10 @@ static int ublk_unmap_io(const struct ublk_queue *ubq,
 
 		WARN_ON_ONCE(io->res > rq_bytes);
 
-		import_single_range(dir, u64_to_user_ptr(io->addr), io->res,
-				&iov, &iter);
+		if (import_single_range(dir, u64_to_user_ptr(io->addr), io->res,
+				&iov, &iter) < 0)
+			return 0;
+
 		return ublk_copy_user_pages(req, 0, &iter, dir);
 	}
 	return rq_bytes;
-- 
2.53.0



